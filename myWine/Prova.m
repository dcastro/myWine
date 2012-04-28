//
//  Prova.m
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Prova.h"

@implementation Prova

@synthesize tasting_date = _tasting_date;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize comment = _comment; 
@synthesize tasting_id = _tasting_id;
@synthesize sections = _sections;

- (NSMutableArray *) sections {
    if (!_sections) {
        [self loadSectionsFromDB];
    }
    return _sections;
}


-(BOOL) loadSectionsFromDB{
#warning FAZER LOAD DAS SECCOES
    return TRUE;
}


@end
