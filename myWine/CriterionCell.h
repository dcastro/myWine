//
//  CriterionCell.h
//  myWine
//
//  Created by Diogo Castro on 26/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Criterio.h"
#import "SectionItemCell.h"

@interface CriterionCell : SectionItemCell
/*
@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;
 */

/*
- (IBAction)adjustSliderValue:(id)sender;
- (IBAction)classificationSliderValueChanged:(id)sender;
- (void) resetState;
- (void) commitEdit;

*/

//template methods
- (int) minVal;
- (int) maxVal;
- (int) itemChosenWeight;
- (int) itemWeight:(Classificacao*) classification;
- (NSString*) getClassificationLabel:(Classificacao*) classification;

@end
