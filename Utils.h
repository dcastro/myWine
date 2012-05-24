//
//  Utils.h
//  myWine
//
//  Created by Antonio Velasquez on 5/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>

//currency definitions
#define EUR 1
#define USD 2
#define GBP 3


@interface Utils : NSObject

extern CGFloat const KEYBOARD_ANIMATION_DURATION;

double calculateAnimation(UIViewController *v, UITextField *keyboard);

NSString* currencyStr(int currency);
int currencyInt(NSString* currency);

@end
