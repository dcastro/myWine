//
//  FilterManager.h
//  myWine
//
//  Created by Diogo Castro on 06/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterViewController.h"

@class Filter;

@interface FilterManager : NSObject

@property (strong, nonatomic) NSMutableArray* filters;

+ (FilterManager*) instance;

+ (void) addFilterForObject:(id)object ofType:(FilterType) filterType;
+ (void) removeFilterForObject:(id)object ofType:(FilterType) filterType;
+ (void) removeFiltersOfType:(FilterType) filterType;
+ (void) removeAllFilters;
+ (int) numberOfFiltersOfType:(FilterType) filterType;
+ (NSMutableArray*) applyFilters:(NSArray*) unfilteredArray;

@end
