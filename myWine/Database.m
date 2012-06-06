//
//  Database.m
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Database.h"

static Database *myDatabase = nil;

@implementation Database


@synthesize databasePath;


#pragma mark Singleton Methods
+(id)instance{
    @synchronized(self) {
        if(myDatabase == nil)
            myDatabase = [[self alloc] init];
    }
    return myDatabase;
}

-(id)init{
    if(self = [super init]){
        
        // Get the documents directory
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docsDir = [dirPaths objectAtIndex:0];

        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: [[NSString alloc] initWithBytes:databaseFilename length:sizeof(databaseFilename) encoding:NSASCIIStringEncoding]]];
  
    }
    return self;
}



- (BOOL)isDatabaseCreated{
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        return FALSE;
    }else {
        return TRUE;
    }
    
}

- (BOOL)createDatabase:(NSError **)error{
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        DebugLog(@"Database pathname: %s", dbpath);
        //creates the database
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            if(sqlite3_exec(contactDB, "Pragma foreign_keys = ON;", NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Could not activate foreign keys error: %s", errMsg);
                sqlite3_free(errMsg);
                
                //create the error message in NSError
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Database Error" forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"myWine" code:100 userInfo:errorDetail];
                
                return FALSE;
            }
            
            int i = 0;
            
            while(strcmp(databaseTables[i], "\n") != 0) {
                
                const char *sql_stmt = databaseTables[i];
                
                if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    
                    //create the error message in NSError
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:@"Database Creation Error" forKey:NSLocalizedDescriptionKey];
                    *error = [NSError errorWithDomain:@"myWine" code:100 userInfo:errorDetail];
                    
                    DebugLog(@"Creating table: %s", sql_stmt);
                    DebugLog(@"ERROR: %s", errMsg);
                    sqlite3_free(errMsg);
                    
                    sqlite3_close(contactDB);//close the database before quiting the function
                    
                    [self deleteDatabase: error];
                    
                    return FALSE;
                }
                i++;
            }
            sqlite3_close(contactDB);
        } else {
            
            //create the error message in NSError
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Database Error" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"myWine" code:100 userInfo:errorDetail];
            
            DebugLog(@"Error connecting to the database");
            
            return FALSE;
        }
    }
    
    return TRUE;
    
}




- (void)deleteDatabase:(NSError **)error{
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    
    if ([filemgr removeItemAtPath:databasePath error:error] == YES){
        DebugLog(@"Removed DataBase from system");
        return;
    }else {
        DebugLog(@"Failled to remove DataBase from system");
        return;
    }
    
}



@end
