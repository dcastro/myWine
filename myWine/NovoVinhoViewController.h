//
//  NovoVinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ListaPaisesViewController.h"
#import "ListaRegioesViewController.h"
#import "Pais.h"
#import "Regiao.h"
#import "Language.h"
#import "Utils.h"
#import "User.h"
#import "Vinho.h"

@class NovoVinhoViewController;

@protocol NovoVinhoViewControllerDelegate <NSObject>
    - (void)NovoVinhoViewControllerDidCancel:(NovoVinhoViewController *)controller;
    - (void)NovoVinhoViewControllerDidSave:(Vinho*) vinho;
@end

@interface NovoVinhoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ListaPaisesViewControllerDelegate,ListaRegioesViewControllerDelegate> {
    UIPickerView *PickAnoVinho;
    UITextField *AnoVinho;
    UIImageView *imageView;
    BOOL newMedia;
    UIImage *image;
}

@property (weak, nonatomic) IBOutlet UIButton *regiaoButton;
@property (weak, nonatomic) IBOutlet UIButton *paisButton;
@property (weak, nonatomic) IBOutlet UITextField *NomeVinho;
@property (weak, nonatomic) IBOutlet UITextField *Produtor;
@property (weak, nonatomic) IBOutlet UITextField *AnoVinho;
@property (weak, nonatomic) IBOutlet UITextField *Preco;
@property (weak, nonatomic) IBOutlet UITextField *tipoVinho;
@property (weak, nonatomic) IBOutlet UITextField *castaVinho;

@property (weak, nonatomic) IBOutlet UIButton *PhotoButton;
@property (nonatomic,strong) IBOutlet UIPickerView *PickAnoVinho;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Done;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Cancel;

@property (weak, nonatomic) IBOutlet UINavigationItem *novoVinho;


@property (nonatomic, weak) id <NovoVinhoViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *anosVinhos;

@property (nonatomic,strong) Pais* country;
@property (nonatomic,strong) Regiao* region;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *myPop;
@property (weak, nonatomic) IBOutlet UIButton *pickFoto;
@property (strong, nonatomic) IBOutlet UILabel *foto;

@property (nonatomic, strong) NSMutableArray* countries;

@property (nonatomic) int vinhos_order;

- (IBAction)pickF:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
