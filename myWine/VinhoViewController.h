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
#import "ListaPaisesViewController.h"
#import "ListaRegioesViewController.h"


@protocol VinhoViewControllerDelegate <NSObject>

- (void) onVinhoEdition:(Vinho*) vinho;

@end

@interface VinhoViewController : UIViewController <UISplitViewControllerDelegate, SubstitutableDetailViewController, UITextFieldDelegate, ListaPaisesViewControllerDelegate, ListaRegioesViewControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *grapes_label;
@property (weak, nonatomic) IBOutlet UILabel *grapes_data_label;

@property (strong, nonatomic) UITextField* wine_name_text_field, *producer_text_field, *year_text_field, *grapes_text_field;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tempButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *selectRegionButton;

@property(nonatomic, getter=isEditing) BOOL editing;

@property (nonatomic, weak) id <VinhoViewControllerDelegate> delegate;

@property (nonatomic, strong) Vinho* editableWine;
@property (nonatomic, strong) Pais* country;

- (IBAction)toggleEdit:(id)sender;

- (void)configureView;

@end
