//
//  MySplitViewViewController.m
//  myWine
//
//  Created by Diogo Castro on 10/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "MySplitViewViewController.h"
#import <objc/runtime.h>

@interface MySplitViewViewController ()

@end

@implementation MySplitViewViewController

@synthesize shouldRotate;

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
    shouldRotate = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(shouldRotate)
        return YES;
    else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
}

- (void) translate {
    for(UINavigationController* navController in self.viewControllers) {
        //NSLog(@"class: %s", class_getName([navController class]));
        for (id<TranslatableViewController> viewController in navController.viewControllers) {
            //NSLog(@"-class: %s", class_getName([viewController class]));
            if ([viewController respondsToSelector:@selector(translate)]) {
                [viewController translate];
                NSLog(@"-class: %s translated", class_getName([viewController class]));
            }
            else {
                NSLog(@"***class: %s cannot be translated", class_getName([viewController class]));
            }
        }
    }
}

-(void)dismiss {
    for(UINavigationController* navController in self.viewControllers) {
        for (UIViewController *viewController in navController.viewControllers) {
            [viewController dismissModalViewControllerAnimated:NO];
        }
        [navController dismissModalViewControllerAnimated:NO];
    }
}

@end
