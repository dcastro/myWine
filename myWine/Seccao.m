//
//  Seccao.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Seccao.h"

@implementation Seccao

@synthesize name = _name;
@synthesize section_id = _section_id;
@synthesize characteristics = _characteristics;
@synthesize criterions = _criterions;


-(NSMutableArray *) characteristics {
    if (!_characteristics) {
        [self loadCharacteristicsFromDB];
    }
    return _characteristics;
}

-(NSMutableArray *)  criterions{
    if(!_criterions){
        [self loadCriterionsFromDB];
    }
    return _criterions;
}


- (BOOL) loadCharacteristicsFromDB {
    return TRUE;
}


- (BOOL) loadCriterionsFromDB {
    return TRUE;
}

         

@end
