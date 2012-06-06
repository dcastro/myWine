//
//  NovoVinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
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
    - (void)NovoVinhoViewControllerDidSave:(NovoVinhoViewController *)controller;
@end

@interface NovoVinhoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, ListaPaisesViewControllerDelegate,ListaRegioesViewControllerDelegate> {
    UIPickerView *PickAnoVinho;
    UITextField *AnoVinho;
    
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

@property (weak, nonatomic) IBOutlet UILabel *lblNomeVinho;
@property (weak, nonatomic) IBOutlet UILabel *lblProdutor;
@property (weak, nonatomic) IBOutlet UILabel *lblAno;
@property (weak, nonatomic) IBOutlet UILabel *lblPreco;
@property (weak, nonatomic) IBOutlet UILabel *lblPais;
@property (weak, nonatomic) IBOutlet UILabel *lblRegiao;
@property (weak, nonatomic) IBOutlet UILabel *lblTipoVinho;
@property (weak, nonatomic) IBOutlet UILabel *lblCasta;
@property (weak, nonatomic) IBOutlet UINavigationItem *novoVinho;


@property (nonatomic, weak) id <NovoVinhoViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *anosVinhos;

@property (nonatomic,strong) Pais* country;
@property (nonatomic,strong) Regiao* region;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
