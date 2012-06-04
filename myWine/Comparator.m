//
//  Comparator.m
//  myWine
//
//  Created by Diogo Castro on 04/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Comparator.h"

static Vinho* vinho1 = nil;
static Vinho* vinho2 = nil;

@implementation Comparator

+ (BOOL) register:(Vinho*) vinho {
    if (vinho1 == nil) {
        vinho1 = vinho;
    }
    else if (vinho2 == nil) {
        vinho2 = vinho;
    }
    else
        return false;
    
    return true;
    
}

+ (void) unregister:(Vinho*) vinho {
    if (vinho1 == vinho)
        vinho1 = nil;
    else if (vinho2 == vinho)
        vinho2 = nil;
}

+ (BOOL) isRegistered:(Vinho*) vinho {
    if (vinho1 == vinho || vinho2 == vinho)
        return true;
    return false;
}

+ (void) reset {
    vinho1 = nil;
    vinho2 = nil;
}

@end
