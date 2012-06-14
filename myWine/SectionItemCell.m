//
//  SectionItemCell.m
//  myWine
//
//  Created by Diogo Castro on 6/1/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "SectionItemCell.h"

@implementation SectionItemCell
@synthesize nameLabel;
@synthesize classificationSlider;
@synthesize classificationLabel;
@synthesize item = _item;
@synthesize delegate = _delegate;
//@synthesize classification = _classification;
@synthesize classification_index = _classification_index;

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



- (void) setItem:(id) item {
    if (_item != item) {
        _item = item;
        [self configureView];
    }
}

- (void) configureView {
    [self.nameLabel setText: [self.item name]];
    [self drawClassificationLabel: [self.item classification_chosen] animated:NO];
    [self.classificationSlider setMinimumValue: [self minVal]]; 
    [self.classificationSlider setMaximumValue: [self maxVal]]; 
    [self.classificationSlider setValue:[self itemChosenWeight]];
    //NSLog(@" MIN %i MAX %i CHOSEN %i", self.criterion.minWeight, self.criterion.maxWeight, self.criterion.classification_chosen.weight);
    
    //temp classification
    [[self item] setClassification:[self.item classification_chosen]];
    
    [self.classificationSlider setUserInteractionEnabled:FALSE];
    
    //color
    self.backgroundColor = [UIColor myWineColorDarkGrey];
    
    //change slider's thumb image
    UIImage* image = [UIImage imageNamed:@"slider_thumb.png"];
    [self.classificationSlider setThumbImage:image forState:UIControlStateNormal];
    [self.classificationSlider setThumbImage:image forState:UIControlStateHighlighted];
    [self.classificationSlider setMinimumTrackTintColor:[UIColor myWineColor]];
}

- (void) drawClassificationLabel:(Classificacao*) classification animated:(BOOL) animated {
    NSString* string = [self getClassificationLabel:classification];
    //[[NSString alloc] initWithFormat:@"%i  %@", classification.weight, classification.name];
    
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

    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent;  
    
    if (editing) {
        
        [UIView transitionWithView:self.classificationSlider 
                          duration:0.3
                           options:options  
                        animations:^{
                            [self.classificationSlider setMaximumTrackTintColor:[UIColor whiteColor]];
                            [self.classificationSlider setMinimumTrackTintColor:[UIColor myWineColor]];
                        }  
                        completion:NULL];  
        
        //temp classification
        //self.classification = [self.item classification_chosen];
        
        //find currently selected classification's index
        int i;
        for(i = 0; i < [self.item classifications].count && ![[((Classificacao*)[[self.item classifications] objectAtIndex:i]) name] isEqualToString:[[[self item] classification] name]]; i++);
        self.classification_index = i;
        
        [self.classificationSlider setUserInteractionEnabled:YES];
    } else {
        
        [UIView transitionWithView:self.classificationSlider 
                          duration:0.3
                           options:options  
                        animations:^{
                            
                            [self.classificationSlider setMaximumTrackTintColor:[UIColor grayColor]];
                            [self.classificationSlider setMinimumTrackTintColor:[UIColor myWineColorDark]];
                            
                        }  
                        completion:NULL];  
        
        [self.classificationSlider setUserInteractionEnabled:NO];
    }
    
    //[super setEditing:editing animated:animated];
    
}

- (IBAction)adjustSliderValue:(id)sender {
    [self.classificationSlider setValue:[self itemWeight:[[ self item] classification]] animated:YES];
}

- (IBAction)classificationSliderValueChanged:(id)sender {
    
    
    float value = self.classificationSlider.value;
    Classificacao* nextClassification;
    int new_index;
    int classification_weight = [self itemWeight:[[self item] classification]];
    
    if(value == classification_weight) {
        return;
    }
    //checks wether the nextClassification is to the right or to the left of the current classification
    if(value > classification_weight) {
        new_index = self.classification_index +1;
    } else if (value < classification_weight) {
        new_index = self.classification_index -1;
    }
    
    nextClassification = [[self.item classifications] objectAtIndex:new_index];
    
    
    //calculates the distance to both current and next classifications
    float distanceToCurrent = abs(classification_weight - value);
    float distanceToNext = abs([self itemWeight:nextClassification] - value);
    
    //if the value is closer to the nextClassification than to the current, the current classification is changed  
    if (distanceToNext < distanceToCurrent) {
        [[self item] setClassification: nextClassification];
        self.classification_index = new_index;
        
        [self drawClassificationLabel:[[self item] classification] animated:YES];
        
        [self.delegate sectionItemCellDidUpdateClassification];
    }
    
    //NSLog(@"classification %i   value %.02f", self.classification.weight, value);
    
}


- (void) resetState {
    if([self.item classification_chosen] != [[self item] classification]) {
        [[self item] setClassification:[self.item classification_chosen]];
        [self drawClassificationLabel:[self.item classification_chosen] animated:YES];
        
        [self resetSlider];
        //[self performSelector:@selector(resetSlider) withObject:nil afterDelay:0.3];
    }
    
}

- (void) commitEdit {
    if([self.item classification_chosen] != [[self item] classification]) {
        [self.item setClassification_chosen:[[self item] classification]];
        [self.item save];
    }
}

- (void) resetSlider {
    [self.classificationSlider setValue: [self itemChosenWeight] animated:YES];
}

- (void) translate {
    //traduz nome
    [self.nameLabel setText: [self.item name]];
    
    //traduz classificacao
    [self drawClassificationLabel:[[self item] classification] animated:NO];
}

@end
