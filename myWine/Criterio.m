//
//  Criterio.m
//  myWine
//
//  Created by Fernando Gracas on 4/28/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Criterio.h"
#import "Classificacao.h"
#import "Query.h"
#import "Language.h"

@implementation Criterio

@synthesize name = _name;
@synthesize criterion_id=_criterion_id;
@synthesize classification_chosen = _classification_chosen;
@synthesize classifications = _classifications;

- (NSMutableArray *)classifications {
    if(!_classifications){
        [self loadClassificationsFromDB];
    }
    return _classifications;
}


-(BOOL) loadClassificationsFromDB{
    _classifications = [[NSMutableArray alloc] init];
    
    
    Query *query = [[Query alloc] init];
    
    NSString *querySQL;
    
    Language *lan = [Language instance];
    switch (lan.selectedLanguage) {
        case FR:
            querySQL = [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_fr\
                        FROM Classification c, PossibleClassification ps\
                        WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Criterion' AND ps.classification_id = c.classification_id;", _criterion_id];
            break;
            
        case EN: 
            querySQL =  [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_en\
                         FROM Classification c, PossibleClassification ps\
                         WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Criterion' AND ps.classification_id = c.classification_id;", _criterion_id];
            break;
            
        case PT:
            querySQL =  [NSString stringWithFormat:@"SELECT c.classification_id, c.weight ,c.name_pt\
                         FROM Classification c, PossibleClassification ps\
                         WHERE ps.classifiable_id = %d AND ps.classifiable_type = 'Criterion' AND ps.classification_id = c.classification_id;", _criterion_id];        
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
        
        [_classifications sortUsingSelector:@selector(compare:)];
        
        [query finalizeQuery:stmt];
        return TRUE;
    }
    else
        return FALSE;

}

- (NSString*) description {
    return self.name;
}

- (int) minWeight {
    if (!self.classifications.count) {
        //NSLog(@"EMPTY CLASSIFC");
        return 0;
    }
    return [[self.classifications objectAtIndex:0] weight];
    
    /*
    int minVal = -1;
    for (int i = 0; i < self.classifications.count; i++) {
        Classificacao* classification = [self.classifications objectAtIndex:i];
        if (classification.weight < minVal || minVal == -1)
            minVal = classification.weight;
        
    }*/
}


- (int) maxWeight {
    if (!self.classifications.count) {
        //NSLog(@"EMPTY CLASSIFC");
        return 0;
    }
    return [[self.classifications objectAtIndex:(self.classifications.count - 1)] weight];
    
}


@end
