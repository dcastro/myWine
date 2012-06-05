//
//  Comparator.m
//  myWine
//
//  Created by Diogo Castro on 04/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Comparator.h"


static Comparator* comparator = nil;

@implementation Comparator

@synthesize prova1, prova2;
@synthesize comparing;

+ (Comparator*) instance {
    @synchronized(self) {
        if (comparator == nil)
            comparator = [[self alloc] init];
    }
    return comparator;
    
}

- (id)init {
    if (self = [super init]) {
        self.prova1 = nil;
        self.prova2 = nil;
        self.comparing = false;
    }
    return self;
}

+ (BOOL) isComparing {
    return comparator.isComparing;
}

+ (void) setComparing:(BOOL) comparing {
    [comparator setComparing:comparing];
}

+ (BOOL) register:(Prova*) prova {
    if (comparator.prova1 == nil) {
        comparator.prova1 = prova;
    }
    else if (comparator.prova2 == nil) {
        comparator.prova2 = prova;
    }
    else
        return false;
    
    return true;
    
}

+ (void) unregister:(Prova*) prova {
    if (comparator.prova1 == prova)
        comparator.prova1 = nil;
    else if (comparator.prova2 == prova)
        comparator.prova2 = nil;
}

+ (BOOL) isRegistered:(Prova*) prova {
    if (comparator.prova1 == prova || comparator.prova2 == prova)
        return true;
    return false;
}

+ (void) reset {
    comparator.prova1 = nil;
    comparator.prova2 = nil;
}

+ (int) numberOfRegistrations {
    int i = 0;
    if (comparator.prova1 != nil)
        i++;
    if (comparator.prova2 != nil) 
        i++;
    return i;
}

@end
