//
//  ProvaCriteriaViewController.m
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ProvaCriteriaViewController.h"
#import "Language.h"
#import <objc/runtime.h> 

@interface ProvaCriteriaViewController ()

@end

@implementation ProvaCriteriaViewController
@synthesize prova = _prova;
@synthesize vinho = _vinho;
@synthesize bottomScrollView = _bottomScrollView;
@synthesize upperView = _upperView;
@synthesize commentContentLabel = _commentContentLabel;
@synthesize commentLabel = _commentLabel;
@synthesize wineNameLabel = _wineNameLabel;
@synthesize dateLabel = _dateLabel;

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
    
    
    //Makes upperView's background transparent
    //[self.upperView setBackgroundColor:[UIColor clearColor]];
    
    //Fetch the data objects from the tab bar parent
    SubstitutableTabBarControllerViewController* tabBarController = (SubstitutableTabBarControllerViewController*) [self tabBarController];
    self.vinho = [tabBarController vinho];
    self.prova = [tabBarController prova];
    
    //Set fonts
    self.wineNameLabel.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    self.dateLabel.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT+2];
    
    [self configureView];
    
}

- (void) configureView {
    
    //header
    NSString* wineNameLabelText = [[NSString alloc] initWithFormat:@"%@: %@", [[Language instance] translate:@"Tasting of"], self.vinho.name];
    [self.wineNameLabel setText:wineNameLabelText];
    
    [self.dateLabel setText:[self.prova fullDate] ];
    
    
    //footer
    [self styleLabel:self.commentLabel withTitle: [[Language instance] translate:@"Comment"]];
    
    [self.commentContentLabel setText: self.prova.comment];
    self.commentContentLabel.numberOfLines = 0;
    [self.commentContentLabel sizeToFit];
    
    
    /*
    NSArray* views = [[self tableView] subviews];
    for(int i = 0; i < views.count; i++) {
        const char* className = class_getName([[views objectAtIndex:i] class]);
        NSLog(@"CLASS: %s", className);
        
        NSArray* views2 = [[views objectAtIndex:i] subviews];
        for(int j = 0; j < views2.count; j++) {
            const char* className = class_getName([[views2 objectAtIndex:j] class]);
            NSLog(@"    CLASS: %s", className);
        }

        
    }*/
    
}

- (void) styleLabel:(UILabel*)label withTitle: (NSString*) title {
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
                                 saturation:1.0
                                 brightness:0.60
                                      alpha:1.0];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(50, 6, 300, 30);
    [self styleLabel:label withTitle:sectionTitle];
    
    
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview: label];
    
    return view;
    
}

- (void)viewDidUnload
{
    [self setBottomScrollView:nil];
    [self setCommentContentLabel:nil];
    [self setCommentLabel:nil];
    [self setUpperView:nil];
    [self setWineNameLabel:nil];
    [self setDateLabel:nil];
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
    return [self.prova.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return section header title.
    return [[self.prova.sections objectAtIndex:section] description];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Seccao* seccao = [self.prova.sections objectAtIndex:section];
    return [seccao.criteria count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CriterionCell *cell = (CriterionCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        //cell = [[CriterionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CriterionCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[CriterionCell class]])
            {
                cell = (CriterionCell *)currentObject;
                break;
            }
        }

    }
    
    // Configure the cell...
    Seccao* section = (Seccao*) [self.prova.sections objectAtIndex:indexPath.section];
    Criterio* criterion = (Criterio*) [section.criteria objectAtIndex:indexPath.row];
    //cell.textLabel.text = [criterion description];
    [cell setCriterion:criterion];
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
