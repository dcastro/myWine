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
    contactDB = [query prepareForExecution];
    
    NSMutableDictionary * requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.username,@"Username" ,user.password, @"Password" , [NSNumber numberWithDouble:user.synced_at], @"SyncedAt" , nil];
    
    
    //new
    NSMutableDictionary * new = [self buildNew];
    if (new) {
        [requestData setObject:new forKey:@"New"];
    }else {
        sqlite3_close(*contactDB);
        return nil;
    }
    
    
    
    //updated
    NSMutableDictionary * updated = [self buildUpdatedWines];
    if(updated){
        [requestData setObject:updated forKey:@"Updated"];
        
    }else {
        sqlite3_close(*contactDB);
        return nil;
    }
    
    
    
    
    //deleted
    NSMutableDictionary * deleted = [self buildDeleted];
    if (deleted) {
        [requestData setObject:deleted forKey:@"Deleted"];
    }else {
        sqlite3_close(*contactDB);
        return nil;
    }
    
    
    
    sqlite3_close(*contactDB);
    
    //conversao para string
    NSData * data = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:error];
    
    if(!data){
        DebugLog(@"Error: %@", *error);
        return nil;
    }else {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}



-(NSMutableDictionary *)buildUpdatedWines
{
    NSMutableDictionary * updated = [[NSMutableDictionary alloc]init ];
    NSMutableArray * wines = [[NSMutableArray alloc] init ];
    
    NSString * querySQL = [NSString stringWithFormat:@"SELECT w.wine_id, w.wine_server_id, w.region_id, w.year, w.name, w.grapes, w.photo_filename, w.producer, w.currency, w.price  \
                           FROM Wine w, Tasting t\
                           WHERE w.user = \'%@\' AND t.wine_id = w.wine_id AND (w.state = 2 OR t.state = 2)", user.username];
    
    sqlite3_stmt * wines_stmt;
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &wines_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(wines_stmt) == SQLITE_ROW){
            
            int wine_id = sqlite3_column_int(wines_stmt, 0);
            NSMutableDictionary * wine = [[NSMutableDictionary alloc]init];
            [wine setObject:[NSNumber numberWithInt:sqlite3_column_int(wines_stmt, 1)] forKey:@"WineServerId"];
            [wine setObject:[NSNumber numberWithInt:sqlite3_column_int(wines_stmt, 2)] forKey:@"Region"];
            [wine setObject:[NSNumber numberWithInt:sqlite3_column_int(wines_stmt, 3)] forKey:@"Harvest"]; //year
            [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(wines_stmt, 4)] forKey:@"Name"];
            [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(wines_stmt, 5)] forKey:@"Grapes"];
            [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(wines_stmt, 6)] forKey:@"PhotoFilename"];
            [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(wines_stmt, 7)] forKey:@"Producer"];
            [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(wines_stmt, 8)] forKey:@"Currency"];
            [wine setObject:[NSNumber numberWithDouble:sqlite3_column_double(wines_stmt, 9)] forKey:@"Price"];
            
            
            
            querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                        FROM Tasting t \
                        WHERE t.wine_id = %d AND t.state = 2", wine_id];
            
            
            sqlite3_stmt * tastings_stmt;
            NSMutableArray * tastings = [[NSMutableArray alloc]init ];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &tastings_stmt, NULL) == SQLITE_OK){
                while(sqlite3_step(tastings_stmt) == SQLITE_ROW){
                    
                    
                    //adiciona prova
                    [tastings addObject:[self buildTasting:&tastings_stmt]];
                    
                    
                }
                sqlite3_finalize(tastings_stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return nil;
            }
            
            [wine setObject:tastings forKey:@"Tastings"];
            
            
            
            [wines addObject:wine];
            
        }
        sqlite3_finalize(wines_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }

    
    
    
    
    
    
    [updated setObject:wines forKey:@"Wines"];
    
    return updated;
    
}



-(NSMutableDictionary *) buildNew
{
    NSMutableDictionary * new = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * newWines = [self buildNewWines];
    if(newWines){
        [new setObject:newWines forKey:@"Wines"];
    }else {
        return nil;
    }
    
    
    NSMutableArray * newTastings = [self buildNewTastings];
    if(newTastings){
        [new setObject:newTastings forKey:@"Tastings"];
    }else {
        return nil;
    }
     
    
    return new;
}


-(NSMutableArray *)buildNewTastings
{
    NSString * querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude, w.wine_server_id \
                           FROM Tasting t, Wine w \
                           WHERE t.state = 1 AND t.wine_id = w.wine_id AND w.state = 0 AND w.user = \'%@\';",user.username];    
    
    
    
    sqlite3_stmt * tastings_stmt;
    NSMutableArray * tastings = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &tastings_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(tastings_stmt) == SQLITE_ROW){
            
            
            int tasting_id = sqlite3_column_int(tastings_stmt, 0);
            
            NSMutableDictionary * tasting = [[NSMutableDictionary alloc]init ];
            [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(tastings_stmt, 1)] forKey:@"TastingDate"];
            [tasting setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(tastings_stmt, 2)] forKey:@"Comment"];
            [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(tastings_stmt, 3)] forKey:@"Latitude"];
            [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(tastings_stmt, 4)] forKey:@"Longitude"];
            [tasting setObject:[NSNumber numberWithInt:sqlite3_column_int(tastings_stmt, 5)] forKey:@"WineServerId"];
            
            
            
            querySQL = [NSString stringWithFormat:@"SELECT s.section_id, s.order_priority, s.name_en, s.name_fr, s.name_pt \
                        FROM Section s \
                        WHERE s.tasting_id = %d", tasting_id];
            
            
            
            
            sqlite3_stmt * sections_stmt;
            NSMutableArray * sections = [[NSMutableArray alloc]init ];
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &sections_stmt, NULL) == SQLITE_OK){
                while(sqlite3_step(sections_stmt) == SQLITE_ROW){
                    
                    
                    [sections addObject:[self buildSection:&sections_stmt]];
                    
                }
                sqlite3_finalize(sections_stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return nil;
            }
            
            [tasting setObject:sections forKey:@"EvaluationSections"];
            
            
            
            querySQL = [NSString stringWithFormat:@"SELECT sc.sectioncharacteristic_id, sc.order_priority, sc.name_en, sc.name_fr, sc.name_pt \
                        FROM SectionCharacteristic sc \
                        WHERE sc.tasting_id = %d", tasting_id];
            
            
            NSMutableArray * characteristicSections = [[NSMutableArray alloc]init ];
            sqlite3_stmt * characteristicSections_stmt;
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &characteristicSections_stmt, NULL) == SQLITE_OK){
                while(sqlite3_step(characteristicSections_stmt) == SQLITE_ROW){
                    
                    
                    [characteristicSections addObject:[self buildCharacteristicSection:&characteristicSections_stmt]];
                    
                }
                sqlite3_finalize(characteristicSections_stmt);
            }else {
                DebugLog(@"Query with error: %@", querySQL);
                return nil;
            }
            
            [tasting setObject:characteristicSections forKey:@"CaracteristicsSections"];

            
            
            [tastings addObject:tasting];
            
        }
        sqlite3_finalize(tastings_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    return tastings;
}



-(NSMutableArray *)buildNewWines
{
    
    
    NSString * querySQL = [NSString stringWithFormat:@"SELECT w.wine_id, w.region_id, w.year, w.name, w.grapes, w.photo_filename, w.producer, w.currency, w.price, wt.winetype_id, wt.name_en, wt.name_fr, wt.name_pt  \
                FROM Wine w, WineType wt\
                WHERE user = \'%@\' AND state == 1 AND w.winetype_id = wt.winetype_id", user.username];
    
    sqlite3_stmt * wines_stmt;
    NSMutableArray * wines = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &wines_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(wines_stmt) == SQLITE_ROW){
            

            //adiciona o vinho
            [wines addObject:[self buildWine:&wines_stmt]];
            
        }
        sqlite3_finalize(wines_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }

    return wines;
    
}
                                 
                                 
                                 
                                 
-(NSDictionary *)buildWine:(sqlite3_stmt **)wine_stmt
{
    
    int wine_id = sqlite3_column_int(*wine_stmt, 0);
    NSMutableDictionary * wine = [[NSMutableDictionary alloc]init];
    [wine setObject:[NSNumber numberWithInt:sqlite3_column_int(*wine_stmt, 1)] forKey:@"Region"];
    [wine setObject:[NSNumber numberWithInt:sqlite3_column_int(*wine_stmt, 2)] forKey:@"Harvest"]; //year
    [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 3)] forKey:@"Name"];
    [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 4)] forKey:@"Grapes"];
    [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 5)] forKey:@"PhotoFilename"];
    [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 6)] forKey:@"Producer"];
    [wine setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 7)] forKey:@"Currency"];
    [wine setObject:[NSNumber numberWithDouble:sqlite3_column_double(*wine_stmt, 8)] forKey:@"Price"];
    
    NSMutableDictionary * winetype =[[NSMutableDictionary alloc] init ]; 
    [winetype setObject:[NSNumber numberWithInt:sqlite3_column_int(*wine_stmt, 9)] forKey:@"Id"];
    [winetype setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 10)] forKey:@"NameEn"];
    [winetype setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 11)] forKey:@"NameFr"];
    [winetype setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*wine_stmt, 12)] forKey:@"NamePt"];
    
    [wine setObject:winetype forKey:@"WineType"];


    
    
    //nao se precisa de verificar estado porque uma vinho novo so tem provas novas
    NSString * querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                FROM Tasting t \
                WHERE wine_id = %d", wine_id];
    
    
  
    sqlite3_stmt * tastings_stmt;
    NSMutableArray * tastings = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &tastings_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(tastings_stmt) == SQLITE_ROW){
            
            
            //adiciona prova
            [tastings addObject:[self buildTasting:&tastings_stmt]];
                        
            
        }
        sqlite3_finalize(tastings_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [wine setObject:tastings forKey:@"Tastings"];

    
    return wine;
}



-(NSDictionary *)buildTasting:(sqlite3_stmt**)tasting_stmt
{
    int tasting_id = sqlite3_column_int(*tasting_stmt, 0);
    NSMutableDictionary * tasting = [[NSMutableDictionary alloc]init ];
    [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(*tasting_stmt, 1)] forKey:@"TastingDate"];
    [tasting setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*tasting_stmt, 2)] forKey:@"Comment"];
    [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(*tasting_stmt, 3)] forKey:@"Latitude"];
    [tasting setObject:[NSNumber numberWithDouble:sqlite3_column_double(*tasting_stmt, 4)] forKey:@"Longitude"];
    
    
    
    
    NSString * querySQL = [NSString stringWithFormat:@"SELECT s.section_id, s.order_priority, s.name_en, s.name_fr, s.name_pt \
                FROM Section s \
                WHERE s.tasting_id = %d", tasting_id];
    
    
    sqlite3_stmt * sections_stmt;
    NSMutableArray * sections = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &sections_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(sections_stmt) == SQLITE_ROW){
            
            
            [sections addObject:[self buildSection:&sections_stmt]];
            
        }
        sqlite3_finalize(sections_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [tasting setObject:sections forKey:@"EvaluationSections"];
    
    
    
    
    
    
    querySQL = [NSString stringWithFormat:@"SELECT sc.sectioncharacteristic_id, sc.order_priority, sc.name_en, sc.name_fr, sc.name_pt \
                FROM SectionCharacteristic sc \
                WHERE sc.tasting_id = %d", tasting_id];
    
    
    NSMutableArray * characteristicSections = [[NSMutableArray alloc]init ];
    sqlite3_stmt * characteristicSections_stmt;
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &characteristicSections_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(characteristicSections_stmt) == SQLITE_ROW){
            
            
            [characteristicSections addObject:[self buildCharacteristicSection:&characteristicSections_stmt]];
            
        }
        sqlite3_finalize(characteristicSections_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }

    [tasting setObject:characteristicSections forKey:@"CaracteristicsSections"];
    
    
    return tasting;
    
}


-(NSMutableDictionary *)buildCharacteristicSection:(sqlite3_stmt**)charcteristicSection_stmt
{
    int characteristicSection_id = sqlite3_column_int(*charcteristicSection_stmt, 0);
    NSMutableDictionary * characteristicSection = [[NSMutableDictionary alloc]init ];
    [characteristicSection setObject:[NSNumber numberWithInt:sqlite3_column_int(*charcteristicSection_stmt, 1)] forKey:@"Order"];
    [characteristicSection setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*charcteristicSection_stmt, 2)] forKey:@"NameEn"];
    [characteristicSection setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*charcteristicSection_stmt, 3)] forKey:@"NameFr"];
    [characteristicSection setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*charcteristicSection_stmt, 4)] forKey:@"NamePt"];
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT c.characteristic_id, c.order_priority, c.name_en, c.name_fr, c.name_pt, cl.name_en, cl.name_fr, cl.name_pt  \
                          FROM Characteristic c, Classification cl \
                          WHERE c.sectioncharacteristic_id = %d AND c.classification_id = cl.classification_id", characteristicSection_id];
    
    
    sqlite3_stmt * characteristics_stmt;
    NSMutableArray * characteristics = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &characteristics_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(characteristics_stmt) == SQLITE_ROW){
            
            [characteristics addObject:[self buildCharacteristic:&characteristics_stmt]];
            
            
        }
        sqlite3_finalize(characteristics_stmt);
        
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [characteristicSection setObject:characteristics forKey:@"Criterias"];
    
    
    return characteristicSection;
    
}

-(NSMutableDictionary *)buildCharacteristic:(sqlite3_stmt **)characteristic_stmt
{
    int characteristic_id = sqlite3_column_int(*characteristic_stmt, 0);
    NSMutableDictionary * characteristic = [[NSMutableDictionary alloc]init ];
    [characteristic setObject:[NSNumber numberWithInt:sqlite3_column_int(*characteristic_stmt, 1)] forKey:@"Order"];
    [characteristic setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 2)] forKey:@"NameEn"];
    [characteristic setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 3)] forKey:@"NameFr"];
    [characteristic setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 4)] forKey:@"NamePt"];
    
    
    NSMutableDictionary *chosenClassification = [[NSMutableDictionary alloc]init ];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 5)] forKey:@"NameEn"];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 6)] forKey:@"NameFr"];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*characteristic_stmt, 7)] forKey:@"NamePt"];
    
    [characteristic setObject:chosenClassification forKey:@"ChosenClassifications"];
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT cl.name_en, cl.name_fr, cl.name_pt  \
                          FROM Classification cl, PossibleClassification pc \
                          WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = cl.classification_id", characteristic_id, @"Characteristic"];
    
    sqlite3_stmt * classifications_stmt;
    NSMutableArray * classifications = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &classifications_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(classifications_stmt) == SQLITE_ROW){
            
            
            NSMutableDictionary * classification = [[NSMutableDictionary alloc]init ];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 0)] forKey:@"NameEn"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 1)] forKey:@"NameFr"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 2)] forKey:@"NamePt"];
            
            
            [classifications addObject:classification];
            
        }
        sqlite3_finalize(classifications_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [characteristic setObject:classifications forKey:@"Classifications"];
    
    
    
    return characteristic;
    
}


-(NSMutableDictionary *)buildSection:(sqlite3_stmt**)section_stmt
{

    int section_id = sqlite3_column_int(*section_stmt, 0);
    NSMutableDictionary * section = [[NSMutableDictionary alloc]init ];
    [section setObject:[NSNumber numberWithInt:sqlite3_column_int(*section_stmt, 1)] forKey:@"Order"];
    [section setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*section_stmt, 2)] forKey:@"NameEn"];
    [section setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*section_stmt, 3)] forKey:@"NameFr"];
    [section setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*section_stmt, 4)] forKey:@"NamePt"];
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT c.criterion_id, c.order_priority, c.name_en, c.name_fr, c.name_pt, cl.weight, cl.name_en, cl.name_fr, cl.name_pt  \
                FROM Criterion c, Classification cl \
                WHERE c.section_id = %d AND c.classification_id = cl.classification_id", section_id];
    
    
    sqlite3_stmt * criterions_stmt;
    NSMutableArray * criterias = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &criterions_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(criterions_stmt) == SQLITE_ROW){
            
            
            [criterias addObject:[self buildCriterion:&criterions_stmt]];
            
            
        }
        sqlite3_finalize(criterions_stmt);
        
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [section setObject:criterias forKey:@"Criterias"];
    

    return section;

}


-(NSMutableDictionary *)buildCriterion:(sqlite3_stmt **)criterion_stmt
{
    int criterion_id = sqlite3_column_int(*criterion_stmt, 0);
    NSMutableDictionary * criterion = [[NSMutableDictionary alloc]init ];
    [criterion setObject:[NSNumber numberWithInt:sqlite3_column_int(*criterion_stmt, 1)] forKey:@"Order"];
    [criterion setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 2)] forKey:@"NameEn"];
    [criterion setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 3)] forKey:@"NameFr"];
    [criterion setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 4)] forKey:@"NamePt"];
    
    
    NSMutableDictionary *chosenClassification = [[NSMutableDictionary alloc]init ];
    [chosenClassification setObject:[NSNumber numberWithInt:sqlite3_column_int(*criterion_stmt, 5)] forKey:@"Weight"];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 6)] forKey:@"NameEn"];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 7)] forKey:@"NameFr"];
    [chosenClassification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(*criterion_stmt, 8)] forKey:@"NamePt"];
    
    [criterion setObject:chosenClassification forKey:@"ChosenClassifications"];
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT cl.weight, cl.name_en, cl.name_fr, cl.name_pt  \
                          FROM Classification cl, PossibleClassification pc \
                          WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = cl.classification_id", criterion_id, @"Criterion"];
    
    sqlite3_stmt * classifications_stmt;
    NSMutableArray * classifications = [[NSMutableArray alloc]init ];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &classifications_stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(classifications_stmt) == SQLITE_ROW){
            
            
            NSMutableDictionary * classification = [[NSMutableDictionary alloc]init ];
            [classification setObject:[NSNumber numberWithInt:sqlite3_column_int(classifications_stmt, 0)] forKey:@"Weight"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 1)] forKey:@"NameEn"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 2)] forKey:@"NameFr"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(classifications_stmt, 3)] forKey:@"NamePt"];
            
            
            [classifications addObject:classification];
            
        }
        sqlite3_finalize(classifications_stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [criterion setObject:classifications forKey:@"Classifications"];

    
    
    return criterion;
    
    
}



-(NSMutableDictionary *)getClassificationByID:(int)classification_id
{
    NSMutableDictionary * classification = [[NSMutableDictionary alloc]init];
    
    sqlite3_stmt * stmt;
    NSString * querySQL = [NSString stringWithFormat:@"SELECT weight, name_en, name_fr, name_pt \
                           FROM Classification \
                           WHERE classification_id = %d;", classification_id];
    
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        if(sqlite3_step(stmt) == SQLITE_ROW){
            
            NSNumber * weight = [NSNumber numberWithInt:sqlite3_column_int(stmt, 0)];
            if(weight != 0)
                [classification setObject:weight forKey:@"weight"];
                
            
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] forKey:@"name_eng"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] forKey:@"name_fr"];
            [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)] forKey:@"name_pt"];
            
            
        }
        sqlite3_finalize(stmt);
    }else {
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    
    return classification;
    
}



-(NSMutableArray *)getClassificationsByID:(int)classifiable Type:(NSString*)classifiableType
{
    NSMutableArray * classifications = [[NSMutableArray alloc]init];
    NSString * querySQL;
    
    sqlite3_stmt * stmt;
    if([classifiableType isEqualToString:@"Criterion"]){
        querySQL = [NSString stringWithFormat:@"SELECT c.weight, c.name_en, c.name_fr, c.name_pt \
                    FROM Classification c, PossibleClassification pc \
                    WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = c.classification_id;", 
                    classifiable, 
                    classifiableType];
        
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                NSMutableDictionary * classification = [[NSMutableDictionary alloc]init];
                
                [classification setObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, 0)] forKey:@"weight"];
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] forKey:@"name_eng"];
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] forKey:@"name_fr"];
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)] forKey:@"name_pt"];
                
                
                [classifications addObject:classification];
                
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return nil;
        }

        
    }else {
        querySQL = [NSString stringWithFormat:@"SELECT c.name_en, c.name_fr, c.name_pt \
                    FROM Classification c, PossibleClassification pc \
                    WHERE pc.classifiable_id = %d AND pc.classifiable_type = \'%@\' AND pc.classification_id = c.classification_id;", 
                    classifiable, 
                    classifiableType];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                NSMutableDictionary * classification = [[NSMutableDictionary alloc]init];
                
                
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)] forKey:@"name_eng"];
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] forKey:@"name_fr"];
                [classification setObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] forKey:@"name_pt"];
                
                
                [classifications addObject:classification];
                
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return nil;
        }
    }
    
    
    return classifications;
       
}



-(NSMutableDictionary *)buildDeleted
{
    NSString * querySQL;
    sqlite3_stmt * stmt;
    NSMutableDictionary* deleted = [[NSMutableDictionary alloc] init];
    
    
    //wines
    NSMutableArray * wines = [[NSMutableArray alloc] init];
    
    querySQL = [NSString stringWithFormat:@"SELECT wine_server_id FROM Wine WHERE user = \'%@\' AND state = 3;", user.username];
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            [wines addObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, 0)]];
            
        }
        sqlite3_finalize(stmt);
    }else{
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [deleted setObject:wines forKey:@"Wines"];
    
    
    //tastings
    NSMutableArray * tastings = [[NSMutableArray alloc] init];
    
    querySQL = [NSString stringWithFormat:@"SELECT t.tasting_date FROM Tasting t, Wine w WHERE w.user = \'%@\' AND w.wine_id = t.wine_id AND t.state = 3;", user.username];
    
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            [tastings addObject:[NSNumber numberWithDouble:sqlite3_column_double(stmt, 0)]];
            
        }
        sqlite3_finalize(stmt);
    }else{
        DebugLog(@"Query with error: %@", querySQL);
        return nil;
    }
    
    [deleted setObject:tastings forKey:@"Tastings"];
    
    
    
    return deleted;
    
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
    
    //DebugLog(@"JSON: %@", [NSString stringWithFormat:@"%@",  receivedJSON]);

    
    
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE User SET synced_at = %f, validated = 1 WHERE username = \'%@\';", [[receivedJSON objectForKey:@"Timestamp"] doubleValue], user.username];
    
    
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        [query rollbackTransaction];
        return FALSE;
    }
    

  
    if([receivedJSON objectForKey:@"Countries"]){
        if(![self parseCountries:[receivedJSON objectForKey:@"Countries"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    
    
    if([receivedJSON objectForKey:@"WineTypes"]){
        if(![self parseWineTypes:[receivedJSON objectForKey:@"WineTypes"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }

    
    if([receivedJSON objectForKey:@"Wines"]){
        if(![self parseWines:[receivedJSON objectForKey:@"Wines"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    
    
    if([receivedJSON objectForKey:@"Deleted"]){
        if(![self parseDeleted:[receivedJSON objectForKey:@"Deleted"]]){
            [query rollbackTransaction];
            return FALSE;
        }
    }
    
    
    if([receivedJSON objectForKey:@"WineSeverIds"]){
        if(![self parseWineServerIds:[receivedJSON objectForKey:@"WineSeverIds"]]){
            [query rollbackTransaction];
            return FALSE;
        }
    }
     
    
    
    //ultimo passo e limpar o lixo solto da bd
    if(![self cleanGarbage]){
        [query rollbackTransaction];
        return FALSE; 
    }
    
    

    if(![self resetStates]){
        [query rollbackTransaction];
        return FALSE;
    }
    
    //actualiza o synced_at
    user.synced_at = [[receivedJSON objectForKey:@"Timestamp"] doubleValue];
    
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
            DebugLog(@"Query with error: %s", errMsg);
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
    NSArray * deletedWines = [deletedJSON objectForKey:@"Wines"];
    for (int i = 0; i < [deletedWines count]; i++) {
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE user = \'%@\' AND wine_server_id = %d",
                    user.username,
                    [[[deletedWines objectAtIndex:i] objectForKey:@"WineSeverIds"] intValue]];
        
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
    }
    
    
    //tastings
    NSArray * deletedTastings = [deletedJSON objectForKey:@"Tastings"];
    int tasting_id;
    for (int i = 0; i < [deletedTastings count]; i++) {
        
        //vai buscar o id da prova do user 
        //para garantir que nao se eliminam varias provas ao mesmo tempo do user errado
        querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id FROM Tasting t , Wine w WHERE t.tasting_date = %f AND t.wine_id = w.wine_id AND w.user = \'%@\';", 
                    [[[deletedTastings objectAtIndex:i] objectForKey:@"TastingDate"] doubleValue],
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
            DebugLog(@"Query with error: %s", errMsg);
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
    char * errMsg;
    
    for(int i = 0; i < [wines count]; i++){
        NSDictionary * wineJSON = [wines objectAtIndex:i];
        int wine_id;
        
        //verificar se o vinho ja existe na da bd, se existir e um update
        querySQL = [NSString stringWithFormat:@"SELECT wine_id FROM wine WHERE wine_server_id = %d AND user = \'%@\'", [[wineJSON objectForKey:@"WineServerId"]intValue], user.username];
        
        
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
                         [wineJSON objectForKey:@"Name"],
                         [wineJSON objectForKey:@"Producer"],
                         [[wineJSON objectForKey:@"Harvest"] intValue],
                         [wineJSON objectForKey:@"Grapes"],
                         [[wineJSON objectForKey:@"Region"] intValue],
                         [wineJSON objectForKey:@"Currency"],
                         [[wineJSON objectForKey:@"Price"]doubleValue],
                         wine_id];
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }else {
            //verificar se o tipo de vinho existe
            querySQL = [NSString stringWithFormat:@"SELECT winetype_id FROM WineType WHERE winetype_id = %d", 
                        [[[wineJSON objectForKey:@"WineType"]objectForKey:@"Id"]intValue]];
            
            BOOL wineTypeExists = FALSE;
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    
                    wineTypeExists = TRUE;
                    
                }
                sqlite3_finalize(stmt);
            }else{
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
                        
            
            if(!wineTypeExists){
                querySQL = [NSString stringWithFormat:@"INSERT INTO WineType VALUES (%d, \'%@\', \'%@\', \'%@\')", 
                            [[[wineJSON objectForKey:@"WineType"]objectForKey:@"Id"]intValue],
                            [[wineJSON objectForKey:@"WineType"]objectForKey:@"NameEn"],
                            [[wineJSON objectForKey:@"WineType"]objectForKey:@"NameFr"],
                            [[wineJSON objectForKey:@"WineType"]objectForKey:@"NamePt"]];
                
                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Query with error: %s", errMsg);
                    sqlite3_free(errMsg);
                    return FALSE;
                }
            }
            
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO Wine(user, region_id, winetype_id, wine_server_id, name, year, grapes, photo_filename, producer, currency, price, state) \
                        VALUES (\'%@\', %d, %d, %d, \'%@\', %d, '\%@\', \'%@\', \'%@\', \'%@\', %f, 0);", 
                        user.username,
                        [[wineJSON objectForKey:@"Region"] intValue],
                        [[[wineJSON objectForKey:@"WineType"]objectForKey:@"Id"]intValue],
                        [[wineJSON objectForKey:@"WineServerId"] intValue],
                        [wineJSON objectForKey:@"Name"],
                        [[wineJSON objectForKey:@"Harvest"]intValue],
                        [wineJSON objectForKey:@"Grapes"],
                        [wineJSON objectForKey:@"PhotoFilename"],
                        [wineJSON objectForKey:@"Producer"],
                        [wineJSON objectForKey:@"Currency"],
                        [[wineJSON objectForKey:@"Price"] doubleValue]];
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }else {
                wine_id = sqlite3_last_insert_rowid(*contactDB);
            }
        }
        
        
        NSArray * tastingsJSON = [wineJSON objectForKey:@"Tastings"];
        for (int k = 0; k < [tastingsJSON count]; k++) {
            NSDictionary * tastingJSON = [tastingsJSON objectAtIndex:k];
            
            BOOL existsTasting = FALSE;
            int tasting_id;
            
            //se o vinho existe verifica se a prova existe
            if(wineExists){
                querySQL = [NSString stringWithFormat:@"SELECT tasting_id FROM tasting WHERE wine_id = %d AND tasting_date = %f", 
                            wine_id, 
                            [[tastingJSON objectForKey:@"TastingDate"]doubleValue]];
                
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
                [tastingJSON objectForKey:@"Comment"],
                [[tastingJSON objectForKey:@"Latitude"]doubleValue],
                [[tastingJSON objectForKey:@"Longitude"]doubleValue],
                tasting_id];
    
    
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }
    
    
    //seccoes
    NSArray * sectionsJSON = [tastingJSON objectForKey:@"EvaluationSections"];
    for(int i = 0; i < [sectionsJSON count]; i++){
        
        NSDictionary *sectionJSON = [sectionsJSON objectAtIndex:i];
        
        int section_id;
        
        querySQL = [NSString stringWithFormat:@"SELECT section_id \
                    FROM Section \
                    WHERE tasting_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                    tasting_id,
                    [[sectionJSON objectForKey:@"Order"]intValue],
                    [sectionJSON objectForKey:@"NameEn"],
                    [sectionJSON objectForKey:@"NameFr"],
                    [sectionJSON objectForKey:@"NamePt"]];
        
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                section_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        NSArray * criteriaJSON = [sectionJSON objectForKey:@"Criterias"];
        for (int k = 0; k < [criteriaJSON count]; k++){
            
            NSDictionary * criterionJSON = [criteriaJSON objectAtIndex:k];
            int criterion_id;
            int classification_id;
            
            
            querySQL = [NSString stringWithFormat:@"SELECT criterion_id \
                        FROM Criterion \
                        WHERE section_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                        section_id,
                        [[criterionJSON objectForKey:@"Order"]intValue],
                        [criterionJSON objectForKey:@"NameEn"],
                        [criterionJSON objectForKey:@"NameFr"],
                        [criterionJSON objectForKey:@"NamePt"]];
            
            
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
                                                    nameEN:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameEn"] 
                                                    nameFR:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameFr"] 
                                                    namePT:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NamePt"] 
                                                andWheight:[[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"Weight"]intValue]];
            
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
    }
    
    
    
    
    
    
    //seccoes de caracteristicas
    NSArray * characteristicsSectionsJSON = [tastingJSON objectForKey:@"CaracteristicsSections"];
    for(int i = 0; i < [characteristicsSectionsJSON count]; i++){
        
        NSDictionary *characteristicsectionJSON = [characteristicsSectionsJSON objectAtIndex:i];
        
        int characteristicsection_id;
        
        querySQL = [NSString stringWithFormat:@"SELECT sectioncharacteristic_id \
                    FROM SectionCharacteristic \
                    WHERE tasting_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                    tasting_id,
                    [[characteristicsectionJSON objectForKey:@"Order"]intValue],
                    [characteristicsectionJSON objectForKey:@"NameEn"],
                    [characteristicsectionJSON objectForKey:@"NameFr"],
                    [characteristicsectionJSON objectForKey:@"NamePt"]];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                characteristicsection_id = sqlite3_column_int(stmt, 0);
            }
            sqlite3_finalize(stmt);
        }else {
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        NSArray * characteriticsJSON = [characteristicsectionJSON objectForKey:@"Criterias"];
        for (int k = 0; k < [characteriticsJSON count]; k++){
            
            NSDictionary * characteristicJSON = [characteriticsJSON objectAtIndex:k];
            int characteristic_id;
            int classification_id;
            
            
            querySQL = [NSString stringWithFormat:@"SELECT characteristic_id \
                        FROM Characteristic \
                        WHERE sectioncharacteristic_id = %d AND order_priority = %d AND name_en = \'%@\' AND  name_fr = \'%@\' AND name_pt = \'%@\';",
                        characteristicsection_id,
                        [[characteristicJSON objectForKey:@"Order"]intValue],
                        [characteristicJSON objectForKey:@"NameEn"],
                        [characteristicJSON objectForKey:@"NameFr"],
                        [characteristicJSON objectForKey:@"NamePt"]];
            
            
            
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
                                                    nameEN:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameEn"] 
                                                    nameFR:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameFr"] 
                                                    namePT:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NamePt"] 
                                                andWheight:[[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"Weight"]intValue]];
            
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
    int tasting_id;
    char * errMsg;
    
    querySQL = [NSString stringWithFormat:@"INSERT INTO Tasting (wine_id, tasting_date, comment, latitude, longitude, state) \
                VALUES (%d, %f, \'%@\', %f, %f, %d);",
                wine_id, 
                [[tastingJSON objectForKey:@"TastingDate"]doubleValue],
                [tastingJSON objectForKey:@"Comment"],
                [[tastingJSON objectForKey:@"Latitude"]doubleValue],
                [[tastingJSON objectForKey:@"Longitude"]doubleValue],
                0];
    
    
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }else {
        tasting_id = sqlite3_last_insert_rowid(*contactDB);
    }
    
    
    
    //seccoes
    NSArray * sectionsJSON = [tastingJSON objectForKey:@"EvaluationSections"];
    for(int i = 0; i < [sectionsJSON count]; i++){
        
        NSDictionary *sectionJSON = [sectionsJSON objectAtIndex:i];
        
        int section_id;
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO Section (tasting_id, order_priority, name_en, name_fr, name_pt)\
                    VALUES (%d, %d, \'%@\', \'%@\', \'%@\');",
                    tasting_id,
                    [[sectionJSON objectForKey:@"Order"]intValue],
                    [sectionJSON objectForKey:@"NameEn"],
                    [sectionJSON objectForKey:@"NameFr"],
                    [sectionJSON objectForKey:@"NamePt"]];
        
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }else {
            section_id = sqlite3_last_insert_rowid(*contactDB);
        }
        
        
               
        NSArray * criteriaJSON = [sectionJSON objectForKey:@"Criterias"];
        for (int k = 0; k < [criteriaJSON count]; k++){
            
            NSDictionary * criterionJSON = [criteriaJSON objectAtIndex:k];
            int criterion_id;
            int classification_id;
            
            
            classification_id = [self insertClassificationIfNotExists:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameEn"] 
                                                               nameFR:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameFr"] 
                                                               namePT:[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NamePt"] 
                                                           andWheight:[[[criterionJSON objectForKey:@"ChosenClassifications"] objectForKey:@"Weight"]intValue]];
            
            if(classification_id == -2)
                return FALSE;
            
                       
            querySQL = [NSString stringWithFormat:@"INSERT INTO Criterion (section_id, order_priority, name_en, name_fr, name_pt, classification_id)\
                        VALUES (%d, %d, \'%@\', \'%@\', \'%@\', %d);",
                        section_id,
                        [[criterionJSON objectForKey:@"Order"]intValue],
                        [criterionJSON objectForKey:@"NameEn"],
                        [criterionJSON objectForKey:@"NameFr"],
                        [criterionJSON objectForKey:@"NamePt"],
                        classification_id];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }else {
                criterion_id = sqlite3_last_insert_rowid(*contactDB);
            }
            
            
            //insere todas as classificacoes possiveis
            NSArray * classificationsJSON = [criterionJSON objectForKey:@"Classifications"];
            for (int z = 0; z < [classificationsJSON count]; z++) {
                NSDictionary * classificationJSON = [classificationsJSON objectAtIndex:z];
                
                
                classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"NameEn"] 
                                                                   nameFR:[classificationJSON objectForKey:@"NameFr"] 
                                                                   namePT:[classificationJSON objectForKey:@"NamePt"] 
                                                               andWheight:[[classificationJSON objectForKey:@"Weight"]intValue]];
                
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
    NSArray * characteristicsSectionsJSON = [tastingJSON objectForKey:@"CaracteristicsSections"];
    for (int i = 0; i < [characteristicsSectionsJSON count]; i++) {
        NSDictionary *characteristicsectionJSON = [characteristicsSectionsJSON objectAtIndex:i];
        
        int characteristicsection_id;
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO SectionCharacteristic (tasting_id, order_priority, name_en, name_fr, name_pt)\
                    VALUES (%d ,%d, \'%@\', \'%@\', \'%@\');",
                    tasting_id,
                    [[characteristicsectionJSON objectForKey:@"Order"]intValue],
                    [characteristicsectionJSON objectForKey:@"NameEn"],
                    [characteristicsectionJSON objectForKey:@"NameFr"],
                    [characteristicsectionJSON objectForKey:@"NamePt"]];
        
        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }else {
            characteristicsection_id = sqlite3_last_insert_rowid(*contactDB);
        }
        
        
        
        NSArray * characteriticsJSON = [characteristicsectionJSON objectForKey:@"Criterias"];
        for (int k = 0; k < [characteriticsJSON count]; k++){
            
            NSDictionary * characteristicJSON = [characteriticsJSON objectAtIndex:k];
            int characteristic_id;
            int classification_id;
            
            
            classification_id = [self insertClassificationIfNotExists:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameEn"] 
                                                               nameFR:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NameFr"] 
                                                               namePT:[[characteristicJSON objectForKey:@"ChosenClassifications"] objectForKey:@"NamePt"] 
                                                           andWheight:0];
            
            if(classification_id == -2)
                return FALSE;
            
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO Characteristic (sectioncharacteristic_id, order_priority, name_en, name_fr, name_pt, classification_id)\
                        VALUES (%d, %d, \'%@\', \'%@\', \'%@\', %d);",
                        characteristicsection_id,
                        [[characteristicJSON objectForKey:@"Order"]intValue],
                        [characteristicJSON objectForKey:@"NameEn"],
                        [characteristicJSON objectForKey:@"NameFr"],
                        [characteristicJSON objectForKey:@"NamePt"],
                        classification_id];
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }else {
                characteristic_id = sqlite3_last_insert_rowid(*contactDB);
            }
            
            
            //insere todas as classificacoes possiveis
            NSArray * classificationsJSON = [characteristicJSON objectForKey:@"Classifications"];
            for (int z = 0; z < [classificationsJSON count]; z++) {
                NSDictionary * classificationJSON = [classificationsJSON objectAtIndex:z];
                
                
                classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"NameEn"] 
                                                                   nameFR:[classificationJSON objectForKey:@"NameFr"] 
                                                                   namePT:[classificationJSON objectForKey:@"NamePt"] 
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
    char *errMsg;

    
    for (int i = 0; i < [winetypes count]; i++) {
        NSDictionary * winetypesWithFormsJSON = [winetypes objectAtIndex:i];
        int winetype_id = [[winetypesWithFormsJSON objectForKey:@"Id"] intValue];
        int formTasting_id;
        
        //verifica se a form para o tipo de vinho existe
        querySQL = [NSString stringWithFormat:@"SELECT formtasting_id FROM UserTypeForm WHERE winetype_id = %d AND user = \'%@\';", winetype_id, user.username];


        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                
                exists = TRUE;
                formTasting_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
            }
        }else{
            DebugLog(@"Query with error: %@", querySQL);
            return FALSE;
        }
        
        
        //se existir apaga os formularios associados e possible classifications (atraves de cascade da foreign key)
        if(exists){
            
            //isto tambem apaga no UserTypeForm
            querySQL = [NSString stringWithFormat:@"DELETE FROM FormTasting WHERE formtasting_id = %d;", formTasting_id];

            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
            
        }else {//senao existir adiciona
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO WineType VALUES (%d, \'%@\', \'%@\', \'%@\');", 
                        winetype_id,
                        [winetypesWithFormsJSON objectForKey:@"NameEn"],
                        [winetypesWithFormsJSON objectForKey:@"NameFr"],
                        [winetypesWithFormsJSON objectForKey:@"NamePt"]];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
            
        }
        
        
        
        
        //insere no formtasting, retrive do id
        querySQL = @"INSERT INTO FormTasting Default Values;";

        
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }else {
            formTasting_id = sqlite3_last_insert_rowid(*contactDB);
        }
        
        
        
        //falta inserir no usertypeform
        querySQL = [NSString stringWithFormat:@"INSERT INTO UserTypeForm VALUES (\'%@\', %d, %d);",
                    user.username,
                    winetype_id,
                    formTasting_id];
        //DebugLog(querySQL);
        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
            DebugLog(@"Query with error: %s", errMsg);
            sqlite3_free(errMsg);
            return FALSE;
        }
        
        
        
        //seccoes, criterios e classificacoes associadas
        NSArray * formSectionsJSON = [winetypesWithFormsJSON objectForKey:@"FormsEvaluationSections"];
        for(int k = 0; k < [formSectionsJSON count]; k++){
            
            int formSection_id;
            NSDictionary * formSectionJSON = [formSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSection(formtasting_id, order_priority, name_en, name_fr, name_pt) \
                        Values(%d, %d, \'%@\', \'%@\', \'%@\');",
                        formTasting_id,
                        [[formSectionJSON objectForKey:@"Order"] intValue],
                        [formSectionJSON objectForKey:@"NameEn"],
                        [formSectionJSON objectForKey:@"NameFr"],
                        [formSectionJSON objectForKey:@"NamePt"]];
            
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }else {
                formSection_id = sqlite3_last_insert_rowid(*contactDB);
            }
            
            
            
            NSArray * formCriteriaJSON = [formSectionJSON objectForKey:@"Criterias"];
            for (int w=0; w < [formCriteriaJSON count]; w++) {
                
                int criterion_id;
                NSDictionary * formCriterionJSON = [formCriteriaJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCriterion(formsection_id, order_priority, name_en, name_fr, name_pt) \
                            Values(%d, %d, \'%@\', \'%@\', \'%@\');",
                            formSection_id,
                            [[formCriterionJSON objectForKey:@"Order"] intValue],
                            [formCriterionJSON objectForKey:@"NameEn"],
                            [formCriterionJSON objectForKey:@"NameFr"],
                            [formCriterionJSON objectForKey:@"NamePt"]];
                
                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Query with error: %s", errMsg);
                    sqlite3_free(errMsg);
                    return FALSE;
                }else {
                    criterion_id = sqlite3_last_insert_rowid(*contactDB);
                }
                
                
                NSArray * formClassificationsJSON = [formCriterionJSON objectForKey:@"Classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    
                    classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"NameEn"]  
                                                                       nameFR:[classificationJSON objectForKey:@"NameFr"] 
                                                                       namePT:[classificationJSON objectForKey:@"NamePt"] 
                                                                   andWheight:[[classificationJSON objectForKey:@"Weight"]intValue]];
                    
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
        NSArray * formCharacteristicSectionsJSON = [winetypesWithFormsJSON objectForKey:@"FormsCaracteristicsSections"];
        for(int k = 0; k < [formCharacteristicSectionsJSON count]; k++){
            int formSectionCharacteristic_id;
            NSDictionary * formCharacteristicSectionJSON = [formCharacteristicSectionsJSON  objectAtIndex:k];
            
            querySQL = [NSString stringWithFormat:@"INSERT INTO FormSectionCharacteristic(formtasting_id, order_priority, name_en, name_fr, name_pt) \
                        Values(%d, %d, \'%@\', \'%@\', \'%@\');",
                        formTasting_id,
                        [[formCharacteristicSectionJSON objectForKey:@"Order"] intValue],
                        [formCharacteristicSectionJSON objectForKey:@"NameEn"],
                        [formCharacteristicSectionJSON objectForKey:@"NameFr"],
                        [formCharacteristicSectionJSON objectForKey:@"NamePt"]];
            
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"Query with error: %s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }else {
                formSectionCharacteristic_id = sqlite3_last_insert_rowid(*contactDB);
            }
            
            
            NSArray * formCharacteristicsJSON = [formCharacteristicSectionJSON objectForKey:@"Criterias"];
            for (int w=0; w < [formCharacteristicsJSON count]; w++) {
                
                int characteristic_id;
                NSDictionary * formCharacteristicJSON = [formCharacteristicsJSON objectAtIndex:w];
                
                querySQL = [NSString stringWithFormat:@"INSERT INTO FormCharacteristic(formsectioncharacteristic_id, order_priority, name_en, name_fr, name_pt) \
                            Values(%d, %d, \'%@\', \'%@\', \'%@\');",
                            formSectionCharacteristic_id,
                            [[formCharacteristicJSON objectForKey:@"Order"] intValue],
                            [formCharacteristicJSON objectForKey:@"NameEn"],
                            [formCharacteristicJSON objectForKey:@"NameFr"],
                            [formCharacteristicJSON objectForKey:@"NamePt"]];
                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Query with error: %s", errMsg);
                    sqlite3_free(errMsg);
                    return FALSE;
                }else {
                    characteristic_id = sqlite3_last_insert_rowid(*contactDB);
                }
                
                
                NSArray * formClassificationsJSON = [formCharacteristicJSON objectForKey:@"Classifications"];
                for (int z = 0; z < [formClassificationsJSON count]; z++) {
                    
                    NSDictionary * classificationJSON = [formClassificationsJSON objectAtIndex:z];
                    
                    //verificar se existe, 
                    int classification_id;
                    
                    classification_id = [self insertClassificationIfNotExists:[classificationJSON objectForKey:@"NameEn"] 
                                                                       nameFR:[classificationJSON objectForKey:@"NameFr"] 
                                                                       namePT:[classificationJSON objectForKey:@"NamePt"] 
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
    char *errMsg;
   
    NSString * querySQL = [NSString stringWithFormat:@"INSERT INTO Classification(weight, name_en, name_fr, name_pt) Values(%d, \'%@\', \'%@\', \'%@\');",
                           weight, name_eng, name_fr, name_pt];
    
    
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        return_value = -2;
    }else {
        return_value = sqlite3_last_insert_rowid(*contactDB);
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
        DebugLog(@"Query with error: %s", errMsg);
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
        
        country_id = [countryWithRegionsJSON objectForKey:@"Id"];
        
        //verifies if the country exists in the database
        BOOL existsCountry = FALSE;
        querySQL = [NSString stringWithFormat:@"SELECT country_id FROM Country WHERE country_id = \'%@\';", country_id];
        
        if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    existsCountry = TRUE;
                }
                sqlite3_finalize(stmt);
            }else{
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
        }
        
        
        //if it doest exists, stores it
        if(!existsCountry){
            querySQL = [NSString stringWithFormat:@"INSERT INTO Country VALUES (\'%@\', \'%@\', \'%@\', \'%@\');", 
                        [countryWithRegionsJSON objectForKey:@"Id"],
                        [countryWithRegionsJSON objectForKey:@"NameEn"],
                        [countryWithRegionsJSON objectForKey:@"NameFr"],
                        [countryWithRegionsJSON objectForKey:@"NamePt"]];
            
            char *errMsg;
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }
        
        
        NSArray * regionsJSON = [countryWithRegionsJSON objectForKey:@"Regions"];
        for (int k = 0; k < [regionsJSON count]; k++) {
            NSDictionary *regionJSON = [regionsJSON objectAtIndex:k];
            
            BOOL existsRegion = FALSE;
            querySQL = [NSString stringWithFormat:@"SELECT region_id FROM Region WHERE region_id = %d;", [[regionJSON objectForKey:@"Id"]intValue]];
            
            
            if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    existsRegion = TRUE;
                }
                sqlite3_finalize(stmt);
            }else{
                DebugLog(@"Query with error: %@", querySQL);
                return FALSE;
            }
            
            if(!existsRegion){
                querySQL = [NSString stringWithFormat:@"INSERT INTO Region VALUES (%d, \'%@\', \'%@\');", 
                            [[regionJSON objectForKey:@"Id"]intValue],
                            country_id,
                            [regionJSON objectForKey:@"Name"]];
                
                char *errMsg;
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"%s", errMsg);
                    sqlite3_free(errMsg);
                    return FALSE;
                }
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
    querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE user= \'%@\' AND state = 3;", user.username];
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
        DebugLog(@"Query with error: %@", querySQL);
        return FALSE;
    }
    sqlite3_finalize(stmt);
    
    
    
    /*
     select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'FormCriterion' AND classifiable_id not in (Select formcriterion_id from formcriterion) UNION select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'FormCharacteristic' AND classifiable_id not in (Select formcharacteristic_id from FormCharacteristic) UNION select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'Criterion' AND classifiable_id not in (Select criterion_id from Criterion) UNION  select distinct classifiable_id, classifiable_type from possibleclassification where  classifiable_type = 'Characteristic' AND classifiable_id not in (Select characteristic_id from Characteristic);
     */

    
    querySQL =  @"SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'FormCriterion' AND classifiable_id NOT IN (\
                        SELECT formcriterion_id \
                        FROM formcriterion) \
                \
                UNION \
                \
                SELECT DISTINCT classifiable_id, classifiable_type \
                FROM possibleclassification \
                WHERE  classifiable_type = 'FormCharacteristic' AND classifiable_id NOT IN (\
                        SELECT formcharacteristic_id \
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
                WHERE  classifiable_type = 'Characteristic' AND classifiable_id NOT IN (\
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
        DebugLog(@"Query with error: %@", querySQL);
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
        DebugLog(@"Query with error: %@", querySQL);
        return FALSE;
    }
    sqlite3_finalize(stmt);
    
    
    return TRUE;
    
}


-(BOOL)resetStates{
    
    
    //wines
    NSString * querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 0 WHERE (state = 1 OR state =2) AND user = \'%@\';", user.username];
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }
    
    
    
    //tastings
    querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET state = 0 WHERE wine_id IN (SELECT w.wine_id FROM Wine w WHERE w.user = \'%@\') AND (state = 1 OR state =2);", user.username];

    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        return FALSE;
    }
    

    
    return TRUE;
}


@end
