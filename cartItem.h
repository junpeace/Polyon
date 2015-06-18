//
//  cartItem.h
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "DBbase.h"
#import "cartProduct.h"

@interface cartItem : DBbase

-(int) retrieveTotalNumberOfCartItems;
-(NSMutableArray*) retrieveAllCartItems;
-(DataBaseInsertionResult) insertItemIntoCart :(NSString*) productId iquantity:(NSString*) quantity;
-(DataBaseDeletionResult)deleteItem:(int)cartID;
-(DataBaseDeletionResult)deleteAllItem;
-(DataBaseUpdateResult)updateCartItem :(NSString *)cartID iquantity:(NSString*)productQuantity;

@end
