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

@implementation Prova

@synthesize tasting_date = _tasting_date;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize comment = _comment; 
@synthesize tasting_id = _tasting_id;
@synthesize sections = _sections;
@synthesize classification_choosen = _classification_choosen;
@synthesize classifications = _classifications;


- (NSMutableArray *) sections {
    if (!_sections) {
        [self loadSectionsFromDB];
    }
    return _sections;
}


-(NSMutableArray *) classifications{
    if (!_classifications) {
        [self loadClassificationsFromBD];
    }
    return _classifications;
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

-(BOOL)loadClassificationsFromBD{
    _classifications = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_fr\
                        FROM Classification c, PossibleClassification ps\
                        WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Tasting' AND ps.classification = c.classification;", _tasting_id];
            break;
            
        case EN: querySQL =  [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_en\
                              FROM Classification c, PossibleClassification ps\
                              WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Tasting' AND ps.classification = c.classification;", _tasting_id];
            break;
            
        case PT:querySQL =  [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_pt\
                             FROM Classification c, PossibleClassification ps\
                             WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Tasting' AND ps.classification = c.classification;", _tasting_id];        
            break;
            
        default:
            break;
    }
    
    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 0);
            c.weight = sqlite3_column_int(stmt, 1);
            c.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            
            [_classifications insertObject:c atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;
}


@end
