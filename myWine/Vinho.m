//
//  Vinho.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Vinho.h"

@implementation Vinho

-(id) init:(NSString *)thenome {
    
    if(self = [super init]) {
        nome = thenome;
    }
    return self;
}

-(NSString *) str {
    return nome;
}

@end
