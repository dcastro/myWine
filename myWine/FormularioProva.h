//
//  FormularioProva.h
//  myWine
//
//  Created by Fernando Gracas on 6/1/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipoVinho.h"
#import "Prova.h"

@interface FormularioProva : NSObject


-(Prova *)generateTasting:(TipoVinho *)wineType;

@end
