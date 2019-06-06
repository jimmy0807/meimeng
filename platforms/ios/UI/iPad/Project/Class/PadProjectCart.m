//
//  PadProjectCart.m
//  Boss
//
//  Created by XiaXianBing on 15/11/6.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectCart.h"

@implementation PadProjectCart

- (id)initWithRelated:(CDProjectRelated *)related
{
    self = [super init];
    if (self)
    {
        self.item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
        if (self.item == nil)
        {
            self.item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
            self.item.itemID = related.productID;
            [[BSCoreDataManager currentManager] save:nil];
        }
        self.quantity = related.quantity.integerValue;
    }
    
    return self;
}

@end
