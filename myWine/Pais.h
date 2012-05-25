//
//  Pais.h
//  myWine
//
//  Created by Diogo Castro on 04/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pais : NSObject

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* regions;

@end
