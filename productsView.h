//
//  productsView.h
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "placeAnOrderView.h"
#import "UIBarButtonItem+Badge.h"
#import "NetworkHandler.h"
#import "getProductCategory.h"
#import "productCategory.h"
#import "UIImageView+WebCache.h"
#import "getProducts.h"
#import "subCategoryProductView.h"
#import "getProductAndCategory.h"
#import "cartItem.h"

@interface productsView : UIViewController
{
    int selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)viewVideoList:(id)sender;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

@end
