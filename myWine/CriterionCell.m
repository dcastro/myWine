//
//  CriterionCell.m
//  myWine
//
//  Created by Diogo Castro on 26/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CriterionCell.h"

@implementation CriterionCell
@synthesize classificationLabel;
@synthesize nameLabel;
@synthesize classificationSlider;
@synthesize criterion = _criterion;

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

- (void) setCriterion:(Criterio *)criterion {
    if (_criterion != criterion) {
        _criterion = criterion;
        [self configureView];
    }
}

- (void) configureView {
    [self.nameLabel setText:self.criterion.name];
    [self.classificationLabel setText:self.criterion.classification_chosen.name];
    [self.classificationSlider setMinimumValue: [self.criterion minWeight]]; 
    [self.classificationSlider setMaximumValue: [self.criterion maxWeight]]; 
    [self.classificationSlider setValue:self.criterion.classification_chosen.weight];
    NSLog(@" MIN %i MAX %i CHOSEN %i", self.criterion.minWeight, self.criterion.maxWeight, self.criterion.classification_chosen.weight);
    
    [self.classificationSlider setUserInteractionEnabled:FALSE];
}

@end
