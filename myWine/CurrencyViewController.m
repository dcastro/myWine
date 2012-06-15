//
//  CurrencyViewController.m
//  myWine
//
//  Created by Diogo Castro on 24/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CurrencyViewController.h"

@interface CurrencyViewController ()

@end

@implementation CurrencyViewController

@synthesize selectedCurrency = _selectedCurrency;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(cell.tag == self.selectedCurrency) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //removes all rows' checkmarks
    for(int i = 0; i < [[self tableView] numberOfRowsInSection:0]; i++ ){
        UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //adds a checkmark to the selected row
    UITableViewCell* cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //informs the delegate of the selected currency
    [self.delegate currencyViewControllerDidSelect:indexPath.row];
}

@end
