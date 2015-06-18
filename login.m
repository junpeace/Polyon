//
//  login.m
//  polyon
//
//  Created by Jun on 15/5/27.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "login.h"

@implementation login

-(id)init_login :(NSString*) username ipassword:(NSString*) password
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"login";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "login"
         POST['data'] = { "login_data": { "user_name":"test", "password":"123" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: username forKey:@"user_name"];
        [jsonDictcol setValue: password forKey:@"password"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"login_data"];
    }
    
    return self;
}

@end
