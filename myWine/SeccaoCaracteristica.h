//
//  SeccaoCaracteristica.h
//  myWine
//
//  Created by Fernando Gracas on 5/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeccaoCaracteristica : NSObject

@property (nonatomic, assign) int sectioncharacteristic_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSMutableArray * characteristics;

@end
