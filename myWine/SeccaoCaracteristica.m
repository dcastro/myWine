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


-(NSMutableArray *) characteristics {
    if (!_characteristics) {
        [self loadCharacteristicsFromDB];
    }
    return _characteristics;
}



- (BOOL) loadCharacteristicsFromDB {
    _characteristics = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.name_fr, c.classification_id, c.weight, c.name_fr\
                        FROM Characteristic ch, Classification c\
                        WHERE ch.sectioncharacteristic_id = %d AND ch.classification_id = c.classification_id \
                        ORDER BY order_priority ASC;", _sectioncharacteristic_id];
            break;
            
        case EN: 
            querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.name_en, c.classification_id, c.weight, c.name_en\
                        FROM Characteristic ch, Classification c\
                        WHERE ch.sectioncharacteristic_id = %d AND ch.classification_id = c.classification_id \
                        ORDER BY order_priority ASC;", _sectioncharacteristic_id];
            break;
            
        case PT:
            querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.name_pt, c.classification_id, c.weight, c.name_pt\
                        FROM Characteristic ch, Classification c\
                        WHERE ch.sectioncharacteristic_id = %d AND ch.classification_id = c.classification_id \
                        ORDER BY order_priority ASC;", _sectioncharacteristic_id];
            
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Caracteristica *ch = [[Caracteristica alloc]init];
            
            ch.characteristic_id = sqlite3_column_int(stmt, 0);
            ch.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 2);
            c.weight = sqlite3_column_int(stmt, 3);
            c.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
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
