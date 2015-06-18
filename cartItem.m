//
//  cartItem.m
//  polyon
//
//  Created by Jun on 15/6/2.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "cartItem.h"

@implementation cartItem

-(int) retrieveTotalNumberOfCartItems
{
    int total = 0;
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from orderCartListTable"];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            total++;
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return total;
}

-(NSMutableArray*) retrieveAllCartItems;
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *selectSQL = [NSString stringWithFormat:@"select * from orderCartListTable"];
        
        sqlite3_stmt *statement;
        
        const char *select_stmt = [selectSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, select_stmt, -1, &statement, NULL);
        
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            cartProduct *item = [[cartProduct alloc] init];
            
            int row0 = sqlite3_column_int(statement, 0);

            item.cartID = [NSString stringWithFormat:@"%d", row0];

            int row1 = sqlite3_column_int(statement, 1);
            
            item.productID = [NSString stringWithFormat:@"%d", row1];
            
            int row2 = sqlite3_column_int(statement, 2);
            
            item.productQuantity = [NSString stringWithFormat:@"%d", row2];
            
            [returnArr addObject: item];
        }
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return returnArr;
}

-(DataBaseInsertionResult) insertItemIntoCart :(NSString*) productId iquantity:(NSString*) quantity
{
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into orderCartListTable(productID, productQuantity) values(%d, %d);", [productId intValue], [quantity intValue]];
        
        NSLog(@"query str : %@", insertSQL);
        
        sqlite3_stmt *statement;
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare(db_name, insert_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            
            [self closeConnection];
            
            return DataBaseInsertionSuccessful;
        }
        
        sqlite3_finalize(statement);
        
    }
    
    return DataBaseInsertionFailed;
}

-(DataBaseDeletionResult)deleteItem:(int)cartID
{
    if([self openConnection]==DataBaseConnectionOpened)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from orderCartListTable where cartID = '%d'", cartID];
        sqlite3_stmt *statement;
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, insert_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            
            return DataBaseDeletionSuccessful;
        }
        
        NSAssert1(0, @"Failed to delete with message '%s'.", sqlite3_errmsg(db_name));
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return DataBaseDeletionFailed;
}

-(DataBaseDeletionResult)deleteAllItem
{
    if([self openConnection]==DataBaseConnectionOpened)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"delete from orderCartListTable"];
        sqlite3_stmt *statement;
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, insert_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            
            return DataBaseDeletionSuccessful;
        }
        
        NSAssert1(0, @"Failed to delete with message '%s'.", sqlite3_errmsg(db_name));
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
    }
    
    return DataBaseDeletionFailed;
}

-(DataBaseUpdateResult)updateCartItem :(NSString *)cartID iquantity:(NSString*)productQuantity
{
    if([self openConnection] == DataBaseConnectionOpened)
    {
        NSString* updateSQL = [NSString stringWithFormat:@"update orderCartListTable set productQuantity=%d where cartID=%d", [productQuantity intValue], [cartID intValue]];
        
        sqlite3_stmt *statement;
        
        const char *insert_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(db_name, insert_stmt, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            
            [self closeConnection];
            
            return DataBaseUpdateSuccessful;
        }
        
        NSAssert1(0, @"Failed to update with message '%s'.", sqlite3_errmsg(db_name));
        
        sqlite3_finalize(statement);
        
        [self closeConnection];
        
        return DataBaseUpdateFailed;
    }
    else
    {
        return DataBaseUpdateFailed;
    }
}

@end
