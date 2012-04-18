//
//  User.m
//  myWine
//
//  Created by Diogo Castro on 17/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "User.h"

static User *sharedUser = nil;

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize vinhos = _vinhos;
@synthesize isValidated = _isValidated;
@synthesize user_id = _user_id;

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
        if (sharedUser == nil)
            sharedUser = [[self alloc] initWithUsername:username Password:password];
    }
}

- (void) loadFromDB {
#warning TODO: check if user already exists in the database
    if (YES) {
#warning TODO: load da info do user e dos seus vinhos
        
        
        self.isValidated = YES; // must be checked in the DB instead
    } else {
        
        self.isValidated = NO;
        
    }
}

- (NSMutableArray*) vinhos {
    if (! _vinhos) {
#warning TODO: retrieve vinhos from DB
        _vinhos = [[NSMutableArray alloc] init];
    }
    
    return _vinhos;
}


@end
