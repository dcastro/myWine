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

   
        

}


@end
