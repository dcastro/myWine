//
//  Pais.m
//  myWine
//
//  Created by Diogo Castro on 04/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Pais.h"
#import "Regiao.h"
#import "Query.h"
#import "Language.h"

@implementation Pais

@synthesize name = _name;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;
@synthesize regions = _regions;
@synthesize id = _id;


- (NSMutableArray*) regions {
    if (! _regions) {
        [self loadRegionsFromDB];
    }
    
    return _regions;
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



- (BOOL) loadRegionsFromDB {
        
    _regions = [[NSMutableArray alloc] init];
    
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL= [NSString stringWithFormat:@"SELECT r.region_id, r.name\
                         FROM Region r\
                         WHERE r.country_id = \'%@\'\
                         ORDER BY r.name DESC",self.id];
                  
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Regiao *region = [[Regiao alloc] init];
            
            region.region_id = sqlite3_column_int(stmt, 0);
            region.region_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            region.country_name = self.name;
            
            [_regions insertObject:region atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }else
        return FALSE;
}






@end
