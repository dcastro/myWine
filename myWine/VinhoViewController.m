//
//  VinhoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "VinhoViewController.h"
#import "Language.h"
#import <objc/runtime.h>
#import "ListaPaisesViewController.h"
#import "Utils.h"
#import "User.h"

@interface VinhoViewController () {
    CGFloat animatedDistance;
    UITextField *keyboard;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation VinhoViewController
@synthesize producer_label = _producer_label;
@synthesize producer_label_name = _producer_label_name;
@synthesize year_label = _year_label;
@synthesize year_label_name = _year_label_name;
@synthesize region_label = _region_label;
@synthesize region_label_name = _region_label_name;
@synthesize country_label = _country_label;
@synthesize country_label_name = _country_label_name;
@synthesize percentage_label_name = _percentage_label_name;
@synthesize wine_label_name = _wine_label_name;
@synthesize grapes_label = _grapes_label;
@synthesize grapes_data_label = _grapes_data_label;
@synthesize wine_type_label = _wine_type_label;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize wine_name_text_field = _wine_name_text_field, producer_text_field = _producer_text_field, year_text_field = _year_text_field, grapes_text_field = _grapes_text_field;
@synthesize editButton = _editButton;
@synthesize tempButton = _tempButton;
@synthesize selectCountryButton = _selectCountryButton;
@synthesize selectRegionButton = _selectRegionButton;
@synthesize selectWineTypeButton = _selectWineTypeButton;
@synthesize editing = _editing;

@synthesize delegate;

@synthesize editableWine = _editableWine, country = _country;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    Language *lan = [Language instance];
    
    
    self.producer_label.text = [lan translate:@"Producer"];
    self.producer_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.year_label.text = [lan translate:@"Harvest year"];
    self.year_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.producer_label.text = [lan translate:@"Producer"];
    self.producer_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];

    self.region_label.text = [lan translate:@"Region"];
    self.region_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];

    self.country_label.text = [lan translate:@"Country"];
    self.country_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.grapes_label.text = [lan translate:@"Grapes"];
    self.grapes_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    
    Vinho* vinho = (Vinho*) self.detailItem;
    
    self.producer_label_name.text = vinho.producer;
    self.producer_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    self.year_label_name.text = [NSString stringWithFormat:@"%d", vinho.year];
    self.year_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    self.region_label_name.text = vinho.region.region_name;
    self.region_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    self.country_label_name.text = vinho.region.country_name;
    self.country_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    self.wine_label_name.text = vinho.name;
    self.wine_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGER_FONT];
    
    self.grapes_data_label.text = vinho.grapes;
    self.grapes_data_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    self.wine_type_label.text = vinho.winetype.name;
    self.wine_type_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.editButton.title = [lan translate:@"Edit"];
    
    //set navigation bar title
    [self setTitle: [self.detailItem description]];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Setup the background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view insertSubview:background atIndex:0];
    
    //init editing frames
    self.wine_name_text_field = [[UITextField alloc] initWithFrame:self.wine_label_name.frame];
    self.producer_text_field = [[UITextField alloc] initWithFrame:self.producer_label_name.frame];
    self.year_text_field = [[UITextField alloc] initWithFrame:self.year_label_name.frame];
    self.grapes_text_field = [[UITextField alloc] initWithFrame:self.grapes_data_label.frame];
    
    /**
     * styling of the editing fields
     **/
    
    //alignment
    [self.wine_name_text_field setTextAlignment:UITextAlignmentCenter];
    
    //borders
    self.wine_name_text_field.borderStyle = UITextBorderStyleRoundedRect;
    self.producer_text_field.borderStyle = UITextBorderStyleRoundedRect;
    self.year_text_field.borderStyle = UITextBorderStyleRoundedRect;    
    self.grapes_text_field.borderStyle = UITextBorderStyleRoundedRect; 
    
    //fonts
    self.wine_name_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    self.producer_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    self.year_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    self.grapes_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    //frame adjustments
    CGRect frame = self.wine_name_text_field.frame;
    self.wine_name_text_field.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 20.0);
    
    //keyboard types
    self.year_text_field.keyboardType = UIKeyboardTypeNumberPad;
    
    //delegates
    self.wine_name_text_field.delegate = self;
    self.producer_text_field.delegate = self;
    self.year_text_field.delegate = self;
    self.grapes_text_field.delegate = self;
    
    [self.selectCountryButton setHidden:TRUE];
    [self.selectRegionButton setHidden:TRUE];
    [self.selectWineTypeButton setHidden:TRUE];

}

- (void)viewDidUnload
{
    [self setProducer_label:nil];
    [self setProducer_label_name:nil];
    [self setYear_label:nil];
    [self setYear_label_name:nil];
    [self setRegion_label:nil];
    [self setRegion_label_name:nil];
    [self setCountry_label:nil];
    [self setCountry_label_name:nil];
    [self setPercentage_label_name:nil];
    [self setWine_label_name:nil];
    [self setEditButton:nil];
    [self setTempButton:nil];
    [self setGrapes_label:nil];
    [self setGrapes_data_label:nil];
    [self setSelectCountryButton:nil];
    [self setSelectRegionButton:nil];
    [self setWine_type_label:nil];
    [self setSelectWineTypeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"vinhoToCountries"]) {
        ListaPaisesViewController* lpvc = (ListaPaisesViewController*) segue.destinationViewController;
        lpvc.delegate = self;
    }
    if([segue.identifier isEqualToString:@"vinhoToRegions"]) {
        ListaRegioesViewController* lrvc = (ListaRegioesViewController*) segue.destinationViewController;
        lrvc.delegate = self;
        lrvc.regions = self.country.regions;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Vinhos", @"Vinhos");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)toggleEdit:(id)sender {

    
    if (![self isEditing]) {
        
        self.editableWine = [self.detailItem copy];
        
        self.wine_name_text_field.text = self.wine_label_name.text;
        self.producer_text_field.text = self.producer_label_name.text;
        self.year_text_field.text = self.year_label_name.text;
        self.grapes_text_field.text = self.grapes_data_label.text;
        
        [self.selectCountryButton setTitle:self.country_label_name.text forState:UIControlStateNormal];
        [self.selectRegionButton setTitle:self.region_label_name.text forState:UIControlStateNormal];
        [self.selectWineTypeButton setTitle:self.wine_type_label.text forState:UIControlStateNormal];
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlDown
						animations:^ {
                            //addition of editing fields to the subviews
                            [[self view] addSubview:self.wine_name_text_field];
                            [[self view] addSubview:self.producer_text_field];
                            [[self view] addSubview:self.year_text_field];
                            [[self view] addSubview:self.grapes_text_field];
                        }
						completion:nil];
        
        //switch do doneButton and cancelButton
        Language* lan = [Language instance];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(toggleEdit:)];
        
        [self setTempButton:self.navigationItem.leftBarButtonItem];
        [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES];   
        
        //set country
        NSString* country_name = self.editableWine.region.country_name;
        NSArray* countries = [[User instance] countries];
        for(int i = 0; i <  [countries count]; i++) {
            if([[[countries objectAtIndex:i] name] isEqualToString:country_name]){
                self.country = [countries objectAtIndex:i];
                break;
            }
        }
        
 
    } else {
        UIBarButtonItem* pressedButton = (UIBarButtonItem*) sender;
        
        if ([pressedButton style] == UIBarButtonItemStyleDone) {
            
            //verifications
            if(!self.editableWine.region) {
                //show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[Language instance] translate:@"Error"] message:[[Language instance] translate:@"Select Region"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            
            [self.editableWine setName:self.wine_name_text_field.text];
            [self.editableWine setProducer:self.producer_text_field.text];
            [self.editableWine setYear: [self.year_text_field.text intValue]];
            [self.editableWine setGrapes:self.grapes_text_field.text];
        
            [self.detailItem updateWithVinho:self.editableWine];
        
            self.wine_label_name.text = self.wine_name_text_field.text;
            self.producer_label_name.text = self.producer_text_field.text;
            self.year_label_name.text = self.year_text_field.text;
            self.grapes_data_label.text = self.grapes_text_field.text;
            
            //refresh master view
            [self.delegate onVinhoEdition:(Vinho*) self.detailItem];
        }
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlUp
						animations:^ {
                            [self.wine_name_text_field removeFromSuperview];
                            [self.producer_text_field removeFromSuperview];
                            [self.year_text_field removeFromSuperview];
                            [self.grapes_text_field removeFromSuperview];
                        }
						completion:nil];
        
        //switch to editButton
        [[self navigationItem] setRightBarButtonItem:self.editButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:self.tempButton animated:YES];
        [self setTempButton:nil];
        
        [self configureView];
        
    }
    
    //switch editing mode
    [self setEditing: !self.isEditing];
    
    //switch views
    [self.wine_label_name setHidden: self.isEditing];
    [self.producer_label_name setHidden: self.isEditing];
    [self.year_label_name setHidden: self.isEditing];
    [self.grapes_data_label setHidden: self.isEditing];
    
    [self.wine_name_text_field setHidden: !self.isEditing];
    [self.producer_text_field setHidden: !self.isEditing];
    [self.year_text_field setHidden: !self.isEditing];
    [self.grapes_text_field setHidden: !self.isEditing];
    
    [self.country_label_name setHidden: self.isEditing];
    [self.selectCountryButton setHidden: !self.isEditing];
    
    [self.region_label_name setHidden:self.isEditing];
    [self.selectRegionButton setHidden: !self.isEditing];
    
    [self.wine_type_label setHidden:self.isEditing];
    [self.selectWineTypeButton setHidden:!self.isEditing];
    
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([self isEditing]) {
        [self setTempButton:barButtonItem];
        return;
    }
    Language* lan = [Language instance];
    barButtonItem.title = [lan translate:@"Wines List Title"];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([self isEditing]) {
        [self setTempButton:nil];
        return;
    }
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark -
#pragma mark UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    animatedDistance = calculateAnimation(self,keyboard);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboard = textField;
    animatedDistance = calculateAnimation(self, textField);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    keyboard = textField;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - ListaPaises and ListaRegioes Delegate Methods

- (void) selectedCountry:(Pais*)country {
    self.country = country;
    [self.selectCountryButton setTitle:self.country.name forState:UIControlStateNormal];
    
    //reset region
    self.editableWine.region = nil;
    [self.selectRegionButton setTitle:[[Language instance] translate:@"Tap to select"] forState:UIControlStateNormal];
    
}

- (void) selectedRegion:(Regiao*) region{
    self.editableWine.region = region;
    [self.selectRegionButton setTitle:region.region_name forState:UIControlStateNormal];
}

@end
