//
//  Comparator.h
//  myWine
//
//  Created by Diogo Castro on 04/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prova.h"

@interface Comparator : NSObject

@property (strong, nonatomic) Prova* prova1;
@property (strong, nonatomic) Prova* prova2;
@property (nonatomic, getter = isComparing) BOOL comparing;

+ (Comparator*) instance;

+ (BOOL) isComparing;
+ (void) setComparing:(BOOL) comparing;

+ (BOOL) register:(Prova*) prova;

+ (void) unregister:(Prova*) prova;

+ (BOOL) isRegistered:(Prova*) prova;

+ (void) reset;

@end
