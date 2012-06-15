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

+ (void) addFilterForObject:(id)object ofType:(FilterType) filterType {
    Filter* filter = [[Filter alloc] initWithFilterType:filterType andObject:object];
    [[filterManager mutableArrayValueForKey:@"filters"] insertObject:filter atIndex:0];
}

+ (void) removeFilterForObject:(id)object ofType:(FilterType) filterType {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"filterType != %i OR  object != %@", filterType, [object description]];
    
    [[filterManager mutableArrayValueForKey:@"filters"] filterUsingPredicate:predicate];
    
}

+ (BOOL) containsFilterForObject:(id)object ofType:(FilterType) filterType {
    for(Filter* filter in filterManager.filters)
        if([filter.object isEqual:object] && filter.filterType == filterType)
            return true;
    return false;
    
}

+ (void) removeFiltersOfType:(FilterType) filterType {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"filterType != %i", filterType];
    
    NSMutableArray* array = [[filterManager.filters filteredArrayUsingPredicate:predicate] mutableCopy];
    filterManager.filters = array;
    
}

+ (void) removeAllFilters {
    
    [[filterManager mutableArrayValueForKey:@"filters"] removeAllObjects];
    
}

+ (int) numberOfFiltersOfType:(FilterType) filterType {
    int i = 0;
    for(Filter* filter in filterManager.filters) {
        if(filter.filterType == filterType)
            i++;
    }
    
    return i;
}

+ (NSMutableArray*) applyFilters:(NSArray*) unfilteredArray {
    
    
     NSMutableArray* array = [unfilteredArray mutableCopy];
    
    for(int i = 0; i < FilterTypeCount; i++) {
        
        //separa filtros por tipo
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"filterType == %i", i];
        NSArray* arrayOfFilters = [filterManager.filters filteredArrayUsingPredicate:predicate];
        
        if( [arrayOfFilters count] == 0)
            continue;
        
        //constroi um predicado para cada tipo de filtro
        NSString* string = nil;
        
        for(Filter* filter in arrayOfFilters) {
            switch (i) {
                case FilterTypeYear:
                    if(string == nil)
                        string = [NSString stringWithFormat:@"year == %i", [filter.object intValue]];
                    else
                        string = [NSString stringWithFormat:@"%@ OR year == %i", string, [filter.object intValue]];
                    break;
                    
                case FilterTypeCountry:
                    if(string == nil)
                        string = [NSString stringWithFormat:@"region.country_name == \"%@\"", filter.object];
                    else
                        string = [NSString stringWithFormat:@"%@ OR region.country_name == \"%@\"", string, filter.object];
                    break;
                    
                case FilterTypeWineType:
                    if(string == nil)
                        string = [NSString stringWithFormat:@"winetype.name == \"%@\"", filter.object];
                    else
                        string = [NSString stringWithFormat:@"%@ OR winetype.name == \"%@\"", string, filter.object];
                    break;
                    
                case FilterTypeProducer:
                    if(string == nil)
                        string = [NSString stringWithFormat:@"producer == \"%@\"", [filter.object description]];
                    else
                        string = [NSString stringWithFormat:@"%@ OR producer == \"%@\"", string, filter.object];
                    break;
            }
        }
        predicate = [NSPredicate predicateWithFormat:string];
        [array filterUsingPredicate:predicate];
    }
    return array;
}

@end
