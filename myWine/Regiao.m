//
//  Regiao.m
//  myWine
//
//  Created by Fernando Gracas on 4/29/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Regiao.h"
#import "Language.h"

@implementation Regiao

@synthesize region_name = _region_name;
@synthesize country_name = _country_name;
@synthesize region_id = _region_id;
@synthesize country_name_en = _country_name_en;
@synthesize country_name_fr = _country_name_fr;
@synthesize country_name_pt = _country_name_pt;



-(NSString *)country_name
{
        
    Language * lan = [Language instance];
    
    switch (lan.selectedLanguage) {
        case EN:
            _country_name = _country_name_en;
            break;
            
        case FR:
            _country_name = _country_name_fr;
            break;
            
        case PT:
            _country_name = _country_name_pt;
            break;
            
        default:
            break;
    }
    
    return _country_name;
}


@end
