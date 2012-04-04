//
//  LoginViewController.h
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
- (void)LoginViewControllerDidLogin:(LoginViewController *)controller;
@end


@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;

- (IBAction)doLogin:(id)sender;

@end
