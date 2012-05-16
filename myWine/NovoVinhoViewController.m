//
//  NovoVinhoViewController.m
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "NovoVinhoViewController.h"
#import "ListaPaisesViewController.h"
#import "Language.h"
#import "ListaRegioesViewController.h"

@interface NovoVinhoViewController () 
@end

@implementation NovoVinhoViewController


@synthesize regiaoButton;
@synthesize paisButton;
@synthesize NomeVinho;
@synthesize Produtor;
@synthesize AnoVinho = _AnoVinho;
@synthesize Preco;
@synthesize delegate;
@synthesize anosVinhos;
@synthesize PickAnoVinho;
@synthesize country = _country;
@synthesize region = _region;

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
    
    Language* lang = [Language instance];
    
    [self.paisButton setTitle:[lang translate:@"Tap to select"] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:NO];
    [self.regiaoButton setTitle: [lang translate:@"Select Country First"] forState:UIControlStateNormal];
    [[self.regiaoButton titleLabel] setTextColor:[UIColor grayColor]];
    
    [_AnoVinho setInputView:PickAnoVinho];
    PickAnoVinho.hidden = YES;
    _AnoVinho.delegate = self;
    
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

-(void)textFieldDidBeginEditing:(UITextField *) textField {
    
    if(textField.tag == 2) {PickAnoVinho.hidden = NO; NSLog(@"dont hide it");}
    else {PickAnoVinho.hidden = YES; NSLog(@"Hide it");}
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (IBAction)cancel:(id)sender
{
	[self.delegate NovoVinhoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Obrigado" message:@"Vinho adicionado com sucesso" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
	[self.delegate NovoVinhoViewControllerDidSave:self];
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
    
    Language* lang = [Language instance];
    
    [self.paisButton setTitle:country.name forState:UIControlStateNormal];
    
    [self.regiaoButton setTitle: [lang translate:@"Tap to select"] forState:UIControlStateNormal];
    [self.regiaoButton setEnabled:YES];
}

- (void) selectedRegion:(Regiao*) region{
    
    self.region = region;
    [self.regiaoButton setTitle:region.region_name forState:UIControlStateNormal];
    
}

@end
