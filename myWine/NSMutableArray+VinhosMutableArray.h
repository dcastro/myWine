//
//  NSMutableArray+VinhosMutableArray.h
//  myWine
//
//  Created by Diogo Castro on 4/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vinho.h"

#define ORDER_BY_NAME 0
#define ORDER_BY_SCORE 1

@interface NSMutableArray (VinhosMutableArray)

-(BOOL) insertVinho:(Vinho*)vinho atIndex:(NSUInteger)index;
    
-(BOOL) removeVinhoAtIndex:(NSUInteger) index;

-(void) orderVinhosBy:(int) order;

- (NSMutableArray*) getYears;
- (NSMutableArray*) getCountries;
- (NSMutableArray*) getWineTypes;
- (NSMutableArray*) getProducers;

- (void) sectionizeOrderedBy:(int) order;
- (int) numberOfSections;
- (int) numberOfRowsInSection:(int)section;
- (id) vinhoForRow:(int) row atSection:(int) section;
- (NSString*) titleForHeaderInSection:(int) section;
@end
