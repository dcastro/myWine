//
//  CheckboxButton.h
//  myWine
//
//  Created by Diogo Castro on 03/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckboxButton : UIButton


+ (CheckboxButton*) createWithTarget:(id) target andPosition:(int) x;

- (void) setHidden:(BOOL)hidden animated:(BOOL) animated;

@end
