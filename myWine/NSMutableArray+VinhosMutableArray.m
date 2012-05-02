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

-(void) insertVinho:(Vinho*) vinho atIndex:(NSUInteger)index {
    
    User * user = [User instance];
    
    Query *query = [[Query alloc] init];
    
    #warning TODO: falta a foto
    #warning TODO: alterar para suportar autoincrement
    
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO Wine VALUES ((SELECT MAX (wine_id) FROM Wine)+1, %@, %d, %d, NULL, %@, %d, NULL, %@, %@, %f); SELECT MAX(wine_id) FROM Wine;", 
                          user.username, vinho.region.region_id, vinho.winetype.winetype_id, vinho.name, vinho.year,  vinho.producer, vinho.currency, vinho.price, 1];
    
    sqlite3_stmt * stmt = [query prepareForSingleQuery:querySQL];
    
    if(stmt != NULL){
        if(sqlite3_step(stmt) == SQLITE_ROW){
         
            vinho.wine_id = sqlite3_column_int(stmt, 0);
        }
        
        [query finalizeQuery:stmt];
        
        [self insertObject:vinho atIndex:index];

    }
    
#warning TODO: tratar em caso de erro

}


-(BOOL) removeVinhoAtIndex:(NSUInteger) index {
    
    Vinho * v = [self objectAtIndex:index];
    Query *query = [[Query alloc] init];
    
    BOOL return_value = TRUE;
    sqlite3_stmt *stmt;
    char * errMsg;

    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT state FROM wine WHERE wine_id = %d", v.wine_id];
    
    sqlite3* contactDB = [query prepareForExecution];
    
    if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
        int state;
        
        if(stmt != NULL){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                state = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                switch (state) {
                    case 0:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 3 WHERE wine_id = %d", v.wine_id];
                        if(sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not mark for deletion: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    case 1:
                        querySQL = [NSString stringWithFormat:@"DELETE FROM Wine WHERE wine_id = %d", v.wine_id];
                        if(sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not delete: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    case 2:
                        querySQL = [NSString stringWithFormat:@"UPDATE Wine SET state = 3 WHERE wine_id = %d", v.wine_id];
                        if(sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                            DebugLog(@"Could not mark for deletion: %s", errMsg);
                            sqlite3_free(errMsg);
                            return_value = FALSE;
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            sqlite3_close(contactDB);
        }
        
    }else{
        return_value = FALSE;
        sqlite3_close(contactDB);
    }
    
    if(return_value)
        [self removeObjectAtIndex:index];
    
    return return_value;
    
    
#warning TODO:tratamento de erros
    
}

@end
