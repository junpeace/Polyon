//
//  leftMenuTableView.m
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "leftMenuTableView.h"

@implementation SWUITableViewCell
@end

@interface leftMenuTableView ()

@end

@implementation leftMenuTableView

@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setupLeftMenu];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_sidemenu"]];
}

-(void) setupLeftMenu
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
    
    dataArr = [[NSMutableArray alloc] init];
    
    NSDictionary *dict1;
    
    if(myBool)
    {
        dict1 = [NSDictionary dictionaryWithObjectsAndKeys: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"userName"], @"name", nil];
    }
    else
    {       dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Log In", @"name", nil];    }
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"About Polyon", @"name", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Why Us", @"name", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Products", @"name", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Place An Order", @"name", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Social Media", @"name", nil];
    NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Contact Us", @"name", nil];
    
    [dataArr addObject:dict1];
    [dataArr addObject:dict2];
    [dataArr addObject:dict3];
    [dataArr addObject:dict4];
    [dataArr addObject:dict5];
    [dataArr addObject:dict6];
    [dataArr addObject:dict7];
    
    if(myBool)
    {
        NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"Logout", @"name", nil];
        
        [dataArr addObject:dict8];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
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
    
    UILabel *lblName = (UILabel*)[cell viewWithTag:1];
    [lblName setText:[NSString stringWithFormat:@"%@", [[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]]];
    
    // login || about || why || products || place order || contact (23x27)
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
    imgView.image = nil;
    
    // user || logout (26x27)
    UIImageView *imgView2 = (UIImageView*)[cell viewWithTag:3];
    imgView2.image = nil;
    
    // social media (24x27)
    UIImageView *imgView3 = (UIImageView*)[cell viewWithTag:4];
    imgView3.image = nil;
    
    UILabel *lblCompanyName = (UILabel*)[cell viewWithTag:5];
    [lblCompanyName setText: @""];
    
    int loggedIn = 0;

    if(indexPath.row == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
        
        if(myBool)
        {
            [lblCompanyName setText: [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInformation"] objectForKey:@"companyName"]];
            
            loggedIn = 1;
        }
    }
    
    switch (indexPath.row)
    {
        case 0:
            
            if(loggedIn == 0)
            {   [imgView setImage: [UIImage imageNamed:@"icon_login"]]; }
            else{   [imgView2 setImage: [UIImage imageNamed:@"icon_user"]]; }
            
            break;
        
        case 1:
            [imgView setImage: [UIImage imageNamed:@"icon_aboutpolyon"]];
            break;
        
        case 2:
            [imgView setImage: [UIImage imageNamed:@"icon_whyus"]];
            break;
        
        case 3:
            [imgView setImage: [UIImage imageNamed:@"icon_products"]];
            break;
        
        case 4:
            [imgView setImage: [UIImage imageNamed:@"icon_placeanorder_1"]];
            break;
        
        case 5:
            [imgView3 setImage: [UIImage imageNamed:@"icon_socialmedia"]];
            break;
        
        case 6:
            [imgView setImage: [UIImage imageNamed:@"icon_contactus"]];
            break;
        
        case 7:
            [imgView2 setImage: [UIImage imageNamed:@"icon_logout"]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
    
    // return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected : %ld", (long)indexPath.row);
    
    if(indexPath.row == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
        
        if(myBool)
        {   [self performSegueWithIdentifier:@"profileSegue" sender:nil];   }
        else{   [self performSegueWithIdentifier:@"loginSegue" sender:nil]; }
    }
    else if(indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"aboutUsSegue" sender:nil];
    }
    else if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"whyUsSegue" sender:nil];
    }
    else if(indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"productsSegue" sender:nil];
    }
    else if(indexPath.row == 4)
    {
        [self performSegueWithIdentifier:@"placeAnOrderSegue" sender:nil];
    }
    else if(indexPath.row == 5)
    {
        [self performSegueWithIdentifier:@"socialMediaSegue" sender:nil];
    }
    else if(indexPath.row == 6)
    {
        [self performSegueWithIdentifier:@"contactUsSegue" sender:nil];
    }
    else if(indexPath.row == 7)
    {
        // store login status to NO
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"userLoggedIn"];
        [defaults synchronize];
        
        [defaults setBool:NO forKey:@"rememberMe"];
        [defaults synchronize];
        
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
