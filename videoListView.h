//
//  videoListView.h
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "placeAnOrderView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIBarButtonItem+Badge.h"
#import "videoView.h"
#import "cartItem.h"

@interface videoListView : UIViewController
{
    int selectedIndex;
}

@property (strong, nonatomic) NSMutableArray *dataArr;

@end
