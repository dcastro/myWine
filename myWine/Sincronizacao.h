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

@interface Sincronizacao : NSObject{
    Query * query;
    sqlite3 ** contactDB;
    User *user;
}


-(NSString *)buildRequest:(NSError **) error;


-(BOOL)parseData:(NSMutableData *)receivedData;




@end
