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


@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *frFlag;
@property (weak, nonatomic) IBOutlet UIButton *ptFlag;
@property (weak, nonatomic) IBOutlet UIButton *enFlag;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *configLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

- (IBAction)doLogin:(id)sender;
- (IBAction)selectLanguage:(id)sender;

@end
