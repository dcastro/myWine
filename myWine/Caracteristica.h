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
@property (nonatomic, retain) Classificacao * classification_choosen;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSMutableArray * classifications;

@end