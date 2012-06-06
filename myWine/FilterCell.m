//
//  FilterCell.m
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

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

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.textLabel.frame;
    frame.size.width += 50;
    self.textLabel.frame = frame;// CGRectMake(0, 0, 320, 20);
    
    frame = self.detailTextLabel.frame;
    frame.origin.x += 50;
    self.detailTextLabel.frame = frame;
}

@end
