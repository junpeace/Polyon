//
//  getProducts.m
//  polyon
//
//  Created by Jun on 15/5/31.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getProducts.h"

@implementation getProducts

-(id)init_getProducts :(NSString*) categoryID
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getProducts";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getProducts"
         POST['data'] = { "getProducts_data": { "category_id":"123" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: categoryID forKey:@"category_id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getProducts_data"];
    }
    
    return self;
}

@end
