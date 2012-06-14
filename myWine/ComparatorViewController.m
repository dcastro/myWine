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
@synthesize scoreView2;
@synthesize scoreView1;
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
    
    [self.tableViewA setBackgroundView:nil];
    [self.tableViewA setBackgroundColor:[UIColor myWineColorGrey]];
    [self.tableViewB setBackgroundView:nil];
    [self.tableViewB setBackgroundColor:[UIColor myWineColorGrey]];
    
    [self.header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    [self.scoreView1 setBackgroundColor:[UIColor myWineColorGrey]];
    [self.scoreView2 setBackgroundColor:[UIColor myWineColorGrey]];
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
    [self setScoreView2:nil];
    [self setScoreView1:nil];
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

- (void) styleLabel:(UILabel*)label withTitle: (NSString*) title {
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor myWineColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = title;
    [label sizeToFit];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    [self styleLabel:label withTitle:sectionTitle];
    NSLog(@"%f %f", self.tableViewA.frame.size.width,label.frame.size.width);
    if(tableView == tableViewA)
        label.frame = CGRectMake(self.tableViewA.frame.size.width - 50 - label.frame.size.width, 6, 300, 30);
    else if (tableView == tableViewB)
        label.frame = CGRectMake(50, 6, 300, 30);
    
    
    
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view setBackgroundColor:[UIColor myWineColorGrey ]];
    [view addSubview: label];
    
    if(tableView == tableViewA)
         [[self.provaA.sections objectAtIndex:section] setLabel:label];
    else if (tableView == tableViewB)
         [[self.provaB.sections objectAtIndex:section] setLabel:label];
    
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [view setBackgroundColor:[UIColor myWineColorGrey ]];
    
    return view;
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
