//
//  SyncViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Language;
@class Sincronizacao;
@class User;

@protocol SyncViewControllerDelegate <NSObject>

- (void) SyncViewControllerDidFinishWithStatusCode:(int) code;

@end


@interface SyncViewController : UIViewController{
    NSMutableData *receivedData;
    Language *lan;
    Sincronizacao * sync;
    User * user;
}

@property (weak, nonatomic) IBOutlet UILabel *description_label;
@property (weak, nonatomic) IBOutlet UILabel *progress_label;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_bar;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) id<SyncViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
