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

    
    if([receivedJSON objectForKey:@"wines"]){
        if(![self parseWines:[receivedJSON objectForKey:@"wines"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    
    
    if([receivedJSON objectForKey:@"deleted"]){
        if(![self parseDeleted:[receivedJSON objectForKey:@"deleted"]]){
            [query rollbackTransaction];
            return FALSE;
        }
    }
    
    
    if([receivedJSON objectForKey:@"wine_server_ids"]){
        if(![self parseWineServerIds:[receivedJSON objectForKey:@"wine_server_ids"]]){
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



-(BOOL)parseWineServerIds:(NSArray *)serverIdsJSON
{
    NSString * querySQL;
    char *errMsg;
    
    
    for (int i = 0; i < [serverIdsJSON count]; i++) {
        
        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET wine_server_id = %d WHERE user = \'%@\' name = \'%@\' AND year = %d;", 
                    [[[serverIdsJSON objectAtIndex:i] objectForKey:@"Wine_server_id"]intValue],
                    user.username,
                    [[serverIdsJSON objectAtIndex:i] objectForKey:@"name"],
                    [[[serverIdsJSON objectAtIndex:i] objectForKey:@"year"]intValue]];
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"%s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
    }
    
    
    return TRUE;
}


-(BOOL)parseDeleted:(NSDictionary *)deletedJSON
{
    NSString * querySQL;
    sqlite3_stmt * stmt;
    char *errMsg;
    
    //wines
    NSArray * deletedWines = [deletedJSON objectForKey:@"wines"];
    for (int i = 0; i < [deletedWines count]; i++) {
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE user = \'%@\' AND wine_server_id = %d",
                    user.username,
                    [[deletedWines objectAtIndex:i]intValue]];
        
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"%s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
    }
    
    
    //tastings
    NSArray * deletedTastings = [deletedJSON objectForKey:@"tastings"];
    int tasting_id;
    for (int i = 0; i < [deletedTastings count]; i++) {
        
        //vai buscar o id da prova do user 
        //para garantir que nao se eliminam varias provas ao mesmo tempo do user errado
        querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id FROM Tasting t , Wine w WHERE t.tasting_date = %d AND t.wine_id = w.wine_id AND w.user = \'%@\';", 
                    [[deletedTastings objectAtIndex:i]intValue],
                    user.username];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                
                tasting_id = sqlite3_column_int(stmt, 0);                
            }
            
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM Tasting WHERE tasting_id = %d;", tasting_id];
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"%s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
        
        
    }
    
    
    return TRUE;
}

           
           
           
-(BOOL)parseWines:(NSArray *) wines
{
    sqlite3_stmt * stmt;
    NSString * querySQL = nil;
    BOOL wineExists = FALSE;
    
    for(int i = 0; i < [wines count]; i++){
        NSDictionary * wineJSON = [wines objectAtIndex:i];
        int wine_id;
        
        //verificar se o vinho ja existe na da bd, se existir e um update
        querySQL = [NSString stringWithFormat:@"SELECT wine_id FROM wine WHERE wine_server_id = %d AND user = \'%@\'", [wineJSON objectForKey:@"wine_server_id"], user.username];
        
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                
                wine_id = sqlite3_column_int(stmt, 0);
                wineExists = TRUE;
                
            }
            sqlite3_finalize(stmt);
        }else{
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        
        //se exisit faz update, senao cria
        if(wineExists){
             querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 0, name = \'%@\', producer = '\%@\', year = %d, grapes = \'%@\',  region_id = %d, currency = \'%@\', price = %f WHERE wine_id = %d", 
                         [wineJSON objectForKey:@"name"],
                         [wineJSON objectForKey:@"producer"],
                         [[wineJSON objectForKey:@"year"] intValue],
                         [wineJSON objectForKey:@"grapes"],
                         [[wineJSON objectForKey:@"region"] intValue],
                         [wineJSON objectForKey:@"currency"],
                         [[wineJSON objectForKey:@"price"]doubleValue],
                         wine_id];
        }else {
            querySQL = [NSString stringWithFormat:@"INSERT INTO Wine(user, region_id, winetype_id, wineserver_id, name, year, grapes, photo_filename, producer, currency, price, state) \
                        VALUES (\'%@\', %d, %d, %d, \'%@\', %d, '\%@\', \'%@\', \'%@\', \'%@\', %f, 0); \
                        SELECT DISTINCT last_insert_rowid() FROM Wine;", 
                        user.username,
                        [[wineJSON objectForKey:@"region"] intValue],
                        [[wineJSON objectForKey:@"wine_type"] intValue],
                        [[wineJSON objectForKey:@"wine_server_id"] intValue],
                        [wineJSON objectForKey:@"name"],
                        [[wineJSON objectForKey:@"year"]intValue],
                        [wineJSON objectForKey:@"grapes"],
                        [wineJSON objectForKey:@"photo_filename"],
                        [wineJSON objectForKey:@"producer"],
                        [wineJSON objectForKey:@"currency"],
                        [[wineJSON objectForKey:@"price"] doubleValue]];
        }
        
        
        //executa o insert e retorna o id
        //ou executa so o update e nao retorna nada sendo que o wine_id anterior e mantido
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){

                wine_id = sqlite3_column_int(stmt, 0);                
            }
            
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        NSArray * tastingsJSON = [wineJSON objectForKey:@"tastings"];
        for (int k = 0; k < [tastingsJSON count]; k++) {
            NSDictionary * tastingJSON = [tastingsJSON objectAtIndex:k];
            
            BOOL existsTasting = FALSE;
            int tasting_id;
            
            //se o vinho existe verifica se a prova existe
            if(wineExists){
                querySQL = [NSString stringWithFormat:@"SELECT tasting_id FROM tasting WHERE wine_id = %d AND tasting_date = %d", 
                            wine_id, 
                            [[tastingJSON objectForKey:@"tasting_date"]intValue]];
                
                if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                    if(sqlite3_step(stmt) == SQLITE_ROW){
                        tasting_id = sqlite3_column_int(stmt, 0);
                        existsTasting = TRUE;
                    }
                    sqlite3_finalize(stmt);
                }else {
                    DebugLog(@"Query with error: %@", querySQL);
                    return FALSE;
                }
            }
        
            //faz update de uma prova existente
            if(wineExists && existsTasting){
                
                if(![self parseUpdatedTasting:tastingJSON forWine:wine_id withTasting:tasting_id])
                    return FALSE;
                
            }else {//nova prova
                
                if(![self parseNewTasting:tastingJSON forWine:wine_id])
                    return FALSE;
                    
            }
        }
    }
    
    return TRUE;
}



-(BOOL)parseUpdatedTasting:(NSDictionary*)tastingJSON forWine:(int)wine_id withTasting:(int)tasting_id
{
    NSString * querySQL;
    sqlite3_stmt * stmt;
    char *errMsg;
    
    //guarda os dados da prova

    querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET comment = \'%@\' , latitude = %f, longitude = %f, state = 0 WHERE tasting_id = %d",
                [tastingJSON objectForKey:@"comment"],
                [[tastingJSON objectForKey:@"latitude"]doubleValue],
                [[tastingJSON objectForKey:@"longitude"]doubleValue],
                tasting_id];
    
    
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }
    
    
    //seccoes
    NSArray * sectionsJSON = [tastingJSON objectForKey:@"sections"];
    for(int i = 0; i < [sectionsJSON count]; i++){
        
        NSDictionary *sectionJSON = [sectionsJSON objectAtIndex:i];
        
        int section_id;
        
        querySQL = [NSString stringWithFormat:@"SELECT section_id \
                    FROM Section \
                    WHERE tasting_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                    tasting_id,
                    [[sectionJSON objectForKey:@"order"]intValue],
                    [sectionJSON objectForKey:@"name_eng"],
                    [sectionJSON objectForKey:@"name_fr"],
                    [sectionJSON objectForKey:@"name_pt"]];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                section_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        NSArray * criteriaJSON = [sectionJSON objectForKey:@"criteria"];
        for (int k = 0; k < [criteriaJSON count]; k++){
            
            NSDictionary * criterionJSON = [criteriaJSON objectAtIndex:k];
            int criterion_id;
            int classification_id;
            
            
            querySQL = [NSString stringWithFormat:@"SELECT criterion_id \
                        FROM Criterion \
                        WHERE section_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                        section_id,
                        [[sectionJSON objectForKey:@"order"]intValue],
                        [sectionJSON objectForKey:@"name_eng"],
                        [sectionJSON objectForKey:@"name_fr"],
                        [sectionJSON objectForKey:@"name_pt"]];
            
            
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    criterion_id = sqlite3_column_int(stmt, 0);
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
        
            
            classification_id = [self existsClassification:stmt 
                                                    nameEN:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_eng"] 
                                                    nameFR:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_fr"] 
                                                    namePT:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_pt"] 
                                                andWheight:[[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"weight"]intValue]];
            
            if(classification_id == -2)
                return FALSE;
        
            
            querySQL = [NSString stringWithFormat:@"UPDATE Criterion SET classification_id = %d WHERE criterion_id = %d;",
                        classification_id,
                        criterion_id];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }
        
        
        return TRUE;
    }
    
    
    
    
    
    
    //seccoes de caracteristicas
    NSArray * characteristicsSectionsJSON = [tastingJSON objectForKey:@"characteristics_sections"];
    for(int i = 0; i < [sectionsJSON count]; i++){
        
        NSDictionary *characteristicsectionJSON = [characteristicsSectionsJSON objectAtIndex:i];
        
        int characteristicsection_id;
        
        querySQL = [NSString stringWithFormat:@"SELECT sectioncharacteristic_id \
                    FROM SectionCharacteristic \
                    WHERE tasting_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                    tasting_id,
                    [[characteristicsectionJSON objectForKey:@"order"]intValue],
                    [characteristicsectionJSON objectForKey:@"name_eng"],
                    [characteristicsectionJSON objectForKey:@"name_fr"],
                    [characteristicsectionJSON objectForKey:@"name_pt"]];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                characteristicsection_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        NSArray * characteriticsJSON = [characteristicsectionJSON objectForKey:@"characteristics"];
        for (int k = 0; k < [characteriticsJSON count]; k++){
            
            NSDictionary * characteristicJSON = [characteriticsJSON objectAtIndex:k];
            int characteristic_id;
            int classification_id;
            
            
            querySQL = [NSString stringWithFormat:@"SELECT characteristic_id \
                        FROM Characteristic \
                        WHERE sectioncharacteristic_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                        characteristicsection_id,
                        [[characteristicJSON objectForKey:@"order"]intValue],
                        [characteristicJSON objectForKey:@"name_eng"],
                        [characteristicJSON objectForKey:@"name_fr"],
                        [characteristicJSON objectForKey:@"name_pt"]];
            
            
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    characteristic_id = sqlite3_column_int(stmt, 0);
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            
            classification_id = [self existsClassification:stmt 
                                                    nameEN:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_eng"] 
                                                    nameFR:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_fr"] 
                                                    namePT:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_pt"] 
                                                andWheight:[[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"weight"]intValue]];
            
            if(classification_id == -2)
                return FALSE;
            
            
            querySQL = [NSString stringWithFormat:@"UPDATE Characteristic SET classification_id = %d WHERE characteristic_id = %d;",
                        classification_id,
                        characteristic_id];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }
    }


    return TRUE;

}


-(BOOL)parseNewTasting:(NSDictionary *)tastingJSON forWine:(int)wine_id
{
    NSString * querySQL;
    sqlite3_stmt * stmt;
    int tasting_id;
    
    querySQL = [NSString stringWithFormat:@"INSERT INTO Tasting (wine_id, tasting_date, comment, latitude, longitude, state) \
                VALUES (%d, %d, \'%@\', %f, %f); \
                SELECT DISTINCT last_insert_rowid() FROM Tasting;",
                wine_id, 
                [[tastingJSON objectForKey:@"tasting_date"]intValue],
                [tastingJSON objectForKey:@"comment"],
                [[tastingJSON objectForKey:@"latitude"]doubleValue],
                [[tastingJSON objectForKey:@"longitude"]doubleValue],
                0];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            tasting_id = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return FALSE;
    }
    
    
    //seccoes
    NSArray * sectionsJSON = [tastingJSON objectForKey:@"sections"];
    for(int i = 0; i < [sectionsJSON count]; i++){
        
        NSDictionary *sectionJSON = [sectionsJSON objectAtIndex:i];
        
        int section_id;
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO Section (tasting_id,order_priority, name_eng, name_fr, name_pt)\
                    VALUES (%d, \'%@\', \'%@\', \'%@\');\
                    SELECT DISTINCT last_insert_rowid() FROM Section;",
                    tasting_id,
                    [[sectionJSON objectForKey:@"order"]intValue],
                    [sectionJSON objectForKey:@"name_eng"],
                    [sectionJSON objectForKey:@"name_fr"],
                    [sectionJSON objectForKey:@"name_pt"]];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                section_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        NSArray * criteriaJSON = [sectionJSON objectForKey:@"criteria"];
        for (int k = 0; k < [criteriaJSON count]; k++){
            
            NSDictionary * criterionJSON = [criteriaJSON objectAtIndex:k];
            int criterion_id;
            int classification_id;
            
            
            classification_id = [self insertClassificationIfNotExists:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_eng"] 
                                                               nameFR:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_fr"] 
                                                               namePT:[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"name_pt"] 
                                                           andWheight:[[[criterionJSON objectForKey:@"chosen_classification"] objectForKey:@"weight"]intValue]];
            
            if(classification_id == -2)
                return FALSE;
            
                       
            querySQL = [NSString stringWithFormat:@"INSERT INTO Criterion (section_id, order_priority, name_eng, name_fr, name_pt, classification_id)\
                        VALUES (%d, \'%@\', \'%@\', \'%@\', %d);\
                        SELECT DISTINCT last_insert_rowid() FROM Criterion;",
                        section_id,
                        [[criterionJSON objectForKey:@"order"]intValue],
                        [criterionJSON objectForKey:@"name_eng"],
                        [criterionJSON objectForKey:@"name_fr"],
                        [criterionJSON objectForKey:@"name_pt"],
                        classification_id];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    criterion_id = sqlite3_column_int(stmt, 0);
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            
            
            //insere todas as classificacoes possiveis
            NSArray * classificationsJSON = [sectionJSON objectForKey:@"classifications"];
            for (int z = 0; z < [classificationsJSON count]; z++) {
                NSDictionary * classificationJSON = [classificationsJSON objectAtIndex:z];
                
                
                classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"name_eng"] 
                                                                   nameFR:[classificationJSON objectForKey:@"name_fr"] 
                                                                   namePT:[classificationJSON objectForKey:@"name_pt"] 
                                                               andWheight:[[classificationJSON objectForKey:@"weight"]intValue]];
                
                if(classification_id == -2)
                    return FALSE;
                
                
                if(![self insertPossibleClassification:criterion_id 
                                    withClassification:classification_id 
                                                  Type:@"Criterion"])
                    return FALSE;
                
            }
        }
    }
    
    
    
    //seccoes de caracteristicas
    NSArray * characteristicsSectionsJSON = [tastingJSON objectForKey:@"characteristics_sections"];
    for (int i = 0; i < [characteristicsSectionsJSON count]; i++) {
        NSDictionary *characteristicsectionJSON = [characteristicsSectionsJSON objectAtIndex:i];
        
        int characteristicsection_id;
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO SectionCharacteristic (tasting_id, order_priority, name_eng, name_fr, name_pt)\
                    VALUES (%d ,%d, \'%@\', \'%@\', \'%@\');\
                    SELECT DISTINCT last_insert_rowid() FROM SectionCharacteristic;",
                    tasting_id,
                    [[characteristicsectionJSON objectForKey:@"order"]intValue],
                    [characteristicsectionJSON objectForKey:@"name_eng"],
                    [characteristicsectionJSON objectForKey:@"name_fr"],
                    [characteristicsectionJSON objectForKey:@"name_pt"]];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                characteristicsection_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        NSArray * characteriticsJSON = [characteristicsectionJSON objectForKey:@"characteristics"];
        for (int k = 0; k < [characteriticsJSON count]; k++){
            
            NSDictionary * characteristicJSON = [characteriticsJSON objectAtIndex:k];
            int characteristic_id;
            int classification_id;
            
            
            classification_id = [self insertClassificationIfNotExists:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_eng"] 
                                                               nameFR:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_fr"] 
                                                               namePT:[[characteristicJSON objectForKey:@"chosen_classification"] objectForKey:@"name_pt"] 
                                                           andWheight:0];
            
            if(classification_id == -2)
                return FALSE;
            
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO Characteristic (sectioncharacteristic_id, order_priority, name_eng, name_fr, name_pt, classification_id)\
                        VALUES (%d, %d, \'%@\', \'%@\', \'%@\', %d);\
                        SELECT DISTINCT last_insert_rowid() FROM Characteristic;",
                        characteristicsection_id,
                        [[characteristicJSON objectForKey:@"order"]intValue],
                        [characteristicJSON objectForKey:@"name_eng"],
                        [characteristicJSON objectForKey:@"name_fr"],
                        [characteristicJSON objectForKey:@"name_pt"],
                        classification_id];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    characteristic_id = sqlite3_column_int(stmt, 0);
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            
            
            //insere todas as classificacoes possiveis
            NSArray * classificationsJSON = [characteristicJSON objectForKey:@"classifications"];
            for (int z = 0; z < [classificationsJSON count]; z++) {
                NSDictionary * classificationJSON = [classificationsJSON objectAtIndex:z];
                
                
                classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"name_eng"] 
                                                                   nameFR:[classificationJSON objectForKey:@"name_fr"] 
                                                                   namePT:[classificationJSON objectForKey:@"name_pt"] 
                                                               andWheight:0];
                
                if(classification_id == -2)
                    return FALSE;
                
                
                if(![self insertPossibleClassification:characteristic_id 
                                    withClassification:classification_id 
                                                  Type:@"Characteristic"])
                    return FALSE;
            }
        }
    }
    
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

        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
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
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        //insere no formtasting, retrive do id
        int formTasting_id;
        querySQL = @"INSERT INTO FormTasting Values((SELECT DISTINCT last_insert_rowid() FROM FormTasting)+1); \
                    SELECT DISTINCT last_insert_rowid() FROM FormtTasting;";
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){            
            if(sqlite3_step(stmt) == SQLITE_ROW){
                formTasting_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
            }
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        
        //adiciona os formularios
        NSDictionary * formJSON = [winetypesWithFormsJSON objectForKey:@"form"];
        
        //seccoes, criterios e classificacoes associadas
        NSArray * formSectionsJSON = [formJSON objectForKey:@"form_sections"];
        for(int k = 0; k < [formSectionsJSON count]; k++){
            
            int formSection_id;
            NSDictionary * formSectionJSON = [formSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSection(formtasting_id, order_priority, name_en, name_fr, name_pt) \
                        Values(%d, %d, \'%@\', \'%@\', \'%@\'); \
                        SELECT DISTINCT last_insert_rowid() FROM FormSection;",
                        formTasting_id,
                        [formSectionJSON objectForKey:@"order"],
                        [formSectionJSON objectForKey:@"name_eng"],
                        [formSectionJSON objectForKey:@"name_fr"],
                        [formSectionJSON objectForKey:@"name_pt"]];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    formSection_id = sqlite3_column_int(stmt, 0);
                    sqlite3_finalize(stmt);
                }
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            
            
            NSArray * formCriteriaJSON = [formSectionJSON objectForKey:@"forms_criteria"];
            for (int w=0; w < [formCriteriaJSON count]; w++) {
                
                int criterion_id;
                NSDictionary * formCriterionJSON = [formCriteriaJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCriterion(formsection_id, order_priority, name_en, name_fr, name_pt) \
                            Values(%d, %d, \'%@\', \'%@\', \'%@\'); \
                            SELECT DISTINCT last_insert_rowid() FROM FormCriterion;",
                            formSection_id,
                            [formCriterionJSON objectForKey:@"order"],
                            [formCriterionJSON objectForKey:@"name_eng"],
                            [formCriterionJSON objectForKey:@"name_fr"],
                            [formCriterionJSON objectForKey:@"name_pt"]];
                
                if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                    
                    if(sqlite3_step(stmt) == SQLITE_ROW){
                        criterion_id = sqlite3_column_int(stmt, 0);
                        sqlite3_finalize(stmt);
                    }
                }else {
                    DebugLog(@"Query with error: %@", querySQL);
                    return FALSE;
                }
                
                
                NSArray * formClassificationsJSON = [formCriterionJSON objectForKey:@"classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    
                    classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"name_eng"]  
                                                                       nameFR:[classificationJSON objectForKey:@"name_fr"] 
                                                                       namePT:[classificationJSON objectForKey:@"name_pt"] 
                                                                   andWheight:[[classificationJSON objectForKey:@"weight"]intValue]];
                    
                    if(classification_id == -2)
                        return FALSE;
                    
                                
                    //insere nas possibleClassifications
                    if(![self insertPossibleClassification:criterion_id 
                                        withClassification:classification_id 
                                                      Type: @"FormCriterion"])
                        return FALSE;
                    
                }
            }
        }
        
        
        
        //seccoes de caracteristicas, caracteristicas e classificacoes associadas
        NSArray * formCharacteristicSectionsJSON = [formJSON objectForKey:@"form_characteristics_sections"];
        for(int k = 0; k < [formCharacteristicSectionsJSON count]; k++){
            int formSectionCharacteristic_id;
            NSDictionary * formCharacteristicSectionJSON = [formCharacteristicSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSectionCharacteristic(formtasting_id, order_priority, name_en, name_fr, name_pt) \
                        Values(%d, %d, \'%@\', \'%@\', \'%@\'); \
                        SELECT DISTINCT last_insert_rowid() FROM FormSectionCharacteristic;",
                        formTasting_id,
                        [formCharacteristicSectionJSON objectForKey:@"order"],
                        [formCharacteristicSectionJSON objectForKey:@"name_eng"],
                        [formCharacteristicSectionJSON objectForKey:@"name_fr"],
                        [formCharacteristicSectionJSON objectForKey:@"name_pt"]];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    formSectionCharacteristic_id = sqlite3_column_int(stmt, 0);
                    sqlite3_finalize(stmt);
                }
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            
            
            NSArray * formCharacteristicsJSON = [formCharacteristicSectionJSON objectForKey:@"form_characteristics"];
            for (int w=0; w < [formCharacteristicsJSON count]; w++) {
                
                int characteristic_id;
                NSDictionary * formCharacteristicJSON = [formCharacteristicsJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCharacteristic(formsectioncharacteristic_id, order_priority, name_en, name_fr, name_pt) \
                            Values(%d, %d, \'%@\', \'%@\', \'%@\'); \
                            SELECT DISTINCT last_insert_rowid() FROM FormCharacteristic;",
                            formSectionCharacteristic_id,
                            [formCharacteristicJSON objectForKey:@"order"],
                            [formCharacteristicJSON objectForKey:@"name_eng"],
                            [formCharacteristicJSON objectForKey:@"name_fr"],
                            [formCharacteristicJSON objectForKey:@"name_pt"]];
                
                if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                    if(sqlite3_step(stmt) == SQLITE_ROW){
                        characteristic_id = sqlite3_column_int(stmt, 0);
                        sqlite3_finalize(stmt);
                    }
                }else {
                    DebugLog(@"Query with error: %@", querySQL);
                    return FALSE;
                }
                
                
                NSArray * formClassificationsJSON = [formCharacteristicJSON objectForKey:@"classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    
                    classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"name_eng"] 
                                                                       nameFR:[classificationJSON objectForKey:@"name_fr"] 
                                                                       namePT:[classificationJSON objectForKey:@"name_pt"] 
                                                                   andWheight:0];
                    
                    if(classification_id == -2)
                        return FALSE;
                    

                    //insere nas possibleClassifications
                    if(![self insertPossibleClassification:characteristic_id 
                                        withClassification:classification_id 
                                                      Type: @"FormCharacteristic"])
                        return FALSE;
                    
                }
            }
        }
    }
    
    
    return TRUE;
}




-(int)insertClassificationIfNotExists:(NSString *)name_eng nameFR:(NSString *)name_fr
                               namePT:(NSString *)name_pt andWheight:(int)weight
{
    int classification_id;
    sqlite3_stmt * stmt = nil;
    
    classification_id = [self existsClassification:stmt 
                                            nameEN:name_eng
                                            nameFR:name_fr
                                            namePT:name_pt
                                        andWheight:weight];
    
    
    if(classification_id == -2)
        return -2;
    
    //se nao existir insere
    if(classification_id == -1){
        classification_id = [self insertClassification:stmt 
                                                nameEN:name_eng
                                                nameFR:name_fr
                                                namePT:name_pt
                                            andWheight:weight];        
        if(classification_id == -2)
            return -2;
    }


    return classification_id;
}


-(int)existsClassification:(sqlite3_stmt *)stmt nameEN:(NSString *)name_eng nameFR:(NSString *)name_fr
namePT:(NSString *)name_pt andWheight:(int)weight
{
    int return_value = -1;
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT classification_id FROM Classification WHERE weight = %d AND name_en = \'%@\' AND name_fr = \'%@\' AND name_pt = \'%@\';",
                weight,
                name_eng,
                name_fr,
                name_pt];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            return_value = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
        }
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return_value = -2;
    }
    
    return return_value;
}


-(int)insertClassification:(sqlite3_stmt *)stmt nameEN:(NSString *)name_eng nameFR:(NSString *)name_fr
                    namePT:(NSString *)name_pt andWheight:(int)weight
{
    int return_value = -1;
   
    NSString * querySQL = [NSString stringWithFormat:@"INSERT INTO Classification(weight, name_en, name_fr, name_pt) Values(%d, \'%@\', \'%@\', \'%@\'); \
                           SELECT DISTINCT last_insert_rowid() FROM Classification;",
                           weight, name_eng, name_fr, name_pt];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            return_value = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
        }
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return_value = -2;
    }
    
    
    return return_value;
}

-(BOOL)insertPossibleClassification:(int)classifiable_id withClassification:(int)classification_id Type:(NSString *)classifiableType
{
    //insere nas possibleClassifications
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO PossibleClassification(classifiable_id, classification_id, classifiable_type) Values(%d, %d, \'%@\');",
                classifiable_id,
                classification_id,
                classifiableType];
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
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
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    exists = TRUE;
                    sqlite3_finalize(stmt);
                }
            }else{
                DebugLog(@"Query with error: %@", querySQL);
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
    char * errMsg;
    
    
    //elimina todas os vinhos que estejam com state = 3 (deleted)
    querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE user= \'%@\' AND state = 3", user.username];
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }
    
    
    
    
    //elimina todas as provas que estejam com state = 3 (deleted)
    querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id \
                FROM Tasting t, Wine w \
                WHERE w.user = \'%@\' AND w.wine_id = t.wine_id AND t.state = 3;", user.username ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            querySQL = [NSString stringWithFormat:@"DELETE FROM Tasting WHERE tasting_id = %d",
                        sqlite3_column_int(stmt,0)];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
            
        }
    }else {
        DebugLog(@"Query with error: %s", querySQL);
        return FALSE;
    }
    sqlite3_finalize(stmt);
    
    
    
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
    
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
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
        DebugLog(@"Query with error: %s", querySQL);
        return FALSE;
    }
    sqlite3_finalize(stmt);

    
    
    

    querySQL =  @"SELECT classification_id \
                FROM classification \
                WHERE classification_id NOT IN ( \
                SELECT DISTINCT c.classification_id \
                FROM classification c, possibleclassification pc \
                WHERE  c.classification_id = pc.classification_id);";
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
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
        DebugLog(@"Query with error: %s", querySQL);
        return FALSE;
    }
    sqlite3_finalize(stmt);
    
    
    return TRUE;
    
}

@end
