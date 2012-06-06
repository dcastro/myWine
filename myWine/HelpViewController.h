//
//  HelpViewController.h
//  myWine
//
//  Created by André Dias on 01/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"

@interface HelpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *faq;
@property (strong, nonatomic) IBOutlet UILabel *pergunta1;
@property (strong, nonatomic) IBOutlet UITextView *resposta1;
@property (strong, nonatomic) IBOutlet UILabel *pergunta2;
@property (strong, nonatomic) IBOutlet UITextView *resposta2;
@property (strong, nonatomic) IBOutlet UILabel *pergunta3;
@property (strong, nonatomic) IBOutlet UITextView *resposta3;
@property (strong, nonatomic) IBOutlet UILabel *pergunta4;
@property (strong, nonatomic) IBOutlet UITextView *resposta4;
@property (strong, nonatomic) IBOutlet UILabel *pergunta5;
@property (strong, nonatomic) IBOutlet UITextView *resposta5;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabSelector;

@end
