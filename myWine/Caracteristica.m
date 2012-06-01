//
//  Caracteristica.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Caracteristica.h"
#import "Classificacao.h"
#import "Query.h"
#import "Language.h"

@implementation Caracteristica

@synthesize name = _name;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;
@synthesize order = _order;
@synthesize characteristic_id = _characteristic_id;
@synthesize classification_choosen = _classification_choosen;
@synthesize classifications = _classifications;

- (NSMutableArray *)classifications {
    if(!_classifications){
        [self loadClassificationsFromDB];
    }
    return _classifications;
}


-(NSString *)name
{
    if(!_name){
        
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
    }
    
    return _name;
}

-(BOOL) loadClassificationsFromDB{
    _classifications = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT c.classification_id, c.weight, c.name_en, c.name_fr, c.name_pt\
                FROM Classification c, PossibleClassification ps\
                WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Characteristic' AND ps.classification_id = c.classification_id;", _characteristic_id];
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 0);
            c.weight = sqlite3_column_int(stmt, 1);
            c.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            c.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            c.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];

            
            [_classifications insertObject:c atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
}

@end
