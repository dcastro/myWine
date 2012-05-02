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

#import "ListaProvasViewController.h"
#import "Vinho.h"

#import "User.h"
#import "Prova.h"
#import "Language.h"

#import "VinhoViewController.h"

#import "NSMutableArray+VinhosMutableArray.h"

#import <objc/runtime.h>

@interface ListaVinhosViewController () {
    NSMutableArray *_objects;
    NSIndexPath* _index;
}
@end

@interface ListaVinhosViewController () <LoginViewControllerDelegate>
@end

@implementation ListaVinhosViewController

@synthesize currentPopover;
@synthesize detailViewController = _detailViewController;
@synthesize vinhos = _vinhos;


SEL action; id target;

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
    [_objects insertObject:@"Vinho do Porto" atIndex:0];
    [_objects insertObject:@"Murganheira" atIndex:0];
    [_objects insertObject:@"Gazela" atIndex:0];
    [_objects insertObject:@"Alvarinho" atIndex:0];
    */
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    
    [self configureView];
    


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
    
    if([segue.identifier isEqualToString:@"PushProvas"]) {
       ListaProvasViewController* lpvc = (ListaProvasViewController*) [segue destinationViewController ];
        
       Vinho* vinho = [self.vinhos objectAtIndex:_index.row];
       lpvc.provas = vinho.provas;
    }
    else if ([segue.identifier isEqualToString:@"showVinho"]) {
        
        VinhoViewController* vvc = (VinhoViewController*) [segue.destinationViewController topViewController];
        Vinho* vinho = [self.vinhos objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        vvc.detailItem = vinho;

    }
	else if ([segue.identifier isEqualToString:@"AddVinho"])
	{
		UINavigationController *navigationController = 
        segue.destinationViewController;
		NovoVinhoViewController 
        *NovoVinhoViewController = 
        [[navigationController viewControllers] 
         objectAtIndex:0];
		NovoVinhoViewController.delegate = self;
	}
    else if([segue.identifier isEqualToString:@"filterSegue"])
    {
        
        action = [sender action];
        target = [sender target];
        
        [sender setTarget:self];
        [sender setAction:@selector(dismiss:)];
        
        self.currentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    
    //switch detail views
    [self switchDetailViews:segue];
}

-(void)dismiss:(id)sender
{
    [self.navigationItem.rightBarButtonItem setAction:action];
    [self.navigationItem.rightBarButtonItem setTarget:target];
    [self.currentPopover dismissPopoverAnimated:YES];
}


-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self.navigationItem.rightBarButtonItem setAction:action];
    [self.navigationItem.rightBarButtonItem setTarget:target];
    return YES;    
}


- (void) switchDetailViews: (UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"showVinho"]) { //|| [segue.identifier isEqualToString:@"VinhosToHome"]) {
        if (rootPopoverButtonItem != nil) {
            UIViewController<SubstitutableDetailViewController>* detailViewController = (UIViewController<SubstitutableDetailViewController>*)[segue.destinationViewController topViewController];
            [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }
        
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
    }
    
    if ([segue.identifier isEqualToString:@"VinhosToHome"]) {
        if (rootPopoverButtonItem != nil) {
            UIViewController<SubstitutableDetailViewController>* detailViewController = (UIViewController<SubstitutableDetailViewController>*) segue.destinationViewController;
            [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }
        
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
    }

}

- (void)insertNewObject:(id)sender
{
    if (!_vinhos) {
        //_objects = [[NSMutableArray alloc] init];
        return;
    }
    //[_objects insertObject:[NSDate date] atIndex:0];
    [self.vinhos insertVinho:sender atIndex:0];
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
    return _vinhos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //NSString *object = [_objects objectAtIndex:indexPath.row];
    Vinho* vinho = [self.vinhos objectAtIndex:indexPath.row];
    cell.textLabel.text = [vinho description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [vinho year]];
    
    //Change cell's background color when selected
    /*UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
     myBackView.backgroundColor = [UIColor colorWithRed:0.48 green:0.05 blue:0.07 alpha:1];
     cell.selectedBackgroundView = myBackView;*/
    
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_gradient.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //fill in provas @ listaprovasviewcontroller
    _index = indexPath;
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
        [_vinhos removeVinhoAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (void) setVinhos:(NSMutableArray*)vinhos {
    if (vinhos != _vinhos) {
        _vinhos = vinhos;
        [[self tableView] reloadData];
    }
}

-(void) configureView {
    Language* lan = [Language instance];
    
    self.title = [lan translate:@"Wines List Title"];
}


#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    Language* lan = [Language instance];
    barButtonItem.title = [lan translate:@"Wines List Title"];
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UIViewController <SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)[[splitViewController.viewControllers objectAtIndex:1] topViewController];
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UIViewController <SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)[[splitViewController.viewControllers objectAtIndex:1] topViewController];
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

@end
