//
//  submitOrder.h
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface submitOrder : JsonRequest

-(id)init_getProductDetails :(NSArray*) orderList iuserID:(NSString*)userID;

@end
