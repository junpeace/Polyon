//
//  videoView.m
//  polyon
//
//  Created by Jun on 15/5/28.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "videoView.h"

@interface videoView ()

@end

@implementation videoView

@synthesize webView;
@synthesize strToken;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Loading video..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self playVideoWithId];
}

- (void)playVideoWithId
{
    NSString *youTubeToken = strToken;
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"body {"];
    [html appendString:@"background-color: transparent;"];
    [html appendString:@"color: white;"];
    [html appendString:@"margin: 0;"];
    [html appendString:@"}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendFormat:@"<iframe id=\"ytplayer\" type=\"text/html\" width=\"%0.0f\" height=\"%0.0f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"/>", webView.frame.size.width, webView.frame.size.height, youTubeToken];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    [webView loadHTMLString:html baseURL:nil];
    
    webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish load");
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"failed to load video");
    
    [SVProgressHUD dismiss];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(void) setUpView
{
    self.navigationItem.title = @"Video";
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
