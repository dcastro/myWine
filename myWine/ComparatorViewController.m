//
//  ComparatorViewController.m
//  myWine
//
//  Created by Diogo Castro on 10/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ComparatorViewController.h"
#import "AppDelegate.h"
#import "ProvaViewController.h"
#import "Comparator.h"
#import "User.h"
#import "ComparatorCell.h"
#import <objc/runtime.h>

@interface ComparatorViewController ()

@end

@implementation ComparatorViewController
@synthesize tableViewA;
@synthesize tableViewB;
@synthesize cancelButton;
@synthesize provaA, provaB;

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
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.provaVC1 = [storyboard instantiateViewControllerWithIdentifier:@"ProvaController"];
    self.provaVC2 = [storyboard instantiateViewControllerWithIdentifier:@"ProvaController"];
    
    self.prova1 = [Comparator instance].prova1;
    self.prova2 = [Comparator instance].prova2;
    
    self.provaVC1.vinho = [[[User instance] vinhos] objectAtIndex:0];
    self.provaVC1.prova_mode = CRITERIA_MODE;
    self.provaVC1.prova = self.prova1;
    
    self.provaVC2.vinho = [[[User instance] vinhos] objectAtIndex:0];
    self.provaVC2.prova_mode = CRITERIA_MODE;
    self.provaVC2.prova = self.prova2;
    
    
    [[[self view] viewWithTag:1] addSubview:self.provaVC1.view];
    [[[self view] viewWithTag:2] addSubview:self.provaVC2.view];
    
    [[[[self.view viewWithTag:1] subviews] objectAtIndex:0] setClipsToBounds:YES];
    NSLog(@"class %s", class_getName([[[[self.view viewWithTag:1] subviews] objectAtIndex:0] class]));
    NSLog(@"class %i", [[[self.view viewWithTag:1] subviews] count] );*/
    
    self.provaA = [Comparator instance].prova1;
    self.provaB = [Comparator instance].prova2;
    
    [self tableViewA].delegate = self;
    [self tableViewA].dataSource = self;
    
    [self tableViewB].delegate = self;
    [self tableViewB].dataSource = self;
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setTableViewA:nil];
    [self setTableViewB:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == tableViewA) {
        return [provaA.sections count];
    }
    else if (tableView == tableViewB) {
        return [provaB.sections count];
    }
    else return 0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tableViewA) {
        return [[[provaA.sections objectAtIndex:section] criteria] count];
    }
    else if (tableView == tableViewB) {
        return [[[provaB.sections objectAtIndex:section] criteria] count];
    }
    else return 0;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    Seccao* criteriaSection;
    
    if(tableView == tableViewA)
        criteriaSection = (Seccao*) [self.provaA.sections objectAtIndex:section];
    else if (tableView == tableViewB)
        criteriaSection = (Seccao*) [self.provaB.sections objectAtIndex:section];
    
    return [criteriaSection name];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ComparatorCell";
    
    ComparatorCell *cell = (ComparatorCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        //cell = [[CriterionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ComparatorCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ComparatorCell class]])
            {
                cell = currentObject;
                break;
            }
        }
        
    }
    
    Seccao* section;
    
    if(tableView == tableViewA)
        section = (Seccao*) [self.provaA.sections objectAtIndex:indexPath.section];
    else if (tableView == tableViewB)
        section = (Seccao*) [self.provaB.sections objectAtIndex:indexPath.section];
    
    Criterio* criterion = (Criterio*) [section.criteria objectAtIndex:indexPath.row];
    
    [cell setCellType: (tableView == tableViewA)? ComparatorCellTypeA : ComparatorCellTypeB];
    [cell setCriterion:criterion];
    
    return cell;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)cancel:(id)sender {
    AppDelegate* del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [del hideComparator];
}
@end
