//
//  SectionItemCell.h
//  myWine
//
//  Created by Diogo Castro on 6/1/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Criterio.h"
#import "UIColor+myWineColor.h"
#import "MySplitViewViewController.h"

@protocol SectionItemCellCellDelegate <NSObject>

- (void) sectionItemCellDidUpdateClassification;

@end

@interface SectionItemCell : UITableViewCell <TranslatableViewController>


@property (strong, nonatomic) id item;
//@property (strong, nonatomic) Classificacao* classification;
@property (nonatomic) int classification_index;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;
@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;

@property (strong, nonatomic) id<SectionItemCellCellDelegate> delegate;

- (IBAction)adjustSliderValue:(id)sender;
- (IBAction)classificationSliderValueChanged:(id)sender;
- (void) resetState;
- (void) commitEdit;

-(void) translate;

//template methods
- (int) minVal;
- (int) maxVal;
- (int) itemChosenWeight;
- (int) itemWeight:(Classificacao*) classification;
- (NSString*) getClassificationLabel:(Classificacao*) classification;

@end
