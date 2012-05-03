//
//  NovoVinhoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/24/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NovoVinhoViewController;

@protocol NovoVinhoViewControllerDelegate <NSObject>
    - (void)NovoVinhoViewControllerDidCancel:(NovoVinhoViewController *)controller;
    - (void)NovoVinhoViewControllerDidSave:(NovoVinhoViewController *)controller;
@end

@interface NovoVinhoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    UIPickerView *PickAnoVinho;
    UITextField *AnoVinho;
    
}

@property (weak, nonatomic) IBOutlet UITextField *NomeVinho;
@property (weak, nonatomic) IBOutlet UITextField *Produtor;
@property (weak, nonatomic) IBOutlet UITextField *AnoVinho;
@property (weak, nonatomic) IBOutlet UITextField *Preco;

@property (nonatomic,strong) IBOutlet UIPickerView *PickAnoVinho;


@property (nonatomic, weak) id <NovoVinhoViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *anosVinhos;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
