//
//  getProductByID.m
//  polyon
//
//  Created by Jun on 15/6/1.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getProductByID.h"

@implementation getProductByID

-(id)init_getProductByID :(NSString*) productID
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getProductById";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getProductById"
         POST['data'] = { "getProductById_data": { "product_id":"123" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: productID forKey:@"product_id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getProductById_data"];
    }
    
    return self;
}

@end
