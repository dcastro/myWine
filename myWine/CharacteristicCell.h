//
//  CharacteristicCell.h
//  myWine
//
//  Created by Diogo Castro on 5/31/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Caracteristica.h"
#import "SectionItemCell.h"

@interface CharacteristicCell : SectionItemCell

/*
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;
@property (weak, nonatomic) IBOutlet UILabel *classificationLabel;*/

//template methods
- (int) minVal;
- (int) maxVal;
- (int) itemChosenWeight;
- (int) itemWeight:(Classificacao*) classification;
- (NSString*) getClassificationLabel:(Classificacao*) classification;

@end
