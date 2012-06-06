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

-(BOOL) insertVinho:(Vinho*) vinho atIndex:(NSUInteger)index {
    
    User * user = [User instance];
    
    Query *query = [[Query alloc] init];
    char * errMsg;
    
    #warning TODO: FERNANDO: falta a foto
    
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO Wine (username, region_id,  winetype_id, name, year, producer, currency, price, state)\
                          VALUES (\'%@\', %d, %d, \'%@\', %d, \'%@\', \'%@\', %f, %d);", 
                          user.username, 
                          vinho.region.region_id,
                          vinho.winetype.winetype_id, 
                          vinho.name, 
                          vinho.year,  
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
        [self insertObject:vinho atIndex:index];
        return TRUE;
    }

    
}


-(BOOL) removeVinhoAtIndex:(NSUInteger) index {
    
    Vinho * v = [self objectAtIndex:index];
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
    
}

- (NSMutableArray*) getRegions {
    
}

@end
