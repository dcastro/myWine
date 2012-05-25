//
//  CurrencyViewController.h
//  myWine
//
//  Created by Diogo Castro on 24/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyViewControllerDelegate <NSObject>

- (void) currencyViewControllerDidSelect:(int) currency;

@end



@interface CurrencyViewController : UITableViewController

@property (nonatomic) int selectedCurrency;
@property (nonatomic, weak) id <CurrencyViewControllerDelegate> delegate;

@end
