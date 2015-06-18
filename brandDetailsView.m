//
//  brandDetailsView.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "brandDetailsView.h"

@interface brandDetailsView ()

@end

@implementation brandDetailsView

@synthesize qp;
@synthesize imgBanner, imgBannerHeightConstraint, lblDescription;
@synthesize lbl;
@synthesize collectionViewHeightConstraint, dataArr, imgTopLine, productCollectionView;
@synthesize viewHeightConstraint;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    lbl = [[RTLabel alloc] init];
    
    [self.scrollView addSubview: lbl];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(callAPI) withObject:nil afterDelay:1];
}


-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(void) setUpView
{
    self.navigationItem.title = qp.name;
    
    self.navigationController.navigationBar.topItem.title = @"";
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getBrandsDetails *request = [[getBrandsDetails alloc] init_getBrandsDetails: qp.brandID];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);
    
    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getBrandById"])
        {            
            dataArr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < [[responseMessage objectForKey:@"data"] count]; i++)
            {
                brandDetail *bd = [[brandDetail alloc] init];
                [bd setName: [[[responseMessage objectForKey:@"data"] objectAtIndex: i] objectForKey: @"brand_name"]];
                [bd setImageURL: [[[responseMessage objectForKey:@"data"] objectAtIndex: i] objectForKey: @"brand_image_url"]];
                
                [dataArr addObject: bd];
            }
            
            
            [imgBanner setImageWithURL: [NSURL URLWithString: qp.imageURL] placeholderImage: [UIImage imageNamed:@"default_warehousestock"]];
            
            imgBannerHeightConstraint.constant = imgBanner.image.size.height;
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[qp.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            [lblDescription setAttributedText: attrStr];
            [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
            lblDescription.textAlignment = NSTextAlignmentCenter;
            [lblDescription setAlpha: 0];
            
            CGFloat maxLabelWidth = lblDescription.frame.size.width;
            CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
            
            [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height)];
            [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
            [lbl setText: qp.desc];
            [lbl setTextAlignment: RTTextAlignmentCenter];
            [lbl setAlpha: 1];
            
            int remainer = 0, divider = 0, totalRow = 0;
            
            remainer = [[responseMessage objectForKey:@"data"] count] % 2;
            
            divider = (int)[[responseMessage objectForKey:@"data"] count] / 2;

            totalRow = (remainer + divider) * 160;
            
            collectionViewHeightConstraint.constant = totalRow;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenHeight = screenRect.size.height;
            
            int estimateScreenComponentHeight = 80 + neededSize.height + imgBanner.image.size.height + totalRow;
            
            if(estimateScreenComponentHeight > screenHeight)
            {
                viewHeightConstraint.constant = estimateScreenComponentHeight + 10;
            }
            else
            {
                if(estimateScreenComponentHeight < 500)
                {
                    // remove scroll
                    screenHeight = screenHeight - 64;
                }
                
                viewHeightConstraint.constant = screenHeight;
            }
            
            if([[responseMessage objectForKey:@"data"] count] != 0)
            {   [imgTopLine setAlpha: 1];   }
            
            [productCollectionView reloadData];
        }
    }
    
    [SVProgressHUD dismiss];
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
    
    brandDetail *bd = [dataArr objectAtIndex: indexPath.row];
    
    UIImageView *img = (UIImageView*)[cell viewWithTag: 1];
    [img setImageWithURL: [NSURL URLWithString: bd.imageURL] placeholderImage: [UIImage imageNamed: @"default_placeanorder"]];
    
    UILabel *lblName = (UILabel*)[cell viewWithTag: 2];
    [lblName setText: bd.name];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index path : %d", indexPath.row);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

@end
