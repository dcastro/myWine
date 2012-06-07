//
//  Filter.h
//  myWine
//
//  Created by Diogo Castro on 06/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterViewController.h"

@interface Filter : NSObject

@property (nonatomic) FilterType filterType;
@property (strong, nonatomic) id object;

-(Filter*) initWithFilterType:(FilterType)filterType andObject:(id) object;

@end
