//
//  Classificacao.h
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classificacao : NSObject

@property (nonatomic, assign) int classification_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int weight;

@end
