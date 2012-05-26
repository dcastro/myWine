//
//  Classificacao.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Classificacao.h"

@implementation Classificacao

@synthesize classification_id = _classification_id;
@synthesize name = _name;
@synthesize weight = _weight;

- (NSComparisonResult)compare:(Classificacao *)classification {
    if ([self weight] < [classification weight])
        return NSOrderedAscending;
    else if ([self weight] > [classification weight])
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
}

@end
