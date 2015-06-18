//
//  signUp.m
//  polyon
//
//  Created by Jun on 15/5/27.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "signUp.h"

@implementation signUp

-(id)init_signUp :(NSString*) username ipassword:(NSString*) password iemail:(NSString*) email icompanyName:(NSString*) companyName icompanyAddress:(NSString*) companyAddress icompanyEmail:(NSString*) companyEmail ipersonInCharge:(NSString*) personInCharge icontactNo:(NSString*) contactNo
{
    self = [super init];
    
    if(self)
    {
        self.Action = @"userRegistration";
        
        self.jsonDicttbl = [[NSMutableDictionary alloc] init];
        
        /*
         GET['action'] = "userRegistration"
         POST['data'] = { "userRegistration_data": { "username":"Alex", "password":"123", "email":"alex@yahoo.com", "company_name":"Jupiter Sdn.Bhd", "company_address":"No.20, Jalan Sultan Ismail, 54000 KL", "company_email":"alex@jupiter.com", "person_in_charge":"Yogesh", "contact_number":"1234567890" } }
         */
        
        NSMutableDictionary *jsonDictcol = [[NSMutableDictionary alloc] init];
        [jsonDictcol setValue: username forKey:@"username"];
        [jsonDictcol setValue: password forKey:@"password"];
        [jsonDictcol setValue: email forKey:@"email"];
        [jsonDictcol setValue: companyName forKey:@"company_name"];
        [jsonDictcol setValue: companyAddress forKey:@"company_address"];
        [jsonDictcol setValue: companyEmail forKey:@"company_email"];
        [jsonDictcol setValue: personInCharge forKey:@"person_in_charge"];
        [jsonDictcol setValue: contactNo forKey:@"contact_number"];
        
        [self.jsonDicttbl setValue:jsonDictcol forKey:@"userRegistration_data"];
    }
    
    return self;
}

@end
