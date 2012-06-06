//
//  FotoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Language.h"

@interface FotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImageView *imageView;
    BOOL newMedia;
}

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Cancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Done;
@property (weak, nonatomic) IBOutlet UINavigationItem *NewPhoto;


@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *myPop;
@end