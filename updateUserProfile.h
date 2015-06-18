//
//  updateUserProfile.h
//  polyon
//
//  Created by Jun on 15/5/28.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "JsonRequest.h"

@interface updateUserProfile : JsonRequest

-(id)init_updateUserProfile :(NSString*) username iuserID:(NSString*) userID iemail:(NSString*) email icompanyName:(NSString*) companyName icompanyAddress:(NSString*) companyAddress icompanyEmail:(NSString*) companyEmail ipersonInCharge:(NSString*) personInCharge icontactNo:(NSString*) contactNo;

@end
