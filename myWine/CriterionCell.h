//
//  CriterionCell.h
//  myWine
//
//  Created by Diogo Castro on 26/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Criterio.h"

@protocol CriterionCellDelegate <NSObject>

- (void) criterionCellDidUpdateClassification;

@end

@interface CriterionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;

@property (strong, nonatomic) Criterio* criterion;
@property (strong, nonatomic) Classificacao* classification; //
@property (nonatomic) int classification_index;

@property (strong, nonatomic) id<CriterionCellDelegate> delegate;

- (IBAction)adjustSliderValue:(id)sender;
- (IBAction)classificationSliderValueChanged:(id)sender;
- (void) resetState;
- (void) commitEdit;

@end
