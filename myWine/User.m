//
//  User.m
//  myWine
//
//  Created by Diogo Castro on 17/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "User.h"
#import "Query.h"
#import "Language.h"
#import "Vinho.h"
#import "Pais.h"
#import "Utils.h"
#import "Sincronizacao.h"

static User *sharedUser = nil;

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize vinhos = _vinhos;
@synthesize isValidated = _isValidated;
@synthesize synced_at;
@synthesize countries = _countries;
@synthesize tipoVinhos = _tipoVinhos;

+ (id)instance {
    @synchronized(self) {
        if (sharedUser == nil)
            sharedUser = [[self alloc] init];
    }
    return sharedUser;
}


- (NSString *)description{
    return [NSString stringWithFormat:@"Username: %@, Password: %@, Synced_at: %d", self.username, self.password, self.synced_at];
}

- (id) initWithUsername:(NSString*) username {
    if (self = [super init]) {
        self.username = username;
        
        [self loadFromDB];
    }
    
    return self;
}

+ (void) createWithUsername:(NSString*) username {
    @synchronized(self) {
        if (sharedUser == nil)
            sharedUser = [[self alloc] initWithUsername:username];
    }
}

- (id) initWithUsername:(NSString*) username Password:(NSString*) password {
    if (self = [super init]) {
        
        self.username = username;
        self.password = password;
        
        [self loadFromDB];
        
    }
    
    return self;
}

+ (void) createWithUsername:(NSString *)username Password:(NSString *)password {
    @synchronized(self) {
        //if (sharedUser == nil)
            sharedUser = [[self alloc] initWithUsername:username Password:password];
    }
}

- (void) loadFromDB {
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL = [NSString stringWithFormat: 
                          @"SELECT * FROM User WHERE username=\'%@\';",self.username,"%"];
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    if(stmt != nil){
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {

            self.username = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
            self.password = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            self.synced_at = sqlite3_column_double(stmt, 2);
            
            int validated = sqlite3_column_int(stmt, 3);
            if(validated >0)
                self.isValidated = TRUE;
            else 
                self.isValidated = FALSE;
            
            
#warning TODO caso o utilizador tenha mudado de pass
            
        }else {
            
            self.isValidated = FALSE;
            DebugLog(@"User doest exist in the database");
    #warning TODO o user nao existe
        } 
        
        
        [query finalizeQuery:stmt];
    }else{
        self.isValidated = FALSE;
        DebugLog(@"Error obtaining user from database");
    }
}

- (NSMutableArray*) vinhos{
    if (! _vinhos) {
        
        [self loadVinhosFromDB];
    }
    
    return _vinhos;
}

- (BOOL) loadVinhosFromDB {
    _vinhos = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    
    querySQL =  @"SELECT w.wine_id, w.name, w.year, w.photo_filename, w.producer, w.currency, w.price, w.grapes,\
                c.name_en, c.name_fr, c.name_pt, r.region_id, r.name ,\
                wt.winetype_id, wt.name_en, wt.name_fr, wt.name_pt \
                        FROM Wine w, Region r, Country c, WineType wt \
                        WHERE w.region_id = r.region_id AND r.country_id = c.country_id AND w.winetype_id = wt.winetype_id AND w.state <> 3 \
                        ORDER BY w.name DESC;";
   
     
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Vinho *wine = [[Vinho alloc] init]; 
                        
            wine.wine_id = sqlite3_column_int(stmt, 0);
            wine.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
            wine.year = sqlite3_column_int(stmt, 2);
            
            const unsigned char * photo = sqlite3_column_text(stmt, 3);
            if(photo != NULL)
                wine.photo = [NSString stringWithUTF8String:(const char *)photo];
            else
                wine.photo = nil;
            
            
            const unsigned char * producer = sqlite3_column_text(stmt, 4);
            if(producer != NULL)
                wine.producer = [NSString stringWithUTF8String:(const char *)producer];
            else
                wine.producer = nil;
            
            
            wine.currency = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            wine.price = sqlite3_column_double(stmt, 6);
            
            
            const unsigned char * wgrapes = sqlite3_column_text(stmt, 7);
            if(wgrapes != NULL)
                wine.grapes = [NSString stringWithUTF8String:(const char *)wgrapes];
            else
                wine.grapes = nil;
            
            
            
            Regiao * r = [[Regiao alloc] init];
            r.country_name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            r.country_name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
            r.country_name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
            r.region_id = sqlite3_column_int(stmt, 11);
            r.region_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 12)];
            wine.region = r;

           
            
            TipoVinho *tv = [[TipoVinho alloc] init];
            tv.winetype_id = sqlite3_column_int(stmt, 13);
            tv.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 14)];
            tv.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 15)];
            tv.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 16)];

            wine.winetype = tv;

            
            [_vinhos insertObject:wine atIndex:0];
         
            
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
    
    
    
    
}

-(BOOL) loadWineTypesFromDB{
    _tipoVinhos = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT wt.winetype_id, wt.name_en, wt.name_fr, wt.name_pt \
                FROM WineType wt, UserTypeForm utf \
                WHERE wt.winetype_id = utf.winetype_id AND user = \'%@\';", _username];
      
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            TipoVinho *winetype = [[TipoVinho alloc] init];
            
            winetype.winetype_id = sqlite3_column_int(stmt, 0);
            winetype.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            winetype.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            winetype.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];

            
            
            [_tipoVinhos insertObject:winetype atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }else
        return FALSE;

    
}


- (BOOL) loadCountries {
    
     _countries  = [[NSMutableArray alloc] init];
    
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    querySQL = [NSString stringWithFormat:@"SELECT c.country_id, c.name_en, c.name_fr, c.name_pt\
                        FROM Country c;"];
            
       
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Pais *country = [[Pais alloc] init];
            
            country.id = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            country.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            country.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            country.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];

            
            [_countries insertObject:country atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }else
        return FALSE;
}

- (NSMutableArray*) countries {
    
    if (!_countries) {
        [self loadCountries];
    }
    
    return _countries;
    
}


- (NSMutableArray*) tipoVinhos {
    if (!_tipoVinhos){
        [self loadWineTypesFromDB];
    }
    return _tipoVinhos;
}



-(BOOL)validateUser
{
    NSString * querySQL;
    Query * query = [[Query alloc] init];
    sqlite3** contactDB = [query prepareForExecution]; 
    sqlite3_stmt * stmt;
    char* errMsg;
    
    BOOL userExists = FALSE;
    
    
    querySQL = [NSString stringWithFormat:@"SELECT username FROM User WHERE username = \'%@\';", 
                _username];
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            
            userExists = TRUE;             
        }
        
        sqlite3_finalize(stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return FALSE;
    }
    
    
    if(userExists){
        
        querySQL = [NSString stringWithFormat:@"UPDATE User SET validadted = %d WHERE username = \'%@\';", 
                    _isValidated, _username];
        
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
        
        
    }else {
        
        if(_isValidated){
           querySQL = [NSString stringWithFormat:@"INSERT INTO User VALUES(\'%@\', \'%@\', %f, %d);",
                       _username,
                       _password,
                       0.0,
                       1];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
            
        }
    }
    
    
    
    
    return TRUE;
}


@end
