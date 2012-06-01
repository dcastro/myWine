//
//  CharacteristicCell.m
//  myWine
//
//  Created by Diogo Castro on 5/31/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CharacteristicCell.h"

@implementation CharacteristicCell
@synthesize nameLabel;
@synthesize classificationSlider;
@synthesize classificationLabel;

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

@end
