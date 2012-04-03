//
//  NovaProvaViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NovaProvaViewController.h"

@interface NovaProvaViewController ()

@end

@implementation NovaProvaViewController

@synthesize delegate;
@synthesize sliderLabel;

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
    if(1) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [self setSliderLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)cancel:(id)sender
{
	[self.delegate NovaProvaViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	[self.delegate NovaProvaViewControllerDidSave:self];
}

-(IBAction) sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = (int)(slider.value + 0.5f);
    NSString *newText = [[NSString alloc] init];
    switch(progressAsInt) {
        case 1:
            newText = @"Mau";
            break;
        case 2:
            newText = @"Razoavel";
            break;
        case 3:
            newText = @"Bom";
            break;
        case 4:
            newText = @"Muito Bom";
            break;
        case 5:
            newText = @"Excelente";
            break;
        default :
            newText = @"";
            break;
    }
    sliderLabel.text=newText;
}

@end
