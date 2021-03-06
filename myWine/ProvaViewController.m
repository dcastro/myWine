//
//  ProvaViewController.m
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ProvaViewController.h"
#import "Language.h"
#import <objc/runtime.h> 
#import <QuartzCore/QuartzCore.h>
#import "SubstitutableTabBarControllerViewController.h"

@interface ProvaViewController ()

@end

@implementation ProvaViewController
@synthesize prova = _prova;
@synthesize vinho = _vinho;
@synthesize upperView = _upperView;
@synthesize commentContentLabel = _commentContentLabel;
@synthesize commentContentTextView = _commentContentTextView;
@synthesize commentLabel = _commentLabel;
@synthesize wineNameLabel = _wineNameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize scoreContentLabel = _scoreContentLabel;
@synthesize comentario = _comentario;
@synthesize header = _header;
@synthesize prova_mode;
@synthesize delegate;

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

    //Set fonts
    self.wineNameLabel.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    self.dateLabel.font = [UIFont fontWithName:@"DroidSerif" size:SMALL_FONT];
    
    //hide the text views
    self.commentContentTextView.hidden = TRUE;
    
    //apply rounded corners to text views
    self.commentContentTextView.clipsToBounds = NO;
    self.commentContentTextView.layer.cornerRadius = 10.0f;
    
    //apply shadow
    self.commentContentTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.commentContentTextView.layer.shadowOffset = CGSizeMake(0, 3);
    self.commentContentTextView.layer.shadowOpacity = 0.8;
    self.commentContentTextView.layer.shadowRadius = 10.0;
    
    [self configureView];
    
    if( [self isEditing] ) {
        [self setEditing:YES animated:YES done:NO];
    }
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor myWineColorGrey]];
    
}

- (void) configureView {
    
    //header
    NSString* wineNameLabelText = [[NSString alloc] initWithFormat:@"%@: %@", [[Language instance] translate:@"Tasting of"], self.vinho.name];
    [self.wineNameLabel setText:wineNameLabelText];
    
    [self.dateLabel setText:[self.prova fullDate] ];
    
    // Setup the background
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self header] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self header] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }

    
    
    //footer
    [self styleLabel:self.commentLabel withTitle: [[Language instance] translate:@"Comment"]];
    [self.commentLabel setFont:[UIFont fontWithName:@"DroidSans" size:SMALL_FONT]];
    
    [self.commentContentLabel setText: self.prova.comment];
    [self.commentContentLabel setFont:[UIFont fontWithName:@"DroidSans" size:SMALL_FONT]];
    self.commentContentLabel.numberOfLines = 0;
    [self.commentContentLabel sizeToFit];
    
    self.scoreLabel.text = [[Language instance] translate:@"Score"];
    [self.scoreLabel setFont:[UIFont fontWithName:@"DroidSerif" size:NORMAL_FONT]];
    [self.scoreLabel setTextColor:[UIColor myWineColor]];
    NSString* string = [[NSString alloc] initWithFormat:@"%i%%", [self.prova calcScore]];
    self.scoreContentLabel.text = string;
    [self.scoreContentLabel setFont:[UIFont fontWithName:@"DroidSerif" size:LARGER_FONT+10]];
    
    if(prova_mode == CHARACTERISTICS_MODE){
        [self.scoreLabel setHidden:YES];
        [self.scoreContentLabel setHidden:YES];
        
        CGRect frame = self.comentario.frame;
        frame.origin.y = 20;
        self.comentario.frame = frame;
    }
}


- (int) updateScoreLabel {
    
    int score = 0, max = 0;
    
    for( Seccao* section in self.prova.sections) {
        for( Criterio* criterion in section.criteria ) {
            if(criterion.classification != nil)
                score += criterion.classification.weight;
            else 
                score += criterion.classification_chosen.weight;
            max += criterion.maxWeight;
        }
    }
    int percentage = ((float) score/ (float) max) * 100.0;
    [self updateScoreLabelWithScore:percentage];
    
    return percentage;
}

-(void) updateScoreLabelWithScore:(int) score {
    NSString* string = [[NSString alloc] initWithFormat:@"%i%%", score];
    
    if(! [self.scoreContentLabel.text isEqualToString:string]) {
        
        [UIView animateWithDuration:0.3 animations:^() {
            self.scoreContentLabel.alpha = 0.0;
        }];
        
        self.scoreContentLabel.text = string;
        
        [UIView animateWithDuration:0.3 animations:^() {
            self.scoreContentLabel.alpha = 1.0;
        }];
    }    
}

- (void) styleLabel:(UILabel*)label withTitle: (NSString*) title {
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor myWineColor];
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
    [view setBackgroundColor:[UIColor myWineColorGrey ]];
    [view addSubview: label];
    
    //save label
    if(prova_mode == CRITERIA_MODE)
        [[self.prova.sections objectAtIndex:section] setLabel:label];
    else if (prova_mode == CHARACTERISTICS_MODE)
        [[self.prova.characteristic_sections objectAtIndex:section] setLabel:label];
    
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [view setBackgroundColor:[UIColor myWineColorGrey ]];
    
    return view;
}


- (void)viewDidUnload
{

    [self setCommentContentLabel:nil];
    [self setCommentLabel:nil];
    [self setUpperView:nil];
    [self setWineNameLabel:nil];
    [self setDateLabel:nil];
    [self setCommentContentTextView:nil];
    [self setScoreLabel:nil];
    [self setScoreContentLabel:nil];
    [self setComentario:nil];
    [self setHeader:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}

- (void)dealloc {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    switch (prova_mode) {
        case CRITERIA_MODE:
            return [self.prova.sections count];
        case CHARACTERISTICS_MODE:
            return [self.prova.characteristic_sections count];
        default:
            return 0;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return section header title.
    switch (prova_mode) {
        case CRITERIA_MODE:
            return [[self.prova.sections objectAtIndex:section] description];
        case CHARACTERISTICS_MODE:
            return [[self.prova.characteristic_sections objectAtIndex:section] description];
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (prova_mode) {
        case CRITERIA_MODE:
            return [((Seccao*) [self.prova.sections objectAtIndex:section]).criteria count];
        case CHARACTERISTICS_MODE:
            return [((SeccaoCaracteristica*) [self.prova.characteristic_sections objectAtIndex:section]).characteristics count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    switch (prova_mode) {
        case CRITERIA_MODE: {
            Seccao* section = (Seccao*) [self.prova.sections objectAtIndex:indexPath.section];
            Criterio* criterion = (Criterio*) [section.criteria objectAtIndex:indexPath.row];
            CellIdentifier = [NSString stringWithFormat:@"criterion %i", criterion.criterion_id];
            break;
            
        }
            
        case CHARACTERISTICS_MODE: {
            SeccaoCaracteristica* section = (SeccaoCaracteristica*) [self.prova.characteristic_sections objectAtIndex:indexPath.section];
            Caracteristica* characteristic = (Caracteristica*) [section.characteristics objectAtIndex:indexPath.row];
            CellIdentifier = [NSString stringWithFormat:@"characteristic %i", characteristic.characteristic_id];
        }
            
    }
    
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SectionItemCell *cell = (SectionItemCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Nova cell
    if(cell == nil) {
        //cell = [[CriterionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SectionItemCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[SectionItemCell class]])
            {
                cell = currentObject;
                break;
            }
        }
        
        [cell setDelegate:self];
        
        switch (prova_mode) {
            case CRITERIA_MODE: {
                Seccao* section = (Seccao*) [self.prova.sections objectAtIndex:indexPath.section];
                Criterio* criterion = (Criterio*) [section.criteria objectAtIndex:indexPath.row];
                object_setClass(cell, [CriterionCell class]);
                [cell setItem:criterion];
                break;
                
            }
                
            case CHARACTERISTICS_MODE: {
                SeccaoCaracteristica* section = (SeccaoCaracteristica*) [self.prova.characteristic_sections objectAtIndex:indexPath.section];
                Caracteristica* characteristic = (Caracteristica*) [section.characteristics objectAtIndex:indexPath.row];
                object_setClass(cell, [CharacteristicCell class]);
                [cell setItem:characteristic];
            }
                
        }

    }
    //Cell reusada
    else {
        //needs resetting
        if( ((int)cell.classificationSlider.value) != [cell itemWeight:[[ cell item] classification]]  ) {
            cell.classificationSlider.value = [cell itemWeight:[[ cell item] classification]];
            [cell drawClassificationLabel:[[cell item] classification] animated:NO];
            
        }
        
        [cell.nameLabel setText: [[cell item] name]];
        [cell drawClassificationLabel: [[cell item] classification] animated:NO];
        
    }
    
    return cell;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated done:(BOOL)done {
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve;  
    
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:options  
                    animations:^{
                        self.commentContentLabel.hidden = editing;
                        self.commentContentTextView.hidden = !editing;
                    
                    }  
                    completion:NULL];  
    
    [super setEditing:editing animated:animated];
    
    //if the edition was canceled
    if (!editing && !done) {
        
        //cancel changes
        [self forEveryCell:^(CriterionCell* cell) {
            [cell resetState];
            //[[cell item] setClassification:[[cell item ] classification_chosen]];
            

            
        } ];
        if(prova_mode == CRITERIA_MODE) {
            for( Seccao* section in self.prova.sections) {
                for( Criterio* criterion in section.criteria ) {
                    [criterion setClassification:criterion.classification_chosen];
                }
                
            }
        }
        else if (prova_mode == CHARACTERISTICS_MODE) {
            for( SeccaoCaracteristica* section in self.prova.characteristic_sections) {
                for( Caracteristica* characteristic in section.characteristics ) {
                    [characteristic setClassification:characteristic.classification_chosen];
                }
                
            }
        }
        
        if(prova_mode == CRITERIA_MODE) {
            int score = [self updateScoreLabel];
            [self.delegate scoreUpdated:score];
        }
        [self.view endEditing:YES];
        
    }
    //if the edition was completed successfully
    else if (!editing) {
        
        //save changes
        /*[self forEveryCell:^(CriterionCell* cell) {
            [cell commitEdit];
        } ];*/
        
        if (prova_mode == CRITERIA_MODE) {
            
            for(Seccao* s in self.prova.sections) {
                for(Criterio* c in s.criteria) {
                    [c save];
                }
            }            
            
        } else if ( prova_mode == CHARACTERISTICS_MODE) {
            for(SeccaoCaracteristica* s in self.prova.characteristic_sections) {
                for(Caracteristica* c in s.characteristics) {
                    [c save];
                }
            }  
        }
        
        //update comment label
        [self updatedCommentLabel];
        [self.view endEditing:YES];
    }
    //if the edition is about to begin
    else if (editing) {
        self.commentContentTextView.text = self.commentContentLabel.text;
    }
}

- (void) updatedCommentLabel {
    //update label
    self.commentContentLabel.text = self.prova.comment;
    
    //adjust label size
    [self.commentContentLabel sizeToFit];
    CGRect frame = self.commentContentLabel.frame;
    frame.size.width = 633;
    self.commentContentLabel.frame = frame;
    
}

// Executes the given block for all cells
-(void) forEveryCell:(void (^)(CriterionCell*)) block {
    for(int i = 0; i < self.prova.sections.count; i++) {
        Seccao* seccao = [self.prova.sections objectAtIndex:i];
        
        for(int j = 0; j < seccao.criteria.count; j++) {
            CriterionCell* cell = (CriterionCell*) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            block(cell);
        }
        
    }
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

#pragma mark - CriterionCell Delegate Method

- (void) sectionItemCellDidUpdateClassification {
    //[self updateScoreLabel];
    if (prova_mode == CRITERIA_MODE) {
        int score = [self updateScoreLabel];
        [self.delegate scoreUpdated:(int) score];
    }
}

#pragma mark - Translatable Delegate Method
- (void) translate {
    //header
    NSString* wineNameLabelText = [[NSString alloc] initWithFormat:@"%@: %@", [[Language instance] translate:@"Tasting of"], self.vinho.name];
    [self.wineNameLabel setText:wineNameLabelText];
    
    [self.dateLabel setText:[self.prova fullDate] ];
    
    //footer
    [self.commentLabel setText:[[Language instance] translate:@"Comment"]];
    self.scoreLabel.text = [[Language instance] translate:@"Score"];
    
    //traduz section headers
    if (prova_mode == CRITERIA_MODE) {
        for(Seccao* section in self.prova.sections) {
            [section.label setText:section.name];
        }
    }
    else if (prova_mode == CHARACTERISTICS_MODE) {
        for(SeccaoCaracteristica* section in self.prova.sections) {
            [section.label setText:section.name];
        }
    }
    
    //traduz labels das cells
    [self forEveryCell:^(CriterionCell* cell) {
        [cell translate];
    } ]; 
    
}

@end
