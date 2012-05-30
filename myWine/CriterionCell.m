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
@synthesize classification = _classification, classification_index = _classification_index;

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
    [self drawClassificationLabel:self.criterion.classification_chosen animated:NO];
    [self.classificationSlider setMinimumValue: [self.criterion minWeight]]; 
    [self.classificationSlider setMaximumValue: [self.criterion maxWeight]]; 
    [self.classificationSlider setValue:self.criterion.classification_chosen.weight];
    NSLog(@" MIN %i MAX %i CHOSEN %i", self.criterion.minWeight, self.criterion.maxWeight, self.criterion.classification_chosen.weight);
    self.classification = self.criterion.classification_chosen;
    
    //find currently selected classification's index
    int i;
    for(i = 0; i < self.criterion.classifications.count && ((Classificacao*)[self.criterion.classifications objectAtIndex:i]).weight != self.classification.weight; i++);
    self.classification_index = i;
    
    [self.classificationSlider setUserInteractionEnabled:FALSE];
}

- (void) drawClassificationLabel:(Classificacao*) classification animated:(BOOL) animated {
    NSString* string = [[NSString alloc] initWithFormat:@"%i  %@", classification.weight, classification.name];
    
    if(animated)
        [UIView animateWithDuration:0.3 animations:^() {
            self.classificationLabel.alpha = 0.0;
        }];
     
    [self.classificationLabel setText:string];
    
    if(animated)
        [UIView animateWithDuration:0.3 animations:^() {
            self.classificationLabel.alpha = 1.0;
        }];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
    if (editing) {
        [self.classificationSlider setUserInteractionEnabled:YES];
    } else {
        [self.classificationSlider setUserInteractionEnabled:NO];
    }
    
    //[super setEditing:editing animated:animated];
    
}

- (IBAction)adjustSliderValue:(id)sender {
    self.classificationSlider.value = self.classification.weight;
}

- (IBAction)classificationSliderValueChanged:(id)sender {
    
    
    float value = self.classificationSlider.value;
    Classificacao* nextClassification;
    int new_index;
    
    if(value == self.classification.weight) {
        return;
    }
    
    //checks wether the nextClassification is to the right or to the left of the current classification
    if(value > self.classification.weight) {
        new_index = self.classification_index +1;
    } else if (value < self.classification.weight) {
        new_index = self.classification_index -1;
    }
    
    nextClassification = [self.criterion.classifications objectAtIndex:new_index];
    
    
    //calculates the distance to both current and next classifications
    float distanceToCurrent = abs(self.classification.weight - value);
    float distanceToNext = abs(nextClassification.weight - value);
    
    //if the value is closer to the nextClassification than to the current, the current classification is changed  
    if (distanceToNext < distanceToCurrent) {
        self.classification = nextClassification;
        self.classification_index = new_index;
        
        [self drawClassificationLabel:self.classification animated:YES];
    }
    
    //NSLog(@"classification %i   value %.02f", self.classification.weight, value);
    
}

@end
