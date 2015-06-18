//
//  aboutUsView.h
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "getCompanyProfile.h"
#import "NetworkHandler.h"
#import "RTLabel.h"
#import "aboutUs.h"
#import "UIImageView+WebCache.h"

@interface aboutUsView : UIViewController
{
    aboutUs *au;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnVisionWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnMissionWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCoreValueWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHistoryWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vmvhViewWidthConstraint;
- (IBAction)viewVision:(id)sender;
- (IBAction)viewMission:(id)sender;
- (IBAction)viewCoreValue:(id)sender;
- (IBAction)viewHistory:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBannerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;
- (IBAction)showAboutUs:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) RTLabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *btnVision;
@property (weak, nonatomic) IBOutlet UIButton *btnMission;
@property (weak, nonatomic) IBOutlet UIButton *btnCoreValue;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;

@end
