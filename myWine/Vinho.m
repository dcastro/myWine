//
//  Vinho.m
//  myWine
//
//  Created by Diogo Castro on 18/04/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Vinho.h"

@implementation Vinho

@synthesize name = _name;
@synthesize wine_id, year, price, currency, producer, photo, region_name, winetype_name, country_name;
@synthesize provas=_provas;

- (NSString*) description {
    return self.name;
}

- (NSMutableArray*) provas {
    if (! _provas) {
        [self loadProvasFromDB];
    } 

    return _provas;
}

#warning TODO - a implementar acesso a base dados da lista de provas de um vinho
- (void) loadProvasFromDB {
}

@end
