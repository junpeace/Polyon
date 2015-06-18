//
//  videoView.h
//  polyon
//
//  Created by Jun on 15/5/28.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface videoView : UIViewController<UIWebViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *strToken;

@end
