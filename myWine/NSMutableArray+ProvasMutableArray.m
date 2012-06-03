//
//  NSMutableArray+ProvasMutableArray.m
//  myWine
//
//  Created by Nuno Sousa on 5/16/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NSMutableArray+ProvasMutableArray.h"
#import "Query.h"

@implementation NSMutableArray (ProvasMutableArray)

- (BOOL) insertProva:(Prova*)prova atIndex:(NSUInteger)index withVinhoID:(int) wine_id {
    #warning TODO: completar este metodo
    
    return FALSE;
}

-(BOOL) removeProvaAtIndex:(NSUInteger) index {
    Prova * p = [self objectAtIndex:index];
    Query *query = [[Query alloc] init];
    
    BOOL return_value = TRUE;
    sqlite3_stmt *stmt;
    char * errMsg;
    
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT state FROM Tasting WHERE tasting_id = %d", p.tasting_id];
    
    sqlite3** contactDB = [query prepareForExecution];
    
    if (sqlite3_prepare_v2(*contactDB, [querySQL UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        
        int state;
        
        if(stmt != NULL){
            if(sqlite3_step(stmt) == SQLITE_ROW){
                state = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                switch (state) {
                    case 0:
                        querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET state = 3 WHERE wine_id = %d", p.tasting_id];
                        break;
                        
                    case 1:
                        querySQL = [NSString stringWithFormat:@"DELETE FROM Tasting WHERE tasting_id = %d", p.tasting_id];
                        break;
                        
                    case 2:
                        querySQL = [NSString stringWithFormat:@"UPDATE Tasting SET state = 3 WHERE tasting_id = %d", p.tasting_id];
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
        DebugLog(@"Query with error: %@", querySQL);
        return_value = FALSE;
        sqlite3_close(*contactDB);
    }
    
    if(return_value)
        [self removeObjectAtIndex:index];
    
    return return_value;

}

@end
