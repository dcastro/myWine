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


-(sqlite3_stmt *)prepareForSingleQuery:(NSString *)query{
    
    sqlite3_stmt    *statement;
    const char* dbpath = [db.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        char *errMsg;
        if(sqlite3_exec(contactDB, "Pragma foreign_keys = ON;", NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Could not activate foreign keys error: %s", errMsg);
            sqlite3_free(errMsg);
            sqlite3_close(contactDB);
            return nil;
        }
        
        const char *query_stmt = [query UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            return statement;
        }else{
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


-(sqlite3 **)prepareForExecution{
    const char* dbpath = [db.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        char *errMsg;
        if(sqlite3_exec(contactDB, "Pragma foreign_keys = ON;", NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Could not activate foreign keys error: %s", errMsg);
            sqlite3_free(errMsg);
            sqlite3_close(contactDB);
            return NULL;
        }
        return &contactDB;
    }  
    return NULL;
    
}



-(sqlite3 **)beginTransaction{
    const char* dbpath = [db.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        char *errMsg;
        if(sqlite3_exec(contactDB, "Pragma foreign_keys = ON;", NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Could not activate foreign keys error: %s", errMsg);
            sqlite3_free(errMsg);
            sqlite3_close(contactDB);
            return NULL;
        }
        
        if(sqlite3_exec(contactDB, "Begin Transaction;", NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Could not begin transaction: %s", errMsg);
            sqlite3_free(errMsg);
            sqlite3_close(contactDB);
            return NULL;
        }
        
        return &contactDB;
    }  
    return NULL;
}



-(BOOL)endTransaction{
    char *errMsg;
    if(sqlite3_exec(contactDB, "Commit Transaction;", NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Could not commit transaction: %s", errMsg);
        sqlite3_free(errMsg);
        sqlite3_close(contactDB);
        return FALSE;
    }else {
        sqlite3_close(contactDB);
        return TRUE;
    }
}


-(BOOL)rollbackTransaction{
    char *errMsg;
    if(sqlite3_exec(contactDB, "Rollback Transaction;", NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Could not rollback transaction: %s", errMsg);
        sqlite3_free(errMsg);
        sqlite3_close(contactDB);
        return FALSE;
    }else {
        sqlite3_close(contactDB);
        return TRUE;
    }
}

@end
