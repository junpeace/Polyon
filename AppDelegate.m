//
//  AppDelegate.m
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [GMSServices provideAPIKey:@"AIzaSyDNH4uR1iHOV3EwnsXJ8vexpgZlxWZfcPA"];
    
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bar_combine"] forBarMetrics:UIBarMetricsDefault];
    
    // font type - century gothic (regular) Century Gothic
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"Century Gothic" size:17.0], NSFontAttributeName, nil]];
    
    [self initKeyBoard];
    
    // check if remember me was ticked
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL myBool = [defaults boolForKey:@"rememberMe"];
    
    if(!myBool)
    {        
        [defaults setBool:NO forKey:@"userLoggedIn"];
        [defaults synchronize];
    }
        
    return YES;
}

-(void) initKeyBoard
{
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && [className isEqualToString:@"AVFullScreenViewController"])
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
