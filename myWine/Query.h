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
 * Function that tests if the query to be executed is valid. This function is not for deletes, inserts and updates
 * Opens the database and compiles the query for execution.
 * 
 * @param query - query to be executed
 * 
 * @return sqlite statement compiled. Returns nil if the query is not valid. After execution must call function filalizeQuery if the query is correct.
 */
-(sqlite3_stmt *)prepareForSingleQuery:(NSString*)query;



/**
 *Function that opens the connection to the database for the execution of multiple queries afterwards.
 *Call function prepareDBForQuery for each query to be executed. 
 *@return pointer to the database connection;
 */
-(sqlite3 *)prepareForMultipleQueries;


/**
 *
 */
-(sqlite3_stmt *)prepareDB:(sqlite3 *)bd ForQuery:(NSString*)query;


/**
 * Function that finalizes the query. Must be called if the function prepareForSingleQuery or prepareForExecution succeeded.
 *
 * @param statement - statement returned from funcion prepareForQuery
 */
-(void)finalizeQuery:(sqlite3_stmt *)statement;



/**
 * Function that prepares for the execution of inserts, updates, deletes.
 * @return - true if the database can accept inserts, updates, deletes. Must call finalizeQuery if returns true
 */
-(BOOL)prepareForExecution;


@end
