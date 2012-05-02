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

@interface VinhoViewController ()
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
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize wine_name_text_field = _wine_name_text_field, producer_text_field = _producer_text_field, year_text_field = _year_text_field;
@synthesize editButton = _editButton;
@synthesize tempButton = _tempButton;
@synthesize editing = _editing;

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
    self.wine_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.editButton.title = [lan translate:@"Edit"];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    //init editing frames
    self.wine_name_text_field = [[UITextField alloc] initWithFrame:self.wine_label_name.frame];
    self.producer_text_field = [[UITextField alloc] initWithFrame:self.producer_label_name.frame];
    self.year_text_field = [[UITextField alloc] initWithFrame:self.year_label_name.frame];
    
    /**
     * styling of the editing fields
     **/
    
    //alignment
    [self.wine_name_text_field setTextAlignment:UITextAlignmentCenter];
    
    //borders
    self.wine_name_text_field.borderStyle = UITextBorderStyleRoundedRect;
    self.producer_text_field.borderStyle = UITextBorderStyleRoundedRect;
    self.year_text_field.borderStyle = UITextBorderStyleRoundedRect;    
    
    //fonts
    self.wine_name_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    self.producer_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    self.year_text_field.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];
    
    //frame adjustments
    CGRect frame = self.wine_name_text_field.frame;
    self.wine_name_text_field.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 20.0);
    
    //keyboard types
    self.year_text_field.keyboardType = UIKeyboardTypeNumberPad;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    //switch editing mode
    [self setEditing: !self.isEditing];    
    
    if ([self isEditing]) {
        
        self.wine_name_text_field.text = self.wine_label_name.text;
        self.producer_text_field.text = self.producer_label_name.text;
        self.year_text_field.text = self.year_label_name.text;
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlDown
						animations:^ {
                            //addition of editing fields to the subviews
                            [[self view] addSubview:self.wine_name_text_field];
                            [[self view] addSubview:self.producer_text_field];
                            [[self view] addSubview:self.year_text_field];
                            
                        }
						completion:nil];
        
        //switch do doneButton and cancelButton
        Language* lan = [Language instance];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(toggleEdit:)];
        
        [self setTempButton:self.navigationItem.leftBarButtonItem];
        [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES];        
 
    } else {
        UIBarButtonItem* pressedButton = (UIBarButtonItem*) sender;
        
        if ([pressedButton style] != UIBarButtonSystemItemCancel) {
            Vinho* vinho = [[Vinho alloc] init];
            [vinho setName:self.wine_name_text_field.text];
            [vinho setProducer:self.producer_text_field.text];
            [vinho setYear: [self.year_text_field.text intValue]];
        
            [self.detailItem updateWithVinho:vinho];
        
            self.wine_label_name.text = self.wine_name_text_field.text;
            self.producer_label_name.text = self.producer_text_field.text;
            self.year_label_name.text = self.year_text_field.text;
        }
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlUp
						animations:^ {
                            [self.wine_name_text_field removeFromSuperview];
                            [self.producer_text_field removeFromSuperview];
                            [self.year_text_field removeFromSuperview];
                        }
						completion:nil];
        
        //switch to editButton
        [[self navigationItem] setRightBarButtonItem:self.editButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:self.tempButton animated:YES];
        [self setTempButton:nil];
        
        [self configureView];


    }
    
    //switch views
    [self.wine_label_name setHidden: self.isEditing];
    [self.producer_label_name setHidden: self.isEditing];
    [self.year_label_name setHidden: self.isEditing];
    
    [self.wine_name_text_field setHidden: !self.isEditing];
    [self.producer_text_field setHidden: !self.isEditing];
    [self.year_text_field setHidden: !self.isEditing];
    
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


@end
