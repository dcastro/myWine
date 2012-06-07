//
//  Filter.m
//  myWine
//
//  Created by Diogo Castro on 06/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Filter.h"

@implementation Filter

@synthesize filterType = _filterType;
@synthesize object = _object;

-(Filter*) initWithFilterType:(FilterType)filterType andObject:(id) object {
    self = [super init];
    if(self) {
        self.filterType = filterType;
        self.object = object;
    }
    return self;
}

@end
