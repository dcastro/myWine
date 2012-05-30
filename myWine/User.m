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

            self.username = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, user_column_username)];
                        
            self.password = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, user_column_password)];
            
            int validated = sqlite3_column_int(stmt, user_column_validated);
            if(validated >0)
                self.isValidated = TRUE;
            else 
                self.isValidated = FALSE;
            
            self.synced_at = sqlite3_column_int(stmt, user_column_synced);
            
            
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
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL =  @"SELECT w.wine_id, c.name_fr, r.name  , wt.name_fr, w.name, w.year, w.photo_filename, w.producer, w.currency, w.price, w.grapes \
                        FROM Wine w, Region r, Country c, WineType wt \
                        WHERE w.region_id = r.region_id AND r.country_id = c.country_id AND w.winetype_id = wt.winetype_id AND w.state <> 3 \
                        ORDER BY w.name DESC;";
            break;
            
        case EN: 
            querySQL =  @"SELECT w.wine_id, c.name_en, r.name  , wt.name_en, w.name, w.year, w.photo_filename, w.producer, w.currency, w.price, w.grapes \
                        FROM Wine w, Region r, Country c, WineType wt \
                        WHERE w.region_id = r.region_id AND r.country_id = c.country_id AND w.winetype_id = wt.winetype_id AND w.state <> 3 \
                        ORDER BY w.name DESC;";
            break;
            
        case PT:
            querySQL =  @"SELECT w.wine_id, c.name_pt, r.name  , wt.name_pt, w.name, w.year, w.photo_filename, w.producer, w.currency, w.price, w.grapes \
                        FROM Wine w, Region r, Country c, WineType wt \
                        WHERE w.region_id = r.region_id AND r.country_id = c.country_id AND w.winetype_id = wt.winetype_id AND w.state <> 3 \
                        ORDER BY w.name DESC;";
            break;
            
        default:
            break;
    }
     
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Vinho *wine = [[Vinho alloc] init]; 
                        
            wine.wine_id = sqlite3_column_int(stmt, 0);
            
            Regiao * r = [[Regiao alloc] init];
            r.country_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            r.region_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            wine.region = r;
            
            TipoVinho *tv = [[TipoVinho alloc] init];
            tv.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            wine.winetype = tv;
            
            wine.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            wine.year = sqlite3_column_int(stmt, 5);
           
            const unsigned char * photo = sqlite3_column_text(stmt, 6);
            if(photo != NULL)
                wine.photo = [NSString stringWithUTF8String:(const char *)photo];
            else
                wine.photo = nil;
            

            const unsigned char * producer = sqlite3_column_text(stmt, 7);
            if(producer != NULL)
                wine.producer = [NSString stringWithUTF8String:(const char *)producer];
            else
                wine.producer = nil;
            
            
            wine.currency = currencyInt( [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)] );
            wine.price = sqlite3_column_double(stmt, 9);
            
            
            const unsigned char * wgrapes = sqlite3_column_text(stmt, 10);
            if(wgrapes != NULL)
                wine.grapes = [NSString stringWithUTF8String:(const char *)wgrapes];
            else
                wine.grapes = nil;
            
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
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT wt.winetype_id, wt.name_fr\
                        FROM WineType wt \
                        ORDER BY wt.name_fr DESC;"];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT wt.winetype_id, wt.name_en\
                              FROM WineType wt \
                              ORDER BY wt.name_en DESC;"];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT wt.winetype_id, wt.name_pt\
                             FROM WineType wt \
                             ORDER BY wt.name_pt DESC;"];
   
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            TipoVinho *winetype = [[TipoVinho alloc] init];
            
            winetype.winetype_id = sqlite3_column_int(stmt, 0);
            winetype.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
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
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT c.country_id, c.name_fr\
                        FROM Country c  \
                        ORDER BY c.name_fr DESC;"];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT c.country_id, c.name_en\
                              FROM Country c \
                              ORDER BY c.name_en DESC;"];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT c.country_id, c.name_pt\
                             FROM Country c \
                             ORDER BY c.name_pt DESC;"];           
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Pais *country = [[Pais alloc] init];
            
            country.id = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            country.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
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


@end
