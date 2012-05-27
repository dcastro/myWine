//
//  Prova.h
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prova : NSObject

@property (nonatomic, assign)  int tasting_date;
@property (nonatomic, assign) int tasting_id;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic,strong) NSMutableArray *sections;
@property (nonatomic,strong) NSMutableArray *characteristic_sections;

- (NSString*) fullDate;

@end
