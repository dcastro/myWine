//
//  SyncViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "SyncViewController.h"
#import "Sincronizacao.h"
#import "Language.h"

@interface SyncViewController ()

@end

@implementation SyncViewController
@synthesize description_label;
@synthesize progress_label;
@synthesize progress_bar;

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
    
    Language *lan = [Language instance];

    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view insertSubview:background atIndex:0];
    self.title = [lan translate:@"Synchronizing"];
    
    self.description_label.text = [lan translate:@"Synchronization frase"];
    self.description_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.progress_label.text = [NSString stringWithFormat:[lan translate:@"Synchronization step"], 3, 5];
    self.progress_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:SMALL_FONT];

    
    [progress_bar setProgress:0.0];
    
    
    [self startsync];
    
}

- (void)viewDidUnload
{
    [self setDescription_label:nil];
    [self setProgress_label:nil];
    [self setProgress_bar:nil];
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



- (void) startsync{
    receivedData = [[NSMutableData data]init];
    
    NSString *jsonRequest = @"{\"accessKey\":\"mywine\",\"userid\":\"mywine@cpcis.pt\",\"MyWines\":null}";
    NSURL *url = [NSURL URLWithString:@"http://backofficegp.cpcis.pt/MyWineSincService/MyWineSincService.svc/MyWineSincronize"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    
    NSURLConnection * theConnection = [NSURLConnection connectionWithRequest:[request copy] delegate:self];
    
    
    if (!theConnection) {
        DebugLog(@"Connection Failed");
    }
    
    [progress_bar setProgress:0.2]; 
}



- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if(data == nil){
        DebugLog(@"Didnt receive any data");
    }else{
        [receivedData appendData:data];
    }
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [progress_bar setProgress:0.50];
    
    NSError *jsonParsingError = nil;
    NSDictionary *ob = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];
    
    NSString *output = [NSString stringWithFormat:@"%@",  ob];
    
    DebugLog(@"JSON: %@", output);
    
    [progress_bar setProgress:1.0];
    
}

@end
