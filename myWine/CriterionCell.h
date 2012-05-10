//
//  CriterionCell.h
//  myWine
//
//  Created by Diogo Castro on 5/10/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Criterio;
@class CriterionView;

@interface CriterionCell : UITableViewCell

@property (strong, nonatomic) CriterionView* criterionView;

- (void)setCriterion:(Criterio *)newCriterion;
- (void)redisplay;

@end
