//
//  CriterionCell.m
//  myWine
//
//  Created by Diogo Castro on 5/10/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CriterionCell.h"
#import "CriterionView.h"

@implementation CriterionCell

@synthesize criterionView = _criterionView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect cvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width,
                                     self.contentView.bounds.size.height);
        self.criterionView = [[CriterionView alloc] initWithFrame:cvFrame];
        self.criterionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.criterionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
