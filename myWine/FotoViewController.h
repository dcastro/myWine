//
//  FotoViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotoViewController : UIViewController <UIImagePickerControllerDelegate>

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end