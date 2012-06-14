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
#define ORDER_BY_NAME_DESC 1
#define ORDER_BY_SCORE_ASC 2
#define ORDER_BY_SCORE 3

@interface NSMutableArray (VinhosMutableArray)

-(BOOL) insertVinho:(Vinho*)vinho orderedBy:(int) order;
    
-(BOOL) removeVinhoAtRow:(int) row inSection:(int) section;

-(void) orderVinhosBy:(int) order;

- (NSMutableArray*) getYears;
- (NSMutableArray*) getCountries;
- (NSMutableArray*) getWineTypes;
- (NSMutableArray*) getProducers;

- (NSString*) sectionIdentifierForVinho:(Vinho*) vinho orderedBy:(int) order;
- (BOOL) hasSection:(NSString*)sectionIdentifier;

- (void) sectionizeOrderedBy:(int) order;
- (int) numberOfSections;
- (int) numberOfRowsInSection:(int)section;
- (id) vinhoForRow:(int) row atSection:(int) section;
- (NSString*) titleForHeaderInSection:(int) section;
@end
