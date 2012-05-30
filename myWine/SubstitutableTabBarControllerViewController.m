//
//  SubstitutableTabBarControllerViewController.m
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "SubstitutableTabBarControllerViewController.h"


@interface SubstitutableTabBarControllerViewController ()

@end

@implementation SubstitutableTabBarControllerViewController

@synthesize vinho = _vinho, prova = _prova;
@synthesize editButton = _editButton, tempButton = _tempButton;
@synthesize  pcvc = _pcvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle: self.vinho.name];
    [self.editButton setTitle:[[Language instance] translate:@"Edit"]];
    self.pcvc = [[self viewControllers] objectAtIndex:0];
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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

#pragma mark - navigation controls

- (IBAction)toggleEdit:(id)sender {
    
    BOOL isEditing = ! self.pcvc.isEditing;
    
    if (isEditing) {
        //switch do doneButton and cancelButton
        Language* lan = [Language instance];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(toggleEdit:)];
        [cancelButton setTintColor: [UIColor colorWithRed:255/255 green:54/255 blue:76/255 alpha:0]];

        [self setTempButton:self.navigationItem.leftBarButtonItem];
        [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES]; 
    } else {
        //switch to editButton
        [[self navigationItem] setRightBarButtonItem:self.editButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:self.tempButton animated:YES];
        [self setTempButton:nil];
    }
    
    
    //switch editing mode
    [self.pcvc setEditing: isEditing animated:YES];
    [self setEditing:isEditing animated:YES];
    
}
@end
