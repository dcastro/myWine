//
//  Sincronizacao.m
//  myWine
//
//  Created by Fernando Gracas on 5/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Sincronizacao.h"
#import "User.h"

@implementation Sincronizacao


- (id)init
{
    self = [super init];
    if (self) {
        query = [[Query alloc] init];
        user = [User instance];
    }
    return self;
}

-(NSString *)buildRequest:(NSError **) error
{
    
    NSMutableDictionary * requestData = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.username,@"username" ,user.password, @"password" , user.synced_at, @"synced_at" , nil];
    
    
    
#warning TODO: FERNANDO: completar
    
    
    //conversao para string
    NSData * data = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:error];
    
    if(error){
        return nil;
    }else {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}





-(BOOL)parseData:(NSMutableData *)receivedData
{
    
    contactDB = [query beginTransaction];
    
    NSError * jsonParsingError = nil;
    NSDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];
    
    if(jsonParsingError){
        DebugLog(@"JSON PARSING ERROR: %@", jsonParsingError);
        [query rollbackTransaction];
        return FALSE; 
    }
    
    DebugLog(@"JSON: %@", [NSString stringWithFormat:@"%@",  receivedJSON]);

    
    
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE User SET synced_at = %d WHERE username = \'%@\';", [receivedJSON objectForKey:@"timestamp"], user.username];
    
    char *errMsg;
    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
        DebugLog(@"%s", errMsg);
        sqlite3_free(errMsg);
        [query rollbackTransaction];
        return FALSE;
    }
    

    
    if([receivedJSON objectForKey:@"countries"]){
        if(![self parseCountries:[receivedJSON objectForKey:@"countries"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    
    
    if([receivedJSON objectForKey:@"wine_types"]){
        if(![self parseWineTypes:[receivedJSON objectForKey:@"wine_types"]]){
            [query rollbackTransaction];
            return FALSE; 
        }
    }
    

    
    [query endTransaction];
    
    return TRUE;
}





-(BOOL)parseWineTypes:(NSArray *) winetypes 
{
    
    sqlite3_stmt * stmt;
    NSString * querySQL = nil;
    BOOL exists = FALSE;
    
    for (int i = 0; i < [winetypes count]; i++) {
        NSDictionary * winetypesWithFormsJSON = [winetypes objectAtIndex:i];
        int winetype_id = [[winetypesWithFormsJSON objectForKey:@"id"] intValue];
        
#warning TODO:o winetype vai ter sempre um formulario?
        //verifica se o tipo de vinho existe
        querySQL = [NSString stringWithFormat:@"SELECT formtasting_id FROM UserTypeWine WHERE winetype_id = %d AND user = \'%@\'", winetype_id, user.username];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
            
            if(sqlite3_step(stmt) == SQLITE_ROW){
                
                exists = TRUE;
                int formtasting_id = sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                
                //se existir apaga os formularios associados e possible classifications
#warning TODO: ver cena das possible classifications...
                if(exists){
                    
                    querySQL = [NSString stringWithFormat:@"DELETE FROM FormTasting WHERE formtasting_id = %d;", formtasting_id]; 
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }else {//senao existir adiciona
                    
                    querySQL = [NSString stringWithFormat:@"INSERT INTO WineType VALUES (%d, \'%@\', \'%@\', \'%@\');", 
                                winetype_id,
                                [winetypesWithFormsJSON objectForKey:@"name_eng"],
                                [winetypesWithFormsJSON objectForKey:@"name_fr"],
                                [winetypesWithFormsJSON objectForKey:@"name_pt"]];
                    char *errMsg;
                    if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                        DebugLog(@"%s", errMsg);
                        sqlite3_free(errMsg);
                        return FALSE;
                    }
                    
                }
                
                
            }
        }else{
            DebugLog(@"Query with error: %s", query_stmt);
            return FALSE;
        }
        
        
        //adiciona os formularios
        
        
        
        
        
    }
    
    
    return FALSE;
}


-(BOOL)parseCountries:(NSArray *) countries 
{
    
    sqlite3_stmt *stmt;
    NSString * querySQL = nil;
    NSString * country_id = nil;

    
    for (int i = 0; i < [countries count]; i++) {
        
        NSDictionary * countryWithRegionsJSON = [countries objectAtIndex:i];
        
        country_id = [countryWithRegionsJSON objectForKey:@"code"];
        
        //verifies if the country exists in the database
        BOOL exists = FALSE;
        querySQL = [NSString stringWithFormat:@"SELECT country_id FROM Country WHERE country_id = \'%@\';", country_id];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(*contactDB, query_stmt, -1, &stmt, NULL) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    exists = TRUE;
                    sqlite3_finalize(stmt);
                }
            }else{
                DebugLog(@"Query with error: %s", query_stmt);
                return FALSE;
        }
        
        
        //if it doest exists, stores it
        if(!exists){
            querySQL = [NSString stringWithFormat:@"INSERT INTO Country VALUES (\'%@\', \'%@\', \'%@\', \'%@\');", 
                        [countryWithRegionsJSON objectForKey:@"code"],
                        [countryWithRegionsJSON objectForKey:@"name_eng"],
                        [countryWithRegionsJSON objectForKey:@"name_fr"],
                        [countryWithRegionsJSON objectForKey:@"name_pt"]];
            
            char *errMsg;
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }
        }
        
        
        NSArray * regionsJSON = [countryWithRegionsJSON objectForKey:@"region"];
        for (int k = 0; k < [regionsJSON count]; k++) {
            NSDictionary *regionJSON = [regionsJSON objectAtIndex:k];
#warning TODO: FERNANDO: ver default
            querySQL = [NSString stringWithFormat:@"INSERT INTO Region VALUES (\'%@\', \'%@\', 0, \'%@\');", 
                        [regionJSON objectForKey:@"code"],
                        country_id,
                        [regionJSON objectForKey:@"name"]];
            
            char *errMsg;
            if(sqlite3_exec(*contactDB, [querySQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK){
                DebugLog(@"%s", errMsg);
                sqlite3_free(errMsg);
                return FALSE;
            }

        }
        
        
    }
    
    
    return TRUE;
}

@end
