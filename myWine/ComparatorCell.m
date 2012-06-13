//
//  ComparatorCell.m
//  myWine
//
//  Created by Diogo Castro on 6/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ComparatorCell.h"
#import "Criterio.h"
#import "UIColor+myWineColor.h"

@implementation ComparatorCell
@synthesize classificationSlider = _classificationSlider;
@synthesize criterionNameLabel = _criterionNameLabel;
@synthesize criterion = _criterion;
@synthesize cellType;

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
    
    //ajustar nome e comprimento da label
    [self.criterionNameLabel setText: self.criterion.name];
    [self.criterionNameLabel sizeToFit];
    
    //color
    self.backgroundColor = [UIColor myWineColorDarkGrey];
    
    
    //ajustar posicionamento da label
    CGRect frame = self.criterionNameLabel.frame;    
    switch (cellType) {
        case ComparatorCellTypeA:
            frame.origin.x = self.frame.size.width - 20 - frame.size.width;
            break;
        case ComparatorCellTypeB:
            frame.origin.x = 20;
            break;
    }
    self.criterionNameLabel.frame = frame;
    
    
    //ajustar sliders
    [self.classificationSlider setMinimumValue: self.criterion.minWeight];
    [self.classificationSlider setMaximumValue: self.criterion.maxWeight];
    
    if (cellType == ComparatorCellTypeB) {
        [self.classificationSlider setValue: self.criterion.classification_chosen.weight];
        [self.classificationSlider setMaximumTrackTintColor:[UIColor grayColor]];
        [self.classificationSlider setMinimumTrackTintColor:[UIColor myWineColorDark]];
    } else if (cellType == ComparatorCellTypeA) {
        [self.classificationSlider setValue: (self.criterion.maxWeight - self.criterion.classification_chosen.weight + self.criterion.minWeight)];
        [self.classificationSlider setMinimumTrackTintColor:[UIColor grayColor]];
        [self.classificationSlider setMaximumTrackTintColor:[UIColor myWineColorDark]];
    }
    
    //ajustar slide para a direita quando só há 1 classificaçao
    if ([self.criterion.classifications count] <= 1 && cellType == ComparatorCellTypeA) {
        [self.classificationSlider setMinimumValue: 0];
        [self.classificationSlider setMaximumValue: 1];
        [self.classificationSlider setValue:1];
    }
    
    //change slider's thumb image
    UIImage* image = [UIImage imageNamed:@"slider_thumb.png"];
    [self.classificationSlider setThumbImage:image forState:UIControlStateNormal];
    [self.classificationSlider setThumbImage:image forState:UIControlStateHighlighted];
    
    [self.classificationSlider setUserInteractionEnabled:NO];
    
}


@end
