//
//  productCategory.h
//  polyon
//
//  Created by Jun on 15/5/31.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productCategory : NSObject

@property (strong, nonatomic) NSString *categoryID, *categoryImageURL, *categoryName, *categorySequenceNo;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *productID, *productImageURL, *productName, *productSequenceNo, *productCode;
@property (strong, nonatomic) NSString *path, *productQuantity;

@end
