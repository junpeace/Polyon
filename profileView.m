//
//  profileView.m
//  polyon
//
//  Created by Jun on 15/5/21.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "profileView.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface profileView ()
{
    CGFloat animatedDistance;
}

@end

@implementation profileView

@synthesize revealLeftMenu;
@synthesize txtCompanyAddress, txtCompanyEmail, txtCompanyName, txtContact, txtEmail, txtPIC, txtUsername;
@synthesize cancelSaveView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [SVProgressHUD showWithStatus:@"Loading information..." maskType:SVProgressHUDMaskTypeBlack];

    [self performSelector:@selector(initializeUserInformation) withObject:nil afterDelay:1];
    
    [self initializeTextFields];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
    
    [self disableAllTextFields];
}

-(void) initializeUserInformation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
    
    if(myBool)
    {
        [txtUsername setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userName"]];
        [txtEmail setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userEmail"]];
        [txtCompanyName setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"companyName"]];
        [txtCompanyAddress setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"companyAddress"]];
        [txtCompanyEmail setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"companyEmail"]];
        [txtPIC setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"personInCharge"]];
        [txtContact setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"contactNo"]];
        
        txtCompanyAddress.textColor = [UIColor colorWithRed: 100/255.0f green: 100/255.0f blue: 100/255.0f alpha: 1]; //optional
        
        [SVProgressHUD dismiss];
    }
}

-(void) disableAllTextFields
{
    [txtUsername setEnabled: NO];
    [txtCompanyAddress setEditable: NO];
    [txtCompanyEmail setEnabled: NO];
    [txtCompanyName setEnabled: NO];
    [txtContact setEnabled: NO];
    [txtEmail setEnabled: NO];
    [txtPIC setEnabled: NO];
}

-(void) enableAllTextFields
{
    [txtUsername setEnabled: YES];
    [txtCompanyAddress setEditable: YES];
    [txtCompanyEmail setEnabled: YES];
    [txtCompanyName setEnabled: YES];
    [txtContact setEnabled: YES];
    [txtEmail setEnabled: YES];
    [txtPIC setEnabled: YES];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Profile";
    
    txtCompanyAddress.delegate = self;
    txtCompanyAddress.text = @"Company address";
    txtCompanyAddress.textColor = [UIColor colorWithRed: 204/255.0f green: 204/255.0f blue: 204/255.0f alpha: 1]; //optional
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateProfile:(id)sender
{
    [self enableAllTextFields];
    
    [cancelSaveView setAlpha: 1.0];
}

-(void)dismissKeyboard
{
    [self.view endEditing: YES];
}

- (IBAction)cancelEdit:(id)sender
{
    [self disableAllTextFields];
    
    [cancelSaveView setAlpha: 0];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([txtCompanyAddress.text isEqualToString:@"Company address"])
    {
        txtCompanyAddress.text = @"";
        txtCompanyAddress.textColor = [UIColor colorWithRed: 100/255.0f green: 100/255.0f blue: 100/255.0f alpha: 1]; //optional
    }
    
    [txtCompanyAddress becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([txtCompanyAddress.text isEqualToString:@""])
    {
        txtCompanyAddress.text = @"Company address";
        txtCompanyAddress.textColor = [UIColor colorWithRed: 204/255.0f green: 204/255.0f blue: 204/255.0f alpha: 1]; //optional
    }
    
    [txtCompanyAddress resignFirstResponder];
}

- (IBAction)confirmEdit:(id)sender
{    
    /* sign up validation */
    
    if([txtUsername.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in username" ititle: @"Alert"];
        
        return;
    }
    
    if([txtUsername.text length] > 20)
    {
        [self showAlert: @"Username should be less than 20 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([txtEmail.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in email" ititle: @"Alert"];
        
        return;
    }
    
    if([txtEmail.text length] > 50)
    {
        [self showAlert: @"Email should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if(![self NSStringIsValidEmail: txtEmail.text])
    {
        [self showAlert: @"Email is not valid" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyName.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in company name" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyName.text length] > 50)
    {
        [self showAlert: @"Company name should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyAddress.text isEqualToString:@""] || [txtCompanyAddress.text isEqualToString:@"Company address"])
    {
        [self showAlert: @"Please fill in company address" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyAddress.text length] > 200)
    {
        [self showAlert: @"Company address should be less than 200 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyEmail.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in company email" ititle: @"Alert"];
        
        return;
    }
    
    if([txtCompanyEmail.text length] > 50)
    {
        [self showAlert: @"Company email should be less than 50 characters" ititle: @"Alert"];
        
        return;
    }
    
    if(![self NSStringIsValidEmail: txtCompanyEmail.text])
    {
        [self showAlert: @"Company email is not valid" ititle: @"Alert"];
        
        return;
    }
    
    if([txtPIC.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in person in charge" ititle: @"Alert"];
        
        return;
    }
    
    if([txtPIC.text length] > 20)
    {
        [self showAlert: @"Person in charge should be less than 20 characters" ititle: @"Alert"];
        
        return;
    }
    
    if([txtContact.text isEqualToString:@""])
    {
        [self showAlert: @"Please fill in contact no" ititle: @"Alert"];
        
        return;
    }
    
    if([txtContact.text length] > 15)
    {
        [self showAlert: @"Contact no should be less than 15 characters" ititle: @"Alert"];
        
        return;
    }
    
    /* end of validation */
    
    [SVProgressHUD showWithStatus:@"Updating profile..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self callUpdateProfileAPI];
}

-(void) callUpdateProfileAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    updateUserProfile *request = [[updateUserProfile alloc] init_updateUserProfile: txtUsername.text iuserID: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userID"] iemail: txtEmail.text icompanyName: txtCompanyName.text icompanyAddress: txtCompanyAddress.text icompanyEmail: txtCompanyEmail.text ipersonInCharge: txtPIC.text icontactNo: txtContact.text];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

-(void) showAlert :(NSString*) msg ititle:(NSString*) title
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:msg delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [message show];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"updateProfile"])
        {
            if([[responseMessage objectForKey: @"result"] intValue] != 0)
            {
                [SVProgressHUD dismiss];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userID"] forKey:@"userID"];
                [dict setValue: txtUsername.text forKey:@"userName"];
                [dict setValue: txtEmail.text forKey:@"userEmail"];
                [dict setValue: txtCompanyName.text forKey:@"companyName"];
                [dict setValue: txtCompanyEmail.text forKey:@"companyEmail"];
                [dict setValue: txtCompanyAddress.text forKey:@"companyAddress"];
                [dict setValue: txtContact.text forKey:@"contactNo"];
                [dict setValue: txtPIC.text forKey:@"personInCharge"];
                
                // store user information
                [[NSUserDefaults standardUserDefaults] setObject: dict forKey:@"userInformation"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Successful"
                            message: @"Your profile has been updated successfully" delegate:self
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
        }
    }
    
    [SVProgressHUD dismiss];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self disableAllTextFields];
    
    [cancelSaveView setAlpha: 0];
}

-(void) initializeTextFields
{
    txtUsername.delegate = self;
    txtEmail.delegate = self;
    txtCompanyName.delegate = self;
    txtCompanyEmail.delegate = self;
    txtPIC.delegate = self;
    txtContact.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == txtUsername)
    {
        [txtEmail becomeFirstResponder];
    }
    else if(textField == txtEmail)
    {
        [txtCompanyName becomeFirstResponder];
    }
    else if(textField == txtCompanyName)
    {
        [txtCompanyAddress becomeFirstResponder];
    }
    else if(textField == txtCompanyEmail)
    {
        [txtPIC becomeFirstResponder];
    }
    else if(textField == txtPIC)
    {
        [txtContact becomeFirstResponder];
    }
    else if(textField == txtContact)
    {
        [self dismissKeyboard];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
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

- (void)textFieldDidEndEditing:(UITextField *)textfield
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
