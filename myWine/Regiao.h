//
//  Regiao.h
//  myWine
//
//  Created by Fernando Gracas on 4/29/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Regiao : NSObject

@property (nonatomic, assign) int region_id;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *country_name;

@end
