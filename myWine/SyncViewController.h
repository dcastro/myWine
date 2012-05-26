//
//  SyncViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/25/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncViewController : UIViewController{
    NSMutableData *receivedData;
}

@property (weak, nonatomic) IBOutlet UILabel *description_label;
@property (weak, nonatomic) IBOutlet UILabel *progress_label;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_bar;



- (IBAction)cancel:(id)sender;

@end
