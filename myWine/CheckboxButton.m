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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
