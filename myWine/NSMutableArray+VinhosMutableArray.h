//
//  NSMutableArray+VinhosMutableArray.h
//  myWine
//
//  Created by Diogo Castro on 4/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vinho.h"

@interface NSMutableArray (VinhosMutableArray)

-(BOOL) insertVinho:(Vinho*)vinho atIndex:(NSUInteger)index;
    
-(BOOL) removeVinhoAtIndex:(NSUInteger) index;

@end
