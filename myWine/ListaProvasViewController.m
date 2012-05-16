//
//  ListaProvasViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ListaProvasViewController.h"
#import "ProvaViewController.h"
#import "Prova.h"
#import "ProvaCriteriaViewController.h"
#import "NSMutableArray+ProvasMutableArray.h"

@interface ListaProvasViewController () {NSMutableArray *_objects;}

@end

@implementation ListaProvasViewController
@synthesize provaViewController = _provaViewController;
@synthesize provas = _provas;

@synthesize rootPopoverButtonItem, popoverController, splitViewController;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    _objects = [NSMutableArray arrayWithCapacity:20];
	Prova *prova = [[Prova alloc] init];
	prova.data = @"22/06/2011";
	prova.local = @"Casa";
	[_objects addObject:prova];
	prova = [[Prova alloc] init];
	prova.data = @"12/11/2011";
	prova.local = @"Herdade do manuel";
	[_objects addObject:prova];
    prova = [[Prova alloc] init];
	prova.data = @"05/01/2012";
	prova.local = @"Restaurante BB";
	[_objects addObject:prova];
    prova = [[Prova alloc] init];
	prova.data = @"14/03/2012";
	prova.local = @"Casa";
*/
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.provaViewController = (ProvaViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
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
 
    if ([segue.identifier isEqualToString:@"showProva"]) {
        
        UITabBarController* tabBarController = (UITabBarController*) [segue.destinationViewController topViewController];
        Prova* prova = [_provas objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        ProvaCriteriaViewController* pcvc = (ProvaCriteriaViewController*) [[tabBarController viewControllers] objectAtIndex:0];
        pcvc.prova = prova;
        
        ProvaViewController* pvc = (ProvaViewController*) [[tabBarController viewControllers] objectAtIndex:1];  //(ProvaViewController*) [segue.destinationViewController topViewController];
        pvc.detailItem = prova;
        
    }
    
	if ([segue.identifier isEqualToString:@"AddProva"])
	{
		UINavigationController *navigationController = 
        segue.destinationViewController;
		NovaProvaViewController 
        *NovaProvaViewController = 
        [[navigationController viewControllers] 
         objectAtIndex:0];
		NovaProvaViewController.delegate = self;
	}
    
    [self switchDetailViews:segue];
}

- (void) switchDetailViews: (UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"showProva"]) { 
        if (rootPopoverButtonItem != nil) {
            UIViewController<SubstitutableDetailViewController>* detailViewController = (UIViewController<SubstitutableDetailViewController>*)[segue.destinationViewController topViewController];
            [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }
        
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}


- (void)insertNewObject:(id)sender
{
    if (!_provas) {
        _provas = [[NSMutableArray alloc] init];
    }
    [_provas insertObject:[NSDate date] atIndex:0];
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
    return _provas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Prova"];
    
    Prova *object = [_provas objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", object.tasting_date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", object.tasting_id];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([_provas removeProvaAtIndex:indexPath.row]){
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Prova *object = [_objects objectAtIndex:indexPath.row];
    //self.provaViewController.detailItem = object.data;
}

#pragma mark - NovaProvaViewControllerDelegate

- (void)NovaProvaViewControllerDidCancel:
(NovaProvaViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)NovaProvaViewControllerDidSave:
(NovaProvaViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setProvas:(NSMutableArray*)provas {
    if (provas != _provas) {
        _provas = provas;
        [[self tableView] reloadData];
    }
}

@end
