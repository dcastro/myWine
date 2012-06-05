//
//  ListaProvasViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ListaProvasViewController.h"

@interface ListaProvasViewController () {NSMutableArray *_objects;}

@end

@implementation ListaProvasViewController
@synthesize filterButton;
@synthesize compareButton;
@synthesize provas = _provas;
@synthesize vinho = _vinho;
@synthesize currentPopover;
@synthesize needsEditing;

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
    
    [self configureView];

}

- (void) configureView {
    Language* lan = [Language instance];
    [self.filterButton setTitle: [lan translate:@"Filter"]];
    [self.compareButton setTitle: [lan translate:@"Compare"]];
}


- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [self setCompareButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillDisappear:(BOOL)animated {
    
    //remove all observers
    for(int i = 0; i < [self.provas count]; i++) {
        ProvaCell* cell = (ProvaCell*) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CheckboxButton* checkbox = (CheckboxButton*) [cell viewWithTag:1];
        
        [checkbox removeObserver:cell forKeyPath:@"selected"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([segue.identifier isEqualToString:@"showProva"]) {
        
        SubstitutableTabBarControllerViewController* tabBarController = (SubstitutableTabBarControllerViewController*) [segue.destinationViewController topViewController];
        Prova* prova = [_provas objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        //ProvaCriteriaViewController* pcvc = (ProvaCriteriaViewController*) [[tabBarController viewControllers] objectAtIndex:0];
        //pcvc.prova = prova;
        tabBarController.vinho = self.vinho;
        tabBarController.prova = prova;
        
        if (needsEditing) {
            needsEditing = false;
            
            tabBarController.needsEditing = true;
        }
        
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
    else if([segue.identifier isEqualToString:@"filterSegue"])
    {
        action = [sender action];
        target = [sender target];
        
        [sender setTarget:self];
        [sender setAction:@selector(dismiss:)];
        
        self.currentPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }

    
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
    
    if ([segue.identifier isEqualToString:@"showProva"]) { 
        if (rootPopoverButtonItem != nil) {
            SubstitutableTabBarControllerViewController* detailViewController = (SubstitutableTabBarControllerViewController*)[segue.destinationViewController topViewController];
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
    ProvaCell *cell = (ProvaCell*) [tableView dequeueReusableCellWithIdentifier:@"Prova"];
    
    Prova *object = [_provas objectAtIndex:indexPath.row];
    cell.textLabel.text = object.shortDate;
    cell.detailTextLabel.text = @""; //[NSString stringWithFormat:@"%d", object.tasting_id];
    
    //initialize the checkbox button
    CheckboxButton* checkbox = [CheckboxButton createWithTarget:self andPosition:cell.frame.size.width - 50];

    //hides the checkbox unless comparation mode is on.
    [checkbox setHidden: ! [Comparator isComparing]];
    
    if([Comparator isRegistered:object])
        [checkbox setSelected:YES];

    
    [cell addSubview:checkbox];
    
    [cell setProva:object];
    
    [checkbox addObserver:cell forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    

    return cell;
}

-(void) checkboxClicked:(UIButton*) sender {
    [sender setSelected: !sender.selected];
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

- (IBAction)addTasting:(id)sender {
    Prova* prova = [FormularioProva generateTasting:self.vinho.winetype]; //[[self provas] objectAtIndex:0];
    
    //index calculation
    int index = [self.provas count];
    NSIndexPath* path = [NSIndexPath indexPathForRow:index inSection:0]; 
    NSArray *paths = [NSArray arrayWithObject: path];
    
    //begin row insertion
    [[self tableView] beginUpdates];
    {
        //insertion of the tasting
#warning TODO:DIOGO tratar erro
        if([self.provas insertProva:prova atIndex:index withVinhoID: self.vinho.wine_id])
            NSLog(@"sucess on insertion");
        else
            NSLog(@"failure to insert");
        //[self.provas insertObject:prova atIndex:index];
        
        //insertion of the row
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    //end row insertion
    [[self tableView] endUpdates];
    

    //scroll to the inserted row and select it
    [[self tableView] scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [[self tableView] selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    //presents the newly added tasting
    self.needsEditing = YES;
    [self performSegueWithIdentifier:@"showProva" sender:self];
}

- (IBAction)toggleComparison:(id)sender {
    [Comparator setComparing: ![Comparator isComparing]];
    
    
    //unhide
    if([Comparator isComparing]) {
        for(int i = 0; i < [self.provas count]; i++) {
            ProvaCell* cell = (ProvaCell*) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CheckboxButton* checkbox = (CheckboxButton*) [cell viewWithTag:1];
            [checkbox setHidden: NO animated:YES];
        }
    }
    //hide
    else {
        for(int i = 0; i < [self.provas count]; i++) {
            ProvaCell* cell = (ProvaCell*) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            CheckboxButton* checkbox = (CheckboxButton*) [cell viewWithTag:1];
            
            [checkbox setHidden: YES animated:YES];
        }
        
    }
}
@end
