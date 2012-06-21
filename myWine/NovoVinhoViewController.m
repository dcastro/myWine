//
// NovoVinhoViewController.m
// myWine
//
// Created by Antonio Velasquez on 3/24/12.
// Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NovoVinhoViewController.h"
#import "NSMutableArray+VinhosMutableArray.h"
#import "UIColor+myWineColor.h"

@interface NovoVinhoViewController () {
    CGFloat animatedDistance;
    UITextField *keyboard;
}
@end


@implementation NovoVinhoViewController

@synthesize regiaoButton;
@synthesize paisButton;
@synthesize NomeVinho = _NomeVinho;
@synthesize Produtor = _Produtor;
@synthesize AnoVinho = _AnoVinho;
@synthesize Preco = _Preco;
@synthesize castaVinho = _castaVinho;
@synthesize PhotoButton;
@synthesize delegate;
@synthesize anosVinhos;
@synthesize PickAnoVinho;
@synthesize Done;
@synthesize Cancel;
@synthesize novoVinho = _novoVinho;
@synthesize currencyButton = _currencyButton;
@synthesize tipoVinho = _tipoVinho;
@synthesize country = _country;
@synthesize region = _region;
@synthesize pickFoto = _pickFoto;
@synthesize foto;
@synthesize myPop = _myPop;
@synthesize imageView;
@synthesize countries = _countries;
@synthesize tipo = _tipo;
@synthesize currency = _currency;
@synthesize popover = _popover;

@synthesize vinhos_order = _vinhos_order;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get current year
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    // Populate picker data array from 1900 to current year
    self.anosVinhos = [[NSMutableArray alloc] init];
    for(int i = year ; i>1900 ; i--)
        [self.anosVinhos addObject: [NSNumber numberWithInt:i]];
    
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

    self.currency = 0;
    [self.currencyButton setTitle:currencyStr(self.currency) forState:UIControlStateNormal];
    
    Language* lang = [Language instance];
    
    User* user = [User instance];
    [self setCountries:user.countries];
    
    [self.novoVinho setTitle:[lang translate:@"NovoVinho"]];
    
    [self.Done setTitle:[lang translate: @"Done"]];
    [self.Cancel setTitle: [lang translate: @"Cancel"]];

    self.foto.text = [lang translate:@"Photo"];
    self.foto.font = [UIFont fontWithName:@"DroidSans" size:NORMAL_FONT];
    
    self.AnoVinho.keyboardType = UIKeyboardTypeNumberPad;
    self.Preco.keyboardType = UIKeyboardTypeNumberPad;
    
    self.NomeVinho.placeholder=[lang translate:@"WineName"];
    [self.NomeVinho setFont:[UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-4]];
    self.NomeVinho.delegate =self;
    self.Produtor.placeholder=[lang translate:@"WineProd"];
    [self.Produtor setFont:[UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-4]];
    self.Produtor.delegate =self;
    self.AnoVinho.placeholder=[lang translate:@"WineYear"];
    [self.AnoVinho setFont:[UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-4]];
    self.AnoVinho.delegate =self;
    self.Preco.placeholder=[lang translate:@"WinePrice"];
    [self.Preco setFont:[UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-4]];
    self.Preco.delegate =self;
    [self.tipoVinho setTitle:[lang translate:@"WineType"] forState:UIControlStateNormal];
    [self.tipoVinho.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT-4]];
    [self.tipoVinho setTitleColor:[UIColor myWineColorDarkGrey] forState:UIControlStateNormal];
    [self.paisButton setTitle:[lang translate:@"WineCountry"] forState:UIControlStateNormal];
    [self.paisButton.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT-4]];
    [self.paisButton setTitleColor:[UIColor myWineColorDarkGrey] forState:UIControlStateNormal];
    [self.regiaoButton setTitle:[lang translate:@"WineRegion"] forState:UIControlStateNormal];
    [self.regiaoButton.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT-4]];
    [self.regiaoButton setTitleColor:[UIColor myWineColorDarkGrey] forState:UIControlStateNormal];
       self.castaVinho.placeholder=[lang translate:@"WineGrape"];
    [self.castaVinho setFont:[UIFont fontWithName:@"DroidSans" size:NORMAL_FONT-4]];
    self.castaVinho.delegate =self;
    //[self.tipoVinho setTitle: [lang translate:@"Tap to select"] forState:UIControlStateNormal];
    
    //[self.paisButton setTitle:[lang translate:@"Tap to select"] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:NO];
    //[self.regiaoButton setTitle: [lang translate:@"Select Country First"] forState:UIControlStateNormal];
    //[[self.regiaoButton titleLabel] setTextColor:[UIColor grayColor]];
    
    [self.currencyButton.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:NORMAL_FONT-4]];
    [self.currencyButton setTitleColor:[UIColor myWineColor] forState:UIControlStateNormal];
    
    [_AnoVinho setInputView:PickAnoVinho];
    PickAnoVinho.hidden = YES;
    _AnoVinho.delegate = self;
    _castaVinho.delegate = self;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasCountry = [defaults boolForKey:@"defaultCountrySet"];
    if(hasCountry){
        int countryIndex = [defaults integerForKey:@"defaultCountry"];
        Pais* defCountry = (Pais*) [self.countries objectAtIndex:countryIndex];
        [self selectedCountry:defCountry];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showCountries"]) {
        ListaPaisesViewController* lpvc = (ListaPaisesViewController*) [segue destinationViewController];
        lpvc.delegate = self;
        
    }
    if([segue.identifier isEqualToString:@"showRegions"]) {
        ListaRegioesViewController* lrvc = (ListaRegioesViewController*) [segue destinationViewController];
        lrvc.delegate = self;
        [lrvc setRegions: [self.country regions]];
        
    }
    if([segue.identifier isEqualToString:@"showTypes"]) {
        ListaTipoVinhosViewController* ltvvc = (ListaTipoVinhosViewController*) [segue destinationViewController];
        ltvvc.delegate = self;
    }
    if([segue.identifier isEqualToString:@"vinhoToCurrency"]) {
        CurrencyViewController* cvc = (CurrencyViewController*) segue.destinationViewController;
        cvc.delegate = self;
        cvc.selectedCurrency = self.currency;
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}

- (void)viewDidUnload
{
    [self setPickAnoVinho:nil];
    [self setAnoVinho:nil];
    [self setNomeVinho:nil];
    [self setProdutor:nil];
    [self setAnoVinho:nil];
    [self setPreco:nil];
    [self setPaisButton:nil];
    [self setRegiaoButton:nil];
    [self setDone:nil];
    [self setCancel:nil];
    [self setCastaVinho:nil];
    [self setPhotoButton:nil];
    [self setNovoVinho:nil];
    [self setImageView:nil];
    [self setPickFoto:nil];
    self.imageView = nil;
    [self setFoto:nil];
    [self setTipoVinho:nil];
    [self setTipoVinho:nil];
    [self setCurrencyButton:nil];
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
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pickF:(id)sender
{
    /*
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
        newMedia = YES;
    }
    else*/ if ([UIImagePickerController isSourceTypeAvailable:
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
    
    //UIImage * image;
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self.pickFoto setImage:image forState:(UIControlStateNormal)];
        [self.foto setHidden:YES];

        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancel:(id)sender
{
    [self.delegate NovoVinhoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    Language* lang = [Language instance];
    
    if( _NomeVinho.text.length == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Error"] message: [lang translate:@"Empty Name"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
        if (_AnoVinho.text.length == 0){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Error"] message: [lang translate:@"Empty year"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
            if(!_country){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Error"] message: [lang translate:@"Empty country"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            else
                if(!_region){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Error"] message:[lang translate:@"Empty region"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                else
                    if(!_tipo){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Error"] message:[lang translate:@"Empty type"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [lang translate:@"Thank you"] message:[lang translate:@"Success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                        Vinho* vinho = [[Vinho alloc] init];
                        User* user = [User instance];
                        vinho.name = _NomeVinho.text;
                        vinho.producer = _Produtor.text;
                        vinho.price = _Preco.text.doubleValue;
                        vinho.year = _AnoVinho.text.intValue;
                        vinho.region = self.region;
                        vinho.winetype = self.tipo;
                        
                        NSString *curr;
                        switch (self.currency) {
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
                         
                        vinho.currency = curr;
                        vinho.grapes = self.castaVinho.text;
                        
                        
                        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setBool:YES forKey:@"defaultCountrySet"];
                        [defaults synchronize];
                        
                        if(image != nil) {
                            // Create paths to output images
                            
                            NSDate* date = [NSDate date];
                            NSTimeInterval time = [date timeIntervalSince1970];
                            
                            //[NSString stringWithFormat:@"Documents/%@/%@",user.username, time];
                            NSString *nome = user.username;
                            NSString *stamp = [NSString stringWithFormat:@"%d", time];
                            NSString *path = [NSString stringWithFormat:@"Documents/Images/%@/",nome];
                            NSString *filePath = [NSString stringWithFormat:@"Documents/Images/%@/%@_%@.png",nome,nome,stamp];
                            
                            NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];                            
                            NSString *dirPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
                            
                            NSError *error;
                            if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) 
                                if(![[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
                                    NSLog(@"Create directory error: %@", error);
                            
                            // Write a UIImage to JPEG with minimum compression (best quality)
                            // The value 'image' must be a UIImage object
                            // The value '1.0' represents image compression quality as value from 0.0 to 1.0
                            //[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
                            // Write image to PNG
                            [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
                            vinho.photo = [NSString stringWithFormat:@"%@_%@.png",nome,stamp];
                            
                        }
                        
                        [self.delegate NovoVinhoViewControllerDidSave:vinho];
                    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return self.anosVinhos.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [NSString stringWithFormat:@"%d", [[self.anosVinhos objectAtIndex:row] integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.AnoVinho.text = [NSString stringWithFormat:@"%d", [[anosVinhos objectAtIndex:row] integerValue]];
}

- (void) selectedCountry:(Pais*)country {
    
    self.country = country;
    self.region = NULL;
    
    Language* lang = [Language instance];
    
    [self.paisButton setTitle:country.name forState:UIControlStateNormal];
    [self.paisButton setTitleColor:[UIColor myWineColor] forState:UIControlStateNormal];
    
    [self.regiaoButton setTitle: [lang translate:@"WineRegion"] forState:UIControlStateNormal];
    [self.regiaoButton setTitleColor:[UIColor myWineColorDarkGrey] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:YES];
}

- (void) selectedRegion:(Regiao*) region{
    
    self.region = region;
    self.region.country_name = self.country.name;
    self.region.country_name_en = self.country.name_en;
    self.region.country_name_fr = self.country.name_fr;
    self.region.country_name_pt = self.country.name_pt;
    [self.regiaoButton setTitle:region.region_name forState:UIControlStateNormal];
    [self.regiaoButton setTitleColor:[UIColor myWineColor] forState:UIControlStateNormal];
    
}

- (void) selectedType:(TipoVinho *) type{
    self.tipo = type;

    [self.tipoVinho setTitle:type.name forState: UIControlStateNormal];
    [self.tipoVinho setTitleColor:[UIColor myWineColor] forState:UIControlStateNormal];
}

- (void) currencyViewControllerDidSelect:(int) currency {
    //sets the selected currency
    self.currency = currency;
    [self.currencyButton setTitle:currencyStr(self.currency) forState:UIControlStateNormal];
    
    //dismisses the popover
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(keyboard!=nil){
        animatedDistance = calculateAnimation(self,keyboard);
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= animatedDistance;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        [self.view setFrame:viewFrame];
        
        [UIView commitAnimations];
    }
    
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

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 3) {PickAnoVinho.hidden = NO;}
    else {PickAnoVinho.hidden = YES;}
    
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    keyboard = textField;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    animatedDistance =0;
    keyboard = nil;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end