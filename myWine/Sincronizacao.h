//
//  Sincronizacao.h
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sincronizacao : NSObject


-(NSString *)buildRequest:(NSError **) error;


-(BOOL)parseData:(NSMutableData *)receivedData;




@end
