//
//  videoListView.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "videoListView.h"

@interface videoListView ()

@end

@implementation videoListView

@synthesize dataArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
    self.navigationItem.title = @"Video";
    
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
    [lblName setText: [[dataArr objectAtIndex: indexPath.row] objectForKey:@"video_title"]];
    
    UILabel *lblCreatedDate = (UILabel*)[cell viewWithTag:2];
    [lblCreatedDate setText: [[dataArr objectAtIndex: indexPath.row] objectForKey:@"video_created_date"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

-(void) viewCartItems
{
    placeAnOrderView *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceAnOrderVC"];
    [self.navigationController pushViewController:auvc animated:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected : %ld", (long)indexPath.row);
    
    selectedIndex = (int)indexPath.row;
    
    [self performSegueWithIdentifier: @"viewVideoSegue" sender: nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"getBrandDetailSegue"])
    {
        videoView *SegueController = (videoView*)[segue destinationViewController];
        SegueController.strToken = [NSString stringWithFormat: @"%@", [[[dataArr objectAtIndex: selectedIndex] objectForKey: @"video_url"] stringByReplacingOccurrencesOfString: @"http://www.youtube.com/watch?v=" withString: @""]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
