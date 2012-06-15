//
//  ListaVinhosViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ListaVinhosViewController.h"
#import "FilterManager.h"
#import "ListaProvasViewController.h"
#import "NSMutableArray+VinhosMutableArray.h"
#import "ListaPaisesViewController.h"
#import "AppDelegate.h"
#import <objc/runtime.h>


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
@synthesize homeButton;
@synthesize filterButton;
@synthesize orderButton;
@synthesize selectedOrder;

SEL action; id target;

@synthesize rootPopoverButtonItem, popoverController, splitViewController, rootTemp;


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
    
    [self.vinhos sectionizeOrderedBy:0];
    Language* lan = [Language instance];
    [self.homeButton setTitle:[lan translate:@"Home"]];
    
    self.tempButton = self.homeButton;
    
}

- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [self setOrderButton:nil];
    [self setHomeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    self.vinhos = [FilterManager applyFilters:[[User instance] vinhos]];
    [self.vinhos sectionizeOrderedBy:self.selectedOrder];
    [[self tableView] reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
        
        UIViewController <SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)[[splitViewController.viewControllers objectAtIndex:1] topViewController];
        [detailViewController showRootPopoverButtonItem:rootTemp];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"vinhosToSync"]) {
        SyncViewController* syncVC = (SyncViewController*) [[segue destinationViewController] topViewController];
        syncVC.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"PushProvas"]) {
        
        ListaProvasViewController* lpvc = (ListaProvasViewController*) [segue destinationViewController ];
        //get the path for the selected button
        UIButton* button = (UIButton*) sender;
        UITableViewCell* cell = (UITableViewCell*) button.superview;
        NSIndexPath* path = [[self tableView] indexPathForCell:cell];
        
        Vinho* vinho = [self.vinhos vinhoForRow:path.row atSection:path.section];
        lpvc.vinho = vinho;
        lpvc.provas = vinho.provas;
        lpvc.delegate = self;
        
        lpvc.rootPopoverButtonItem = self.rootPopoverButtonItem;
        lpvc.popoverController = self.popoverController;
        lpvc.splitViewController = self.splitViewController;
    }
    else if ([segue.identifier isEqualToString:@"showVinho"]) {
        
        vvc = (VinhoViewController*) [segue.destinationViewController topViewController];
        NSIndexPath* path = [self.tableView indexPathForSelectedRow];
        Vinho* vinho = [self.vinhos vinhoForRow:path.row atSection:path.section];
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
        nvvc.vinhos_order = selectedOrder;
		nvvc.delegate = self;
	}
    else if ([segue.identifier isEqualToString:@"VinhosToHome"]) {
        
        DetailViewController* home = segue.destinationViewController;
        home.delegate = self;
        
        NSIndexPath* path = [[self tableView] indexPathForSelectedRow];
        [[self tableView] deselectRowAtIndexPath:path animated:YES];
    }
    else if([segue.identifier isEqualToString:@"orderVinhos"]) {
        
        action = [sender action];
        target = [sender target];
        
        [sender setTarget:self];
        [sender setAction:@selector(dismiss:)];
        
        OrderViewController* ovc = (OrderViewController*) segue.destinationViewController;
        ovc.selectedOrder = [self selectedOrder];
        //NSLog(@"Segue, order %i",[self selectedOrder]);
        ovc.delegate = self;
        
        self.currentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.currentPopover.delegate = (id)self;
        self.popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
    else if ([segue.identifier isEqualToString:@"toFilters"]) {
        NSIndexPath* path = [[self tableView] indexPathForSelectedRow];
        [[self tableView] deselectRowAtIndexPath:path animated:YES];
    }
    
    //switch detail views
    [self switchDetailViews:segue];
}

-(void)dismiss:(id)sender
{
    [self.orderButton setAction:action];
    [self.orderButton setTarget:target];
    [self.currentPopover dismissPopoverAnimated:YES];
}


-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self.orderButton setAction:action];
    [self.orderButton setTarget:target];
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
    
    if ([segue.identifier isEqualToString:@"toFilters"]) {
        if (rootPopoverButtonItem != nil) {
            UIViewController<SubstitutableDetailViewController>* detailViewController = (UIViewController<SubstitutableDetailViewController>*) [segue.destinationViewController topViewController];
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
    
    Vinho* vinho = (Vinho*) sender;
    
    NSString* sectionIdentifier = [self.vinhos sectionIdentifierForVinho:vinho orderedBy:self.selectedOrder];
    
    BOOL hasIdentifier = [self.vinhos hasSection:sectionIdentifier];
    
    
    
    [[self tableView] beginUpdates];
    
    [self.vinhos insertVinho:vinho orderedBy:self.selectedOrder];
    
    if (!hasIdentifier) {
        NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:vinho.section];
        [[self tableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:vinho.row inSection:vinho.section]; 
    NSArray *paths = [NSArray arrayWithObject: path];
    
    [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [[self tableView] endUpdates];
    
    /*
     [self tableView] insertSections:<#(NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
     [self.vinhos insertVinho:sender atIndex:0];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     */
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.vinhos numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vinhos numberOfRowsInSection:section];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.vinhos titleForHeaderInSection:section];
}

-(NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[Language instance] translate:@"Delete"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //NSString *object = [_objects objectAtIndex:indexPath.row];
    Vinho* vinho = [self.vinhos vinhoForRow:indexPath.row atSection:indexPath.section ];
    
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
    [self performSegueWithIdentifier:@"PushProvas" sender:button];
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
        
        Vinho* vinho = (Vinho*) [self.vinhos vinhoForRow:indexPath.row atSection:indexPath.section];
        NSMutableArray* vinhos = [[User instance] vinhos];
        
        int n_sections = [self.vinhos numberOfSections];
        
        if ([vinhos removeVinhoAtRow:indexPath.row inSection:indexPath.section]) {
            
            [[self tableView] beginUpdates];  
            
            self.vinhos = [FilterManager applyFilters:vinhos];
            [self.vinhos sectionizeOrderedBy:self.selectedOrder];
            
            NSArray* paths = [NSArray arrayWithObject:indexPath];
            [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
            
            if (n_sections != [self.vinhos numberOfSections]) {
                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
            }
            
            [[self tableView] endUpdates];
            
            //[[self tableView] reloadData];
            
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
(Vinho*)vinho {
	[self dismissViewControllerAnimated:YES completion:nil];
    
    //[[self tableView] beginUpdates];
    
    NSMutableArray* user_vinhos = [[User instance] vinhos];
    
    [user_vinhos insertVinho:vinho orderedBy:self.selectedOrder];
    self.vinhos = [FilterManager applyFilters:user_vinhos];
    [self.vinhos orderVinhosBy:self.selectedOrder];
    [self.vinhos sectionizeOrderedBy:self.selectedOrder];
    
    /*
     if (vinho.sectionIsNew) {
     NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:vinho.section];
     [[self tableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
     }
     
     NSIndexPath* path = [NSIndexPath indexPathForRow:vinho.row inSection:vinho.section]; 
     NSArray *paths = [NSArray arrayWithObject: path];
     
     [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
     
     
     [[self tableView] endUpdates];
     */
    
    [[self tableView] reloadData];
}


- (void)LoginViewControllerDidLogin:(LoginViewController *)controller {
    NSLog(@"Dismissing LoginController");
    
    self.vinhos = [[User instance] vinhos];
    [self.vinhos orderVinhosBy:selectedOrder];
    [self.vinhos sectionizeOrderedBy:selectedOrder];
    [[self tableView] reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //hide "Wines" button if on landscape
    UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        UIViewController <SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)[[splitViewController.viewControllers objectAtIndex:1] topViewController];
        [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
        rootPopoverButtonItem = nil;
        popoverController = nil;
    }
    
}

- (void) setVinhos:(NSMutableArray*)vinhos {
    if (vinhos != _vinhos) {
        _vinhos = vinhos;
        //[[self tableView] reloadData];
    }
}

-(void) configureView {
    Language* lan = [Language instance];
    
    self.title = [lan translate:@"Wines List Title"];
    self.orderButton.title = [lan translate:@"Order"];
    //self.filter.title = [lan translate:@"Filter"];
    [self.filterButton setTitle: [lan translate:@"Filter"]];
    
    [self.rootPopoverButtonItem setTitle:[lan translate:@"Wines List Title"]];
    [self.rootTemp setTitle:[lan translate:@"Wines List Title"]];
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
    self.rootTemp = barButtonItem;
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
    self.vinhos = [FilterManager applyFilters: [[User instance] vinhos] ];
    [self.vinhos sectionizeOrderedBy:self.selectedOrder];
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

    if(selectedOrder != order) {
        
        [[self tableView] beginUpdates];
        
        //num de secçoes antes da re-ordenaçao
        int nSectionsBefore = [self.vinhos numberOfSections];
        
        //re-ordenaçao
        [self.vinhos orderVinhosBy:order];
        [self.vinhos sectionizeOrderedBy:order];

        //num de secções depois da re-ordenaçao
        int nSectionsAfter = [self.vinhos numberOfSections];

        //indices das secçoes a actualizar
        NSIndexSet* indexSetToDelete = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nSectionsBefore) ];
        NSIndexSet* indexSetToInsert = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nSectionsAfter) ];
        
        //actualizaçao das secçoes
        [[self tableView] deleteSections:indexSetToDelete withRowAnimation:UITableViewRowAnimationTop];
        [[self tableView] insertSections:indexSetToInsert withRowAnimation:UITableViewRowAnimationTop];
        
        [[self tableView] endUpdates];
        
        self.selectedOrder = order;
            
    }
    [self.orderButton setAction:action];
    [self.orderButton setTarget:target];
    [self.popoverController dismissPopoverAnimated:YES];
}

-(void) reloadData {
    [[self tableView] reloadData];
}


#pragma mark - ListaProvas Delegate Methods
-(void) ListaProvasViewControllerDelegateDidUpdateScore {
    //NSLog(@"prova did update score");
    [self.vinhos orderVinhosBy:selectedOrder];
    [self.vinhos sectionizeOrderedBy:selectedOrder];
    [[self tableView] reloadData];
}

- (void) goHome {
    [self performSegueWithIdentifier:@"VinhosToHome" sender:self];
}


#pragma mark - Translatable Delegate Method
- (void) translate {
    Language* lan = [Language instance];
    
    self.title = [lan translate:@"Wines List Title"];
    self.orderButton.title = [lan translate:@"Order"];
    [self.filterButton setTitle: [lan translate:@"Filter"]];
    
    [self.rootPopoverButtonItem setTitle:[lan translate:@"Wines List Title"]];
    [self.rootTemp setTitle:[lan translate:@"Wines List Title"]];
    [[self tableView] reloadData];
    
}

#pragma mark - SyncVC Delegate Method
- (void) SyncViewControllerDidFinishWithStatusCode:(int)code {
    
    Language *lan = [Language instance];

    switch (code) {
        //sucesso
        case 200: {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //reset dos dados
            [[User instance] resetState];
            
            //reload da tabela
            self.vinhos = [FilterManager applyFilters:[[User instance] vinhos]];
            [self.vinhos orderVinhosBy:selectedOrder];
            [self.vinhos sectionizeOrderedBy:selectedOrder];
            [[self tableView] reloadData];
            
            //go back home
            [self performSegueWithIdentifier:@"VinhosToHome" sender:self];
            break;

        }
            
        //credenciais invalidas
        case 400: {            
            [self dismissViewControllerAnimated:YES completion: ^() {
                AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate]; 
                [appDelegate doLogout];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Error"] message:[lan translate:@"Login 400"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }];
            

            //[appDelegate performSelector:@selector(doLogout) withObject:nil afterDelay:3.0];
            
            break;
        }
        //sem conexão
        case 0: {
            [self dismissViewControllerAnimated:YES completion: ^() {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Error"] message:[lan translate:@"Login 0"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }];
            break;
        }
        //outros erros
        default: {
            
            [self dismissViewControllerAnimated:YES completion: ^() {
                NSString* message = [NSString stringWithFormat:@"%@ (%i)", [lan translate:@"Login Default Error"], code];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Error"] message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }];
            break;
        }
    }
    
    
    
}

@end
