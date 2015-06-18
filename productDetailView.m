//
//  productDetailView.m
//  polyon
//
//  Created by Jun on 15/5/28.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "productDetailView.h"

@interface productDetailView ()

@end

@implementation productDetailView

@synthesize imgProduct, imgProductHeightConstraint;
@synthesize btnVideo, lblProductDescription, productDetailViewHeightConstraint, btnAdd;
@synthesize lbl;
@synthesize imgOverlay, pickerView;
@synthesize txtNumberOfItem, noPicker;
@synthesize pc, lblProductCode;
@synthesize fromView, btnUpdate, cartID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading product..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSLog(@"from location : %@", fromView);
    
    if ([fromView isEqualToString: @"update"])
    {
        [btnUpdate setAlpha: 1];
    }
    
    [self performSelector:@selector(callAPI_getProductByID) withObject:nil afterDelay:1];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(NSString*) getCartNumber
{
    cartItem *ci = [[cartItem alloc] init];
    
    NSString *total = [NSString stringWithFormat: @"%d", [ci retrieveTotalNumberOfCartItems]];
    
    return total;
}

-(void) callAPI_getProductByID
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getProductByID *request = [[getProductByID alloc] init_getProductByID: pc.productID];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) setUpView
{
    self.navigationItem.title = pc.productName;
    
    self.navigationController.navigationBar.topItem.title = @"";
        
    UIImage *image = [UIImage imageNamed:@"icon_placeanorder_2"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(viewCartItems) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    self.navigationItem.rightBarButtonItem.badgeValue = [self getCartNumber];
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:251/255.0f green:195/255.0f blue:10/255.0f alpha:1];
    self.navigationItem.rightBarButtonItem.badgeTextColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.badgeFont = [UIFont fontWithName: @"Century Gothic" size: 15];
}

-(void) viewCartItems
{
    placeAnOrderView *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceAnOrderVC"];
    [self.navigationController pushViewController:auvc animated:NO];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getProductById"])
        {
            [lblProductCode setText: [[responseMessage objectForKey: @"data"] objectForKey:@"product_code"]];
            
            int totalQuantity = [[[responseMessage objectForKey: @"data"] objectForKey:@"product_current_quantity"] intValue];
            
            pickerData = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < totalQuantity; i++)
            {
                [pickerData addObject: [NSString stringWithFormat: @"%d", i + 1]];
            }
            
            [noPicker reloadAllComponents];
            
            [imgProduct setImageWithURL: [NSURL URLWithString: pc.productImageURL] placeholderImage: [UIImage imageNamed: @"default_productscategory_1"]];
            
            imgProductHeightConstraint.constant = imgProduct.image.size.height;
            
            NSString * htmlString = [[responseMessage objectForKey: @"data"] objectForKey:@"product_desc"];
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [lblProductDescription setAttributedText: attrStr];
            [lblProductDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
            [lblProductDescription setTextAlignment: NSTextAlignmentCenter];
            [lblProductDescription setTextColor: [UIColor colorWithRed: 100/255.0f green: 100/255.0f blue: 100/255.0f alpha:1]];
            [lblProductDescription setAlpha: 1];
            
            CGFloat maxLabelWidth = lblProductDescription.frame.size.width;
            CGSize neededSize = [lblProductDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
            
            videoArr = [[responseMessage objectForKey: @"data"] objectForKey:@"videoArr"];
            
            if((imgProduct.image.size.height + neededSize.height) > productDetailViewHeightConstraint.constant)
            {
                int productCodePadding = 62;
                int videoPadding = 62;
                
                if([videoArr count] == 0){   videoPadding = 0;   [btnVideo setAlpha: 0];}
                else{   [btnVideo setAlpha: 1]; }
                
                productDetailViewHeightConstraint.constant = imgProduct.image.size.height + neededSize.height + 10 + videoPadding + productCodePadding;
            }
                        
            /*lbl = [[RTLabel alloc] init];
            
            [self.scrollView addSubview: lbl];
            
            // instead of using uilabel to show the text
            // use the label to get the height needed
            // then hide the label
            // use RTLabel to show the html tagged text
            // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            
            int newOriginXForRTLabel = (screenWidth - neededSize.width) / 2;
            
            [lbl setFrame: CGRectMake(newOriginXForRTLabel, lblProductDescription.frame.origin.y, neededSize.width, neededSize.height)];
            [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
            [lbl setLineSpacing: 0];
            [lbl setText: htmlString];
            [lbl setTextAlignment: RTTextAlignmentCenter];
            [lbl setAlpha: 0];*/
        }
    }
    
    [SVProgressHUD dismiss];
}

- (IBAction)addToCart:(id)sender
{
    [btnAdd setAlpha: 1];
    [imgOverlay setAlpha: 0.6];
    [pickerView setAlpha: 1];
}

- (IBAction)viewVideoList:(id)sender
{
    [self performSegueWithIdentifier: @"videoListSegue" sender: nil];
}

- (IBAction)addProduct:(id)sender
{
    cartItem *ci = [[cartItem alloc] init];
    [ci insertItemIntoCart: pc.productID iquantity: txtNumberOfItem.text];
    
    [btnAdd setAlpha: 0];
    [imgOverlay setAlpha: 0];
    [pickerView setAlpha: 0];
        
    self.navigationItem.rightBarButtonItem.badgeValue = [self getCartNumber];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Order Cart"
                                                      message: @"Item has been added into cart" delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [message show];
}

- (IBAction)minusNumber:(id)sender
{
    if([txtNumberOfItem.text intValue] != 0)
    {
        [txtNumberOfItem setText: [NSString stringWithFormat: @"%d", [txtNumberOfItem.text intValue] - 1]];
    }
}

- (IBAction)plusNumber:(id)sender
{
    [txtNumberOfItem setText: [NSString stringWithFormat: @"%d", [txtNumberOfItem.text intValue] + 1]];
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [txtNumberOfItem setText: pickerData[row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"videoListSegue"])
    {
        videoListView *SegueController = (videoListView*)[segue destinationViewController];
        SegueController.dataArr = videoArr;
    }
}

- (IBAction)updateCart:(id)sender
{
    int decider = updateCounter % 2;
    
    if(decider == 0)
    {
        [imgOverlay setAlpha: 0.6];
        [pickerView setAlpha: 1];
        
        [txtNumberOfItem setText: pc.productQuantity];
        
        [noPicker selectRow: [pc.productQuantity intValue] - 1 inComponent: 0 animated: YES];
    }
    else
    {
        [imgOverlay setAlpha: 0];
        [pickerView setAlpha: 0];
        
        // update here
        
        cartItem *ci = [[cartItem alloc] init];
        [ci updateCartItem: cartID iquantity: txtNumberOfItem.text];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Order Cart"
                        message: @"Item has been updated in cart" delegate:self
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [message show];
    }
    
    updateCounter++;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void) proceedExecution
{
    imgProductHeightConstraint.constant = imgProduct.image.size.height;
    
    NSString * htmlString = @"<p><strong>Tax Filing for Married Individuals<br /></strong>There are many financial benefits available to individuals who are married and file <a href='/terms/j/jointreturn.asp'>joint tax returns</a>. For instance, the <a href='/terms/s/standarddeduction.asp'>standard deduction</a> is higher for married couples who file a joint return. Another example is where one spouse has little or no income (referred to as the non-working spouse), and the working spouse's taxable income can be used as 'eligible compensation' for purposes of funding the non-working spouse's <a href='/terms/s/spousalira.asp'>IRA</a>. This can result in a considerable increase in retirement savings for the couple by the time they retire. However, there are also circumstances where it may make better financial sense to file separate returns. For instance, if the family incurs a significant amount of medical expenses that were not reimbursed through a health plan, or if they have several miscellaneous deductions, filing separate returns may result in a lower tax bill. To be sure, couples should consult with a tax professional, who will be able to demonstrate the net financial effect of filing both options, making it possible to choose the one that will either result in the lowest tax liability or the greater tax refund amount. The amount saved could be used to fund a retirement account for one or both spouses. (For more on this, check out <a href='/articles/retirement/06/marriedperks.asp'><em>The Benefits Of Having A Spouse</em></a>.)</p>";
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [lblProductDescription setAttributedText: attrStr];
    [lblProductDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
    [lblProductDescription setAlpha: 0];
    
    CGFloat maxLabelWidth = lblProductDescription.frame.size.width;
    CGSize neededSize = [lblProductDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    
    if((imgProduct.image.size.height + neededSize.height) > productDetailViewHeightConstraint.constant)
    {
        int productCodePadding = 62;
        int videoPadding = 62;
        
        int needVideoButton = 1;
        
        if(needVideoButton == 0){   videoPadding = 0;   [btnVideo setAlpha: 0];}
        
        productDetailViewHeightConstraint.constant = imgProduct.image.size.height + neededSize.height + 10 + videoPadding + productCodePadding;
    }
    
    lbl = [[RTLabel alloc] init];
    
    [self.scrollView addSubview: lbl];
    
    // instead of using uilabel to show the text
    // use the label to get the height needed
    // then hide the label
    // use RTLabel to show the html tagged text
    // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
    
    [lbl setFrame: CGRectMake(lblProductDescription.frame.origin.x, lblProductDescription.frame.origin.y, neededSize.width, neededSize.height)];
    [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
    [lbl setLineSpacing: 0];
    [lbl setText: htmlString];
}
*/

@end
