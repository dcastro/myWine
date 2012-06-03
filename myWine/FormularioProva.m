//
//  FormularioProva.m
//  myWine
//
//  Created by Fernando Gracas on 6/1/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FormularioProva.h"
#import "Query.h"
#import "User.h"
#import "Seccao.h"
#import "SeccaoCaracteristica.h"
#import "Caracteristica.h"

@implementation FormularioProva



+ (Prova *)generateTasting:(TipoVinho *)wineType
{
    
    NSString *querySQL;
    Query * query = [[Query alloc]init];
    sqlite3 ** contactDB = [query prepareForExecution];
    sqlite3_stmt * stmt;
    
    
    User * user = [User instance];
    Prova * tasting = [[Prova alloc]init];
    tasting.sections = [[NSMutableArray alloc]init];
    tasting.characteristic_sections = [[NSMutableArray alloc]init];

    
    //nao se pode fazer query dentro de query por causa do statement de sql senao apagava os dados
    
    
    //obter seccoes de criterios
    querySQL = [NSString stringWithFormat:@"SELECT fs.formsection_id, fs.order_priority, fs.name_en, fs.name_fr, fs.name_pt\
                FROM FormSection fs, FormTasting ft, UserTypeForm utf \
                WHERE utf.user = \'%@\' AND utf.winetype_id = %d AND utf.formtasting_id = ft.formtasting_id AND ft.formtasting_id = fs.formtasting_id \
                ORDER BY fs.order_priority ASC;", 
                user.username,
                wineType.winetype_id];
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            Seccao * section = [[Seccao alloc] init];
            section.criteria = [[NSMutableArray alloc]init];
            
            section.order = sqlite3_column_int(stmt, 1); 
            section.name_en  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            section.name_fr  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            section.name_pt  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            //para ter referencia em futuras queries
            section.section_id = sqlite3_column_int(stmt, 0);
            
            [tasting.sections insertObject:section atIndex:0];
            //DebugLog(@"Section: %@", [[tasting.sections objectAtIndex:0] name_en]);

        }
        
        sqlite3_finalize(stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        sqlite3_close(*contactDB);
        return nil;
    }
    
    
    //obter criterios para as seccoes
    for (int i = 0; i < tasting.sections.count; i++) {
        
        Seccao * section =  [tasting.sections objectAtIndex:i];
        
        querySQL = [NSString stringWithFormat:@"SELECT fc.formcriterion_id, fc.order_priority, fc.name_en, fc.name_fr, fc.name_pt \
        FROM FormCriterion fc \
        WHERE fc.formsection_id = %d;", section.section_id];
        
        //DebugLog(querySQL);
        //DebugLog(@"\ncount: %d", section.criteria.count);
        
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Criterio * criterion = [[Criterio alloc]init];
                criterion.classifications = [[NSMutableArray alloc]init];
                
                
                criterion.order = sqlite3_column_int(stmt, 1);
                criterion.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                criterion.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                criterion.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                //para ter referencia em futuras queries
                criterion.criterion_id = sqlite3_column_int(stmt, 0);
                
                
                [section.criteria  insertObject:criterion atIndex:0];
                //DebugLog(@"Section: %@% , Criterion: %@", section.name_en, [[section.criteria objectAtIndex:0] name_en]);
            
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            sqlite3_close(*contactDB);
            return nil;
        }
        
        //DebugLog(@"Section: %@-%d count: %d", section.name_en, section.section_id ,section.criteria.count);
    }
    
    
    //obter classificacoes para os criterios
    for (int i = 0; i < tasting.sections.count; i++) {
        
        Seccao * section =  [tasting.sections objectAtIndex:i];
        //DebugLog(@"Seccao: %@", section.name_en);
        
        for (int k = 0; k < section.criteria.count; k++) {
        
            Criterio * criterion = [section.criteria objectAtIndex:k];
            
            
            querySQL = [NSString stringWithFormat:@"SELECT c.classification_id, c.weight, c.name_en, c.name_fr, c.name_pt \
                        FROM Classification c, PossibleClassification pc \
                        WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = c.classification_id",
                        criterion.criterion_id,
                        @"FormCriterion"];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    
                    Classificacao * classification = [[Classificacao alloc]init];
                    
                    classification.classification_id = sqlite3_column_int(stmt, 0);
                    classification.weight = sqlite3_column_int(stmt, 1);
                    classification.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                    classification.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                    classification.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                    
                    
                    //DebugLog(@"Section: %@, Criterion: %@, Classification: %@", section.name_en, criterion.name_en, [[criterion.classifications objectAtIndex:0] name_en]);
                    DebugLog(@"Section: %@, Criterion: %@, Classification: %@", section.name_en, criterion.name_en, classification.name_en);
                    [criterion.classifications insertObject:classification atIndex:0];
                    

                    
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                sqlite3_close(*contactDB);
                return nil;
            }
            
            //DebugLog(@"\n\n");
            
        }
        //DebugLog(@"\n\n");
    }
    
    
    /*
    //////////////////////////////////////////////////////////
    //obter seccoes de caracteristicas
    querySQL = [NSString stringWithFormat:@"SELECT fsc.formsectioncharacteristic_id, fsc.order_priority, fsc.name_en, fsc.name_fr, fsc.name_pt\
                FROM FormSectionCharacteristic fsc, FormTasting ft, UserTypeForm utf \
                WHERE utf.user = \'%@\' AND utf.winetype_id = %d AND utf.formtasting_id = ft.formtasting_id AND ft.formtasting_id = fsc.formtasting_id \
                ORDER BY fsc.order_priority ASC;", 
                user.username,
                wineType.winetype_id];
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            SeccaoCaracteristica * sectionCharacteristic = [[SeccaoCaracteristica alloc] init];
            
            sectionCharacteristic.order = sqlite3_column_int(stmt, 1); 
            sectionCharacteristic.name_en  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            sectionCharacteristic.name_fr  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            sectionCharacteristic.name_pt  = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            //para ter referencia em futuras queries
            sectionCharacteristic.sectioncharacteristic_id = sqlite3_column_int(stmt, 0);
            
            [tasting.characteristic_sections insertObject:sectionCharacteristic atIndex:0];
            
        }
        
        sqlite3_finalize(stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        sqlite3_close(*contactDB);
        return nil;
    }
    
    
    //obter caracteristicas para as seccoes de caracteristicas
    for (int i = 0; i < tasting.characteristic_sections.count; i++) {
        
        SeccaoCaracteristica * sectionCharacteristic =  [tasting.characteristic_sections objectAtIndex:i];
        
        querySQL = [NSString stringWithFormat:@"SELECT fc.formcharacteristic_id, fc.order_priority, fc.name_en, fc.name_fr, fc.name_pt \
                    FROM FormCharacteristic fc \
                    WHERE fc.formsectioncharacteristic_id = %d;", sectionCharacteristic.sectioncharacteristic_id];
        
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Caracteristica * characteristic = [[Caracteristica alloc]init];
                
                
                characteristic.order = sqlite3_column_int(stmt, 1);
                characteristic.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                characteristic.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                characteristic.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                //para ter referencia em futuras queries
                characteristic.characteristic_id = sqlite3_column_int(stmt, 0);
                
                
                [sectionCharacteristic.characteristics insertObject:characteristic atIndex:0];                
                
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            sqlite3_close(*contactDB);
            return nil;
        }
    }
    
    
    //obter classificacoes para as caracteristicas
    for (int i = 0; i < tasting.characteristic_sections.count; i++) {
        
        SeccaoCaracteristica * sectionCharacteristic =  [tasting.characteristic_sections objectAtIndex:i];
        
        for (int k = 0; k < sectionCharacteristic.characteristics.count; k++) {
            
            Caracteristica * characteristic = [sectionCharacteristic.characteristics objectAtIndex:k];
            
            
            querySQL = [NSString stringWithFormat:@"SELECT c.classification_id, c.weight, c.name_en, c.name_fr, c.name_pt \
                        FROM Classification c, PossibleClassification pc \
                        WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = c.classification_id",
                        characteristic.characteristic_id,
                        @"FormCharacteristic"];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    
                    Classificacao * classification = [[Classificacao alloc]init];
                    
                    classification.classification_id = sqlite3_column_int(stmt, 0);
                    classification.weight = sqlite3_column_int(stmt, 1);
                    classification.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                    classification.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                    classification.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                    
                    
                    [characteristic.classifications insertObject:classification atIndex:0];
                }
                sqlite3_finalize(stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                sqlite3_close(*contactDB);
                return nil;
            }
            
        }
    }
     */
    
    //current time
    NSDate* date = [NSDate date];
    
    //conversion to unix representation
    NSTimeInterval time = [date timeIntervalSince1970];
    
    tasting.tasting_date = (int) time;
    
    return tasting;
    
}




@end
