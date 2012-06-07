//
//  OrderViewController.h
//  myWine
//
//  Created by Nuno Sousa on 07/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderViewControllerDelegate <NSObject>

- (void) orderViewControllerDidSelect:(int) order;

@end

@interface OrderViewController : UITableViewController

//@property (nonatomic) int selectedOrder;
@property (nonatomic, weak) id <OrderViewControllerDelegate> delegate;

@end
