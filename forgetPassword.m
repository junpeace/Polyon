//
//  forgetPassword.m
//  polyon
//
//  Created by jun on 5/22/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "forgetPassword.h"

@implementation forgetPassword

-(id)init_forgetPassword :(NSString*) email
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"forgetPassword";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "forgetPassword"
         POST['data'] = { "forgetPassword_data": { "email":"jammie@gmail.com" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue:email forKey:@"email"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"forgetPassword_data"];
    }
    
    return self;
}

@end
