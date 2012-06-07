//
//  ListaVinhosViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ListaVinhosViewController.h"
#import "FilterManager.h"

@interface ListaVinhosViewController () {
    NSMutableArray *_objects;
    NSUInteger _index;
}
@end

@interface ListaVinhosViewController () <LoginViewControllerDelegate>
@end

@implementation ListaVinhosViewController

@synthesize currentPopover;
@synthesize detailViewController = _detailViewController;
@synthesize vinhos = _vinhos;
@synthesize vvc;

@synthesize homeVisibility;
@synthesize tempButton;
@synthesize filterButton;

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
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    
    [self configureView];
    
    self.detailViewController.delegate = self;
    [self setHomeVisibility:TRUE];
    
    //Observar gestor de filtros
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;
    
    [[FilterManager instance] addObserver:self forKeyPath:@"filters" options:options context:nil];
}

- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    self.vinhos = [FilterManager applyFilters:[[User instance] vinhos]];
    [[self tableView] reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"PushProvas"]) {
        
        ListaProvasViewController* lpvc = (ListaProvasViewController*) [segue destinationViewController ];
        
        Vinho* vinho = [self.vinhos objectAtIndex:_index];
        lpvc.vinho = vinho;
        lpvc.provas = vinho.provas;
        
        lpvc.rootPopoverButtonItem = self.rootPopoverButtonItem;
        lpvc.popoverController = self.popoverController;
        lpvc.splitViewController = self.splitViewController;
    }
    else if ([segue.identifier isEqualToString:@"showVinho"]) {
        
        vvc = (VinhoViewController*) [segue.destinationViewController topViewController];
        Vinho* vinho = [self.vinhos objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        vvc.detailItem = vinho;
        vvc.delegate = self;

    }
	else if ([segue.identifier isEqualToString:@"AddVinho"])
	{
		UINavigationController *navigationController = 
        segue.destinationViewController;
		NovoVinhoViewController 
        *nvvc = 
        [[navigationController viewControllers] 
         objectAtIndex:0];
		nvvc.delegate = self;
	}
    else if([segue.identifier isEqualToString:@"filterSegue"])
    {
        action = [sender action];
        target = [sender target];
        
        [sender setTarget:self];
        [sender setAction:@selector(dismiss:)];
        
        self.currentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    else if ([segue.identifier isEqualToString:@"VinhosToHome"]) {
        
        DetailViewController* home = segue.destinationViewController;
        home.delegate = self;
        
        NSIndexPath* path = [[self tableView] indexPathForSelectedRow];
        [[self tableView] deselectRowAtIndexPath:path animated:YES];
    }

    //switch detail views
    [self switchDetailViews:segue];
}

-(void)dismiss:(id)sender
{
    [self.filterButton setAction:action];
    [self.filterButton setTarget:target];
    [self.currentPopover dismissPopoverAnimated:YES];
}


-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self.filterButton setAction:action];
    [self.filterButton setTarget:target];
    return YES;    
}


- (void) switchDetailViews: (UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"showVinho"]) {
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
    
    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon setImage:[UIImage imageNamed:@"material mywine-19.png"] forState:UIControlStateNormal];
    [icon setFrame:CGRectMake(0,0,30,30)];
    icon.tag = indexPath.row;
    [icon addTarget:self action:@selector(listProvas:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = icon;
    
    cell.textLabel.text = [vinho description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %d", [[vinho winetype] name], [vinho year]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_gradient.png"]];
    cell.textLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT-2];
    cell.detailTextLabel.font = [UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-2];
    
    return cell;
}

- (void)listProvas:(UIButton *) button
{
    _index = (NSUInteger) button.tag;
    [self performSegueWithIdentifier:@"PushProvas" sender:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //fill in provas @ listaprovasviewcontroller
    //_index = indexPath;
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
        
        Vinho* vinho = (Vinho*) [_vinhos objectAtIndex:indexPath.row];
        
        if ([_vinhos removeVinhoAtIndex:indexPath.row]) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //if the displayed wine was deleted
            if (vvc && vvc.detailItem == vinho) {
                //if there are any other wines to be displayed
                if([_vinhos count] > 0) {
                    
                    //show another wine
                    vvc.detailItem = [_vinhos objectAtIndex:0];
                    [vvc configureView];
                }
                //if there are no more wines
                else {
                    //go back home
                    [self performSegueWithIdentifier:@"VinhosToHome" sender:self];
                }
            }
        }
        //removal failure
        else {
            Language* lan = [Language instance];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Error"] message:[lan translate:@"Wine delete fail"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
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
    [[self tableView] reloadData];
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
    //self.filter.title = [lan translate:@"Filter"];
    [self.filterButton setTitle: [lan translate:@"Filter"]];
}

- (IBAction)didPressHomeButton:(id)sender {
    if ([self homeIsVisible])
        return;
    
    [self performSegueWithIdentifier:@"VinhosToHome" sender:self];
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

#pragma mark - VinhoViewController Delegate Methods

- (void) onVinhoEdition:(Vinho*) vinho {
    [[self tableView] reloadData];
}

#pragma mark - DetailViewController Delegate Methods

- (void) detailViewDidDisappear {
    [self setHomeVisibility:FALSE];
    [[self navigationItem] setLeftBarButtonItem:[self tempButton] animated:YES];
    tempButton = nil;

}
- (void) detailViewDidAppear {
    [self setHomeVisibility:TRUE];
    tempButton = [[self navigationItem] leftBarButtonItem];
    [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
}

- (void) orderViewControllerDidSelect:(int)order {
    [_vinhos orderVinhosBy:order];
    [[self tableView] reloadData];
    
    
}

@end
