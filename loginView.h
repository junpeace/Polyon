//
//  loginView.h
//  polyon
//
//  Created by jun on 5/21/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "placeAnOrderView.h"
#import "NetworkHandler.h"
#import "login.h"
#import "signUp.h"

@interface loginView : UIViewController<UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    NSString *selection;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;

- (IBAction)forgotPassword:(id)sender;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgTapBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblSignUp;

- (IBAction)showLogin:(id)sender;
- (IBAction)showSignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
- (IBAction)signUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UITextField *loginView_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *loginView_txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
- (IBAction)rememberMe:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tabLoginView;
@property (weak, nonatomic) IBOutlet UIView *tabSignUpView;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtCompanyName;
@property (weak, nonatomic) IBOutlet UITextView *signupView_txtCompanyAddress;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtCompanyEmail;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtPersonInCharge;
@property (weak, nonatomic) IBOutlet UITextField *signupView_txtContactNo;

@property (strong, nonatomic) NSString *fromPlaceAnOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signupViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *tabLoginScrollView;


@end
