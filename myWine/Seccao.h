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
@property (nonatomic, strong) NSMutableArray * criteria;
@property (nonatomic, copy) NSMutableArray * characteristics;

@end
