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
@synthesize classification_chosen = _classification_chosen;
@synthesize classifications = _classifications;
@synthesize classification;

- (NSMutableArray *)classifications {
    if(!_classifications){
        [self loadClassificationsFromDB];
    }
    return _classifications;
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

- (NSString*) description {
    return self.name;
}

- (BOOL) save {
    
    if(self.classification == nil)
        return true;
    
    self.classification_chosen = self.classification;  
    
    Query *query = [[Query alloc]init];
    NSString * querySQL = [NSString stringWithFormat:@"UPDATE Characteristic SET classification_id = %d WHERE characteristic_id= %d", 
                           self.classification_chosen.classification_id,
                           self.characteristic_id];
    sqlite3 ** contactDB = [query prepareForExecution];
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        sqlite3_close(*contactDB);
        return FALSE;
    }
    sqlite3_close(*contactDB);
    
    
    
    return TRUE;
}

@end
