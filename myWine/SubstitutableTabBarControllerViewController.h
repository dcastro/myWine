//
//  SubstitutableTabBarControllerViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vinho.h"
#import "Prova.h"
#import "Language.h"

@protocol SubstitutableDetailViewController;

@interface SubstitutableTabBarControllerViewController : UITabBarController <SubstitutableDetailViewController>

@property (strong, nonatomic) Vinho* vinho;
@property (strong, nonatomic) Prova* prova;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
