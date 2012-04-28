//
//  Criterio.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Criterio.h"

@implementation Criterio

@synthesize name = _name;
@synthesize section_id=_section_id;
@synthesize classification_choosen = _classification_choosen;
@synthesize classifications = _classifications;

- (NSMutableArray *)classifications {
    if(!_classifications){
        [self loadClassificationsFromDB];
    }
    return _classifications;
}

- (Classificacao *)classification_choosen {
    if(!_classification_choosen){
        [self loadClassificationChoosenFromDB];
    }
    return _classification_choosen;
}


-(BOOL) loadClassificationsFromDB{
    return true;
}


-(BOOL) loadClassificationChoosenFromDB{
    return TRUE;
}


@end
