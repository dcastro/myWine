//
//  Vinho.m
//  myWine
//
//  Created by Diogo Castro on 18/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Vinho.h"
#import "Query.h"
#import "Language.h"
#import "Prova.h"
#import "Classificacao.h"
#import "Casta.h"
#import "Utils.h"

@implementation Vinho

@synthesize name = _name;
@synthesize wine_id = _wine_id;
@synthesize  year = _year;
@synthesize price = _price; 
@synthesize currency = _currency;
@synthesize producer = _producer; 
@synthesize photo = _photo; 
@synthesize winetype = _winetype; 
@synthesize provas=_provas;
@synthesize region = _region;
@synthesize grapes = _grapes;

- (NSString*) description {
    return self.name;
}

- (NSMutableArray*) provas {
    if (! _provas) {
        [self loadProvasFromDB];
    } 
    return _provas;
}

-(NSMutableArray*)grapes {
    if(_grapes){
        [self loadCastasFromDB];
    }
    return _grapes;
}

- (BOOL) loadProvasFromDB {
    _provas = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude,  c.classification_id, c.weight, c.name_fr\
                        FROM Tasting t, Classification c\
                        WHERE t.wine_id = %d AND t.classification_id = c.classification_id AND t.state <> 3;", _wine_id ];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude,  c.classification_id, c.weight, c.name_en\
                              FROM Tasting t, Classification c\
                              WHERE t.wine_id = %d AND t.classification_id = c.classification_id AND t.state <> 3;", _wine_id ];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude,  c.classification_id, c.weight, c.name_pt\
                             FROM Tasting t, Classification c\
                             WHERE t.wine_id = %d AND t.classification_id = c.classification_id AND t.state <> 3;", _wine_id ];            
            break;
            
        default:
            break;
    }
        
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Prova *tasting = [[Prova alloc] init];
            
            tasting.tasting_id = sqlite3_column_int(stmt, 0);
            tasting.tasting_date = sqlite3_column_int(stmt, 1);   
            
            const unsigned char * comment = sqlite3_column_text(stmt, 2);
            if(comment != NULL){
                tasting.comment = [NSString stringWithUTF8String:(const char *)comment];
            }
            
            tasting.latitude = sqlite3_column_int(stmt, 3);
            tasting.longitude = sqlite3_column_double(stmt, 4);
            
            Classificacao *c = [[Classificacao alloc] init];
            c.classification_id = sqlite3_column_int(stmt, 5);
            c.weight = sqlite3_column_int(stmt, 6);
            c.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            
            tasting.classification_choosen = c;
            
            [_provas insertObject:tasting atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;

}



- (BOOL) loadCastasFromDB {
    _grapes = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT g.grape_id, g.name_fr\
                        FROM Grape g, WineGrape wg\
                        WHERE wg.wine_id = %d AND wg.grape_id = g.grape_id;", _wine_id ];
            break;
            
        case EN: 
            querySQL =  [NSString stringWithFormat:@"SELECT g.grape_id, g.name_en\
                              FROM Grape g, WineGrape wg\
                              WHERE wg.wine_id = %d AND wg.grape_id = g.grape_id;", _wine_id ];
            break;
            
        case PT:
            querySQL =  [NSString stringWithFormat:@"SELECT g.grape_id, g.name_pt\
                             FROM Grape g, WineGrape wg\
                             WHERE wg.wine_id = %d AND wg.grape_id = g.grape_id;", _wine_id ];            
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Casta *grape = [[Casta alloc] init];
            
            grape.grape_id = sqlite3_column_int(stmt, 0);
            grape.grape_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];  
            
            [_grapes insertObject:grape atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
    
}


- (void) updateWithVinho:(Vinho *)vinho {
    
    
    if (self.name != vinho.name)
        self.name = vinho.name;
    if (self.producer != vinho.producer)
        self.producer = vinho.producer;
    if (self.year != vinho.year)
        self.year = vinho.year;
    if (self.grapes != vinho.grapes)
        self.grapes = vinho.grapes;
    if (self.region != vinho.region)
        self.region = vinho.region;
    if (self.currency != vinho.currency)
        self.currency = vinho.currency;
    
    //TODO: actualizar na BD os atributos alterados
#warning TODO FERNANDO: actualizar castas
#warning TODO FERNANDO: actualizar regiao
#warning TODO FERNANDO: actualizar currency e (se ainda nao estiver a ser actualizado) o price
    Query *query = [[Query alloc] init];
    
    BOOL return_value = TRUE;
    sqlite3_stmt *stmt;
    char * errMsg;
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT state FROM wine WHERE wine_id = %d", self.wine_id];
    
    sqlite3** contactDB = [query prepareForExecution];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
        int state;
        
        if(stmt != NULL){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                state = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                switch (state) {
                    case 0:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 2, name = \'%@\', producer = '\%@\', year = %d WHERE wine_id = %d", self.name, self.producer, self.year, self.wine_id];
                        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not update: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    case 1:
                         querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 1, name = \'%@\', producer = \'%@\', year = %d WHERE wine_id = %d", self.name, self.producer, self.year, self.wine_id];
                        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not update: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    case 2:
                         querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 2, name = \'%@\', producer = \'%@\', year = %d WHERE wine_id = %d", self.name, self.producer, self.year, self.wine_id];
                        if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not update: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            sqlite3_close(*contactDB);
        }
        
    }else{
        return_value = FALSE;
        sqlite3_close(*contactDB);
    }
    
    
#warning TODO: tratamento de erros
    
    
}



-(id) copyWithZone: (NSZone *) zone {
    Vinho* vinho = [[Vinho allocWithZone:zone] init];
    [vinho setProducer:self.producer];
    [vinho setYear:self.year];
    [vinho setRegion:self.region];
    [vinho setPrice:self.price];
    [vinho setCurrency:self.currency];
    [vinho setGrapes:self.grapes];
    [vinho setName:self.name];
    
    return vinho;
}

-(NSString*) fullPrice {
    NSString* full_price = [[NSString alloc] initWithFormat:@"%.02f %@", self.price, currencyStr(self.currency)];
    return full_price;
}


@end
