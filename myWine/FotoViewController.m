//
//  FotoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "FotoViewController.h"

@interface FotoViewController ()

@end

@implementation FotoViewController
@synthesize Cancel;
@synthesize Done;
@synthesize NewPhoto;

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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera (needs real iPad !!)
    //imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    Language* lang = [Language instance];
    
    [self.Cancel setTitle:[lang translate:@"Cancel"]];
    
    [self.Done setTitle:[lang translate:@"Done"]];
    
    [self.NewPhoto setTitle:[lang translate:@"New Photo"]];
    
    // Delegate is self
    //imagePicker.delegate = self;
    
    // Show image picker
    //[self presentModalViewController:imagePicker animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCancel:nil];
    [self setDone:nil];
    [self setNewPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)cancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)done:(id)sender
{
	// TODO
}


@end
