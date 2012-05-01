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

- (NSString*) description {
    return self.name;
}

- (NSMutableArray*) provas {
    if (! _provas) {
        [self loadProvasFromDB];
    } 
    return _provas;
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
                        WHERE t.wine_id = %d AND t.classification_id = c.classification_id;", _wine_id ];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude,  c.classification_id, c.weight, c.name_en\
                              FROM Tasting t, Classification c\
                              WHERE t.wine_id = %d AND t.classification_id = c.classification_id;", _wine_id ];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude,  c.classification_id, c.weight, c.name_pt\
                             FROM Tasting t, Classification c\
                             WHERE t.wine_id = %d AND t.classification_id = c.classification_id;", _wine_id ];            
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

- (void) updateWithVinho:(Vinho *)vinho {
    
#warning TODO: update do vinho
    
    if (self.name != vinho.name)
        self.name = vinho.name;
    if (self.producer != vinho.producer)
        self.producer = vinho.producer;
    if (self.year != vinho.year)
        self.year = vinho.year;
    
    //TODO: actualizar na BD os atributos alterados
    
}

@end
