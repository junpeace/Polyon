//
//  productDetailView.h
//  polyon
//
//  Created by Jun on 15/5/28.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "placeAnOrderView.h"
#import "UIBarButtonItem+Badge.h"
#import "RTLabel.h"
#import "productCategory.h"
#import "getProductByID.h"
#import "NetworkHandler.h"
#import "UIImageView+WebCache.h"
#import "videoListView.h"
#import "cartItem.h"

@interface productDetailView : UIViewController
{
    NSMutableArray *pickerData;
    NSMutableArray *videoArr;
    int updateCounter;
}

- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgProductHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
- (IBAction)viewVideoList:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productDetailViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)addProduct:(id)sender;
@property (strong, nonatomic) RTLabel *lbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgOverlay;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)minusNumber:(id)sender;
- (IBAction)plusNumber:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNumberOfItem;
@property (weak, nonatomic) IBOutlet UIPickerView *noPicker;
@property (strong, nonatomic) productCategory *pc;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCode;
@property (strong, nonatomic) NSString *fromView, *cartID;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
- (IBAction)updateCart:(id)sender;

@end
