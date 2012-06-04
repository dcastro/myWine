//
//  Comparator.h
//  myWine
//
//  Created by Diogo Castro on 04/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vinho.h"

@interface Comparator : NSObject

+ (BOOL) register:(Vinho*) vinho;

+ (void) unregister:(Vinho*) vinho;

+ (BOOL) isRegistered:(Vinho*) vinho;

+ (void) reset;

@end
