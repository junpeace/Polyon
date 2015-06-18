//
//  socialMediaView.m
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

// https://developers.facebook.com/docs/graph-api/reference/v2.3/user/feed
// https://graph.facebook.com/787770424599913/posts?access_token=422286701249433%7C8K92jQe2WPfNUqq5u5VlfS4TBio

#import "socialMediaView.h"

@interface socialMediaView ()

@end

@implementation socialMediaView

@synthesize revealLeftMenu, dataArr, tblSocialFeeds;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading facebook feeds..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self performSelector:@selector(initializeFacebookFeeds) withObject:nil afterDelay:1];
}

-(void) initializeFacebookFeeds
{
    // much more faster compare to asynchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.facebook.com/787770424599913/posts?access_token=422286701249433%7C8K92jQe2WPfNUqq5u5VlfS4TBio"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error)
    {   [self fetchingGroupsFailedWithError:error]; }
    else
    {   [self receivedGroupsJSON:data]; }
}

- (void)receivedGroupsJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    dataArr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [[parsedObject objectForKey:@"data"] count]; i++)
    {
        fbPostFeed *fbObj = [[fbPostFeed alloc] init];
        [fbObj setImageURL: [[[parsedObject objectForKey:@"data"] objectAtIndex: i] objectForKey:@"picture"]];
        [fbObj setStory: [[[parsedObject objectForKey:@"data"] objectAtIndex: i] objectForKey:@"story"]];
        [fbObj setLink: [[[parsedObject objectForKey:@"data"] objectAtIndex: i] objectForKey:@"link"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *orignalDate   =  [dateFormatter dateFromString: [[[[parsedObject objectForKey:@"data"] objectAtIndex: i] objectForKey:@"created_time"] substringToIndex: 10]];
        
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *finalString = [dateFormatter stringFromDate:orignalDate];
        
        [fbObj setCreatedDate: finalString];
        
        [dataArr addObject: fbObj];
    }
    
    [tblSocialFeeds reloadData];
    
    [SVProgressHUD dismiss];
}

- (void)fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
    
    [SVProgressHUD dismiss];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
    
    [self customSetup];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Social Media";
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
    
    fbPostFeed *fbObj = [dataArr objectAtIndex: indexPath.row];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    
    [imgView setImageWithURL: [NSURL URLWithString: fbObj.imageURL] placeholderImage: nil];
    
    UILabel *lblStory = (UILabel*) [cell viewWithTag: 2];
    [lblStory setText: fbObj.story];
    
    UILabel *lblCreatedDate = (UILabel*) [cell viewWithTag: 3];
    [lblCreatedDate setText: fbObj.createdDate];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected : %ld", (long)indexPath.row);
    
    fbPostFeed *fbObj = [dataArr objectAtIndex: indexPath.row];
    
    NSURL* facebookAppURL = [ NSURL URLWithString: fbObj.link];
    
    UIApplication* app = [ UIApplication sharedApplication];
    
    [app openURL: facebookAppURL];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)followOnFacebook:(id)sender
{
    NSURL* facebookURL = [ NSURL URLWithString: @"https://www.facebook.com/pages/Polyon-Enterprise-KL-Sdn-Bhd/787770424599913?fref=ts" ];
    NSURL* facebookAppURL = [ NSURL URLWithString: @"fb://profile/787770424599913" ];
    
    UIApplication* app = [ UIApplication sharedApplication];
    
    if([app canOpenURL: facebookAppURL])
    {
        [app openURL: facebookAppURL];
    }
    else
    {
        [app openURL: facebookURL];
    }
}

@end
