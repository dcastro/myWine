//
//  SubstitutableTabBarControllerViewController.m
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "SubstitutableTabBarControllerViewController.h"
#import "Language.h"


@interface SubstitutableTabBarControllerViewController ()

@end

@implementation SubstitutableTabBarControllerViewController

@synthesize vinho = _vinho, prova = _prova;
@synthesize editButton = _editButton, tempButton = _tempButton;
@synthesize criteriaController = _criteriaController, characteristicsController = _characteristicsController;
@synthesize needsEditing;
@synthesize myDelegate;

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
    
    [self setTitle: self.vinho.name];
    [self.editButton setTitle:[[Language instance] translate:@"Edit"]];
    
    //fetch tabs' controllers
    self.criteriaController = [[self viewControllers] objectAtIndex:0];
    self.characteristicsController = [[self viewControllers] objectAtIndex:1];
    
    //set Tab Bar items
    Language* lan = [Language instance];
    UITabBarItem* criteriaItem = [[UITabBarItem alloc] initWithTitle:[lan translate:@"Criteria"] image:[UIImage imageNamed:@"criteria.png"] tag:0];
    UITabBarItem* characteristicsItem = [[UITabBarItem alloc] initWithTitle:[lan translate:@"Characteristics"] image:[UIImage imageNamed:@"chars.png"] tag:1];
    
    self.criteriaController.tabBarItem = criteriaItem;
    self.characteristicsController.tabBarItem = characteristicsItem;
    
    //set tabs' modes
    self.criteriaController.prova_mode = CRITERIA_MODE;
    self.characteristicsController.prova_mode = CHARACTERISTICS_MODE;
    
    //set tabs' data sources
    self.criteriaController.prova = self.prova;
    self.criteriaController.vinho = self.vinho;
    self.characteristicsController.prova = self.prova;
    self.characteristicsController.vinho = self.vinho;
    
    
    //delegate
    self.criteriaController.delegate = self;
    
    self.delegate = self;
    
    if(needsEditing) {
        [self setNeedsEditing: false];
        [self toggleEdit:self];
    }
    
}

- (void)viewDidUnload
{
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Tab Bar Controller delegate methods
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    ProvaViewController *currentVC = (ProvaViewController*) [tabBarController selectedViewController];
    ProvaViewController* destinationVC = (ProvaViewController*) viewController;
    
    if (currentVC == destinationVC)
        return NO;
    
    
    if ([self isEditing]) {
        destinationVC.commentContentTextView.text = currentVC.commentContentTextView.text;
    }
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.delegate = self;    
    
    if(currentVC == self.criteriaController) {
        transition.subtype = kCATransitionFromRight;
    } else {
        transition.subtype = kCATransitionFromLeft;
    }
    
    [[[[[self view] subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    [currentVC viewWillAppear:YES];
    [destinationVC viewWillDisappear:YES];
    [destinationVC viewDidDisappear:YES];
    [currentVC viewDidAppear:YES];
    /*
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve;  
    
    [UIView transitionWithView:tabBarController.view 
                      duration:0.3
                       options:options  
                    animations:^{
                        [currentVC viewWillAppear:YES];
                        [destinationVC viewWillDisappear:YES];
                        [destinationVC viewDidDisappear:YES];
                        [currentVC viewDidAppear:YES];
                        
                    }  
                    completion:NULL];
    */
    return YES;
}


#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([self isEditing]) {
        [self setTempButton:barButtonItem];
        return;
    }
    Language* lan = [Language instance];
    barButtonItem.title = [lan translate:@"Wines List Title"];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([self isEditing]) {
        [self setTempButton:nil];
        return;
    }
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - navigation controls

- (IBAction)toggleEdit:(id)sender {
    
    BOOL isEditing = ! self.isEditing;
    BOOL done = false;
    
    if (isEditing) {
        //switch do doneButton and cancelButton
        Language* lan = [Language instance];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(toggleEdit:)];
        [cancelButton setTintColor: [UIColor colorWithRed:255/255 green:54/255 blue:76/255 alpha:0]];

        [self setTempButton:self.navigationItem.leftBarButtonItem];
        [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES]; 
    } else {
        //switch to editButton
        [[self navigationItem] setRightBarButtonItem:self.editButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:self.tempButton animated:YES];
        [self setTempButton:nil];
        
        UIBarButtonItem* pressedButton = (UIBarButtonItem*) sender;
        done = [pressedButton style] == UIBarButtonItemStyleDone;
        
        if (done) {
            //save prova
            ProvaViewController* selectedVC = (ProvaViewController*) [self selectedViewController];
            self.prova.comment = selectedVC.commentContentTextView.text;
            [self.prova save];

        }

    }
    
    int old_score = self.vinho.score;
    
    //switch editing mode
    [self.criteriaController setEditing: isEditing animated:YES done:done];
    [self.characteristicsController setEditing: isEditing animated:YES done:done];
    [self setEditing:isEditing animated:YES];
    
    int new_score = self.vinho.score;
    
    if(old_score != new_score)
        [myDelegate SubstitutableTabBarControllerViewControllerDidUpdateScore];
}
-(void) scoreUpdated:(int) score {
    [self.characteristicsController updateScoreLabelWithScore:score];
}

#pragma mark - Translatable Delegate Method
- (void) translate {
    Language* lan = [Language instance];
    
    [self.criteriaController translate];
    [self.characteristicsController translate];
    
    //traduzir butoes
    
    if (self.isEditing) {
        //butoes done & cancel
        [[[self navigationItem] rightBarButtonItem] setTitle:[lan translate:@"Done"]];
        [[[self navigationItem] leftBarButtonItem] setTitle:[lan translate:@"Cancel"]];
    }

    [self.editButton setTitle:[[Language instance] translate:@"Edit"]];
    
    [self.criteriaController.tabBarItem setTitle:[lan translate:@"Criteria"]];
    [self.characteristicsController.tabBarItem setTitle:[lan translate:@"Characteristics"]];
}


@end
