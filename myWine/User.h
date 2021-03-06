//
//  User.h
//  myWine
//
//  Created by Diogo Castro on 17/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Regiao;

@interface User : NSObject

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, strong) NSMutableArray* vinhos;
@property (nonatomic, strong) NSMutableArray* tipoVinhos;
@property (nonatomic, assign) double synced_at;

@property (nonatomic) BOOL isValidated;

@property (nonatomic) NSMutableArray* countries;


- (NSMutableArray*) vinhos;

//singleton instance creators
+ (void) createWithUsername:(NSString*) username Password:(NSString*) password;
+ (void) createWithUsername:(NSString*) username;

//singleton
+(id) instance;


-(NSString *)description;
-(BOOL)validateUser;
-(Regiao*) regionWithName:(NSString*) region_name;

- (void) resetState;

@end
