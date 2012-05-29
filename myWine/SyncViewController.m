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
    
    lan = [Language instance];
    sync = [[Sincronizacao alloc]init];

    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view insertSubview:background atIndex:0];
    self.title = [lan translate:@"Synchronizing"];
    
    self.description_label.text = [lan translate:@"Synchronization frase"];
    self.description_label.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];
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
    
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 1,3];
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
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 2,3];
    [progress_bar setProgress:0.50];
    
    if(![sync parseData:receivedData]){
        [progress_bar setProgress:0.0];
        self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];
#warning FERNANDO: mostrar aviso
        return;
    };
    
    [progress_bar setProgress:1.0];
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 3,3];

    
}




- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

@end
