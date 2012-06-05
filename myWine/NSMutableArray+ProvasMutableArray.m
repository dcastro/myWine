//
//  NSMutableArray+ProvasMutableArray.m
//  myWine
//
//  Created by Nuno Sousa on 5/16/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NSMutableArray+ProvasMutableArray.h"
#import "Query.h"
#import "Seccao.h"
#import "SeccaoCaracteristica.h"
#import "Caracteristica.h"

@implementation NSMutableArray (ProvasMutableArray)

- (BOOL) insertProva:(Prova*)prova atIndex:(NSUInteger)index withVinhoID:(int) wine_id {

    Query *query = [[Query alloc] init];
    NSString * querySQL;
    sqlite3** contactDB = [query beginTransaction];
    sqlite3_stmt *stmt;
    char * errMsg;

    
    querySQL = [NSString stringWithFormat:@"INSERT INTO Tasting (wine_id, tasting_date, comment, latitude, longitude, state) \
                VALUES (%d, '%@', '%@', %f, %f, %d); \
                SELECT DISTINCT last_insert_rowid() FROM Tasting;",
                wine_id,
                prova.tasting_date,
                prova.comment,
                prova.latitude,
                prova.longitude,
                1];
    
    //insere prova obtem id
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            prova.tasting_id = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
        }
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        [query rollbackTransaction];        
        return FALSE;
    }
    
    
    //insere criterios
    for (Seccao* section in [prova sections]) {
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO Section (tasting_id, order_priority, name_en, name_fr, name_pt) \
                    VALUES (%d, %d, '%@', '%@', '%@'); \
                    SELECT DISTINCT last_insert_rowid() FROM Section;",
                    prova.tasting_id, 
                    section.order, 
                    section.name_en, 
                    section.name_fr, 
                    section.name_pt];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                section.section_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                
                for(Criterio* criterion in [section criteria]){
                    querySQL = [NSString stringWithFormat:@"INSERT INTO Criterion (section_id, order_priority, classification_id, name_en, name_fr, name_pt) \
                                VALUES (%d, %d, %d, '%@', '%@', '%@'); \
                                SELECT DISTINCT last_insert_rowid() FROM Criterion;",
                                section.section_id,
                                criterion.order,
                                criterion.classification_chosen.classification_id,
                                criterion.name_en,
                                criterion.name_fr,
                                criterion.name_pt];
                    
                    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                        if(sqlite3_step(stmt) == SQLITE_ROW){
                            criterion.criterion_id = sqlite3_column_int(stmt, 0);
                            sqlite3_finalize(stmt);
                            
                            for (Classificacao* classification in criterion.classifications) {
                                
                                querySQL = [NSString stringWithFormat:@"INSERT INTO PossibleClassification (classifiable_id, classification_id, classifiable_type) \
                                            VALUE (%d, %d, \'%@\');", 
                                            criterion.criterion_id,
                                            criterion.classification_chosen.classification_id,
                                            @"Criterion"];
                                
                                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                                    DebugLog(@"Query with error: %s", errMsg);
                                    sqlite3_free(errMsg);
                                    [query rollbackTransaction];
                                    return FALSE;
                                }
                                
                            }
                            
                        }
                    }else {
                        DebugLog(@"Query with error: %@", querySQL);
                        [query rollbackTransaction];
                        return FALSE;
                    }
                    
                }
                
            }
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            [query rollbackTransaction];
            return FALSE;
        }
        
        
    }
    
    
    
    
    //insere caracteristicas
    for (SeccaoCaracteristica* characteristicSection in [prova characteristic_sections]) {
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO SectionCharacteristic (tasting_id, order_priority, name_en, name_fr, name_pt) \
                    VALUES (%d, %d, '%@', '%@', '%@'); \
                    SELECT DISTINCT last_insert_rowid() FROM SectionCharacteristic;",
                    prova.tasting_id, 
                    characteristicSection.order, 
                    characteristicSection.name_en, 
                    characteristicSection.name_fr, 
                    characteristicSection.name_pt];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                characteristicSection.sectioncharacteristic_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                
                for(Caracteristica* characteristic in [characteristicSection characteristics]){
                    querySQL = [NSString stringWithFormat:@"INSERT INTO Characteristic (sectioncharacteristic_id, order_priority, classification_id, name_en, name_fr, name_pt) \
                                VALUES (%d, %d, %d, '%@', '%@', '%@'); \
                                SELECT DISTINCT last_insert_rowid() FROM Characteristic;",
                                characteristicSection.sectioncharacteristic_id,
                                characteristic.order,
                                characteristic.classification_chosen.classification_id,
                                characteristic.name_en,
                                characteristic.name_fr,
                                characteristic.name_pt];
                    
                    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                        if(sqlite3_step(stmt) == SQLITE_ROW){
                            characteristic.characteristic_id = sqlite3_column_int(stmt, 0);
                            sqlite3_finalize(stmt);
                            
                            for (Classificacao* classification in characteristic.classifications) {
                                
                                querySQL = [NSString stringWithFormat:@"INSERT INTO PossibleClassification (classifiable_id, classification_id, classifiable_type) \
                                            VALUE (%d, %d, \'%@\');", 
                                            characteristic.characteristic_id,
                                            characteristic.classification_chosen.classification_id,
                                            @"Characteristic"];
                                
                                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                                    DebugLog(@"Query with error: %s", errMsg);
                                    sqlite3_free(errMsg);
                                    [query rollbackTransaction];
                                    return FALSE;
                                }
                                
                            }
                            
                        }
                    }else {
                        DebugLog(@"Query with error: %@", querySQL);
                        [query rollbackTransaction];
                        return FALSE;
                    }
                    
                }
                
            }
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            [query rollbackTransaction];
            return FALSE;
        }
        
        
    }

    
    
    [query endTransaction];
    //insere classificacoes
    
    
    
    
    
    return TRUE;
}

-(BOOL) removeProvaAtIndex:(NSUInteger) index {
    Prova * p = [self objectAtIndex:index];
    Query *query = [[Query alloc] init];
    
    BOOL return_value = TRUE;
    sqlite3_stmt *stmt;
    char * errMsg;
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT state FROM Tasting WHERE tasting_id = %d", p.tasting_id];
    
    sqlite3** contactDB = [query prepareForExecution];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
        int state;
        
        if(stmt != NULL){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                state = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                switch (state) {
                    case 0:
                        querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET state = 3 WHERE wine_id = %d", p.tasting_id];
                        break;
                        
                    case 1:
                        querySQL = [NSString stringWithFormat:@"DELETE FROM Tasting WHERE tasting_id = %d", p.tasting_id];
                        break;
                        
                    case 2:
                        querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET state = 3 WHERE tasting_id = %d", p.tasting_id];
                        break;
                        
                    default:
                        break;
                }
                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Could not mark for deletion: %s", errMsg);
                    sqlite3_free(errMsg);
                    return_value = FALSE;
                }
            }
            sqlite3_close(*contactDB);
        }
        
    }else{
        DebugLog(@"Query with error: %@", querySQL);
        return_value = FALSE;
        sqlite3_close(*contactDB);
    }
    
    if(return_value)
        [self removeObjectAtIndex:index];
    
    return return_value;

}

@end
