//
//  VinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Vinho.h"
#import "ListaPaisesViewController.h"
#import "ListaRegioesViewController.h"
#import "Language.h"
#import <objc/runtime.h>
#import "Utils.h"
#import "User.h"
#import "CurrencyViewController.h"
#import "MySplitViewViewController.h"

@protocol VinhoViewControllerDelegate <NSObject>

- (void) onVinhoEdition:(Vinho*) vinho;

@end

@interface VinhoViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, ListaPaisesViewControllerDelegate, ListaRegioesViewControllerDelegate, CurrencyViewControllerDelegate, TranslatableViewController> {
    UIImage *image;
    BOOL newMedia;
}

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
@property (weak, nonatomic) IBOutlet UILabel *wine_type_label;
@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet UILabel *price_value_label;

@property (strong, nonatomic) IBOutlet UITextField *wineName;
@property (strong, nonatomic) IBOutlet UITextField *priceValue;
@property (strong, nonatomic) IBOutlet UITextField *harvestyear;
@property (strong, nonatomic) IBOutlet UITextField *producerName;
@property (strong, nonatomic) IBOutlet UITextView *grapesList;
@property (strong, nonatomic) IBOutlet UITextView *grapesListShow;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tempButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *selectRegionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCurrencyButton;

@property(nonatomic, getter=isEditing) BOOL editing;

@property (nonatomic, weak) id <VinhoViewControllerDelegate> delegate;

@property (nonatomic, strong) Vinho* editableWine;
@property (nonatomic, strong) Pais* country;

@property (nonatomic, strong) UIPopoverController* popover;

@property (weak, nonatomic) IBOutlet UIButton *winePic;
@property (strong, nonatomic) UIPopoverController *myPop;

- (IBAction)pickF:(id)sender;
- (IBAction)toggleEdit:(id)sender;

- (void)configureView;

- (void) translate;

@end
