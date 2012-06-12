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
#import "Language.h"
#import <objc/runtime.h>

@interface ComparatorViewController ()

@end

@implementation ComparatorViewController
@synthesize tableViewA;
@synthesize tableViewB;
@synthesize scoreContentLabelA;
@synthesize scoreContentLabelB;
@synthesize header;
@synthesize provaAlabel;
@synthesize provaBlabel;
@synthesize provaAdate;
@synthesize provaBdate;
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
    
    self.provaA = [Comparator instance].prova1;
    self.provaB = [Comparator instance].prova2;
    
    [self tableViewA].delegate = self;
    [self tableViewA].dataSource = self;
    
    [self tableViewB].delegate = self;
    [self tableViewB].dataSource = self;
    
    [self configureView];
    
    [self.header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    [self.provaAlabel setText:self.provaA.vinho.name];
    [self.provaAlabel setFont:[UIFont fontWithName:@"DroidSerif" size:LARGE_FONT]];
    [self.provaBlabel setText:self.provaB.vinho.name];
    [self.provaBlabel setFont:[UIFont fontWithName:@"DroidSerif" size:LARGE_FONT]];
    [self.provaAdate setText:[self.provaA fullDate]];
    [self.provaAdate setFont:[UIFont fontWithName:@"DroidSerif" size:SMALL_FONT]];
    [self.provaBdate setText:[self.provaB fullDate]];
    [self.provaBdate setFont:[UIFont fontWithName:@"DroidSerif" size:SMALL_FONT]];
}


- (void) configureView {
    
    [self.cancelButton setTitle:[[Language instance] translate:@"Cancel"]];
    
    NSString* string = [[NSString alloc] initWithFormat:@"%i%%", [self.provaA calcScore]];
    self.scoreContentLabelA.text = string;
    [self.scoreContentLabelA setFont:[UIFont fontWithName:@"DroidSerif" size:LARGER_FONT]];
    
    string = [[NSString alloc] initWithFormat:@"%i%%", [self.provaB calcScore]];
    self.scoreContentLabelB.text = string;
    [self.scoreContentLabelB setFont:[UIFont fontWithName:@"DroidSerif" size:LARGER_FONT]];
    if([self.provaA calcScore]>[self.provaB calcScore]){
        [self.scoreContentLabelA setFont:[UIFont fontWithName:@"DroidSerif" size:LARGER_FONT+8]];
        [self.scoreContentLabelA setTextColor:[UIColor myWineColor]];
    }
    else if([self.provaA calcScore]<[self.provaB calcScore]){
        [self.scoreContentLabelB setFont:[UIFont fontWithName:@"DroidSerif" size:LARGER_FONT+8]];
        [self.scoreContentLabelB setTextColor:[UIColor myWineColor]];
    }
        
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setTableViewA:nil];
    [self setTableViewB:nil];
    [self setScoreContentLabelA:nil];
    [self setScoreContentLabelB:nil];
    [self setHeader:nil];
    [self setProvaAlabel:nil];
    [self setProvaBlabel:nil];
    [self setProvaAdate:nil];
    [self setProvaBdate:nil];
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
