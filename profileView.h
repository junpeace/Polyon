//
//  profileView.h
//  polyon
//
//  Created by Jun on 15/5/21.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "NetworkHandler.h"
#import "updateUserProfile.h"

@interface profileView : UIViewController<UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)updateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (weak, nonatomic) IBOutlet UITextView *txtCompanyAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPIC;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;
- (IBAction)cancelEdit:(id)sender;
- (IBAction)confirmEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cancelSaveView;



@end
