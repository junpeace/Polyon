//
//  login.h
//  polyon
//
//  Created by Jun on 15/5/27.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface login : JsonRequest

-(id)init_login :(NSString*) username ipassword:(NSString*) password;

@end
