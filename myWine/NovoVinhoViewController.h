//
//  NovoVinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaPaisesViewController.h"
#import "Pais.h"


@class NovoVinhoViewController;

@protocol NovoVinhoViewControllerDelegate <NSObject>
    - (void)NovoVinhoViewControllerDidCancel:(NovoVinhoViewController *)controller;
    - (void)NovoVinhoViewControllerDidSave:(NovoVinhoViewController *)controller;
@end

@interface NovoVinhoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, ListaPaisesViewControllerDelegate> {
    UIPickerView *PickAnoVinho;
    UITextField *AnoVinho;
    
}
@property (weak, nonatomic) IBOutlet UIButton *regiaoButton;
@property (weak, nonatomic) IBOutlet UIButton *paisButton;
@property (weak, nonatomic) IBOutlet UITextField *NomeVinho;
@property (weak, nonatomic) IBOutlet UITextField *Produtor;
@property (weak, nonatomic) IBOutlet UITextField *AnoVinho;
@property (weak, nonatomic) IBOutlet UITextField *Preco;

@property (nonatomic,strong) IBOutlet UIPickerView *PickAnoVinho;


@property (nonatomic, weak) id <NovoVinhoViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *anosVinhos;

@property (nonatomic,strong) Pais* country;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
