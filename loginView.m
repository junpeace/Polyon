//
//  loginView.m
//  polyon
//
//  Created by jun on 5/21/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "loginView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface loginView ()
{
    CGFloat animatedDistance;
}

@end

@implementation loginView

@synthesize revealLeftMenu;
@synthesize imgTapBackground, lblLogin, lblSignUp;
@synthesize btnLogin, btnSignUp, btnForgotPassword, loginView_txtPassword, loginView_txtUsername, imgCheck;
@synthesize tabLoginView, tabSignUpView;
@synthesize signupView_txtCompanyAddress, signupView_txtCompanyEmail, signupView_txtCompanyName, signupView_txtConfirmPassword, signupView_txtContactNo, signupView_txtEmail, signupView_txtPassword, signupView_txtPersonInCharge, signupView_txtUsername;
@synthesize fromPlaceAnOrder;
@synthesize loginViewHeightConstraint, signupViewHeightConstraint;
@synthesize tabLoginScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    selection = @"";
    
    [self initializeTextField];
    
    [self checkIfComeFromPlaceAnOrderView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Log in";
    
    loginView_txtPassword.secureTextEntry = YES;
    signupView_txtPassword.secureTextEntry = YES;
    signupView_txtConfirmPassword.secureTextEntry = YES;
    
    signupView_txtCompanyAddress.delegate = self;
    signupView_txtCompanyAddress.text = @"Company address";
    signupView_txtCompanyAddress.textColor = [UIColor colorWithRed: 204/255.0f green: 204/255.0f blue: 204/255.0f alpha: 1]; //optional
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    // prevent front view from interacting
    if (position == FrontViewPositionRight) { // Menu is shown
        self.navigationController.interactivePopGestureRecognizer.enabled = NO; // Prevents the iOS7’s pan gesture
        self.view.userInteractionEnabled = NO;
    } else if (position == FrontViewPositionLeft) { // Menu is closed
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.view.userInteractionEnabled = YES;
    }
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [revealLeftMenu setTarget: self.revealViewController];
        [revealLeftMenu setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"forgottenPasswordSegue" sender:nil];
}

- (IBAction)login:(id)sender
{
    /* start validation */
    
    if([loginView_txtUsername.text isEqualToString:@""])
    {
        [self showAlert:@"Please fill in username" ititle:@"Alert"];
        
        return;
    }
    
    if([loginView_txtPassword.text isEqualToString:@""])
    {
        [self showAlert:@"Please fill in password" ititle:@"Alert"];
        
        return;
    }
    
    /* end of validation */
    
    [SVProgressHUD showWithStatus:@"Logging in..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self callLoginAPI];
}

-(void) callLoginAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    login *request = [[login alloc] init_login: loginView_txtUsername.text ipassword: loginView_txtPassword.text];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) callSignUpAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    signUp *request = [[signUp alloc] init_signUp: signupView_txtUsername.text ipassword: signupView_txtPassword.text iemail:signupView_txtEmail.text icompanyName: signupView_txtCompanyName.text icompanyAddress: signupView_txtCompanyAddress.text icompanyEmail: signupView_txtCompanyEmail.text ipersonInCharge: signupView_txtPersonInCharge.text icontactNo: signupView_txtContactNo.text];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

- (IBAction)showLogin:(id)sender
{
    // simply compare image not working after app has been bring to background
    if([imgTapBackground.image isEqual:[UIImage imageNamed:@"btn_tab_loginsignup_rightactive"]] || [selection isEqualToString:@"signup"])
    {
        self.navigationItem.title = @"Log in";
        
        lblSignUp.textColor = [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:1];
        lblLogin.textColor = [UIColor colorWithRed:(57/255.f) green:(181/255.f) blue:(74/255.f) alpha:1];
        
        [imgTapBackground setImage: [UIImage imageNamed:@"btn_tab_loginsignup_leftactive"]];
        
        [btnSignUp setAlpha: 0];
        [btnLogin setAlpha: 1];
        [btnForgotPassword setAlpha: 1];
        [tabLoginScrollView setAlpha: 1];
        [tabSignUpView setAlpha: 0];
        
        selection = @"login";
    }
}

- (IBAction)showSignUp:(id)sender
{
    // simply compare image not working after app has been bring to background
    if([imgTapBackground.image isEqual:[UIImage imageNamed:@"btn_tab_loginsignup_leftactive"]] || [selection isEqualToString:@"login"])
    {
        self.navigationItem.title = @"Sign Up";
        
        lblLogin.textColor = [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:1];
        lblSignUp.textColor = [UIColor colorWithRed:(57/255.f) green:(181/255.f) blue:(74/255.f) alpha:1];
        
        [imgTapBackground setImage: [UIImage imageNamed:@"btn_tab_loginsignup_rightactive"]];
        
        [btnLogin setAlpha: 0];
        [btnForgotPassword setAlpha: 0];
        [btnSignUp setAlpha: 1];
        [tabLoginScrollView setAlpha: 0];
        [tabSignUpView setAlpha: 1];
        
        selection = @"signup";
    }
}

- (IBAction)signUp:(id)sender
{
    /* sign up validation */
    
    if([signupView_txtUsername.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in username" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtUsername.text length] > 20)
    {
        [self showAlert: @"Username should be less than 20 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtPassword.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in password" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtPassword.text length] > 15)
    {
        [self showAlert: @"Password should be less than 15 characters" ititle: @"Alert"];
        
        return;
    }
    
    if(![signupView_txtPassword.text isEqualToString: signupView_txtConfirmPassword.text])
    {
        [self showAlert: @"Comfirm password is not match with password" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtEmail.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in email" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtEmail.text length] > 50)
    {
        [self showAlert: @"Email should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if(![self NSStringIsValidEmail: signupView_txtEmail.text])
    {
        [self showAlert: @"Email is not valid" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyName.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in company name" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyName.text length] > 50)
    {
        [self showAlert: @"Company name should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyAddress.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in company address" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyAddress.text length] > 200)
    {
        [self showAlert: @"Company address should be less than 200 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyEmail.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in company email" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtCompanyEmail.text length] > 50)
    {
        [self showAlert: @"Company email should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if(![self NSStringIsValidEmail: signupView_txtCompanyEmail.text])
    {
        [self showAlert: @"Company email is not valid" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtPersonInCharge.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in person in charge" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtPersonInCharge.text length] > 20)
    {
        [self showAlert: @"Person in charge should be less than 20 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtContactNo.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in contact no" ititle: @"Alert"];
        
        return;
    }
    
    if([signupView_txtContactNo.text length] > 15)
    {
        [self showAlert: @"Contact no should be less than 15 characters" ititle: @"Alert"];
        
        return;
    }
    
    /* end of validation */
    
    [SVProgressHUD showWithStatus:@"Signing up..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self callSignUpAPI];
}

- (IBAction)rememberMe:(id)sender
{
    if([imgCheck.image isEqual: [UIImage imageNamed:@"btn_check"]])
    {
        [imgCheck setImage: [UIImage imageNamed:@"btn_check_active"]];
    }
    else
    {
        [imgCheck setImage: [UIImage imageNamed:@"btn_check"]];
    }
}

-(void)dismissKeyboard
{
    loginViewHeightConstraint.constant = 454;
    signupViewHeightConstraint.constant = 454;
    
    [self.view endEditing: YES];
}

-(void) showAlert :(NSString*) msg ititle:(NSString*) title
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:msg delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"login"])
        {
            if([[responseMessage objectForKey: @"result"] intValue] != 0)
            {
                // NSLog(@"data : %@", [responseMessage objectForKey:@"data"]);
                
                [SVProgressHUD dismiss];
                
                // store login status to YES
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"userLoggedIn"];
                [defaults synchronize];
                
                if([imgCheck.image isEqual: [UIImage imageNamed: @"btn_check_active"]])
                {
                    // do remember me
                    [defaults setBool:YES forKey:@"rememberMe"];
                    [defaults synchronize];
                }
                else
                {
                    // no need remember me
                    [defaults setBool:NO forKey:@"rememberMe"];
                    [defaults synchronize];
                }
                    
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"userId"] forKey:@"userID"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"username"] forKey:@"userName"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"email"] forKey:@"userEmail"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_name"] forKey:@"companyName"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_email"] forKey:@"companyEmail"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_address"] forKey:@"companyAddress"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"contact_number"] forKey:@"contactNo"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"person_in_charge"] forKey:@"personInCharge"];

                // store user information
                [[NSUserDefaults standardUserDefaults] setObject: dict forKey:@"userInformation"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                placeAnOrderView *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceAnOrderVC"];
                [self.navigationController pushViewController:auvc animated:NO];
            }
            else
            {
                [self showAlert: @"Username or password that you have entered is incorrect" ititle: @"Alert"];
            }
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"sign_up"])
        {
            if([[responseMessage objectForKey: @"result"] intValue] != 0)
            {
                // NSLog(@"data : %@", [responseMessage objectForKey:@"data"]);
                
                [SVProgressHUD dismiss];
                
                // store login status to YES
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"userLoggedIn"];
                [defaults synchronize];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"userId"] forKey:@"userID"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"username"] forKey:@"userName"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"email"] forKey:@"userEmail"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_name"] forKey:@"companyName"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_email"] forKey:@"companyEmail"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"company_address"] forKey:@"companyAddress"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"contact_number"] forKey:@"contactNo"];
                [dict setValue: [[responseMessage objectForKey:@"data"] objectForKey:@"person_in_charge"] forKey:@"personInCharge"];
                
                // store user information
                [[NSUserDefaults standardUserDefaults] setObject: dict forKey:@"userInformation"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Successful"
                                                                  message: @"Successful Sign Up!" delegate:self
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            else
            {
                [self showAlert: [responseMessage objectForKey:@"message"] ititle: @"Alert"];
            }
        }
    }
    
    [SVProgressHUD dismiss];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    placeAnOrderView *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceAnOrderVC"];
    [self.navigationController pushViewController:auvc animated:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([signupView_txtCompanyAddress.text isEqualToString:@"Company address"])
    {
        signupView_txtCompanyAddress.text = @"";
        signupView_txtCompanyAddress.textColor = [UIColor colorWithRed: 100/255.0f green: 100/255.0f blue: 100/255.0f alpha: 1]; //optional
    }
    
    [signupView_txtCompanyAddress becomeFirstResponder];
    
    [self moveScreenUp: (UITextField*) textView];
    
    signupViewHeightConstraint.constant = 454; // default
    
    if(textView == signupView_txtCompanyAddress)
    {   signupViewHeightConstraint.constant += 69;      }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([signupView_txtCompanyAddress.text isEqualToString:@""])
    {
        signupView_txtCompanyAddress.text = @"Company address";
        signupView_txtCompanyAddress.textColor = [UIColor colorWithRed: 204/255.0f green: 204/255.0f blue: 204/255.0f alpha: 1]; //optional
    }
    
    [signupView_txtCompanyAddress resignFirstResponder];
    
    [self moveScreenDown: (UITextField*) textView];
}

-(void) initializeTextField
{
    loginView_txtUsername.delegate = self;
    loginView_txtPassword.delegate = self;
    
    signupView_txtUsername.delegate = self;
    signupView_txtPassword.delegate = self;
    signupView_txtConfirmPassword.delegate = self;
    signupView_txtEmail.delegate = self;
    signupView_txtCompanyName.delegate = self;
    signupView_txtCompanyEmail.delegate = self;
    signupView_txtPersonInCharge.delegate = self;
    signupView_txtContactNo.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == loginView_txtUsername)
    {
        [loginView_txtPassword becomeFirstResponder];
    }
    else if(textField == loginView_txtPassword)
    {
        [self dismissKeyboard];
    }
    else if(textField == signupView_txtUsername)
    {
        [signupView_txtPassword becomeFirstResponder];
    }
    else if(textField == signupView_txtPassword)
    {
        [signupView_txtConfirmPassword becomeFirstResponder];
    }
    else if(textField == signupView_txtConfirmPassword)
    {
        [signupView_txtEmail becomeFirstResponder];
    }
    else if(textField == signupView_txtEmail)
    {
        [signupView_txtCompanyName becomeFirstResponder];
    }
    else if(textField == signupView_txtCompanyName)
    {
        [signupView_txtCompanyAddress becomeFirstResponder];
    }
    else if(textField == signupView_txtCompanyEmail)
    {
        [signupView_txtPersonInCharge becomeFirstResponder];
    }
    else if(textField == signupView_txtPersonInCharge)
    {
        [signupView_txtContactNo becomeFirstResponder];
    }
    else if(textField == signupView_txtContactNo)
    {
        [self dismissKeyboard];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveScreenUp: textField];
    
    loginViewHeightConstraint.constant = 454; // default
    signupViewHeightConstraint.constant = 454; // default
    
    if(textField == loginView_txtUsername)
    {   loginViewHeightConstraint.constant += 213;  }
    else if(textField == loginView_txtPassword)
    {   loginViewHeightConstraint.constant += 183;  }
    else if(textField == signupView_txtUsername)
    {   signupViewHeightConstraint.constant += 213;  }
    else if(textField == signupView_txtPassword)
    {   signupViewHeightConstraint.constant += 183;  }
    else if(textField == signupView_txtConfirmPassword)
    {   signupViewHeightConstraint.constant += 159;  }
    else if(textField == signupView_txtEmail)
    {   signupViewHeightConstraint.constant += 144;  }
    else if(textField == signupView_txtCompanyName)
    {   signupViewHeightConstraint.constant += 121;  }
    else if(textField == signupView_txtCompanyEmail)
    {   signupViewHeightConstraint.constant += 30;  }
    else if(textField == signupView_txtPersonInCharge)
    {   signupViewHeightConstraint.constant += 25;  }
    else if(textField == signupView_txtContactNo)
    {   signupViewHeightConstraint.constant += 8;  }
}

-(void) moveScreenUp : (UITextField *) textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void) moveScreenDown :(UITextField *) textfield
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield
{
    [self moveScreenDown: textfield];
}

-(void) checkIfComeFromPlaceAnOrderView
{
    if([fromPlaceAnOrder isEqualToString: @"YES"])
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBar.topItem.title = @"";
    }
}

@end
