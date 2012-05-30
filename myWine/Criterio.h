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
@property (nonatomic, copy) NSMutableArray * classifications;

- (NSString*) description;

- (int) minWeight;
- (int) maxWeight;

- (void) save;

@end
