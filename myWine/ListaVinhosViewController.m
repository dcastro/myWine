//
//  ListaVinhosViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ListaVinhosViewController.h"

#import "DetailViewController.h"

#import "LoginViewController.h"

@interface ListaVinhosViewController () {
    NSMutableArray *_objects;
}
@end

@interface ListaVinhosViewController () <LoginViewControllerDelegate>
@end

@implementation ListaVinhosViewController

@synthesize detailViewController = _detailViewController;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:@"Vinho do Porto" atIndex:0];
    [_objects insertObject:@"Murganheira" atIndex:0];
    [_objects insertObject:@"Gazela" atIndex:0];
    [_objects insertObject:@"Alvarinho" atIndex:0];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddVinho"])
	{
		UINavigationController *navigationController = 
        segue.destinationViewController;
		NovoVinhoViewController 
        *NovoVinhoViewController = 
        [[navigationController viewControllers] 
         objectAtIndex:0];
		NovoVinhoViewController.delegate = self;
	}
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSString *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PushProvas" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = [_objects objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = object;
}

#pragma mark - NovoVinhoViewControllerDelegate

- (void)NovoVinhoViewControllerDidCancel:
(NovoVinhoViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)NovoVinhoViewControllerDidSave:
(NovoVinhoViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)LoginViewControllerDidLogin:(LoginViewController *)controller {
    NSLog(@"Dismissing LoginController");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
