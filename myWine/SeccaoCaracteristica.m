//
//  SeccaoCaracteristica.m
//  myWine
//
//  Created by Fernando Gracas on 5/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "SeccaoCaracteristica.h"
#import "Query.h"
#import "Caracteristica.h"
#import "Language.h"

@implementation SeccaoCaracteristica

@synthesize characteristics = _characteristics;
@synthesize sectioncharacteristic_id = _sectioncharacteristic_id;
@synthesize name = _name;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;
@synthesize order = _order;



-(NSMutableArray *) characteristics {
    if (!_characteristics) {
        [self loadCharacteristicsFromDB];
    }
    return _characteristics;
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




- (BOOL) loadCharacteristicsFromDB {
    _characteristics = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.order_priority , ch.name_en, ch.name_fr, ch.name_pt, \
                c.classification_id, c.weight, c.name_en, c.name_fr, c.name_pt\
                FROM Characteristic ch, Classification c\
                WHERE ch.sectioncharacteristic_id = %d AND ch.classification_id = c.classification_id \
                ORDER BY ch.order_priority ASC;", _sectioncharacteristic_id];
   
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Caracteristica *ch = [[Caracteristica alloc]init];
            
            ch.characteristic_id = sqlite3_column_int(stmt, 0);
            ch.order = sqlite3_column_int(stmt, 1);
            ch.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            ch.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            ch.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];


            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 5);
            c.weight = sqlite3_column_int(stmt, 6);
            c.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            c.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            c.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];

            
            ch.classification_choosen = c;
            
            [_characteristics insertObject:ch atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
    
}


@end
