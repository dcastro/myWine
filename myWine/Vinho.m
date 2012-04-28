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

@implementation Vinho

@synthesize name = _name;
@synthesize wine_id, year, price, currency, producer, photo, region_name, winetype_name, country_name;
@synthesize provas=_provas;

- (NSString*) description {
    return self.name;
}

- (NSMutableArray*) provas {
    if (! _provas) {
        [self loadProvasFromDB];
    } 
    return _provas;
}

- (void) loadProvasFromDB {
    _provas = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                        FROM Tasting t \
                        WHERE t.wine_id = %d;", wine_id ];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                              FROM Tasting t \
                              WHERE t.wine_id = %d;", wine_id ];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                             FROM Tasting t \
                             WHERE t.wine_id = %d;", wine_id ];            
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@",querySQL);
    
    sqlite3_stmt *stmt = [query prepareForQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Prova *tasting = [[Prova alloc] init];
            
            
            tasting.tasting_date = sqlite3_column_int(stmt, 1);   
            tasting.tasting_date = sqlite3_column_int(stmt, 0);
            tasting.comment = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            tasting.latitude = sqlite3_column_double(stmt, 3);
            tasting.longitude = sqlite3_column_double(stmt, 4);
            
            [_provas insertObject:tasting atIndex:0];
        }
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
