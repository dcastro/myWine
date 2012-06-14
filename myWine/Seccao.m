//
//  Seccao.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Seccao.h"
#import "Criterio.h"
#import "Language.h"
#import "Query.h"

@implementation Seccao

@synthesize name = _name;
@synthesize name_en = _name_en;
@synthesize name_fr = _name_fr;
@synthesize name_pt = _name_pt;
@synthesize section_id = _section_id;
@synthesize criteria = _criteria;
@synthesize order = _order;
@synthesize label;


-(NSMutableArray *)  criteria{
    if(!_criteria){
        [self loadCriteriaFromDB];
    }
    return _criteria;
}


-(NSString *)name
{
        
    Language * lan = [Language instance];
    
    switch (lan.selectedLanguage) {
        case EN:
            _name = _name_en;
            break;
            
        case FR:
            _name = _name_fr;
            break;
            
        case PT:
            _name = _name_pt;
            break;
            
        default:
            break;
    }
    
    return _name;
}


- (BOOL) loadCriteriaFromDB {
    _criteria = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    

    querySQL = [NSString stringWithFormat:@"SELECT cr.criterion_id, cr.order_priority, cr.name_en, cr.name_fr, cr.name_pt, \
                c.classification_id, c.weight, c.name_en, c.name_fr, c.name_pt\
                FROM Criterion cr, Classification c\
                WHERE cr.section_id = %d AND cr.classification_id = c.classification_id \
                ORDER BY cr.order_priority ASC;", self.section_id];

    sqlite3_stmt *stmt = [query prepareForSingleQuery:querySQL];
    
    if(stmt != nil){
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            Criterio *cr = [[Criterio alloc]init];
            
            cr.criterion_id = sqlite3_column_int(stmt, 0);
            cr.order = sqlite3_column_int(stmt, 1);
            cr.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            cr.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            cr.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];

            
            Classificacao * c = [[Classificacao alloc]init];
            c.classification_id = sqlite3_column_int(stmt, 5);
            c.weight = sqlite3_column_int(stmt, 6);
            c.name_en = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            c.name_fr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
            c.name_pt = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];

            
            cr.classification_chosen = c;
            
            [_criteria insertObject:cr atIndex:0];
        }
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;

}

- (NSString*) description {
    return self.name;
}

- (NSComparisonResult)compare:(Seccao *)otherSection {
    if (self.order < otherSection.order)
        return NSOrderedAscending;
    else if (self.order > otherSection.order)
        return NSOrderedDescending;
    else 
        return NSOrderedSame;
}

@end
