//
//  getCompanyProfile.m
//  polyon
//
//  Created by Jun on 15/5/24.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "getCompanyProfile.h"

@implementation getCompanyProfile

-(id)init_getCompanyProfile
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"getCompanyProfile";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "getCompanyProfile"
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:@"" forKey:@"id"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"getCompanyProfile_data"];
    }
    
    return self;
}

@end
