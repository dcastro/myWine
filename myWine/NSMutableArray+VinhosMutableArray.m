//
//  NSMutableArray+VinhosMutableArray.m
//  myWine
//
//  Created by Diogo Castro on 4/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NSMutableArray+VinhosMutableArray.h"
#import "Query.h"
#import "User.h"

@implementation NSMutableArray (VinhosMutableArray)

-(BOOL) insertVinho:(Vinho*) vinho orderedBy:(int) order {
    
    User * user = [User instance];
    
    Query *query = [[Query alloc] init];
    char * errMsg;
    
    #warning TODO: FERNANDO: falta a foto e corrigir a query
    
    
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO Wine (user, region_id,  winetype_id, name, year, grapes, photo_filename, producer, currency, price, state)\
                          VALUES (\'%@\', %d, %d, \'%@\', %d, \'%@\' , \'%@\', \'%@\', \'%@\', %f, %d);", 
                          user.username, 
                          vinho.region.region_id,
                          vinho.winetype.winetype_id, 
                          vinho.name, 
                          vinho.year,
                          vinho.grapes,
                          vinho.photo,
                          vinho.producer, 
                          vinho.currency, 
                          vinho.price, 
                          1];
    
    //DebugLog(querySQL);
    
    sqlite3 ** contactDB = [query prepareForExecution];
    
    //insere prova obtem id
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"Query with error: %s", errMsg);
        sqlite3_free(errMsg);
        sqlite3_close(*contactDB);
                
        return FALSE;
    }else {        
        vinho.wine_id = sqlite3_last_insert_rowid(*contactDB);
        sqlite3_close(*contactDB);
        [self insertInArrayVinho:vinho orderedBy:order];
        return TRUE;
    }
    


    
}

-(void) insertInArrayVinho:(Vinho*) vinho orderedBy:(int) order {
    //NSString* sectionIdentifier = [self sectionIdentifierForVinho:vinho orderedBy:order];
    
    NSString* sectionIdentifier = [self sectionIdentifierForVinho:vinho orderedBy:order];
    
    BOOL hasIdentifier = [self hasSection:sectionIdentifier];
    

    [self insertObject:vinho atIndex:0];
    [self orderVinhosBy:order];
    [self sectionizeOrderedBy:order];
    
    if (!hasIdentifier)
        vinho.sectionIsNew = true;
    
    
}


-(BOOL) removeVinhoAtRow:(int)row inSection:(int)section {
    
    Vinho * v;// = [self objectAtIndex:index];
    int index = 0;
    for(index = 0; index < [self count] ; index++) {
        Vinho* x = [self objectAtIndex:index];
        if(x.row == row && x.section == section)
            break;
        
    }
    
    //NSLog(@"index: %i", index);
    
    Query *query = [[Query alloc] init];
    
    BOOL return_value = TRUE;
    sqlite3_stmt *stmt;
    char * errMsg;

    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT state FROM wine WHERE wine_id = %d", v.wine_id];
    
    sqlite3** contactDB = [query prepareForExecution];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
        int state;
        
        if(stmt != NULL){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                state = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                switch (state) {
                    case 0:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 3 WHERE wine_id = %d", v.wine_id];
                        break;
                        
                    case 1:
                        querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE wine_id = %d", v.wine_id];
                        break;
                        
                    case 2:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 3 WHERE wine_id = %d", v.wine_id];
                        break;
                        
                    default:
                        break;
                }
                
                if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                    DebugLog(@"Could not mark for deletion: %s", errMsg);
                    sqlite3_free(errMsg);
                    return_value = FALSE;
                }
            }
            sqlite3_close(*contactDB);
        }
        
    }else{
        return_value = FALSE;
        sqlite3_close(*contactDB);
    }
    
    if(return_value)
        [self removeObjectAtIndex:index];
    
    return return_value;
    
}

- (void) orderVinhosBy:(int) order {
    switch (order) {
        case ORDER_BY_NAME:
            [self sortUsingSelector:@selector(compareUsingName:)];
            break;
            
        case ORDER_BY_SCORE:
            [self sortUsingSelector:@selector(compareUsingScore:)];
    }
}

- (NSMutableArray*) getYears {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(Vinho* vinho in self) {
        NSString* year = [[NSString alloc] initWithFormat:@"%i", vinho.year];
        if( ! [array containsObject: year]) {
            [array addObject:year];
        }
    }
    
    return array;

}

- (NSMutableArray*) getCountries {

    NSMutableArray* array = [[NSMutableArray alloc] init];

    for(Vinho* vinho in self) {
        if( ! [array containsObject: vinho.region.country_name]) {
            [array addObject:vinho.region.country_name];
        }
    }
    
    return array;
}

- (NSMutableArray*) getWineTypes {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(Vinho* vinho in self) {
        if( ! [array containsObject: vinho.winetype.name]) {
            [array addObject:vinho.winetype.name];
        }
    }
    
    return array;
}

- (NSMutableArray*) getProducers {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(Vinho* vinho in self) {
        if( ! [array containsObject: vinho.producer]) {
            [array addObject:vinho.producer];
        }
    }
    
    return array;
}

- (NSString*) sectionIdentifierForVinho:(Vinho*) vinho orderedBy:(int) order {
    NSString* sectionIdentifier;
    if(order == ORDER_BY_NAME) {
        sectionIdentifier = [[NSString stringWithFormat:@"%c", [vinho.name characterAtIndex:0]] uppercaseString];
    }
    if(order == ORDER_BY_SCORE) {
        int score = vinho.score;
        int truncated = score/10;
        truncated *= 10;
        
        if(truncated != 90 && truncated != 100)
            sectionIdentifier = [NSString stringWithFormat:@"%i .. %i %%", truncated, truncated +9];
        else
            sectionIdentifier = [NSString stringWithFormat:@"90 .. 100 %%", truncated, truncated +9];
    }
    
    return sectionIdentifier;
}

- (BOOL) hasSection:(NSString*)sectionIdentifier {
    NSSet* identifiersSet = [NSSet setWithArray:[self valueForKey:@"sectionIdentifier"]];
    return [identifiersSet containsObject:sectionIdentifier];
}

- (void) sectionizeOrderedBy:(int) order {
    
    if ([self count] == 0)
        return;
    
    /*
    id x = [self objectAtIndex:0];
    id y = [self objectAtIndex:1];
    [self insertObject:y atIndex:1];
    [self insertObject:x atIndex:0];
    [self insertObject:x atIndex:0];
    */
    
    //mark vinhos with their section identifiers
    for(Vinho* vinho in self ) {
        vinho.sectionIdentifier = [self sectionIdentifierForVinho:vinho orderedBy:order];
    }
    
    //get set of unique identifiers
    NSSet* identifiersSet = [NSSet setWithArray:[self valueForKey:@"sectionIdentifier"]];
    NSArray* identifiersArray = [identifiersSet allObjects];
    identifiersArray = [identifiersArray sortedArrayUsingSelector:@selector(compare:)];
    
    if(order == ORDER_BY_SCORE)
        identifiersArray = [[identifiersArray reverseObjectEnumerator] allObjects];
    
    
    //mark vinhos with their responding sections
    
    for(int i = 0; i < [identifiersArray count]; i++) {
        NSString* identifier = [identifiersArray objectAtIndex:i];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"sectionIdentifier == %@", identifier];
        NSArray* array = [self filteredArrayUsingPredicate:predicate];
        
        for(int j = 0; j < [array count]; j++) {
            Vinho* vinho = [array objectAtIndex:j];
            vinho.section = i;
            vinho.row = j;
        }
        
    }
    
    
    for(Vinho* vinho in self) {
        //NSLog(@"%@ %i %i", vinho.sectionIdentifier, vinho.section, vinho.row);
    }
    
}

- (int) numberOfSections {
    NSSet* identifiersSet = [NSSet setWithArray:[self valueForKey:@"sectionIdentifier"]];
    return [identifiersSet count];
}

- (int) numberOfRowsInSection:(int)section {
    
    NSArray* array = [self getSection:section];    
    return [array count];
}

- (NSArray*) getSection:(int) section {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"section == %i", section];
    return [self filteredArrayUsingPredicate:predicate];
}

- (id) vinhoForRow:(int) row atSection:(int) section {
    NSArray* array = [self getSection:section];
    return [array objectAtIndex:row];
}

- (NSString*) titleForHeaderInSection:(int) section {
    NSArray* array = [self getSection:section];
    Vinho* vinho = (Vinho*) [array objectAtIndex:0];
    return vinho.sectionIdentifier;
}

@end
