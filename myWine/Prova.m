//
//  Prova.m
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Prova.h"
#import "Query.h"
#import "Language.h"
#import "Seccao.h"
#import "SeccaoCaracteristica.h"

@implementation Prova

@synthesize tasting_date = _tasting_date;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize comment = _comment; 
@synthesize tasting_id = _tasting_id;
@synthesize sections = _sections;
@synthesize characteristic_sections = _characteristic_sections;
@synthesize vinho = _vinho;

- (NSMutableArray *) sections 
{
    if (!_sections) {
        [self loadSectionsFromDB];
    }
    return _sections;
}


-(NSMutableArray *) characteristic_sections
{
    if (!_characteristic_sections) {
        [self loadCharacteristicSectionsFromDB];
    }
    return _characteristic_sections;
}


-(BOOL) loadSectionsFromDB
{
    _sections = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT s.section_id, s.order_priority ,s.name_en, s.name_fr, s.name_pt\
                FROM Section s\
                WHERE s.tasting_id = %d \
                ORDER BY s.order_priority ASC;", _tasting_id];
     
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Seccao * s = [[Seccao alloc]init];
            s.section_id = sqlite3_column_int(stmt, 0);
            s.order = sqlite3_column_int(stmt, 1);
            s.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            s.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            s.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];

            
            [_sections insertObject:s atIndex:0];
        
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
    
}



- (BOOL)loadCharacteristicSectionsFromDB
{
    _characteristic_sections = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT sc.sectioncharacteristic_id, sc.order_priority, sc.name_en, sc.name_fr, sc.name_pt\
                FROM SectionCharacteristic sc\
                WHERE sc.tasting_id = %d \
                ORDER BY sc.order_priority ASC;", _tasting_id];
 
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            SeccaoCaracteristica * sc = [[SeccaoCaracteristica alloc]init];
            sc.sectioncharacteristic_id = sqlite3_column_int(stmt, 0);
            sc.order = sqlite3_column_int(stmt, 1);
            sc.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            sc.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            sc.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];

            
            [_characteristic_sections insertObject:sc atIndex:0];
            
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
}


-(BOOL)save
{
    Query *query = [[Query alloc]init];
    NSString * querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET comment = \'%@\' WHERE tasting_id= %d", 
                           self.comment,
                           self.tasting_id];
    
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


- (NSString*) fullDate
{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:self.tasting_date];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* locale = [[Language instance] locale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy     hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}



- (NSString*) shortDate 
{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:self.tasting_date];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* locale = [[Language instance] locale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd/MM/YYYY hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

- (int) calcScore {
    
    int score = 0, max = 0;
    
    for( Seccao* section in self.sections) {
        for( Criterio* criterion in section.criteria ) {
            score += criterion.classification_chosen.weight;
            max += criterion.maxWeight;
        }
    }
    
    if (max == 0)
        return 0;
    int percentage = ((float)score/ (float) max) * 100.0;

    return percentage;
}


- (NSComparisonResult)compare:(Prova *)otherProva {
    if (self.tasting_date > otherProva.tasting_date)
        return NSOrderedAscending;
    else if (self.tasting_date < otherProva.tasting_date)
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
}


@end
