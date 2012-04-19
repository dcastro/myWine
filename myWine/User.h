//
//  User.h
//  myWine
//
//  Created by Diogo Castro on 17/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSMutableArray* vinhos;
@property (nonatomic, assign) int synced_at;

@property (nonatomic) BOOL isValidated;
@property (nonatomic) int user_id;


- (void) sync;
- (NSMutableArray*) vinhos;

//singleton instance creators
+ (void) createWithUsername:(NSString*) username Password:(NSString*) password;
+ (void) createWithID: (int) user_id;

//singleton
+(id) instance;


-(NSString *)description;

@end
