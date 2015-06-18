//
//  placeAnOrderView.h
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "cartItem.h"
#import "cartProduct.h"
#import "NetworkHandler.h"
#import "getProductDetails.h"
#import "productCategory.h"
#import "UIImageView+WebCache.h"
#import "loginView.h"
#import "productDetailView.h"
#import "submitOrder.h"

@interface placeAnOrderView : UIViewController<UIAlertViewDelegate>
{
    int selectedIndex, selectedSegueIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoOrder;
- (IBAction)submitOrder:(id)sender;
@property (strong, nonatomic) NSMutableArray *dataArr, *productIdArr, *productQuantityArr, *cartIdArr;
@property (weak, nonatomic) IBOutlet UITableView *tblOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgOrderSubmitted;

@end
