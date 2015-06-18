//
//  whyUsView.h
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "NetworkHandler.h"
#import "getBrands.h"
#import "qualityProduct.h"
#import "UIImageView+WebCache.h"
#import "brandDetailsView.h"
#import "getWarehouseAndStock.h"
#import "factoryStock.h"
#import "factoryView.h"

@interface whyUsView : UIViewController
{
    int selectedQualityProductIndex, selectedFacotryWarehouseIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgTapButtonBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapButtonBackgroundWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapButtonViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblQuaityProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblWarehouseAndStock;
@property (strong, nonatomic) NSMutableArray *dataArr, *dataArrWS;
@property (weak, nonatomic) IBOutlet UITableView *tblQualityProducts;
- (IBAction)showQualityProduct:(id)sender;
- (IBAction)showWarehouseAndStock:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblWarehouseAndFactory;

@end
