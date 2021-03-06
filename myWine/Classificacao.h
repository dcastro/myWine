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
@property (nonatomic, copy) NSString * name_en;
@property (nonatomic, copy) NSString * name_fr;
@property (nonatomic, copy) NSString * name_pt;
@property (nonatomic, assign) NSInteger weight;


- (NSComparisonResult)compare:(Classificacao *)classification;

- (BOOL)isEqual:(id)anObject;

@end
