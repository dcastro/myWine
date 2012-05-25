//
//  ProvaViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaVinhosViewController.h"
#import "Language.h"

@interface ProvaViewController : UIViewController <UISplitViewControllerDelegate, SubstitutableDetailViewController>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
