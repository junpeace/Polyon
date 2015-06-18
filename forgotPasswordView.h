//
//  forgotPasswordView.h
//  polyon
//
//  Created by jun on 5/21/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "NetworkHandler.h"
#import "forgetPassword.h"

@interface forgotPasswordView : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)sendPassword:(id)sender;

@end
