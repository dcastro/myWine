//
//  Sincronizacao.m
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Sincronizacao.h"
#import "User.h"

@implementation Sincronizacao


- (id)init
{
    self = [super init];
    if (self) {
        query = [[Query alloc] init];
        user = [User instance];
    }
    return self;
}

-(NSString *)buildRequest:(NSError **) error
{
    
    NSMutableDictionary * requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.username,@"username" ,user.password, @"password" , user.synced_at, @"synced_at" , nil];
    

    
    
    //conversao para string
    NSData * data = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:error];
    
    if(error){
        return nil;
    }else {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}





-(BOOL)parseData:(NSMutableData *)receivedData
{
    
    contactDB = [query beginTransaction];
    
    NSError * jsonParsingError = nil;
    NSDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];
    
    if(jsonParsingError){
        DebugLog(@"JSON PARSING ERROR: %@", jsonParsingError);
        [query rollbackTransaction];
        return FALSE; 
    }
    
    DebugLog(@"JSON: %@", [NSString stringWithFormat:@"%@",  receivedJSON]);

    
    
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE User SET synced_at = %d WHERE username = \'%@\';", [receivedJSON objectForKey:@"timestamp"], user.username];
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        [query rollbackTransaction];
        return FALSE;
    }
    

    
    if([receivedJSON objectForKey:@"countries"]){
        if(![self parseCountries:[receivedJSON objectForKey:@"countries"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    
    
    if([receivedJSON objectForKey:@"wine_types"]){
        if(![self parseWineTypes:[receivedJSON objectForKey:@"wine_types"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    

    
    //ultimo passo e limpar o lixo solto da bd
    if(![self cleanGarbage]){
        [query rollbackTransaction];
        return FALSE; 
    }

    
    
    [query endTransaction];
    
    return TRUE;
}





-(BOOL)parseWineTypes:(NSArray *) winetypes 
{
    
    sqlite3_stmt * stmt;
    NSString * querySQL = nil;
    BOOL exists = FALSE;
    
    for (int i = 0; i < [winetypes count]; i++) {
        NSDictionary * winetypesWithFormsJSON = [winetypes objectAtIndex:i];
        int winetype_id = [[winetypesWithFormsJSON objectForKey:@"id"] intValue];
        
        //verifica se o tipo de vinho existe
        querySQL = [NSString stringWithFormat:@"SELECT formtasting_id FROM UserTypeWine WHERE winetype_id = %d AND user = \'%@\'", winetype_id, user.username];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
            
            if(sqlite3_step(stmt) == SQLITE_ROW){
                
                exists = TRUE;
                int formtasting_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                //se existir apaga os formularios associados e possible classifications
                if(exists){
                    
                    querySQL = [NSString stringWithFormat:@"DELETE FROM FormTasting WHERE formtasting_id = %d;", formtasting_id]; 
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }else {//senao existir adiciona
                    
                    querySQL = [NSString stringWithFormat:@"INSERT INTO WineType VALUES (%d, \'%@\', \'%@\', \'%@\');", 
                                winetype_id,
                                [winetypesWithFormsJSON objectForKey:@"name_eng"],
                                [winetypesWithFormsJSON objectForKey:@"name_fr"],
                                [winetypesWithFormsJSON objectForKey:@"name_pt"]];
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }
                
                
            }
        }else{
            DebugLog(@"Query with error: %s", query_stmt);
            return FALSE;
        }
        
        
        //insere no formtasting, retrive do id
        int formTasting_id;
        querySQL = @"INSERT INTO FormTasting Values((SELECT DISTINCT last_insert_rowid() FROM FormTasting)+1); SELECT DISTINCT last_insert_rowid() FROM FormtTasting;";
        query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
            
            if(sqlite3_step(stmt) == SQLITE_ROW){
                formTasting_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
            }
        }else {
            DebugLog(@"Query with error: %s", query_stmt);
            return FALSE;
        }
        
        
        
        //adiciona os formularios
        NSDictionary * formJSON = [winetypesWithFormsJSON objectForKey:@"form"];
        
        //seccoes, criterios e classificacoes associadas
        NSArray * formSectionsJSON = [formJSON objectForKey:@"form_sections"];
        for(int k = 0; k < [formSectionsJSON count]; k++){
            
            int formSection_id;
            NSDictionary * formSectionJSON = [formSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSection(formtasting_id, order_priority, name_en, name_fr, name_pt) Values(%d, %d, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM FormSection;",
                        formTasting_id,
                        [formSectionJSON objectForKey:@"order"],
                        [formSectionJSON objectForKey:@"name_eng"],
                        [formSectionJSON objectForKey:@"name_fr"],
                        [formSectionJSON objectForKey:@"name_pt"]];
            
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    formSection_id = sqlite3_column_int(stmt, 0);
                    sqlite3_finalize(stmt);
                }
            }else {
                DebugLog(@"Query with error: %s", query_stmt);
                return FALSE;
            }
            
            
            
            NSArray * formCriteriaJSON = [formSectionJSON objectForKey:@"forms_criteria"];
            for (int w=0; w < [formCriteriaJSON count]; w++) {
                
                int criterion_id;
                NSDictionary * formCriterionJSON = [formCriteriaJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCriterion(formsection_id, order_priority, name_en, name_fr, name_pt) Values(%d, %d, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM FormCriterion;",
                            formSection_id,
                            [formCriterionJSON objectForKey:@"order"],
                            [formCriterionJSON objectForKey:@"name_eng"],
                            [formCriterionJSON objectForKey:@"name_fr"],
                            [formCriterionJSON objectForKey:@"name_pt"]];
                
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                    
                    if(sqlite3_step(stmt) == SQLITE_ROW){
                        criterion_id = sqlite3_column_int(stmt, 0);
                        sqlite3_finalize(stmt);
                    }
                }else {
                    DebugLog(@"Query with error: %s", query_stmt);
                    return FALSE;
                }
                
                
                NSArray * formClassificationsJSON = [formCriterionJSON objectForKey:@"classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    BOOL existsClassification = FALSE;
                    
                    querySQL = [NSString stringWithFormat:@"SELECT classification_id FROM Classification WHERE weight = %d AND name_en = \'%@\' AND name_fr = \'%@\' AND name_pt = \'%@\';",
                                [classificationJSON objectForKey:@"weight"],
                                [classificationJSON objectForKey:@"name_eng"],
                                [classificationJSON objectForKey:@"name_ft"],
                                [classificationJSON objectForKey:@"name_pt"]];
                    
                    query_stmt = [querySQL UTF8String];
                    if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                        
                        if(sqlite3_step(stmt) == SQLITE_ROW){
                            classification_id = sqlite3_column_int(stmt, 0);
                            existsClassification = TRUE;
                            sqlite3_finalize(stmt);
                        }
                    }else {
                        DebugLog(@"Query with error: %s", query_stmt);
                        return FALSE;
                    }
                    
                    
                    
                    //se existir nao insere, senao insere e retorna o classification_id
                    if(!existsClassification){
                        
                        querySQL = [NSString stringWithFormat:@"INSERT INTO Classification(weight, name_en, name_fr, name_pt) Values(%d, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM Classification;",
                                    [classificationJSON objectForKey:@"weight"],
                                    [classificationJSON objectForKey:@"name_eng"],
                                    [classificationJSON objectForKey:@"name_ft"],
                                    [classificationJSON objectForKey:@"name_pt"]];
                        
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                            
                            if(sqlite3_step(stmt) == SQLITE_ROW){
                                classification_id = sqlite3_column_int(stmt, 0);
                                sqlite3_finalize(stmt);
                            }
                        }else {
                            DebugLog(@"Query with error: %s", query_stmt);
                            return FALSE;
                        }
                    }
                    
                                
                    //insere nas possibleClassifications
                    querySQL = [NSString stringWithFormat:@"INSERT INTO PossibleClassification(classifiable_id, classification_id, classifiable_type) Values(%d, %d, \'%@\');",
                               criterion_id,
                                classification_id,
                                @"FormCriterion"];
                    
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }
            }
        }
        
        
        
        //seccoes de caracteristicas, caracteristicas e classificacoes associadas
        NSArray * formCharacteristicSectionsJSON = [formJSON objectForKey:@"form_characteristics_sections"];
        for(int k = 0; k < [formCharacteristicSectionsJSON count]; k++){
            int formSectionCharacteristic_id;
            NSDictionary * formCharacteristicSectionJSON = [formCharacteristicSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSectionCharacteristic(formtasting_id, order_priority, name_en, name_fr, name_pt) Values(%d, %d, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM FormSectionCharacteristic;",
                        formTasting_id,
                        [formCharacteristicSectionJSON objectForKey:@"order"],
                        [formCharacteristicSectionJSON objectForKey:@"name_eng"],
                        [formCharacteristicSectionJSON objectForKey:@"name_fr"],
                        [formCharacteristicSectionJSON objectForKey:@"name_pt"]];
            
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    formSectionCharacteristic_id = sqlite3_column_int(stmt, 0);
                    sqlite3_finalize(stmt);
                }
            }else {
                DebugLog(@"Query with error: %s", query_stmt);
                return FALSE;
            }
            
            
            
            NSArray * formCharacteristicsJSON = [formCharacteristicSectionJSON objectForKey:@"form_characteristics"];
            for (int w=0; w < [formCharacteristicsJSON count]; w++) {
                
                int characteristic_id;
                NSDictionary * formCharacteristicJSON = [formCharacteristicsJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCharacteristic(formsectioncharacteristic_id, order_priority, name_en, name_fr, name_pt) Values(%d, %d, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM FormCharacteristic;",
                            formSectionCharacteristic_id,
                            [formCharacteristicJSON objectForKey:@"order"],
                            [formCharacteristicJSON objectForKey:@"name_eng"],
                            [formCharacteristicJSON objectForKey:@"name_fr"],
                            [formCharacteristicJSON objectForKey:@"name_pt"]];
                
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                    
                    if(sqlite3_step(stmt) == SQLITE_ROW){
                        characteristic_id = sqlite3_column_int(stmt, 0);
                        sqlite3_finalize(stmt);
                    }
                }else {
                    DebugLog(@"Query with error: %s", query_stmt);
                    return FALSE;
                }
                
                
                NSArray * formClassificationsJSON = [formCharacteristicJSON objectForKey:@"classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    BOOL existsClassification = FALSE;
                    
                    querySQL = [NSString stringWithFormat:@"SELECT classification_id FROM Classification WHERE weight = 0 AND name_en = \'%@\' AND name_fr = \'%@\' AND name_pt = \'%@\';",
                                [classificationJSON objectForKey:@"name_eng"],
                                [classificationJSON objectForKey:@"name_ft"],
                                [classificationJSON objectForKey:@"name_pt"]];
                    
                    query_stmt = [querySQL UTF8String];
                    if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                        
                        if(sqlite3_step(stmt) == SQLITE_ROW){
                            classification_id = sqlite3_column_int(stmt, 0);
                            existsClassification = TRUE;
                            sqlite3_finalize(stmt);
                        }
                    }else {
                        DebugLog(@"Query with error: %s", query_stmt);
                        return FALSE;
                    }
                    
                    
                    
                    //se existir nao insere, senao insere e retorna o classification_id
                    if(!existsClassification){
                        
                        querySQL = [NSString stringWithFormat:@"INSERT INTO Classification(weight, name_en, name_fr, name_pt) Values(0, \'%@\', \'%@\', \'%@\'); SELECT DISTINCT last_insert_rowid() FROM Classification;",
                                    [classificationJSON objectForKey:@"name_eng"],
                                    [classificationJSON objectForKey:@"name_ft"],
                                    [classificationJSON objectForKey:@"name_pt"]];
                        
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                            
                            if(sqlite3_step(stmt) == SQLITE_ROW){
                                classification_id = sqlite3_column_int(stmt, 0);
                                sqlite3_finalize(stmt);
                            }
                        }else {
                            DebugLog(@"Query with error: %s", query_stmt);
                            return FALSE;
                        }
                    }
                    
                    
                    //insere nas possibleClassifications
                    querySQL = [NSString stringWithFormat:@"INSERT INTO PossibleClassification(classifiable_id, classification_id, classifiable_type) Values(%d, %d, \'%@\');",
                                characteristic_id,
                                classification_id,
                                @"FormCriterion"];
                    
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }
            }
        }
    }
    
    
    return TRUE;
}


-(BOOL)parseCountries:(NSArray *) countries 
{
    
    sqlite3_stmt *stmt;
    NSString * querySQL = nil;
    NSString * country_id = nil;

    
    for (int i = 0; i < [countries count]; i++) {
        
        NSDictionary * countryWithRegionsJSON = [countries objectAtIndex:i];
        
        country_id = [countryWithRegionsJSON objectForKey:@"code"];
        
        //verifies if the country exists in the database
        BOOL exists = FALSE;
        querySQL = [NSString stringWithFormat:@"SELECT country_id FROM Country WHERE country_id = \'%@\';", country_id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    exists = TRUE;
                    sqlite3_finalize(stmt);
                }
            }else{
                DebugLog(@"Query with error: %s", query_stmt);
                return FALSE;
        }
        
        
        //if it doest exists, stores it
        if(!exists){
            querySQL = [NSString stringWithFormat:@"INSERT INTO Country VALUES (\'%@\', \'%@\', \'%@\', \'%@\');", 
                        [countryWithRegionsJSON objectForKey:@"code"],
                        [countryWithRegionsJSON objectForKey:@"name_eng"],
                        [countryWithRegionsJSON objectForKey:@"name_fr"],
                        [countryWithRegionsJSON objectForKey:@"name_pt"]];
            
            char *errMsg;
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }
        
        
        NSArray * regionsJSON = [countryWithRegionsJSON objectForKey:@"region"];
        for (int k = 0; k < [regionsJSON count]; k++) {
            NSDictionary *regionJSON = [regionsJSON objectAtIndex:k];
            querySQL = [NSString stringWithFormat:@"INSERT INTO Region VALUES (\'%@\', \'%@\', \'%@\');", 
                        [regionJSON objectForKey:@"code"],
                        country_id,
                        [regionJSON objectForKey:@"name"]];
            
            char *errMsg;
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }

        }
        
        
    }
    
    
    return TRUE;
}




-(BOOL)cleanGarbage
{
    
    sqlite3_stmt *stmt;
    NSString * querySQL = nil;
    
    
    /*
     select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'FormCriterion' AND classifiable_id not in (Select formcriterion_id from formcriterion) UNION select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'FormCharacteristic' AND classifiable_id not in (Select formcharacteristics_id from FormCharacteristic) UNION select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'Criterion' AND classifiable_id not in (Select criterion_id from Criterion) UNION  select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'Characteristic' AND classifiable_id not in (Select characteristic_id from Characteristic);
     */
    
    querySQL =  @"SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'FormCriterion' AND classifiable_id NOT INT (\
                        SELECT formcriterion_id \
                        FROM formcriterion) \
                \
                UNION \
                \
                SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'FormCharacteristic' AND classifiable_id NOT IN (\
                        SELECT formcharacteristics_id \
                        FROM FormCharacteristic) \
                \
                UNION\
                \
                SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'Criterion' AND classifiable_id NOT IN (\
                        SELECT criterion_id \
                        FROM Criterion) \
                \
                UNION\
                \
                SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'Characteristic' AND classifiable_id NOT INE (\
                        SELECT characteristic_id \
                        FROM Characteristic);";
    
    
    
    const char * query_stmt = [querySQL UTF8String];
    char *errMsg;
    if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            querySQL = [NSString stringWithFormat:@"DELETE FROM PossibleClassification \
                        WHERE classifiable_id = %d AND classifiable_type = \'%@\'", 
                        sqlite3_column_int(stmt, 0),
                        [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)]];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }

            
            
        }
    }else {
        DebugLog(@"Query with error: %s", query_stmt);
        return FALSE;
    }
    sqlite3_finalize(stmt);

    
    
    

    querySQL =  @"SELECT classification_id \
                FROM classification \
                WHERE classification_id NOT IN ( \
                SELECT DISTINCT c.classification_id \
                FROM classification c, possibleclassification pc \
                WHERE  c.classification_id = pc.classification_id);";
    
    query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            querySQL = [NSString stringWithFormat:@"DELETE FROM Classification \
                        WHERE classification_id = %d", 
                        sqlite3_column_int(stmt, 0)];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
            
            
            
        }
    }else {
        DebugLog(@"Query with error: %s", query_stmt);
        return FALSE;
    }
    sqlite3_finalize(stmt);
    
    
    return TRUE;
    
}

@end
