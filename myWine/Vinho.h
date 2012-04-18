//
//  Vinho.h
//  myWine
//
//  Created by Diogo Castro on 18/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vinho : NSObject


@property (nonatomic, assign) int wine_id;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *producer;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *winetype_name;
@property (nonatomic, copy) NSString *photo;




- (NSString*) description;

@end
