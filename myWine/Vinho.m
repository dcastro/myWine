//
//  Vinho.m
//  myWine
//
//  Created by Diogo Castro on 18/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Vinho.h"
#import "Query.h"
#import "Prova.h"
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
@synthesize section = _section, row = _row;
@synthesize sectionIsNew = _sectionIsNew;
@synthesize sectionIdentifier = _sectionIdentifier;

- (NSString*) description {
    return self.name;
}

- (NSMutableArray*) provas {
    if (! _provas) {
        [self loadProvasFromDB];
        [_provas sortUsingSelector:@selector(compare:)];
    } 
    return _provas;
}

- (BOOL) loadProvasFromDB {
    _provas = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT t.tasting_id, t.tasting_date, t.comment, t.latitude, t.longitude \
                          FROM Tasting t \
                          WHERE t.wine_id = %d AND t.state <> 3;", self.wine_id ];
    
        
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Prova *tasting = [[Prova alloc] init];
            
            tasting.tasting_id = sqlite3_column_int(stmt, 0);
            tasting.tasting_date = sqlite3_column_double(stmt, 1);   
            const unsigned char * comment = sqlite3_column_text(stmt, 2);
            if(comment != NULL){
                tasting.comment = [NSString stringWithUTF8String:(const char *)comment];
            }else {
                tasting.comment = nil;
            }
            
            tasting.latitude = sqlite3_column_int(stmt, 3);
            tasting.longitude = sqlite3_column_double(stmt, 4);
                        
            tasting.vinho = self;
            [_provas insertObject:tasting atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;

}



- (BOOL) updateWithVinho:(Vinho *)vinho {
    
    
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
    if (self.price != vinho.price)
        self.price = vinho.price;
    if(self.photo != vinho.photo)
        self.photo = vinho.photo;
    
    //TODO: actualizar na BD os atributos alterados
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
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 2, name = \'%@\', producer = '\%@\', year = %d, grapes = \'%@\', photo_filename = \'%@\', region_id = %d, price = %f, currency = \'%@\' WHERE wine_id = %d", self.name, self.producer, self.year, self.grapes, self.photo,self.region.region_id, self.price, self.currency, self.wine_id];
                        break;
                        
                    case 1:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 1, name = \'%@\', producer = \'%@\', year = %d, grapes = \'%@\', photo_filename = \'%@\', region_id = %d, price = %f, currency = \'%@\' WHERE wine_id = %d", self.name, self.producer, self.year, self.grapes, self.photo,self.region.region_id, self.price, self.currency, self.wine_id];
                        break;
                        
                    case 2:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 2, name = \'%@\', producer = \'%@\', year = %d, grapes = \'%@\', photo_filename = \'%@\', region_id = %d, price = %f, currency = \'%@\' WHERE wine_id = %d", self.name, self.producer, self.year, self.grapes, self.photo,self.region.region_id, self.price, self.currency, self.wine_id];
                        break;
                        
                    default:
                        break;
                }
                                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Could not update: %s", errMsg);
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
    
    
    return return_value;
    
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
    NSString* full_price = [[NSString alloc] initWithFormat:@"%.02f %@", self.price, self.currency];
    return full_price;
}

- (NSComparisonResult)compareUsingName:(Vinho*)vinho {
    
    return [self.name caseInsensitiveCompare:vinho.name];

}

- (NSComparisonResult)compareUsingScore:(Vinho*)vinho {
    int thisScore = [self score];
    int otherScore = [vinho score];
    
    if (thisScore > otherScore)
        return NSOrderedAscending;
    else if (thisScore < otherScore)
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
}

- (int) score {
    if ([self.provas count] == 0)
        return -1;
    int total = 0;
    
    for (Prova* prova in self.provas)
        total += [prova calcScore];
    
    int percentage = (float) total / (float) [self.provas count];
    
    return percentage;
    
}


@end
