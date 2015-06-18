//
//  forgotPasswordView.m
//  polyon
//
//  Created by jun on 5/21/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "forgotPasswordView.h"

@interface forgotPasswordView ()

@end

@implementation forgotPasswordView

@synthesize txtEmail;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self initializeTextField];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(void) setUpView
{
    self.navigationItem.title = @"Forgotten Your Password";
    
    self.navigationController.navigationBar.topItem.title = @"";
}

-(void) initializeTextField
{
    txtEmail.delegate = self;
}

-(void)dismissKeyboard
{
    [txtEmail resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPassword:(id)sender
{
    if([self NSStringIsValidEmail:txtEmail.text])
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
        
        forgetPassword *request = [[forgetPassword alloc] init_forgetPassword:txtEmail.text];
        
        [networkHandler setDelegate:(id)self];
        
        [networkHandler request:request];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Message"
                        message: @"Invalid email. Please check your email address." delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [message show];
    }
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"forgetPassword"])
        {
            if ([[responseMessage objectForKey:@"result"] isEqualToString:@"1"])
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Password Sent"
                                                                  message: @"Your password has been sent to you successfully. Please check your email for more details." delegate:self
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Invalid Email"
                                                                  message: @"Please check your email address." delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [message show];
            }
            
            [SVProgressHUD dismiss];
        }
    }
    else
    {
        NSLog(@"error :- forgetPasswordView");
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == txtEmail){  [self dismissKeyboard]; }
    
    return YES;
}

@end
