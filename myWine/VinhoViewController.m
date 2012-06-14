//
//  VinhoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "VinhoViewController.h"
#import "UIColor+myWineColor.h"
#import <QuartzCore/QuartzCore.h>

@interface VinhoViewController () {
    CGFloat animatedDistance;
    UITextField *keyboard;
    UITextView *keyboard2;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation VinhoViewController
@synthesize producer_label = _producer_label;
@synthesize producer_label_name = _producer_label_name;
@synthesize year_label = _year_label;
@synthesize year_label_name = _year_label_name;
@synthesize region_label = _region_label;
@synthesize region_label_name = _region_label_name;
@synthesize country_label = _country_label;
@synthesize country_label_name = _country_label_name;
@synthesize percentage_label_name = _percentage_label_name;
@synthesize wine_label_name = _wine_label_name;
@synthesize grapes_label = _grapes_label;
@synthesize wine_type_label = _wine_type_label;
@synthesize price_label = _price_label;
@synthesize price_value_label = _price_value_label;
@synthesize wineName = _wineName;
@synthesize priceValue = _priceValue;
@synthesize harvestyear = _harvestyear;
@synthesize producerName = _producerName;
@synthesize grapesList = _grapesList;
@synthesize grapesListShow = _grapesListShow;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize editButton = _editButton;
@synthesize tempButton = _tempButton;
@synthesize selectCountryButton = _selectCountryButton;
@synthesize selectRegionButton = _selectRegionButton;
@synthesize selectCurrencyButton = _selectCurrencyButton;
@synthesize editing = _editing;

@synthesize delegate;

@synthesize popover = _popover;
@synthesize winePic = _winePic;
@synthesize myPop = _myPop;

@synthesize editableWine = _editableWine, country = _country;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    Language *lan = [Language instance];
    
    
    self.producer_label.text = [lan translate:@"Producer"];
    self.producer_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];
    
    self.year_label.text = [lan translate:@"Harvest year"];
    self.year_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];
    
    self.producer_label.text = [lan translate:@"Producer"];
    self.producer_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];

    self.region_label.text = [lan translate:@"Region"];
    self.region_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];

    self.country_label.text = [lan translate:@"Country"];
    self.country_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];
    
    self.grapes_label.text = [lan translate:@"Grapes"];
    self.grapes_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];
    
    self.price_label.text = [lan translate:@"Price"];
    self.price_label.font = [UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT];
    
    //set score
    int score = [((Vinho*) self.detailItem) score];
    NSString* scoreString;
    if (score == -1)
        scoreString = [[NSString alloc] initWithFormat:@"-- %%"];
    else scoreString = [[NSString alloc] initWithFormat:@"%i %%", score];
    self.percentage_label_name.text = scoreString;
    self.percentage_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:72];
    
    
    Vinho* vinho = (Vinho*) self.detailItem;
    
    self.producer_label_name.text = vinho.producer;
    self.producer_label_name.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.year_label_name.text = [NSString stringWithFormat:@"%d", vinho.year];
    self.year_label_name.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.region_label_name.text = vinho.region.region_name;
    self.region_label_name.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.country_label_name.text = vinho.region.country_name;
    self.country_label_name.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.wine_label_name.text = vinho.name;
    self.wine_label_name.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGER_FONT];
    
    self.wine_type_label.text = vinho.winetype.name;
    self.wine_type_label.font = [UIFont fontWithName:@"DroidSerif" size:LARGE_FONT];
    
    self.price_value_label.text = [vinho fullPrice];
    self.price_value_label.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.grapesListShow.text = [vinho grapes];
    self.grapesListShow.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    self.editButton.title = [lan translate:@"Edit"];
    
    self.selectCurrencyButton.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.selectCountryButton.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.selectRegionButton.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];

    //set navigation bar title
    [self setTitle: [self.detailItem description]];
    
    
    self.wineName.delegate=self;
    self.priceValue.delegate=self;
    self.harvestyear.delegate=self;
    self.producerName.delegate=self;
    self.grapesList.delegate=self;
    
    self.grapesList.layer.cornerRadius = 5;
    self.grapesList.clipsToBounds = YES;
    
    self.grapesList.layer.cornerRadius = 5;
    self.grapesList.clipsToBounds = YES;
    
    [self.wineName setHidden:YES];
    [self.priceValue setHidden:YES];
    [self.harvestyear setHidden:YES];
    [self.producerName setHidden:YES];
    [self.grapesList setHidden:YES];
    self.grapesList.backgroundColor = [UIColor  whiteColor];
    self.grapesList.textColor = [UIColor myWineColor];
    self.grapesListShow.backgroundColor = [UIColor  clearColor];
    self.grapesListShow.textColor = [UIColor whiteColor];
    
    
    if(vinho.photo != nil && vinho.photo != NULL && ![vinho.photo isEqualToString:@"<null>"]) {
        User* user = [User instance];
        NSString *nome = user.username;
        NSString *path = [NSString stringWithFormat:@"Documents/Images/%@/%@",nome,vinho.photo];
        NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:path]; 
        image = [UIImage imageWithContentsOfFile:pngPath];
        NSLog(@"image name: %@", vinho.photo);
        [self.winePic setImage:image forState:(UIControlStateNormal)];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Setup the background
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }
    
    //fonts
    self.wineName.font = [UIFont fontWithName:@"DroidSerif-Bold" size:LARGE_FONT];
    self.producerName.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    self.harvestyear.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    self.grapesList.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    self.priceValue.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT];
    
    //keyboard types
    self.harvestyear.keyboardType = UIKeyboardTypeNumberPad;
    self.priceValue.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.selectCountryButton setHidden:TRUE];
    [self.selectRegionButton setHidden:TRUE];
    [self.selectCurrencyButton setHidden:TRUE];
    [self.winePic setUserInteractionEnabled:NO];
    newMedia = NO;
    

}

- (void)viewDidUnload
{
    [self setProducer_label:nil];
    [self setProducer_label_name:nil];
    [self setYear_label:nil];
    [self setYear_label_name:nil];
    [self setRegion_label:nil];
    [self setRegion_label_name:nil];
    [self setCountry_label:nil];
    [self setCountry_label_name:nil];
    [self setPercentage_label_name:nil];
    [self setWine_label_name:nil];
    [self setEditButton:nil];
    [self setTempButton:nil];
    [self setGrapes_label:nil];
    [self setSelectCountryButton:nil];
    [self setSelectRegionButton:nil];
    [self setWine_type_label:nil];
    [self setPrice_label:nil];
    [self setPrice_value_label:nil];
    [self setSelectCurrencyButton:nil];
    [self setWineName:nil];
    [self setPriceValue:nil];
    [self setHarvestyear:nil];
    [self setProducerName:nil];
    [self setGrapesList:nil];
    [self setGrapesListShow:nil];
    [self setWinePic:nil];
    [self setWinePic:nil];
    [self setWinePic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// allows next button on keyboard to move onto the next text field
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } 
    if (nextTag==5){
        [self.grapesList becomeFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"vinhoToCountries"]) {
        ListaPaisesViewController* lpvc = (ListaPaisesViewController*) segue.destinationViewController;
        lpvc.delegate = self;
    }
    if([segue.identifier isEqualToString:@"vinhoToRegions"]) {
        ListaRegioesViewController* lrvc = (ListaRegioesViewController*) segue.destinationViewController;
        lrvc.delegate = self;
        lrvc.regions = self.country.regions;
    }
    if([segue.identifier isEqualToString:@"vinhoToCurrency"]) {
        CurrencyViewController* cvc = (CurrencyViewController*) segue.destinationViewController;
        if([self.editableWine.currency isEqualToString:@"EUR"])
            cvc.selectedCurrency = 0;
        else if([self.editableWine.currency isEqualToString:@"USD"])
            cvc.selectedCurrency = 1;
        else if([self.editableWine.currency isEqualToString:@"GBP"])
            cvc.selectedCurrency = 2;
        cvc.delegate = self;
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        

    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pickF:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker
                                animated:YES];
        newMedia = NO;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        
        _myPop = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [_myPop presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        newMedia = NO;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No photo capacity"
                              message: @"No!"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    [_myPop dismissPopoverAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self.winePic setImage:image forState:(UIControlStateNormal)];
        
        newMedia = YES;
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Vinhos", @"Vinhos");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


- (IBAction)toggleEdit:(id)sender {
    
    if (![self isEditing]) {
        
        self.editableWine = [self.detailItem copy];
        
        self.wineName.text = self.wine_label_name.text;
        self.producerName.text = self.producer_label_name.text;
        self.harvestyear.text = self.year_label_name.text;
        self.priceValue.text = [[NSString alloc] initWithFormat: @"%.02f", self.editableWine.price];
        self.grapesList.text = self.grapesListShow.text;
        
        [self.selectCountryButton setTitle:self.country_label_name.text forState:UIControlStateNormal];
        [self.selectRegionButton setTitle:self.region_label_name.text forState:UIControlStateNormal];
        [self.selectCurrencyButton setTitle:self.editableWine.currency forState:UIControlStateNormal];
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlDown
						animations:^ {
                            //addition of editing fields to the subviews
                            [self.wineName setHidden:NO];
                            [self.priceValue setHidden:NO];
                            [self.harvestyear setHidden:NO];
                            [self.producerName setHidden:NO];
                            [self.grapesListShow setHidden:YES];
                            [self.grapesList setHidden:NO];
                            [self.winePic setUserInteractionEnabled:YES];
                        }
						completion:nil];
        
        //switch do doneButton and cancelButton
        Language* lan = [Language instance];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[lan translate:@"Cancel"] style:UIBarButtonSystemItemCancel target:self action:@selector(toggleEdit:)];
        [cancelButton setTintColor: [UIColor colorWithRed:255/255 green:54/255 blue:76/255 alpha:0]];
        
        [self setTempButton:self.navigationItem.leftBarButtonItem];
        [[self navigationItem] setRightBarButtonItem:doneButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES];   
        
        //set country
        NSString* country_name = self.editableWine.region.country_name;
        NSArray* countries = [[User instance] countries];
        for(int i = 0; i <  [countries count]; i++) {
            if([[[countries objectAtIndex:i] name] isEqualToString:country_name]){
                self.country = [countries objectAtIndex:i];
                break;
            }
        }
    
 
    } else {
        UIBarButtonItem* pressedButton = (UIBarButtonItem*) sender;
        
        if ([pressedButton style] == UIBarButtonItemStyleDone) {
            
            //verifications
            if(!self.editableWine.region) {
                //show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[Language instance] translate:@"Error"] message:[[Language instance] translate:@"Select Region"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            
            [self.editableWine setName:self.wineName.text];
            [self.editableWine setProducer:self.producerName.text];
            [self.editableWine setYear: [self.harvestyear.text intValue]];
            [self.editableWine setGrapes:self.grapesList.text];
            [self.editableWine setPrice: [self.priceValue.text doubleValue]];  
        
            if(newMedia) {                
                if(image != nil) {
                    
                    // Create paths to output images and delete old
                    
                    NSDate* date = [NSDate date];
                    NSTimeInterval time = [date timeIntervalSince1970];

                    User* user = [User instance];
                    Vinho* oldVinho = (Vinho*) self.detailItem;
                    
                    
                    
                    NSString *nome = user.username;
                    NSString *stamp = [NSString stringWithFormat:@"%d", time];
                    NSString *path = [NSString stringWithFormat:@"Documents/Images/%@/",nome];
                    NSString *filePath = [NSString stringWithFormat:@"Documents/Images/%@/%@_%@.png",nome,nome,stamp];
                    NSString *oldPath = [NSString stringWithFormat:@"Documents/Images/%@/%@",nome,oldVinho.photo];
                    

                    
                    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];                            
                    NSString *dirPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
                    NSString *remPath = [NSHomeDirectory() stringByAppendingPathComponent:oldPath];
                    
                    [[NSFileManager defaultManager] removeItemAtPath:remPath error:NULL];
                    
                    NSError *error;
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
                        if(![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
                            NSLog(@"Create directory error: %@", error);

                    
                    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
                    [self.editableWine setPhoto:[NSString stringWithFormat:@"%@_%@.png",nome,stamp]];
                    
                    newMedia = NO;
                }
            }
            
            
            [self.detailItem updateWithVinho:self.editableWine];
        
            self.wine_label_name.text = self.wineName.text;
            self.producer_label_name.text = self.producerName.text;
            self.year_label_name.text = self.harvestyear.text;
            self.price_value_label.text = self.priceValue.text;
            self.country_label_name.text= self.editableWine.region.country_name;
            self.region_label_name.text = self.editableWine.region.region_name;
            self.grapesListShow.text = self.grapesList.text;
            
            //refresh master view
            [self.delegate onVinhoEdition:(Vinho*) self.detailItem];
        }
        
        [UIView transitionWithView:[self view] duration:0.5
						   options:UIViewAnimationOptionTransitionCurlUp
						animations:^ {
                            [self.wineName setHidden:YES];
                            [self.priceValue setHidden:YES];
                            [self.harvestyear setHidden:YES];
                            [self.producerName setHidden:YES];
                            [self.grapesListShow setHidden:NO];
                            [self.grapesList setHidden:YES];
                            [self.winePic setUserInteractionEnabled:NO];
                        }
						completion:nil];
        
        //switch to editButton
        [[self navigationItem] setRightBarButtonItem:self.editButton animated:YES];
        [[self navigationItem] setLeftBarButtonItem:self.tempButton animated:YES];
        [self setTempButton:nil];

        [self.wineName  becomeFirstResponder];
        [self.wineName  resignFirstResponder];
        
        [self configureView];
        
    }
    
    //switch editing mode
    [self setEditing: !self.isEditing];
    
    //switch views
    [self.wine_label_name setHidden: self.isEditing];
    [self.producer_label_name setHidden: self.isEditing];
    [self.year_label_name setHidden: self.isEditing];
    
     
    [self.country_label_name setHidden: self.isEditing];
    [self.selectCountryButton setHidden: !self.isEditing];
    
    [self.region_label_name setHidden:self.isEditing];
    [self.selectRegionButton setHidden: !self.isEditing];
        
    [self.price_value_label setHidden:self.isEditing];
    [self.selectCurrencyButton setHidden:!self.isEditing];
    
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

#pragma mark -
#pragma mark UITextField Delegate Method

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(keyboard!=nil){
        animatedDistance = calculateAnimation(self,keyboard);
    }
    else if (keyboard2!=nil) {
        animatedDistance = calculateAnimation2(self,keyboard2);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];

    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboard = textField;
    animatedDistance = calculateAnimation(self, textField);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    keyboard2 = textView;
    animatedDistance = calculateAnimation2(self, textView);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    keyboard = textField;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    animatedDistance =0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    keyboard = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    keyboard2 = textView;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    animatedDistance =0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    keyboard2 = nil;
}

//only accepts 2 digits precision doubles
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == self.priceValue) {
    
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count]>=2)
        {
            NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
            return !([sepStr length]>2);
        }
    }
    return YES;
}

#pragma mark - ListaPaises and ListaRegioes Delegate Methods

- (void) selectedCountry:(Pais*)country {
    self.country = country;
    [self.selectCountryButton setTitle:self.country.name forState:UIControlStateNormal];
    
    //reset region
    self.editableWine.region = nil;
    [self.selectRegionButton setTitle:[[Language instance] translate:@"Tap to select"] forState:UIControlStateNormal];
    
}

- (void) selectedRegion:(Regiao*) region{
    self.editableWine.region = region;
    self.editableWine.region.country_name = self.country.name;
    self.editableWine.region.country_name_en = self.country.name_en;
    self.editableWine.region.country_name_fr = self.country.name_fr;
    self.editableWine.region.country_name_pt = self.country.name_pt;
    [self.selectRegionButton setTitle:region.region_name forState:UIControlStateNormal];
}

#pragma mark - Currency Delegate Method
- (void) currencyViewControllerDidSelect:(int) currency {
    //sets the selected currency
    NSString *curr;
    switch (currency) {
        case 0:
            curr = @"EUR";
            break;
        case 1:
            curr = @"USD";
            break;
        case 2:
            curr = @"GBP";
            break;
        default:
            break;
    }
    self.editableWine.currency = curr;
    
    //sets the button text
    [self.selectCurrencyButton setTitle:self.editableWine.currency forState:UIControlStateNormal];
    
    //dismisses the popover
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - Translatable Delegate Method
- (void) translate {
    
    Language *lan = [Language instance];
    
    //traduzir labels
    self.producer_label.text = [lan translate:@"Producer"];
    self.year_label.text = [lan translate:@"Harvest year"];
    self.producer_label.text = [lan translate:@"Producer"];
    self.region_label.text = [lan translate:@"Region"];
    self.country_label.text = [lan translate:@"Country"];
    self.grapes_label.text = [lan translate:@"Grapes"];
    self.price_label.text = [lan translate:@"Price"];
    
    //traduzir conteúdo
    Vinho* vinho = (Vinho*) self.detailItem;
    self.wine_type_label.text = vinho.winetype.name;
    
    self.country_label_name.text = vinho.region.country_name;

    if (self.isEditing) {
        [self.selectCountryButton setTitle:self.country.name forState:UIControlStateNormal];
        
        if (self.editableWine.region == nil) {
            [self.selectRegionButton setTitle:[[Language instance] translate:@"Tap to select"] forState:UIControlStateNormal];
        }
        
        //butoes done & cancel
        [[[self navigationItem] rightBarButtonItem] setTitle:[lan translate:@"Done"]];
        [[[self navigationItem] leftBarButtonItem] setTitle:[lan translate:@"Cancel"]];
    }
    
    self.editButton.title = [lan translate:@"Edit"];
    
}


@end
