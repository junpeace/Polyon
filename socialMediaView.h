//
//  socialMediaView.h
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "fbPostFeed.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface socialMediaView : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tblSocialFeeds;
- (IBAction)followOnFacebook:(id)sender;

@end
