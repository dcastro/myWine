//
//  ProvaCell.m
//  myWine
//
//  Created by Diogo Castro on 05/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ProvaCell.h"
#import <objc/runtime.h>

@implementation ProvaCell
@synthesize prova = _prova;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if([keyPath isEqualToString:@"selected"]) {
        if ([object isSelected])
            [Comparator register:self.prova];
        else {
            [Comparator unregister:self.prova];
        }
    }
    
}

@end
