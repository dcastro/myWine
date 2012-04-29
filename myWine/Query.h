//
//  Query.h
//  myWine
//
//  Created by Fernando Gracas on 4/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface Query : NSObject{
    Database *db;
    sqlite3 *contactDB;
}


/**
 * Default object initializer
 */
-(id)init;


/**
 * Function that tests if the query to be executed is valid. 
 * This function can only be used for deletes, inserts and updates if, and only if, 
 * there is a query in the statement after the insert/update/delete.
 * Opens the database and compiles the query for execution.
 * After execution must call function filalizeQuery if the query is correct.
 *
 * @param query - query to be executed
 * 
 * @return sqlite statement compiled. Returns nil if the query is not valid.  */
-(sqlite3_stmt *)prepareForSingleQuery:(NSString*)query;



/**
 * Function that finalizes the query.
 * Must be called if the function prepareForSingleQuery or prepareForExecution succeeded.
 *
 * @param statement - statement returned from funcion prepareForQuery
 */
-(void)finalizeQuery:(sqlite3_stmt *)statement;



/**
 * Function that prepares for the execution of inserts, updates, deletes.
 * @return - true if the database can accept inserts, updates, deletes. Must call finalizeQuery if returns true
 */
-(sqlite3 *)prepareForExecution;


@end
