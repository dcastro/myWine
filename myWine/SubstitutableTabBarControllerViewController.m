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
@synthesize  criteriaController = _criteriaController, characteristicsController = _characteristicsController;

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
    
    //fetch tabs' controllers
    self.criteriaController = [[self viewControllers] objectAtIndex:0];
    self.characteristicsController = [[self viewControllers] objectAtIndex:1];
    
    //set Tab Bar items
    Language* lan = [Language instance];
    UITabBarItem* criteriaItem = [[UITabBarItem alloc] initWithTitle:[lan translate:@"Criteria"] image:nil tag:0];
    UITabBarItem* characteristicsItem = [[UITabBarItem alloc] initWithTitle:[lan translate:@"Characteristics"] image:nil tag:1];
    
    self.criteriaController.tabBarItem = criteriaItem;
    self.characteristicsController.tabBarItem = characteristicsItem;
    
    //set tabs' modes
    self.criteriaController.prova_mode = CRITERIA_MODE;
    self.characteristicsController.prova_mode = CHARACTERISTICS_MODE;
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
    
    BOOL isEditing = ! self.isEditing;
    BOOL done = false;
    
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
        
        UIBarButtonItem* pressedButton = (UIBarButtonItem*) sender;
        done = [pressedButton style] == UIBarButtonItemStyleDone;

    }
    
    
    //switch editing mode
    [self.criteriaController setEditing: isEditing animated:YES done:done];
    [self.characteristicsController setEditing: isEditing animated:YES done:done];
    [self setEditing:isEditing animated:YES];
    
}
@end
