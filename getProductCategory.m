//
//  getProductCategory.m
//  polyon
//
//  Created by Jun on 15/5/31.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getProductCategory.h"

@implementation getProductCategory

-(id)init_getProductCategory :(NSString*) parentCategoryID
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getProductCategory";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getProductCategory"
         POST['data'] = { "getProductCategory_data": { "parentCategoryId":"123" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: parentCategoryID forKey:@"parentCategoryId"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getProductCategory_data"];
    }
    
    return self;
}

@end
