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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
