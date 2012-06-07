//
//  FilterManager.m
//  myWine
//
//  Created by Diogo Castro on 06/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FilterManager.h"
#import "Filter.h"

static FilterManager* filterManager = nil;

@implementation FilterManager

@synthesize filters;

+ (FilterManager*) instance {
    @synchronized(self) {
        if (filterManager == nil)
            filterManager = [[self alloc] init];
    }
    return filterManager;
    
}

- (id)init {
    if (self = [super init]) {
        self.filters = [[NSMutableArray alloc] init];
    }
    return self;

}

+ (void) addFilter:(Filter*) filter {
    [filterManager.filters insertObject:filter atIndex:0];
}

+ (void) removeFiltersOfType:(FilterType) filterType {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"filterType != %i", filterType];
    
    NSMutableArray* array = [[filterManager.filters filteredArrayUsingPredicate:predicate] mutableCopy];
    filterManager.filters = array;
    
}

+ (void) removeAllFilters {
    
    [filterManager.filters removeAllObjects];
    
}

+ (NSMutableArray*) applyFilters:(NSArray*) unfilteredArray {
    
    NSMutableArray* array = [unfilteredArray mutableCopy];
    for(Filter* filter in filterManager.filters) {
        
        NSPredicate* predicate;
        
        switch (filter.filterType) {
            case FilterTypeYear:
                predicate = [NSPredicate predicateWithFormat:@"year != %i", [filter.object intValue] ];
                break;
            case FilterTypeCountry:
                predicate = [NSPredicate predicateWithFormat:@"region.country_name != %@", filter.object];
                break;
            case FilterTypeWineType:
                predicate = [NSPredicate predicateWithFormat:@"winetype.name != %@", filter.object];
                break;
            case FilterTypeProducer:
                predicate = [NSPredicate predicateWithFormat:@"producer != %@", filter.object];
                break;
        }
        
        [array filterUsingPredicate:predicate];
    }
        
    return array;
}

@end