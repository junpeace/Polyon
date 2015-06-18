//
//  leftMenuTableView.h
//  polyon
//
//  Created by jun on 5/20/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface SWUITableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel *label;
@end

@interface leftMenuTableView : UITableViewController
{

}

@property (strong, nonatomic) NSMutableArray *dataArr;

@end
