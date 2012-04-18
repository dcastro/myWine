//
//  Database.h
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#include "DatatabaseDefinitions.h"



#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )


@interface Database : NSObject{
    sqlite3 *contactDB;
}

@property (readonly, nonatomic) NSString *databasePath;


/**
 * Class method for returning the instance of the singleton object.
 * Initializes the object if it needs to.
 */
+ (id)instance;


/**
 * Default object initializer
 */
- (id)init;


/**
 * This method verifies if the database is already created, it does not create the database.
 */
- (BOOL)isDatabaseCreated;


/**
 * Function that creates the database and all its tables with relations
 * @param error - pointer to a NSError class to return possible errors, nil if errors arent detected.
 */
- (BOOL)createDatabase:(NSError **)error;


/**
 * Function that deletes the database on the application folder
 * @param error - pointer to a NSError class to return possible errors, nil if errors arent detected.
 */
- (void)deleteDatabase:(NSError**)error;


@end
