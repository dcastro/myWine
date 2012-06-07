//
//  FilterViewController.m
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterSelectionViewController.h"
#import "User.h"
#import "NSMutableArray+VinhosMutableArray.h"
#import "FilterManager.h"
#import "FilterCell.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize selectedFilterType;

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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"filterToSelection"]) {
        
        FilterSelectionViewController* filterSelectionViewController = (FilterSelectionViewController*) [segue destinationViewController];
        
        filterSelectionViewController.filterType = selectedFilterType;
        filterSelectionViewController.delegate = self;
        
        NSMutableArray* vinhos = [[User instance] vinhos];
        
        switch (filterSelectionViewController.filterType) {
            case FilterTypeYear:
                filterSelectionViewController.objects = [vinhos getYears];
                break;
                
            case FilterTypeCountry:
                filterSelectionViewController.objects = [vinhos getCountries];
                break;
                
            case FilterTypeWineType:
                filterSelectionViewController.objects = [vinhos getWineTypes];
                break;
                
            case FilterTypeProducer:
                filterSelectionViewController.objects = [vinhos getProducers];
                break;
        }
        
    }
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self tableView] deselectRowAtIndexPath:indexPath animated:NO];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    selectedFilterType = indexPath.row;
    [self performSegueWithIdentifier:@"filterToSelection" sender:self];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self tableView] selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    selectedFilterType = indexPath.row;
    [self performSegueWithIdentifier:@"filterToSelection" sender:self];
}


#pragma mark - Filter Selection Delegate Method
- (void) filterSelectionViewControllerDidSelect:(id) object withFilter:(FilterType) filterType {
    
    NSLog(@"%@ %i", [object description], filterType);
}

- (IBAction)clearAll:(id)sender {
    [FilterManager removeAllFilters];
}


-(void) forEveryCell:(void (^)(FilterCell *)) block {
    for(int i = 0; i < 4; i++) {
        FilterCell* cell = (FilterCell*) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        block(cell);
    }
}

@end
