//
//  NSMutableArray+ProvasMutableArray.h
//  myWine
//
//  Created by Nuno Sousa on 5/16/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prova.h"

@interface NSMutableArray (ProvasMutableArray)

-(void) insertProva:(Prova*)prova atIndex:(NSUInteger)index;

-(BOOL) removeProvaAtIndex:(NSUInteger) index;

@end
