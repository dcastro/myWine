//
//  User.m
//  myWine
//
//  Created by Diogo Castro on 17/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "User.h"
#import "Query.h"

static User *sharedUser = nil;

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize vinhos = _vinhos;
@synthesize isValidated = _isValidated;
@synthesize user_id = _user_id;
@synthesize synced_at;

+ (id)instance {
    @synchronized(self) {
        if (sharedUser == nil)
            sharedUser = [[self alloc] init];
    }
    return sharedUser;
}

- (void) sync {
    /**
     * Login logic
     * updated isValidated at the end
     */
    DebugLog([self description]);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Username: %@, Password: %@, Synced_at: %d", self.username, self.password, self.synced_at];
}

- (id) initWithID:(int)user_id {
    if (self = [super init]) {
        self.user_id = user_id;
        
        [self loadFromDB];
    }
    
    return self;
}

+ (void) createWithID:(int) user_id {
    @synchronized(self) {
        if (sharedUser == nil)
            sharedUser = [[self alloc] initWithID:user_id];
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
    
    sqlite3_stmt *stmt = [query prepareForQuery:querySQL];
    
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

- (void) loadVinhosFromDB {
    #warning TODO: load dos vinhos da DB
    _vinhos = [[NSMutableArray alloc] init];
}


@end
