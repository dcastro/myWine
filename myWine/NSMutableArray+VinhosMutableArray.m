//
//  NSMutableArray+VinhosMutableArray.m
//  myWine
//
//  Created by Diogo Castro on 4/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NSMutableArray+VinhosMutableArray.h"

@implementation NSMutableArray (VinhosMutableArray)

-(void) insertVinho:(Vinho*) vinho atIndex:(NSUInteger)index {
    
    #warning TODO: inserir novo vinho na BD
    
    [self insertObject:vinho atIndex:index];
    
}


@end
