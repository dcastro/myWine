//
//  Seccao.h
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seccao : NSObject

@property (nonatomic, assign) int section_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * name_en;
@property (nonatomic, copy) NSString * name_fr;
@property (nonatomic, copy) NSString * name_pt;
@property (nonatomic, assign) int order;

@property (nonatomic, strong) NSMutableArray * criteria;

@property (strong, nonatomic) UILabel* label;

@end
