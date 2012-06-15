//
//  HelpViewController.m
//  myWine
//
//  Created by André Dias on 01/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize faq;
@synthesize pergunta1;
@synthesize resposta1;
@synthesize pergunta2;
@synthesize resposta2;
@synthesize pergunta3;
@synthesize resposta3;
@synthesize pergunta4;
@synthesize resposta4;
@synthesize pergunta5;
@synthesize resposta5;
@synthesize tabSelector;

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
    
    Language *lan = [Language instance];
    
	self.faq.text = [lan translate:@"FAQ"];
    self.faq.font = [UIFont fontWithName:@"DroidSerif-Bold" size:TITLE_FONT];
    self.pergunta1.text = [lan translate:@"P1"];
    self.pergunta1.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.pergunta2.text = [lan translate:@"P2"];
    self.pergunta2.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.pergunta3.text = [lan translate:@"P3"];
    self.pergunta3.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.pergunta4.text = [lan translate:@"P4"];
    self.pergunta4.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.pergunta5.text = [lan translate:@"P5"];
    self.pergunta5.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    
    self.resposta1.text = [lan translate:@"R1"];
    self.resposta1.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.resposta2.text = [lan translate:@"R2"];
    self.resposta2.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.resposta3.text = [lan translate:@"R3"];
    self.resposta3.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.resposta4.text = [lan translate:@"R4"];
    self.resposta4.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.resposta5.text = [lan translate:@"R5"];
    self.resposta5.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    
    self.tabSelector.title = [lan translate:@"FAQ"];
    [[self.tabBarController.viewControllers objectAtIndex:1] setTitle:[lan translate:@"Contacts"]];
}

- (void)viewDidUnload
{
    [self setPergunta1:nil];
    [self setResposta1:nil];
    [self setPergunta2:nil];
    [self setResposta2:nil];
    [self setPergunta3:nil];
    [self setResposta3:nil];
    [self setPergunta4:nil];
    [self setResposta4:nil];
    [self setPergunta5:nil];
    [self setResposta5:nil];
    [self setFaq:nil];
    [self setTabSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
