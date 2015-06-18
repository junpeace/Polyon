//
//  getProductAndCategory.m
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getProductAndCategory.h"

@implementation getProductAndCategory

-(id)init_getProductAndCategory :(NSString*) categoryID
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getProductsCategoriesByCategoryId";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getProductsCategoriesByCategoryId"
         POST['data'] = { "getProductsCategoriesByCategoryId_data": { "category_id":"138" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: categoryID forKey:@"category_id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getProductsCategoriesByCategoryId_data"];
    }
    
    return self;
}

@end
