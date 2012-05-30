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
@synthesize editButton = _editButton;
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

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    Language* lan = [Language instance];
    barButtonItem.title = [lan translate:@"Wines List Title"];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

- (IBAction)toggleEdit:(id)sender {
    
    [self.pcvc setEditing:!self.pcvc.isEditing animated:YES];
    
}
@end
