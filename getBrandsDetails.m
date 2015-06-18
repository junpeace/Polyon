//
//  getBrandsDetails.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getBrandsDetails.h"

@implementation getBrandsDetails

-(id)init_getBrandsDetails :(NSString*) brandID;
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getBrandById";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getBrandById"
         POST['data'] = { "getBrandById_data": { "brand_id":"123" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:brandID forKey:@"brand_id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getBrandById_data"];
    }
    
    return self;
}

@end
