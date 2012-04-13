//
//  Language.h
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FR 1
#define PT 2
#define EN 3

@interface Language : NSObject

@property (assign,readwrite) int selectedLanguage;

+ (id)instance;
-(NSString*) translate:(NSString*) key;

@end
