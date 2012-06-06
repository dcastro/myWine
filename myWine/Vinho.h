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

@interface Vinho : NSObject <NSCopying>

@property (nonatomic, assign) int wine_id;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) double price;
@property (nonatomic) int currency;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *producer;
@property (nonatomic, retain) Regiao * region;
@property (nonatomic, retain) TipoVinho *winetype;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic) NSMutableArray *provas;
@property (nonatomic, copy) NSString* grapes;



- (NSString*) description;
- (NSString*) fullPrice;
- (int) score;

- (BOOL) updateWithVinho:(Vinho*) vinho;

- (NSComparisonResult)compareUsingName:(Vinho*)vinho;
- (NSComparisonResult)compareUsingScore:(Vinho*)vinho;

@end
