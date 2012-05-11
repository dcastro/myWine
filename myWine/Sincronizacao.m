//
//  Sincronizacao.m
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Sincronizacao.h"

@implementation Sincronizacao


-(BOOL)sync:(NSError **)error{
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
    //TODO: delete dos wine/tastings enviados mais os recebidos pelo server
    return TRUE;
}



-(BOOL)processResponseCountries:(NSArray *)countries{
    return TRUE;
}


@end
