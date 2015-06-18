//
//  subCategoryProductView.h
//  polyon
//
//  Created by Jun on 15/6/1.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "placeAnOrderView.h"
#import "UIBarButtonItem+Badge.h"
#import "productCategory.h"
#import "UIImageView+WebCache.h"
#import "NetworkHandler.h"
#import "getProductCategory.h"
#import "getProducts.h"
#import "productDetailView.h"
#import "getProductAndCategory.h"

@interface subCategoryProductView : UIViewController
{
    int selectedIndex;
}

@property (strong, nonatomic) productCategory *pc;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

@end
