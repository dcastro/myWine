//
//  NovaProvaViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"

@class NovaProvaViewController;

@protocol NovaProvaViewControllerDelegate <NSObject>
    - (void)NovaProvaViewControllerDidCancel:(NovaProvaViewController *)controller;
    - (void)NovaProvaViewControllerDidSave:(NovaProvaViewController *)controller;
@end

@interface NovaProvaViewController : UIViewController {
    UILabel *sliderLabel;
}

@property (nonatomic, weak) id <NovaProvaViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *DoneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CancelButton;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
