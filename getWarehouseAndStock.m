//
//  getWarehouseAndStock.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getWarehouseAndStock.h"

@implementation getWarehouseAndStock

-(id)init_getWarehouseAndStock
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getFactoryStocks";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getFactoryStocks"
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:@"" forKey:@"id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getFactoryStocks_data"];
    }
    
    return self;
}

@end
