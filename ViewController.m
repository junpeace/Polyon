//
//  ViewController.m
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
     [self performSelector:@selector(proceedView) withObject:nil afterDelay:3];
}

-(void) proceedView
{
   [self performSegueWithIdentifier:@"entrySegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
