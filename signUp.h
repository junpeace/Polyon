//
//  signUp.h
//  polyon
//
//  Created by Jun on 15/5/27.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface signUp : JsonRequest

-(id)init_signUp :(NSString*) username ipassword:(NSString*) password iemail:(NSString*) email icompanyName:(NSString*) companyName icompanyAddress:(NSString*) companyAddress icompanyEmail:(NSString*) companyEmail ipersonInCharge:(NSString*) personInCharge icontactNo:(NSString*) contactNo;

@end
