//
//  Criterio.h
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Classificacao.h"

@interface Criterio : NSObject

@property (nonatomic, assign) int criterion_id;
@property (nonatomic, retain) Classificacao * classification_chosen;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * name_en;
@property (nonatomic, strong) NSString * name_fr;
@property (nonatomic, strong) NSString * name_pt;
@property (nonatomic, assign) int order;
@property (nonatomic, strong) NSMutableArray * classifications;

@property (nonatomic, strong) Classificacao* classification; //for editing

- (NSString*) description;

- (int) minWeight;
- (int) maxWeight;

- (BOOL) save;

@end
