//
//  VinhoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "VinhoViewController.h"
#import "Language.h"

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

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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

@end
