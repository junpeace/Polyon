//
//  getProductDetails.m
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getProductDetails.h"

@implementation getProductDetails

-(id)init_getProductDetails :(NSArray*) productIDs
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getProductsDetails";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getProductsDetails"
         POST['data'] = { "getProductsDetails_data": { "productIds":[1,2,3] } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: productIDs forKey:@"productIds"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getProductsDetails_data"];
    }
    
    return self;
}

@end
