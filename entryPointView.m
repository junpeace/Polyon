//
//  entryPointView.m
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "entryPointView.h"

@interface entryPointView ()

@end

@implementation entryPointView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
}

-(void) setUpView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL myBool = [defaults boolForKey:@"userLoggedIn"];
    
    if(myBool)
    {
        placeAnOrderView *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceAnOrderVC"];
        [self.navigationController pushViewController:pvc animated:NO];
    }
    else
    {
        aboutUsView *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsVC"];
        [self.navigationController pushViewController:pvc animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

@end
