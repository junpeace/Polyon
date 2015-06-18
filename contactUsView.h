//
//  contactUsView.h
//  polyon
//
//  Created by Jun on 15/5/20.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "detailMapView.h"

@interface contactUsView : UIViewController
{
    NSString *latitude, *longitude;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealLeftMenu;
- (IBAction)getDirectionKLOffice:(id)sender;
- (IBAction)getDirectionPenangOffice:(id)sender;
- (IBAction)openPolyonWebPage:(id)sender;

@end
