//
//  TipoVinho.h
//  myWine
//
//  Created by Fernando Gracas on 4/29/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipoVinho : NSObject

@property (nonatomic, assign) int winetype_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *name_fr;
@property (nonatomic, copy) NSString *name_pt;

- (NSString*) description;
@end
