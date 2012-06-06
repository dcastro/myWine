//
//  NovoVinhoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NovoVinhoViewController.h"

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
@synthesize tipoVinho = _tipoVinho;
@synthesize castaVinho = _castaVinho;
@synthesize PhotoButton;
@synthesize delegate;
@synthesize anosVinhos;
@synthesize PickAnoVinho;
@synthesize Done;
@synthesize Cancel;
@synthesize lblNomeVinho = _lblNomeVinho;
@synthesize lblProdutor = _lblProdutor;
@synthesize lblAno = _lblAno;
@synthesize lblPreco = _lblPreco;
@synthesize lblPais = _lblPais;
@synthesize lblRegiao = _lblRegiao;
@synthesize lblTipoVinho = _lblTipoVinho;
@synthesize lblCasta = _lblCasta;
@synthesize novoVinho = _novoVinho;
@synthesize country = _country;
@synthesize region = _region;
@synthesize pickFoto = _pickFoto;
@synthesize myPop = _myPop;
@synthesize imageView;

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
    
    // Setup the background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view insertSubview:background atIndex:0];

    Language* lang = [Language instance];
    
    [self.novoVinho setTitle:[lang translate:@"NovoVinho"]];
    
    [self.Done setTitle:[lang translate: @"Done"]];
    [self.Cancel setTitle: [lang translate: @"Cancel"]];
    
    [self.PhotoButton setTitle:[lang translate:@"Photo"] forState:UIControlStateNormal];
    
    [_lblNomeVinho setText:[lang translate:@"WineName"]];
    [_lblProdutor setText:[lang translate:@"WineProd"]];
    [_lblAno setText:[lang translate:@"WineYear"]];
    [_lblPreco setText:[lang translate:@"WinePrice"]];
    [_lblPais setText:[lang translate:@"WineCountry"]];
    [_lblRegiao setText:[lang translate:@"WineRegion"]];
    [_lblTipoVinho setText:[lang translate:@"WineType"]];
    [_lblCasta setText:[lang translate:@"WineGrape"]];
    
    [self.paisButton setTitle:[lang translate:@"Tap to select"] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:NO];
    [self.regiaoButton setTitle: [lang translate:@"Select Country First"] forState:UIControlStateNormal];
    [[self.regiaoButton titleLabel] setTextColor:[UIColor grayColor]];
    
    [_AnoVinho setInputView:PickAnoVinho];
    PickAnoVinho.hidden = YES;
    _AnoVinho.delegate = self;
    _castaVinho.delegate = self;
    _tipoVinho.delegate = self;
    
    // Get current year
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    // Populate picker data array from 1900 to current year
    self.anosVinhos = [[NSMutableArray alloc] init];
    for(int i = year ; i>1900 ; i--)
        [anosVinhos addObject: [NSNumber numberWithInt:i]];
    // TODO: convert mutable into normal static array for improved performance, since array shuld only be recalculated once per year
    
    if(1) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
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
    [self setTipoVinho:nil];
    [self setCastaVinho:nil];
    [self setLblNomeVinho:nil];
    [self setLblProdutor:nil];
    [self setLblAno:nil];
    [self setLblPreco:nil];
    [self setLblPais:nil];
    [self setLblRegiao:nil];
    [self setLblTipoVinho:nil];
    [self setLblCasta:nil];
    [self setPhotoButton:nil];
    [self setNovoVinho:nil];
    [self setImageView:nil];
    [self setPickFoto:nil];
    self.imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
        newMedia = YES;
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
        
        //[self presentModalViewController:imagePicker animated:YES]; // Teste this type in a real device
        
        //[_myPop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        _myPop = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [_myPop presentPopoverFromRect:CGRectMake(180.0, 200.0, 400.0, 400.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
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
    
    //[self dismissModalViewControllerAnimated:YES];
    NSLog(@"Picked");
    [_myPop dismissPopoverAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info 
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
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
                    
                    /*@synthesize regiaoButton;

                    @synthesize Produtor = _Produtor;
                    @synthesize AnoVinho = _AnoVinho;
                    @synthesize Preco = _Preco;
                    @synthesize delegate;
                    @synthesize anosVinhos;
                    @synthesize PickAnoVinho;
                    @synthesize Done;
                    @synthesize Cancel;
                    @synthesize country = _country;
                    @synthesize region = _region;*/
                    
                    [user.vinhos insertObject: vinho atIndex: user.vinhos.count];
                    [self.delegate NovoVinhoViewControllerDidSave:self];
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
    return anosVinhos.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [NSString stringWithFormat:@"%d", [[anosVinhos objectAtIndex:row] integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.AnoVinho.text = [NSString stringWithFormat:@"%d", [[anosVinhos objectAtIndex:row] integerValue]];
}

- (void) selectedCountry:(Pais*)country {
    
    self.country = country;
    self.region = NULL;
    
    Language* lang = [Language instance];
    
    [self.paisButton setTitle:country.name forState:UIControlStateNormal];
    
    [self.regiaoButton setTitle: [lang translate:@"Tap to select"] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:YES];
}

- (void) selectedRegion:(Regiao*) region{
    
    self.region = region;
    [self.regiaoButton setTitle:region.region_name forState:UIControlStateNormal];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    animatedDistance = calculateAnimation(self,keyboard);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 2) {PickAnoVinho.hidden = NO; NSLog(@"dont hide it");}
    else {PickAnoVinho.hidden = YES; NSLog(@"Hide it");}
    
    keyboard = textField;
    animatedDistance = calculateAnimation(self, textField);
    NSLog(@"Animated: %f", animatedDistance);
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
    
    NSLog(@"Animated 2: %f", animatedDistance);
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
