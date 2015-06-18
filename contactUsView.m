//
//  contactUsView.m
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "contactUsView.h"

@interface contactUsView ()

@end

@implementation contactUsView

@synthesize revealLeftMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    /* Google Map API Key (iOS) - AIzaSyDNH4uR1iHOV3EwnsXJ8vexpgZlxWZfcPA */
    
    [self setUpView];
    
    [self customSetup];
}

-(void) setUpView
{
    self.revealViewController.delegate = (id)self;
    
    self.navigationItem.title = @"Contact Us";
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

- (IBAction)getDirectionKLOffice:(id)sender
{
    // KL : 3.0260481, 101.5491794
    
    latitude = @"3.0260481";
    longitude = @"101.5491794";
    
    [self performSegueWithIdentifier:@"showMapSegue" sender:nil];
}

- (IBAction)getDirectionPenangOffice:(id)sender
{
    // Penang: 5.3844276,100.3899188
    
    latitude = @"5.3844276";
    longitude = @"100.3899188";
    
    [self performSegueWithIdentifier:@"showMapSegue" sender:nil];
}

- (IBAction)openPolyonWebPage:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.polyon.com.my"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary*)sender
{
    if([[segue identifier]isEqualToString:@"showMapSegue"])
    {
        detailMapView *SegueController = (detailMapView*)[segue destinationViewController];
        SegueController.latitude = latitude;
        SegueController.longitude = longitude;
    }
}

@end
