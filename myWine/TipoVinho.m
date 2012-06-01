//
//  TipoVinho.m
//  myWine
//
//  Created by Fernando Gracas on 4/29/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "TipoVinho.h"
#import "Language.h"

@implementation TipoVinho

@synthesize name = _name;
@synthesize winetype_id = _winetype_id;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;


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
