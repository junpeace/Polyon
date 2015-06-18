//
//  submitOrder.m
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "submitOrder.h"

@implementation submitOrder

-(id)init_getProductDetails :(NSArray*) orderList iuserID:(NSString*)userID
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"submitOrder";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "submitOrder"
         POST['data'] = { "submitOrder_data": { "user_id":"123", "orderList":[{"product_id":"123", "quantity":"213"}, {"product_id":"2", "quantity":"1"}] } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: userID forKey:@"user_id"];
        [jsonDictcol setValue: orderList forKey:@"orderList"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"submitOrder_data"];
    }
    
    return self;
}

@end
