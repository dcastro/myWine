//
//  OrderViewController.h
//  myWine
//
//  Created by Admin on 06/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderViewControllerDelegate <NSObject>

- (void) orderViewControllerDidSelect:(int) orderType;

@end

@interface OrderViewController : UITableViewController

@property (nonatomic, weak) id <OrderViewControllerDelegate> delegate;
@property (nonatomic) int selectedOrder;

@end
