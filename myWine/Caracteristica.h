//
//  Caracteristica.h
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Classificacao.h"

@interface Caracteristica : NSObject

@property (nonatomic, assign) int characteristic_id;
@property (nonatomic, assign) int order;
@property (nonatomic, retain) Classificacao * classification_chosen;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * name_en;
@property (nonatomic, copy) NSString * name_fr;
@property (nonatomic, copy) NSString * name_pt;
@property (nonatomic, strong) NSMutableArray * classifications;

- (NSString*) description;

- (BOOL) save;

@end
