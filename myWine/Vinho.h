//
//  Vinho.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vinho : NSObject {
    NSString *nome;
}

-(id) init:(NSString *) nome;

-(NSString *) str;

@end
