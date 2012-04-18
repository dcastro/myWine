//
//  Query.m
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Query.h"


@implementation Query


-(id)init{
    db = [Database instance];
    return self;
}


-(sqlite3_stmt *)prepareForQuery:(NSString *)query{
    
    sqlite3_stmt    *statement;
    const char* dbpath = [db.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        const char *query_stmt = [query UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, 
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
            return statement;
        else{
            sqlite3_close(contactDB);
            DebugLog(@"Query with error: %s", query_stmt);
            return nil;
        }
    }else{
        DebugLog(@"Cannot access database");
        return nil;
    }
}


-(void)finalizeQuery:(sqlite3_stmt *)statement{
    sqlite3_finalize(statement);
    sqlite3_close(contactDB);
}


-(BOOL)prepareForExecution{
    const char* dbpath = [db.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        return TRUE;
    return FALSE;
    
}

@end
