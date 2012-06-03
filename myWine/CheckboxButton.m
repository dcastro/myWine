//
//  CheckboxButton.m
//  myWine
//
//  Created by Diogo Castro on 03/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CheckboxButton.h"

@implementation CheckboxButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) setHighlighted:(BOOL)highlighted {
    
    //this button cannot be told to be highlighted by a superview, only by another control.
    NSString* backtrace = [NSString stringWithFormat: @"%@",[NSThread callStackSymbols]];
    if ([backtrace rangeOfString:@"_updateHighlightColorsForView"].location!=NSNotFound) {
        return;
    }
    
    [super setHighlighted:highlighted];
}

- (void) setHidden:(BOOL)hidden animated:(BOOL) animated {
    
    if(animated) {
        [UIView animateWithDuration:0.3 animations:^() {
            [self setHidden:hidden];
        }];
    } else {
        [self setHidden:hidden];
    }
}

- (void) setHidden:(BOOL)hidden {
    self.alpha = (hidden)? 0.0: 1.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (CheckboxButton*) createWithTarget:(id) target andPosition:(int)x {
    
    //initialize the checkbox button
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Checkbox" owner:nil options:nil];
    CheckboxButton* checkbox;
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[CheckboxButton class]])
        {
            checkbox = currentObject;
            break;
        }
    }
    
    //set tag
    checkbox.tag = 1;
    
    //set button's action
    [checkbox addTarget:target action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //adjust button's position
    CGRect frame = checkbox.frame;
    frame.origin.x = x;
    checkbox.frame = frame;
    
    return checkbox;
}

@end
