//
//  CRequest.h
//  couper
//
//  Created by Tiseno Mac 2 on 5/30/13.
//  Copyright (c) 2013 Tiseno Mac 2. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "dbIPServer.h"
//#import "IXMLRequest.h"
@interface JsonRequest : NSObject
{
    
}
@property (nonatomic, retain) NSString *webserviceURL;
@property (nonatomic, retain) NSString *Action;
@property (nonatomic, retain) NSMutableDictionary *jsonDicttbl;

@end
