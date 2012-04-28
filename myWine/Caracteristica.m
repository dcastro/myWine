//
//  Caracteristica.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Caracteristica.h"

@implementation Caracteristica

@synthesize name = _name;
@synthesize characteristic_id = _characteristic_id;
@synthesize classification_choosen = _classification_choosen;
@synthesize classifications = _classifications;

- (NSMutableArray *)classifications {
    if(!_classifications){
        [self loadClassificationsFromDB];
    }
    return _classifications;
}

-(BOOL) loadClassificationsFromDB{
    return true;
}

@end
