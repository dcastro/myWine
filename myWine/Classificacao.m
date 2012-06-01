//
//  Classificacao.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Classificacao.h"
#import "Language.h"

@implementation Classificacao

@synthesize classification_id = _classification_id;
@synthesize name = _name;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;
@synthesize weight = _weight;

- (NSComparisonResult)compare:(Classificacao *)classification {
    if ([self weight] < [classification weight])
        return NSOrderedAscending;
    else if ([self weight] > [classification weight])
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
}


-(NSString *)name
{
        
    Language * lan = [Language instance];
    
    switch (lan.selectedLanguage) {
        case EN:
            _name = _name_en;
            break;
            
        case FR:
            _name = _name_fr;
            break;
            
        case PT:
            _name = _name_pt;
            break;
            
        default:
            break;
    }
    
    return _name;
}


@end
