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
//@synthesize cancelButton;
@synthesize delegate;

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
    user = [User instance];

    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }

    self.title = [lan translate:@"Synchronizing"];
    
    self.description_label.text = [lan translate:@"Synchronization frase"];
    self.description_label.font = [UIFont fontWithName:@"DroidSans" size:LARGE_FONT];
    
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];
    self.progress_label.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];

    /*
    [self.cancelButton setTitle:[lan translate:@"Cancel"] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    */
    [progress_bar setProgress:0.0];
    
    
    [self startsync];
    
}

- (void)viewDidUnload
{
    [self setDescription_label:nil];
    [self setProgress_label:nil];
    [self setProgress_bar:nil];
    //[self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/*
- (IBAction)cancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
*/


- (void) startsync{
    receivedData = [[NSMutableData data]init];
    NSError * err;
    NSString* testJSON = [sync buildRequest:&err];
    DebugLog(testJSON);
    
    
    /*
    //NSString *jsonRequest = @"{\"Password\":\"mywine\",\"Username\":\"mywine@cpcis.pt\",\"SyncedAt\":1339502400.0}";
    NSError * err;
    NSString* testJSON = [sync buildRequest:&err];
    DebugLog(testJSON);
    
    
    NSString *jsonRequest = @"{\"Password\":\"mywine\",\"Username\":\"mywine@cpcis.pt\",\"SyncedAt\":634758524838925820}";
    NSURL *url = [NSURL URLWithString:@"http://backofficegp.cpcis.pt/MyWineSincService/MyWineSincService.svc/MyWineSincronize"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
     */
    
    
    NSURL *url = [NSURL URLWithString:@"http://dl.dropbox.com/u/14513425/resp.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    int responseStatusCode = [httpResponse statusCode];
    
    
    switch (responseStatusCode) {
        case 200:
            user.isValidated = TRUE;
            [user validateUser];
            break;
            
        case 400:
            user.isValidated = FALSE;
            [user validateUser];
            [delegate SyncViewControllerDidFinishWithStatusCode:400];
            
            
            break;
            
        default:
            user.isValidated = FALSE;
            [user validateUser];
            [delegate SyncViewControllerDidFinishWithStatusCode:responseStatusCode];            
            break;
    }

        
    
    [receivedData setLength:0];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(!user.isValidated){
        [progress_bar setProgress:0.0];
        self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];

        return;
    }
    
    
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 2,3];
    [progress_bar setProgress:0.50];
    
    
    if(![sync parseData:receivedData]){
        [progress_bar setProgress:0.0];
        self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];
        
        return;
    };
     

    /*
    NSError * jsonParsingError = nil;
    NSDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:&jsonParsingError];
    
    if(jsonParsingError){
        DebugLog(@"JSON PARSING ERROR: %@", jsonParsingError);
        return; 
    }
    
    DebugLog(@"JSON: %@", [NSString stringWithFormat:@"%@",  receivedJSON]);
    */
    [progress_bar setProgress:1.0];
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 3,3];
    
    [delegate SyncViewControllerDidFinishWithStatusCode:200];

    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    
    // inform the user
    DebugLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    
    
    self.progress_label.Text=[NSString stringWithFormat:[lan translate:@"Synchronization step"], 0,3];
    [progress_bar setProgress:0.0];

    
    [delegate SyncViewControllerDidFinishWithStatusCode:0];
    
    return;
    
}

@end
