//
//  Seccao.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Seccao.h"
#import "Criterio.h"
#import "Caracteristica.h"
#import "Language.h"
#import "Query.h"

@implementation Seccao

@synthesize name = _name;
@synthesize section_id = _section_id;
@synthesize characteristics = _characteristics;
@synthesize criteria = _criteria;


-(NSMutableArray *) characteristics {
    if (!_characteristics) {
        [self loadCharacteristicsFromDB];
    }
    return _characteristics;
}

-(NSMutableArray *)  criteria{
    if(!_criteria){
        [self loadCriteriaFromDB];
    }
    return _criteria;
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
                        WHERE ch.section_id = %d AND ch.classification_id = c.classification_id;", _section_id];
            break;
            
        case EN: 
            querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.name_en, c.classification_id, c.weight, c.name_en\
                        FROM Characteristic ch, Classification c\
                        WHERE ch.section_id = %d AND ch.classification_id = c.classification_id;", _section_id];
            break;
            
        case PT:
            querySQL = [NSString stringWithFormat:@"SELECT ch.characteristic_id, ch.name_pt, c.classification_id, c.weight, c.name_pt\
                        FROM Characteristic ch, Classification c\
                        WHERE ch.section_id = %d AND ch.classification_id = c.classification_id;", _section_id];
    
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


- (BOOL) loadCriteriaFromDB {
    _criteria = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT cr.criterion_id, cr.name_fr, c.classification_id, c.weight, c.name_fr\
                        FROM Criterion cr, Classification c\
                        WHERE cr.section_id = %d AND cr.classification_id = c.classification_id;", _section_id];
            break;
            
        case EN: 
            querySQL = [NSString stringWithFormat:@"SELECT cr.criterion_id, cr.name_en, c.classification_id, c.weight, c.name_en\
                        FROM Criterion cr, Classification c\
                        WHERE cr.section_id = %d AND cr.classification_id = c.classification_id;", _section_id];

            break;
            
        case PT:
            querySQL = [NSString stringWithFormat:@"SELECT cr.criterion_id, cr.name_pt, c.classification_id, c.weight, c.name_pt\
                        FROM Criterion cr, Classification c\
                        WHERE cr.section_id = %d AND cr.classification_id = c.classification_id;", _section_id];

            
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Criterio *cr = [[Criterio alloc]init];
            
            cr.criterion_id = sqlite3_column_int(stmt, 0);
            cr.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 2);
            c.weight = sqlite3_column_int(stmt, 3);
            c.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            cr.classification_choosen = c;
            
            [_criteria insertObject:cr atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;

}

- (NSString*) description {
    return self.name;
}
         

@end
