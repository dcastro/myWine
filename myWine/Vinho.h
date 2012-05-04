//
//  Vinho.h
//  myWine
//
//  Created by Diogo Castro on 18/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Regiao.h"
#import "TipoVinho.h"

@interface Vinho : NSObject

@property (nonatomic, assign) int wine_id;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *producer;
@property (nonatomic, retain) Regiao * region;
@property (nonatomic, retain) TipoVinho *winetype;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic,copy) NSMutableArray *provas;



- (NSString*) description;

- (void) updateWithVinho:(Vinho*) vinho;

@end
