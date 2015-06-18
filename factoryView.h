//
//  factoryView.h
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "factoryStock.h"
#import "UIImageView+WebCache.h"
#import "RTLabel.h"

@interface factoryView : UIViewController

@property (strong, nonatomic) factoryStock *fs;
@property (weak, nonatomic) IBOutlet UIImageView *imgFactory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgFactoryHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *factoryDetailViewHeightConstraint;
@property (strong, nonatomic) RTLabel *lbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
