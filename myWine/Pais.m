//
//  Pais.m
//  myWine
//
//  Created by Diogo Castro on 04/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Pais.h"
#import "Regiao.h"

@implementation Pais

@synthesize name = _name;
@synthesize regions = _regions;
@synthesize id = _id;


- (NSMutableArray*) regions {
    if (! _regions) {
        [self loadRegions];
    }
    
    return _regions;
}

- (void) loadRegions {
    
#warning TODO: load das regioes
    Regiao* r = [[Regiao alloc] init];
    r.region_name = @"Douro";
    
    _regions = [[NSMutableArray alloc] initWithObjects:r , nil];
}


@end
