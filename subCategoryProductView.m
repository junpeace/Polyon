//
//  subCategoryProductView.m
//  polyon
//
//  Created by Jun on 15/6/1.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "subCategoryProductView.h"

@interface subCategoryProductView ()

@end

@implementation subCategoryProductView

@synthesize pc, dataArr, productCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading products..." maskType:SVProgressHUDMaskTypeBlack];

    [self performSelector:@selector(callAPI_getProductAndCategory) withObject:nil afterDelay:1];
}

-(void) callAPI_getProductAndCategory
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getProductAndCategory *request = [[getProductAndCategory alloc] init_getProductAndCategory: pc.categoryID];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) callAPI_getProductCategory
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getProductCategory *request = [[getProductCategory alloc] init_getProductCategory: pc.categoryID];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) callAPI_getProducts
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getProducts *request = [[getProducts alloc] init_getProducts: pc.categoryID];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
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

-(void) setUpView
{    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.title = pc.categoryName;
    
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

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"productCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    productCategory *pc_ = [dataArr objectAtIndex: indexPath.row];
    
    UIImageView *imgProduct = (UIImageView*)[cell viewWithTag:1];
    UILabel *lblName = (UILabel*)[cell viewWithTag:2];
    
    if([pc_.type isEqualToString: @"Category"])
    {
        [lblName setBackgroundColor: [UIColor colorWithRed: 249/255.0f green: 192/255.0f blue: 9/255.0f alpha:1]];
        [lblName setText: pc_.categoryName];
        [imgProduct setImageWithURL: [NSURL URLWithString: pc_.categoryImageURL] placeholderImage: [UIImage imageNamed: @"default_productscategory_1"]];
    }
    else
    {
        [lblName setBackgroundColor: [UIColor colorWithRed: 127/255.0f green: 214/255.0f blue: 254/255.0f alpha:1]];
        [lblName setText: pc_.productName];
        [imgProduct setImageWithURL: [NSURL URLWithString: pc_.productImageURL] placeholderImage: [UIImage imageNamed: @"default_productscategory_1"]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 170);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    productCategory *pc_ = [dataArr objectAtIndex: indexPath.row];
    
    if([pc_.type isEqualToString: @"Category"])
    {
        [self performSegueWithIdentifier: @"subCategoryProductSegue" sender: nil];
    }
    else
    {
        [self performSegueWithIdentifier: @"productDetailSegue" sender: nil];
    }
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getProductCategory"])
        {
            // NSLog(@"data : %@", [responseMessage objectForKey: @"data"]);
            
            dataArr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < [[responseMessage objectForKey: @"data"] count]; i++)
            {
                productCategory *pc_ = [[productCategory alloc] init];
                [pc_ setType: @"Category"];
                [pc_ setCategoryID: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"category_id"]];
                [pc_ setCategoryName: [[[responseMessage objectForKey: @"data"] objectAtIndex: i]objectForKey: @"category_name"]];
                [pc_ setCategorySequenceNo: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"sequence_no"]];
                [pc_ setCategoryImageURL: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"category_image_url"]];
                
                [dataArr addObject: pc_];
            }
            
            NSLog(@"data arr count : %d", [dataArr count]);
            
            [self callAPI_getProducts];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getProducts"])
        {
            for(int i = 0; i < [[responseMessage objectForKey: @"data"] count]; i++)
            {
                // add product here
                
                productCategory *pc_ = [[productCategory alloc] init];
                [pc_ setType: @"Product"];
                [pc_ setProductID: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"product_id"]];
                [pc_ setProductName: [[[responseMessage objectForKey: @"data"] objectAtIndex: i]objectForKey: @"product_name"]];
                [pc_ setProductSequenceNo: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"image_sequence"]];
                [pc_ setProductImageURL: [[[responseMessage objectForKey: @"data"] objectAtIndex: i] objectForKey: @"product_image"]];
                
                [dataArr addObject: pc_];
            }
            
            [productCollectionView reloadData];
            
            [SVProgressHUD dismiss];
        }
        else if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getProductsCategoriesByCategoryId"])
        {
            dataArr = [[NSMutableArray alloc] init];
            
            NSArray *catArr = [[responseMessage objectForKey: @"data"] objectForKey: @"categoryList"];
            
            for(int i = 0; i < [catArr count]; i++)
            {
                productCategory *pc_ = [[productCategory alloc] init];
                [pc_ setType: @"Category"];
                [pc_ setCategoryID: [[catArr objectAtIndex: i] objectForKey: @"category_id"]];
                [pc_ setCategoryName: [[catArr objectAtIndex: i] objectForKey: @"category_name"]];
                [pc_ setCategorySequenceNo: [[catArr objectAtIndex: i] objectForKey: @"sequence_no"]];
                [pc_ setCategoryImageURL: [[catArr objectAtIndex: i] objectForKey: @"category_image_url"]];
                
                [dataArr addObject: pc_];
            }
            
            NSArray *productArr = [[responseMessage objectForKey: @"data"] objectForKey: @"productList"];
            
            for(int i = 0; i < [productArr count]; i++)
            {
                productCategory *pc_ = [[productCategory alloc] init];
                [pc_ setType: @"Product"];
                [pc_ setProductID: [[productArr objectAtIndex: i] objectForKey: @"product_id"]];
                [pc_ setProductName: [[productArr objectAtIndex: i]objectForKey: @"product_name"]];
                [pc_ setProductSequenceNo: [[productArr objectAtIndex: i] objectForKey: @"image_sequence"]];
                [pc_ setProductImageURL: [[productArr objectAtIndex: i] objectForKey: @"product_image"]];
                
                [dataArr addObject: pc_];
            }
            
            
            [productCollectionView reloadData];
            
            [SVProgressHUD dismiss];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"subCategoryProductSegue"])
    {
        subCategoryProductView *SegueController = (subCategoryProductView*)[segue destinationViewController];
        SegueController.pc = [dataArr objectAtIndex: selectedIndex];
    }
    else if([[segue identifier] isEqualToString:@"productDetailSegue"])
    {        
        productDetailView *SegueController = (productDetailView*)[segue destinationViewController];
        SegueController.pc = [dataArr objectAtIndex: selectedIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
