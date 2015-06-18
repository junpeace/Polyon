//
//  getBrands.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getBrands.h"

@implementation getBrands

-(id)init_getBrands
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getBrands";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getBrands"
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:@"" forKey:@"id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getBrands_data"];
    }
    
    return self;
}

@end
