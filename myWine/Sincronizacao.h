//
//  Sincronizacao.h
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Query.h"
#import "User.h"

/**
 Class that contains the methods to build the http request json and parse the http response.
 */
@interface Sincronizacao : NSObject{
    Query * query;
    sqlite3 ** contactDB;
    User *user;
}

/**
 Default initializer
 */
-(id)init;




/**
 Build the request json to be used in the http connection
 
 @param error - pointer an error classe to be modified in case of error
 @returns string - encoded string with the json information
 */
-(NSString *)buildRequest:(NSError **) error;




/**
 Parses the data of the response from the http connection. 
 In this method the connection to database is initialized with a transaction.
 In case of error the transaction is rolledback so that the information of the user is restored.
 
 @param data -  data received from the server
 @return boolean - the result of the parse
 */
-(BOOL)parseData:(NSMutableData *)receivedData;




@end
