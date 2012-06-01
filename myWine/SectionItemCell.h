//
//  SectionItemCell.h
//  myWine
//
//  Created by Diogo Castro on 6/1/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Criterio.h"

@interface SectionItemCell : UITableViewCell


@property (strong, nonatomic) id item;
@property (strong, nonatomic) Classificacao* classification;
@property (nonatomic) int classification_index;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;
@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;

- (IBAction)adjustSliderValue:(id)sender;
- (IBAction)classificationSliderValueChanged:(id)sender;
- (void) resetState;
- (void) commitEdit;

@end
