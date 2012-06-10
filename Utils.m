//
//  Utils.m
//  myWine
//
//  Created by Antonio Velasquez on 5/18/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "Utils.h"

@implementation Utils

CGFloat const KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;

double calculateAnimation(UIViewController *v, UITextField *keyboard) {
    
    CGRect textFieldRect =[v.view.window convertRect:keyboard.bounds fromView:keyboard];
    CGRect viewRect =[v.view.window convertRect:v.view.bounds fromView:v.view];
    
    CGFloat midline = 0.0;
    double animatedDistance = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        midline = viewRect.size.height - textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        if(midline < PORTRAIT_KEYBOARD_HEIGHT)
            animatedDistance = PORTRAIT_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);
    }
    else if(orientation == UIInterfaceOrientationPortraitUpsideDown){
        midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        if(midline < PORTRAIT_KEYBOARD_HEIGHT)
            animatedDistance = PORTRAIT_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight){
        midline = textFieldRect.origin.x + 0.5 * textFieldRect.size.width;
        if(midline < LANDSCAPE_KEYBOARD_HEIGHT) {
            animatedDistance = LANDSCAPE_KEYBOARD_HEIGHT-midline+(textFieldRect.size.width/2);
        }
    }   
    else if (orientation == UIInterfaceOrientationLandscapeLeft){
        midline = viewRect.size.height - textFieldRect.origin.x - 0.5 * textFieldRect.size.width;
        if(midline < LANDSCAPE_KEYBOARD_HEIGHT) {
            animatedDistance = LANDSCAPE_KEYBOARD_HEIGHT-midline+(textFieldRect.size.width/2);
        }
    }
    return animatedDistance;
}

double calculateAnimation2(UIViewController *v, UITextView *keyboard) {
    
    CGRect textFieldRect =[v.view.window convertRect:keyboard.bounds fromView:keyboard];
    CGRect viewRect =[v.view.window convertRect:v.view.bounds fromView:v.view];
    
    CGFloat midline = 0.0;
    double animatedDistance = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        midline = viewRect.size.height - textFieldRect.origin.y + 0.5 * textFieldRect.size.height-72;
        if(midline < PORTRAIT_KEYBOARD_HEIGHT)
            animatedDistance = PORTRAIT_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);  
    }
    else if(orientation == UIInterfaceOrientationPortraitUpsideDown){
        midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        if(midline < PORTRAIT_KEYBOARD_HEIGHT)
            animatedDistance = PORTRAIT_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight){
        midline = textFieldRect.origin.x + 0.5 * textFieldRect.size.height;
        if(midline < LANDSCAPE_KEYBOARD_HEIGHT) {
            animatedDistance = LANDSCAPE_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);
        }    
    }   
    else if (orientation == UIInterfaceOrientationLandscapeLeft){
        midline = viewRect.size.height - textFieldRect.origin.x + 0.5 * textFieldRect.size.height-72;
        if(midline < LANDSCAPE_KEYBOARD_HEIGHT) {
            animatedDistance = LANDSCAPE_KEYBOARD_HEIGHT-midline+(textFieldRect.size.height/2);
        }
    }
    return animatedDistance;
}


NSString* currencyStr(int currency) {
    switch(currency) {
        case EUR:
            return @"EUR";
        case USD:
            return @"USD";
        case GBP:
            return @"GBP";
        default:
            return Nil;
    }
        
}

int currencyInt(NSString* currency) {
    if([currency isEqualToString:@"USD"])
        return USD;
    if([currency isEqualToString:@"GBP"])
        return GBP;
    //default
    return EUR;
}

@end

