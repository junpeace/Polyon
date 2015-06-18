//
//  placeAnOrderView.m
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "placeAnOrderView.h"

@interface placeAnOrderView ()

@end

@implementation placeAnOrderView

@synthesize revealLeftMenu, imgNoOrder;
@synthesize dataArr, tblOrder, productIdArr, productQuantityArr, cartIdArr;
@synthesize imgOrderSubmitted;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // ok
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
}

-(void) getCartItems
{
    cartItem *ci = [[cartItem alloc] init];
    
    NSArray *arr = [ci retrieveAllCartItems];
    
    productIdArr = [[NSMutableArray alloc] init];
    productQuantityArr = [[NSMutableArray alloc] init];
    cartIdArr = [[NSMutableArray alloc] init];
    
    if([arr count] > 0)
    {
        for(int i = 0; i < arr.count; i++)
        {
            cartProduct *cp = [arr objectAtIndex: i];
            
            NSLog(@"cart id : %@", cp.cartID);
            
            [cartIdArr addObject: cp.cartID];
            [productIdArr addObject: cp.productID];
            [productQuantityArr addObject: cp.productQuantity];
        }
        
        [self callAPI_getProductDetails];
    }
    else
    {
        [SVProgressHUD dismiss];
        
        [imgNoOrder setAlpha: 1];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
    
    [self performSelector:@selector(getCartItems) withObject:nil afterDelay:1.5];
}

-(void) callAPI_getProductDetails
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getProductDetails *request = [[getProductDetails alloc] init_getProductDetails: productIdArr];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) callAPI_submitOrder
{
    [SVProgressHUD showWithStatus:@"Submitting order..." maskType:SVProgressHUDMaskTypeBlack];

    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [dataArr count]; i++)
    {
        productCategory *pc = [dataArr objectAtIndex: i];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue: pc.productID forKey:@"product_id"];
        [dict setValue: pc.productQuantity forKey:@"quantity"];
        
        [tempArr addObject: dict];
    }
    
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    submitOrder *request = [[submitOrder alloc] init_getProductDetails: tempArr iuserID: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userID"]];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Place An Order";
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

- (IBAction)submitOrder:(id)sender
{    
    if([dataArr count] == 0)
    {   return; }

    UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Submit Order"
                    message: @"Do you want to submit your order now?" delegate:self
                                cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    message.tag = 1;
    [message show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    productCategory *pc = [dataArr objectAtIndex: indexPath.row];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    
    [imgView setImageWithURL: [NSURL URLWithString: pc.productImageURL] placeholderImage: [UIImage imageNamed: @"default_socialmedia"]];
    
    UIButton *btnDelete = (UIButton*)[cell viewWithTag:2];
    [btnDelete addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblProductCode = (UILabel*)[cell viewWithTag: 3];
    [lblProductCode setText: pc.productCode];

    UILabel *lblProductName = (UILabel*)[cell viewWithTag: 4];
    [lblProductName setText: pc.productName];
    
    UILabel *lblPath = (UILabel*)[cell viewWithTag: 5];
    [lblPath setText: pc.path];
    
    UILabel *lblProductQuantity = (UILabel*)[cell viewWithTag: 6];
    [lblProductQuantity setText: pc.productQuantity];

    return cell;
}

-(void)deleteOrder: (UIButton*)sender
{
    UITableViewCell* cell = [(UITableViewCell*)[sender superview] superview];
    NSIndexPath* indexPath = [tblOrder indexPathForCell:cell];
    
    NSLog(@"delete order index : %d", indexPath.row);
    
    selectedIndex = indexPath.row;
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Delete Cart"
                                                      message: @"Do you really want to delete this item?" delegate:self
                                            cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    message.tag = 3;
    [message show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected : %ld", (long)indexPath.row);
    
    selectedSegueIndex = indexPath.row;
    
    [self performSegueWithIdentifier: @"productDetailSegue" sender: nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getProductsDetails"])
        {
            dataArr = [[NSMutableArray alloc] init];
            
            NSArray *temp = [responseMessage objectForKey: @"data"];
            
            NSMutableString *str;
        
            for(int i = 0; i < temp.count; i++)
            {
                productCategory *pc = [[productCategory alloc] init];
                
                str = [[NSMutableString alloc] init];
                
                [pc setProductName: [[temp objectAtIndex: i] objectForKey: @"product_name"]];
                [pc setProductCode: [[temp objectAtIndex: i] objectForKey: @"product_code"]];
                [pc setProductID: [[temp objectAtIndex: i] objectForKey: @"product_id"]];
                [pc setProductQuantity: [productQuantityArr objectAtIndex: i]];
                
                NSArray *img = [[temp objectAtIndex: i] objectForKey: @"imageArr"];
                
                if([img count] > 0)
                {
                    [pc setProductImageURL: [[img objectAtIndex: 0] objectForKey: @"product_image"]];
                }
                
                NSArray *parentCat = [[temp objectAtIndex: i] objectForKey: @"ParentCategoriyList"];
                
                for(int j = [parentCat count] - 1; j >= 0; j--)
                {
                    if([[[parentCat objectAtIndex: j] objectForKey:@"category_id"] intValue] == 0)
                    {   continue;   }
                    
                    [str appendString: [NSString stringWithFormat: @"%@/", [[parentCat objectAtIndex: j] objectForKey:@"category_name"]]];
                }
                
                [pc setPath: str];
                
                [dataArr addObject: pc];
            }
            
            [tblOrder reloadData];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"submitOrder"])
        {
            if([[responseMessage objectForKey: @"result"] intValue] == 1)
            {
                dataArr = [[NSMutableArray alloc] init];

                [tblOrder reloadData];
                
                // delete all order from local
                cartItem *ci = [[cartItem alloc] init];
                [ci deleteAllItem];
                
                // show the stupid image
                [imgOrderSubmitted setAlpha: 1];
            }
            else
            {
                // failed
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Error"
                                                                  message: @"Failed to submit order" delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [message show];
            }
        }
    }
    
    [SVProgressHUD dismiss];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
            
            if(!myBool)
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Login Required"
                                                                  message: @"Please log in to submit order" delegate:self
                                                        cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                message.tag = 2;
                [message show];
            }
            else
            {
                [self callAPI_submitOrder];
            }
        }
    }
    else if(alertView.tag == 2)
    {
        // loginView *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        // [self.navigationController pushViewController:auvc animated:NO];
        
        [self performSegueWithIdentifier: @"gotoLoginSegue" sender: nil];
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 1)
        {
             cartItem *ci = [[cartItem alloc] init];
             [ci deleteItem: [[cartIdArr objectAtIndex: selectedIndex] intValue]];
             
             [dataArr removeObjectAtIndex: selectedIndex];
             
             [tblOrder reloadData];
             
             if([dataArr count] == 0)
             {   [imgNoOrder setAlpha: 1];   }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"productDetailSegue"])
    {
        productDetailView *SegueController = (productDetailView*)[segue destinationViewController];
        SegueController.pc = [dataArr objectAtIndex: selectedSegueIndex];
        SegueController.fromView = @"update";
        SegueController.cartID = [cartIdArr objectAtIndex: selectedSegueIndex];
    }
    else if([[segue identifier]isEqualToString:@"gotoLoginSegue"])
    {
        loginView *SegueController = (loginView*)[segue destinationViewController];
        SegueController.fromPlaceAnOrder = @"YES";
    }
}

@end
