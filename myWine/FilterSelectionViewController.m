//
//  FilterSelectionViewController.m
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FilterSelectionViewController.h"
#import "FilterManager.h"

@interface FilterSelectionViewController ()

@end

@implementation FilterSelectionViewController

@synthesize clearAllButton = _clearAllButton;
@synthesize filterType;
@synthesize objects = _objects;
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
    
    switch (filterType) {
        case FilterTypeYear:
            
            break;
            
        case FilterTypeCountry:
            
            break;
            
        case FilterTypeWineType:
            
            break;
            
        case FilterTypeProducer:
            break;
            
        default:
            break;
    }
    
    [self configureView];
    
}

- (void) configureView {
    for(int i = 0; i < [[self objects] count]; i++) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
        //UITableViewCell* cell = (UITableViewCell*) [[self tableView] cellForRowAtIndexPath:path];
    
        id object = [self.objects objectAtIndex:i];
        
        if( [FilterManager containsFilterForObject:object ofType:filterType] ) {
            [[self tableView] selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
            
    }
    
    [self.clearAllButton setTitle:[[Language instance] translate:@"Clear All"]];
    
}


- (void)viewDidUnload
{
    [self setClearAllButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id object = [self.objects objectAtIndex:indexPath.row];
    
    [cell.textLabel setText: [object description]];
    
    return cell;
}

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
    
    id object = [[self objects] objectAtIndex:indexPath.row];
    
    [FilterManager addFilterForObject:object ofType:filterType];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [[self objects] objectAtIndex:indexPath.row];
    
    [FilterManager removeFilterForObject:object ofType:filterType];
}

- (IBAction)clearAll:(id)sender {
    [FilterManager removeFiltersOfType:filterType];
    
    for(int i = 0; i < [[self objects] count]; i++) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
        
        [[self tableView] deselectRowAtIndexPath:path animated:YES];
    }
    
    
    
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.delegate showRootPopoverButtonItem:barButtonItem];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.delegate invalidateRootPopoverButtonItem:barButtonItem];
}

@end
