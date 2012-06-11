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
#import <objc/runtime.h>

@interface ComparatorViewController ()

@end

@implementation ComparatorViewController
@synthesize cancelButton;
@synthesize prova1, prova2;
@synthesize provaVC1, provaVC2;

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
    NSLog(@"class %i", [[[self.view viewWithTag:1] subviews] count] );
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
