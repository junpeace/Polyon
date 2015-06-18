//
//  brandDetailsView.h
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qualityProduct.h"
#import "NetworkHandler.h"
#import "getBrandsDetails.h"
#import "UIImageView+WebCache.h"
#import "RTLabel.h"
#import "brandDetail.h"

@interface brandDetailsView : UIViewController

@property (strong, nonatomic) qualityProduct *qp;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBannerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) RTLabel *lbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopLine;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end
