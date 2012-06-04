//
//  UIColor+myWineColor.m
//  myWine
//
//  Created by Diogo Castro on 5/30/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "UIColor+myWineColor.h"

@implementation UIColor (myWineColor)

+ (UIColor*) myWineColor {
    return [UIColor colorWithRed:99/255.0 green:5/255.0 blue:2/255.0 alpha:1.0];
}

+ (UIColor*) myWineColorDark {
    int darkeningFactor = 3;
    return [UIColor colorWithRed:99/255.0/ darkeningFactor
                           green:5/255.0/ darkeningFactor
                            blue:2/255.0/ darkeningFactor
                           alpha:1.0];
}

@end
