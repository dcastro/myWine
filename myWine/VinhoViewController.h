//
//  VinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vinho.h"
#import "ListaVinhosViewController.h"

@interface VinhoViewController : UIViewController <UISplitViewControllerDelegate, SubstitutableDetailViewController, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) Vinho* selected_wine;

@property (weak, nonatomic) IBOutlet UILabel *producer_label;
@property (weak, nonatomic) IBOutlet UILabel *producer_label_name;
@property (weak, nonatomic) IBOutlet UILabel *year_label;
@property (weak, nonatomic) IBOutlet UILabel *year_label_name;
@property (weak, nonatomic) IBOutlet UILabel *region_label;
@property (weak, nonatomic) IBOutlet UILabel *region_label_name;
@property (weak, nonatomic) IBOutlet UILabel *country_label;
@property (weak, nonatomic) IBOutlet UILabel *country_label_name;
@property (weak, nonatomic) IBOutlet UILabel *percentage_label_name;
@property (weak, nonatomic) IBOutlet UILabel *wine_label_name;

@property (strong, nonatomic) UITextField* wine_name_text_field, *producer_text_field, *year_text_field;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tempButton;

@property(nonatomic, getter=isEditing) BOOL editing;

- (IBAction)toggleEdit:(id)sender;

- (void)configureView;

@end
