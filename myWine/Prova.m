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


- (NSMutableArray *) sections {
    if (!_sections) {
        [self loadSectionsFromDB];
    }
    return _sections;
}

-(NSMutableArray *) characteristic_sections{
    if (!_characteristic_sections) {
        [self loadCharacteristicSectionsFromDB];
    }
    return _characteristic_sections;
}


-(BOOL) loadSectionsFromDB{
    _sections = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT s.section_id, s.name_fr\
                        FROM Section s\
                        WHERE s.tasting_id = %d;", _tasting_id];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT s.section_id, s.name_en\
                              FROM Section s\
                              WHERE s.tasting_id = %d;", _tasting_id];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT s.section_id, s.name_pt\
                             FROM Section s\
                             WHERE s.tasting_id = %d;", _tasting_id];           
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Seccao * s = [[Seccao alloc]init];
            s.section_id = sqlite3_column_int(stmt, 0);
            s.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
            [_sections insertObject:s atIndex:0];
        
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
    
}


- (BOOL)loadCharacteristicSectionsFromDB{
    _characteristic_sections = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT sc.section_id, sc.name_fr\
                        FROM SectionCharacteristic sc\
                        WHERE sc.tasting_id = %d \
                        ORDER BY order_priority ASC;", _tasting_id];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT sc.section_id, sc.name_en\
                              FROM SectionCharacteristic sc\
                              WHERE sc.tasting_id = %d \
                              ORDER BY order_priority ASC;", _tasting_id];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT sc.section_id, sc.name_pt\
                             FROM SectionCharacteristic sc\
                             WHERE sc.tasting_id = %d \
                             ORDER BY order_priority ASC;", _tasting_id];          
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            SeccaoCaracteristica * sc = [[SeccaoCaracteristica alloc]init];
            sc.sectioncharacteristic_id = sqlite3_column_int(stmt, 0);
            sc.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            
            [_characteristic_sections insertObject:sc atIndex:0];
            
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
}

- (NSString*) fullDate {
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:self.tasting_date];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* locale = [[Language instance] locale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy     hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

@end
