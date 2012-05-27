//
//  Sincronizacao.m
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Sincronizacao.h"
#import "User.h"

@implementation Sincronizacao



-(NSString *)buildRequest:(NSError **) error{
    
    User *u = [User instance];
    NSString * synced_at = nil;
    
    
    NSMutableDictionary * requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:u.username,@"username" ,u.password, @"password" , u.synced_at, @"synced_at" , nil];
    
    
    
#warning TODO: FERNANDO fazer o resto
    
    
    
    
    //conversao para string
    NSError * jsonErr = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:error];
    
    if(error){
        return nil;
    }else {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}


-(BOOL)parseData:(NSMutableData *)receivedData{
    return FALSE;
}


-(NSMutableDictionary *)buidRequestNewWines{
    return Nil;
    
}



-(NSMutableDictionary *)buildRequestNewTastings{
    return Nil;
}



-(NSMutableDictionary *)buildRequestDeleted{
    return Nil;
}



-(NSMutableDictionary *)buildRequestUpdatedWines{
    return Nil;
}



-(BOOL)processResponseDeleted:(NSDictionary *)deleted{
    return TRUE;
}



-(BOOL)processResponseCountries:(NSArray *)countries{
    return TRUE;
}


@end
