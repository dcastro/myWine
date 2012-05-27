//
//  ProvaCriteriaViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prova.h"
#import "Seccao.h"
#import "Criterio.h"
#import "CriterionCell.h"
#import "Vinho.h"
#import "SubstitutableTabBarControllerViewController.h"

@interface ProvaCriteriaViewController : UITableViewController

@property (strong, nonatomic) Prova* prova;
@property (strong, nonatomic) Vinho* vinho;

@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UIView *upperView;


@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
