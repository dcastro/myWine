//
//  ComparatorCell.h
//  myWine
//
//  Created by Diogo Castro on 6/11/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ComparatorCellTypeA,
    ComparatorCellTypeB
} ComparatorCellType;

@class Criterio;

@interface ComparatorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *classificationSlider;
@property (weak, nonatomic) IBOutlet UILabel *criterionNameLabel;
@property (strong, nonatomic) Criterio* criterion;

@property (nonatomic) ComparatorCellType cellType;

@end
