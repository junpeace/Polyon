//
//  aboutUsView.m
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "aboutUsView.h"

@interface aboutUsView ()

@end

@implementation aboutUsView

@synthesize revealLeftMenu;
@synthesize btnCoreValueWidthConstraint, btnHistoryWidthConstraint, btnMissionWidthConstraint, btnVisionWidthConstraint;
@synthesize vmvhViewWidthConstraint, imgBanner, imgBannerHeightConstraint, lblDescription;
@synthesize detailViewHeightConstraint;
@synthesize lbl;
@synthesize btnCoreValue, btnHistory, btnMission, btnVision;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
        
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    lbl = [[RTLabel alloc] init];
    
    [self.scrollView addSubview: lbl];
    
    [self callAPI];
}

-(void) callAPI
{
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    
    getCompanyProfile *request = [[getCompanyProfile alloc] init_getCompanyProfile];
    
    [networkHandler setDelegate:(id)self];
    
    [networkHandler request:request];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"About Polyon";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"screen width : %f", screenWidth);
    NSLog(@"screen height : %f", screenHeight);
    
    if(screenWidth == 320)
    {
        vmvhViewWidthConstraint.constant = 320;

        btnCoreValueWidthConstraint.constant = 80;
        btnHistoryWidthConstraint.constant = 80;
        btnMissionWidthConstraint.constant = 80;
        btnVisionWidthConstraint.constant = 80;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)handleRecievedResponseMessage:(NSDictionary *)responseMessage
{
    // NSLog(@"response : %@", responseMessage);

    if (responseMessage != nil)
    {
        if ([[responseMessage objectForKey:@"action"] isEqualToString:@"getCompanyProfile"])
        {
            // NSLog(@"data : %@", [responseMessage objectForKey:@"data"]);
            
            NSArray *temp = [responseMessage objectForKey:@"data"];
            
            au = [[aboutUs alloc] init];
            
            for(int i = 0; i < temp.count; i++)
            {
                if ([[[temp objectAtIndex: i] objectForKey: @"title"] isEqualToString:@"About Polyon"])
                {
                    [au setAboutUs_desc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                    [au setAboutUs_imageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                }
                else if ([[[temp objectAtIndex: i] objectForKey: @"title"] isEqualToString:@"Vision"])
                {
                    [au setVision_desc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                    [au setVision_imageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                }
                else if ([[[temp objectAtIndex: i] objectForKey: @"title"] isEqualToString:@"Mission"])
                {
                    [au setMission_desc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                    [au setMission_imageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                }
                else if ([[[temp objectAtIndex: i] objectForKey: @"title"] isEqualToString:@"Core Value"])
                {
                    [au setCv_desc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                    [au setCv_imageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                }
                else if ([[[temp objectAtIndex: i] objectForKey: @"title"] isEqualToString:@"History"])
                {
                    [au setHistory_desc: [[temp objectAtIndex: i] objectForKey: @"description"]];
                    [au setHistory_imageURL: [[temp objectAtIndex: i] objectForKey: @"image_url"]];
                }
            }
        
            [self sample];
        }
    }
    
    [SVProgressHUD dismiss];
}

- (IBAction)viewVision:(id)sender
{
    [btnVision setImage: [UIImage imageNamed: @"btn_vision_active"] forState: UIControlStateNormal];
    [btnMission setImage: [UIImage imageNamed: @"btn_mission"] forState: UIControlStateNormal];
    [btnCoreValue setImage: [UIImage imageNamed: @"btn_corevalues"] forState: UIControlStateNormal];
    [btnHistory setImage: [UIImage imageNamed: @"btn_history"] forState: UIControlStateNormal];
    
    self.navigationItem.title = @"Vision";
    
    [imgBanner setImageWithURL:[NSURL URLWithString: au.vision_imageURL]
                   placeholderImage:[UIImage imageNamed:@"default_placeanorder"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              //... completion code here ...
                              
                              imgBannerHeightConstraint.constant = imgBanner.image.size.height;
                              
                              NSString * htmlString = au.vision_desc;
                              
                              NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                              
                              [lblDescription setAttributedText: attrStr];
                              [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
                              [lblDescription setAlpha: 0];
                              
                              CGFloat maxLabelWidth = lblDescription.frame.size.width;
                              CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
                              
                              //reset constraint
                              detailViewHeightConstraint.constant = 460;
                              
                              if((imgBanner.image.size.height + neededSize.height) > detailViewHeightConstraint.constant)
                              {
                                  detailViewHeightConstraint.constant = imgBanner.image.size.height + neededSize.height + 10;
                              }
                              
                              // instead of using uilabel to show the text
                              // use the label to get the height needed
                              // then hide the label
                              // use RTLabel to show the html tagged text
                              // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
                              
                              [lbl setAlpha: 0];
                              [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height + 20)];
                              [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
                              [lbl setLineSpacing: 1];
                              [lbl setText: htmlString];
                              [lbl setAlpha: 1];
                              
                              [self performSelector:@selector(scrollToTop) withObject:nil afterDelay: 0.5];
                          }];
}

- (IBAction)viewMission:(id)sender
{
    [btnVision setImage: [UIImage imageNamed: @"btn_vision"] forState: UIControlStateNormal];
    [btnMission setImage: [UIImage imageNamed: @"btn_mission_active"] forState: UIControlStateNormal];
    [btnCoreValue setImage: [UIImage imageNamed: @"btn_corevalues"] forState: UIControlStateNormal];
    [btnHistory setImage: [UIImage imageNamed: @"btn_history"] forState: UIControlStateNormal];
    
    self.navigationItem.title = @"Mission";
    
    [imgBanner setImageWithURL:[NSURL URLWithString: au.mission_imageURL]
              placeholderImage:[UIImage imageNamed:@"default_placeanorder"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         //... completion code here ...
                         
                         imgBannerHeightConstraint.constant = imgBanner.image.size.height;
                         
                         NSString * htmlString = au.mission_desc;
                         
                         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                         
                         [lblDescription setAttributedText: attrStr];
                         [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
                         [lblDescription setAlpha: 0];
                         
                         CGFloat maxLabelWidth = lblDescription.frame.size.width;
                         CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
                         
                         //reset constraint
                         detailViewHeightConstraint.constant = 460;
                         
                         if((imgBanner.image.size.height + neededSize.height) > detailViewHeightConstraint.constant)
                         {
                             detailViewHeightConstraint.constant = imgBanner.image.size.height + neededSize.height + 10;
                         }
                         
                         // instead of using uilabel to show the text
                         // use the label to get the height needed
                         // then hide the label
                         // use RTLabel to show the html tagged text
                         // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
                         
                         [lbl setAlpha: 0];
                         [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height + 20)];
                         [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
                         [lbl setLineSpacing: 1];
                         [lbl setText: htmlString];
                         [lbl setAlpha: 1];
                         
                         [self performSelector:@selector(scrollToTop) withObject:nil afterDelay: 0.5];
                         
                     }];
}

- (IBAction)viewCoreValue:(id)sender
{
    [btnVision setImage: [UIImage imageNamed: @"btn_vision"] forState: UIControlStateNormal];
    [btnMission setImage: [UIImage imageNamed: @"btn_mission"] forState: UIControlStateNormal];
    [btnCoreValue setImage: [UIImage imageNamed: @"btn_corevalues_active"] forState: UIControlStateNormal];
    [btnHistory setImage: [UIImage imageNamed: @"btn_history"] forState: UIControlStateNormal];
    
    self.navigationItem.title = @"Core Values";
    
    [imgBanner setImageWithURL:[NSURL URLWithString: au.cv_imageURL]
              placeholderImage:[UIImage imageNamed:@"default_placeanorder"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         //... completion code here ...
                         
                         imgBannerHeightConstraint.constant = imgBanner.image.size.height;
                         
                         NSString * htmlString = au.cv_desc;
                         
                         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                         
                         [lblDescription setAttributedText: attrStr];
                         [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
                         [lblDescription setAlpha: 0];
                         
                         CGFloat maxLabelWidth = lblDescription.frame.size.width;
                         CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
                         
                         //reset constraint
                         detailViewHeightConstraint.constant = 460;
                         
                         if((imgBanner.image.size.height + neededSize.height) > detailViewHeightConstraint.constant)
                         {
                             detailViewHeightConstraint.constant = imgBanner.image.size.height + neededSize.height + 10;
                         }
                         
                         // instead of using uilabel to show the text
                         // use the label to get the height needed
                         // then hide the label
                         // use RTLabel to show the html tagged text
                         // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
                         
                         [lbl setAlpha: 0];
                         [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height + 20)];
                         [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
                         [lbl setLineSpacing: 1];
                         [lbl setText: htmlString];
                         [lbl setAlpha: 1];
                         
                         [self performSelector:@selector(scrollToTop) withObject:nil afterDelay: 0.5];
                         
                     }];
}

- (IBAction)viewHistory:(id)sender
{
    [btnVision setImage: [UIImage imageNamed: @"btn_vision"] forState: UIControlStateNormal];
    [btnMission setImage: [UIImage imageNamed: @"btn_mission"] forState: UIControlStateNormal];
    [btnCoreValue setImage: [UIImage imageNamed: @"btn_corevalues"] forState: UIControlStateNormal];
    [btnHistory setImage: [UIImage imageNamed: @"btn_history_active"] forState: UIControlStateNormal];
    
    self.navigationItem.title = @"History";
    
    [imgBanner setImageWithURL:[NSURL URLWithString: au.history_imageURL]
              placeholderImage:[UIImage imageNamed:@"default_placeanorder"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         //... completion code here ...
                         
                         imgBannerHeightConstraint.constant = imgBanner.image.size.height;
                         
                         NSString * htmlString = au.history_desc;
                         
                         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                         
                         [lblDescription setAttributedText: attrStr];
                         [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
                         [lblDescription setAlpha: 0];
                         
                         CGFloat maxLabelWidth = lblDescription.frame.size.width;
                         CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
                         
                         //reset constraint
                         detailViewHeightConstraint.constant = 460;
                         
                         if((imgBanner.image.size.height + neededSize.height) > detailViewHeightConstraint.constant)
                         {
                             detailViewHeightConstraint.constant = imgBanner.image.size.height + neededSize.height + 10;
                         }
                         
                         // instead of using uilabel to show the text
                         // use the label to get the height needed
                         // then hide the label
                         // use RTLabel to show the html tagged text
                         // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
                         
                         [lbl setAlpha: 0];
                         [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height + 20)];
                         [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
                         [lbl setLineSpacing: 1];
                         [lbl setText: htmlString];
                         [lbl setAlpha: 1];
                         
                         [self performSelector:@selector(scrollToTop) withObject:nil afterDelay: 0.5];
                     }];
}

- (IBAction)showAboutUs:(id)sender
{
    self.navigationItem.title = @"About Polyon";
    
    [self sample];
}

-(void) sample
{
    [btnVision setImage: [UIImage imageNamed: @"btn_vision"] forState: UIControlStateNormal];
    [btnMission setImage: [UIImage imageNamed: @"btn_mission"] forState: UIControlStateNormal];
    [btnCoreValue setImage: [UIImage imageNamed: @"btn_corevalues"] forState: UIControlStateNormal];
    [btnHistory setImage: [UIImage imageNamed: @"btn_history"] forState: UIControlStateNormal];
    
    [imgBanner setImageWithURL:[NSURL URLWithString: au.aboutUs_imageURL]
              placeholderImage:[UIImage imageNamed:@"default_placeanorder"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         //... completion code here ...
                         
                         imgBannerHeightConstraint.constant = imgBanner.image.size.height;
                         
                         NSString * htmlString = au.aboutUs_desc;
                         
                         NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                         
                         [lblDescription setAttributedText: attrStr];
                         [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
                         [lblDescription setAlpha: 0];
                         
                         CGFloat maxLabelWidth = lblDescription.frame.size.width;
                         CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
                         
                         //reset constraint
                         detailViewHeightConstraint.constant = 460;
                         
                         if((imgBanner.image.size.height + neededSize.height) > detailViewHeightConstraint.constant)
                         {
                             detailViewHeightConstraint.constant = imgBanner.image.size.height + neededSize.height + 10;
                         }
                         
                         // instead of using uilabel to show the text
                         // use the label to get the height needed
                         // then hide the label
                         // use RTLabel to show the html tagged text
                         // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
                         
                         [lbl setAlpha: 0];
                         [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, neededSize.width, neededSize.height + 20)];
                         [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
                         [lbl setLineSpacing: 1];
                         [lbl setText: htmlString];
                         [lbl setAlpha: 1];
                         
                         [self performSelector:@selector(scrollToTop) withObject:nil afterDelay: 0.5];
                     }];
}

-(void) scrollToTop
{
    [self.scrollView setContentOffset: CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

@end
