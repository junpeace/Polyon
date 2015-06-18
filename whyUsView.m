//
//  whyUsView.m
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "whyUsView.h"

@interface whyUsView ()

@end

@implementation whyUsView

@synthesize revealLeftMenu;
@synthesize imgTapButtonBackground, tapButtonBackgroundWidthConstraint, tapButtonViewWidthConstraint;
@synthesize lblQuaityProducts, lblWarehouseAndStock;
@synthesize dataArr, tblQualityProducts, dataArrWS;
@synthesize tblWarehouseAndFactory;

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(callAPI_getQualityProducts) withObject:nil afterDelay:1];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Why Us";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    NSLog(@"screen width : %f", screenWidth);
    
    if(screenWidth == 320)
    {
        tapButtonBackgroundWidthConstraint.constant = 294;
        tapButtonViewWidthConstraint.constant = 294;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if(tableView == tblQualityProducts)
    {
        return [dataArr count];
    }
    
    return [dataArrWS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    
    if(tableView == tblQualityProducts)
    {
        CellIdentifier = @"productCell";
    }
    else
    {
        CellIdentifier = @"factoryCell";
    }
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if(tableView == tblQualityProducts)
    {
        qualityProduct *qp = [dataArr objectAtIndex: indexPath.row];
    
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        [lblName setText: qp.name];
    
        UIImageView *imgProduct = (UIImageView*)[cell viewWithTag:2];
        [imgProduct setImageWithURL: [NSURL URLWithString: qp.imageURL] placeholderImage: nil];
    }
    else
    {
        factoryStock *fs = [dataArrWS objectAtIndex: indexPath.row];
        
        UIImageView *imgFactory = (UIImageView*)[cell viewWithTag:1];
        [imgFactory setImageWithURL: [NSURL URLWithString: fs.imageURL] placeholderImage: nil];
                
        UILabel *lblName = (UILabel*)[cell viewWithTag:2];
        [lblName setText: fs.title];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblQualityProducts)
    {
        return 80.0f;
    }
    
    return 185.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected : %ld", (long)indexPath.row);
    
    if(tableView == tblQualityProducts)
    {
        selectedQualityProductIndex = indexPath.row;
        
        [self performSegueWithIdentifier: @"getBrandDetailSegue" sender: nil];
    }
    else
    {
        selectedFacotryWarehouseIndex = indexPath.row;
        
        [self performSegueWithIdentifier: @"warehouseFactorySegue" sender: nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void) callAPI_getQualityProducts
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getBrands *request = [[getBrands alloc] init_getBrands];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) callAPI_getWarehouseAndStock
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getWarehouseAndStock *request = [[getWarehouseAndStock alloc] init_getWarehouseAndStock];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getBrands"])
        {            
            NSArray *temp = [responseMessage objectForKey:@"data"];
            
            dataArr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < [temp count]; i++)
            {
                qualityProduct *qp = [[qualityProduct alloc] init];
                [qp setName: [[temp objectAtIndex: i] objectForKey: @"name"]];
                [qp setBrandID: [[temp objectAtIndex: i] objectForKey: @"brand_id"]];
                [qp setDesc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                [qp setImageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                
                [dataArr addObject: qp];
            }
            
            [tblQualityProducts reloadData];
            
            [tblQualityProducts setAlpha: 1];
            [tblWarehouseAndFactory setAlpha: 0];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getFactoryStocks"])
        {
            NSArray *temp = [responseMessage objectForKey:@"data"];
            
            dataArrWS = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < [temp count]; i++)
            {
                factoryStock *fs = [[factoryStock alloc] init];
                [fs setFactoryID: [[temp objectAtIndex: i] objectForKey: @"factory_id"]];
                [fs setTitle: [[temp objectAtIndex: i] objectForKey: @"title"]];
                [fs setDesc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                [fs setImageURL: [[temp objectAtIndex: i] objectForKey: @"image"]];
                
                [dataArrWS addObject: fs];
            }
            
            [tblWarehouseAndFactory reloadData];
            
            [tblQualityProducts setAlpha: 0];
            [tblWarehouseAndFactory setAlpha: 1];
        }
    }
    
    [SVProgressHUD dismiss];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"getBrandDetailSegue"])
    {
        brandDetailsView *SegueController = (brandDetailsView*)[segue destinationViewController];
        SegueController.qp = [dataArr objectAtIndex: selectedQualityProductIndex];
    }
    else if([[segue identifier] isEqualToString:@"warehouseFactorySegue"])
    {
        factoryView *SegueController = (factoryView*)[segue destinationViewController];
        SegueController.fs = [dataArrWS objectAtIndex: selectedFacotryWarehouseIndex];
    }
}

- (IBAction)showQualityProduct:(id)sender
{
    if([imgTapButtonBackground.image isEqual:[UIImage imageNamed:@"btn_tab_rightactive"]])
    {
        lblQuaityProducts.textColor = [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:1];
        lblWarehouseAndStock.textColor = [UIColor colorWithRed:(57/255.f) green:(181/255.f) blue:(74/255.f) alpha:1];
        
        [imgTapButtonBackground setImage: [UIImage imageNamed:@"btn_tab_lefttactive"]];
        
        if([dataArr count] == 0)
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];

            [self callAPI_getQualityProducts];
        }
        else
        {
            [tblWarehouseAndFactory setAlpha: 0];
            [tblQualityProducts setAlpha: 1];
        }        
    }
}

- (IBAction)showWarehouseAndStock:(id)sender
{
    if([imgTapButtonBackground.image isEqual:[UIImage imageNamed:@"btn_tab_lefttactive"]])
    {
        lblWarehouseAndStock.textColor = [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:1];
        lblQuaityProducts.textColor = [UIColor colorWithRed:(57/255.f) green:(181/255.f) blue:(74/255.f) alpha:1];
        
        [imgTapButtonBackground setImage: [UIImage imageNamed:@"btn_tab_rightactive"]];
        
        if ([dataArrWS count] == 0)
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];

            [self callAPI_getWarehouseAndStock];
        }
        else
        {
            [tblWarehouseAndFactory setAlpha: 1];
            [tblQualityProducts setAlpha: 0];
        }
    }
}

@end
