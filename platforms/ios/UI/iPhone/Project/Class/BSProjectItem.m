//
//  BSProjectItem.m
//  Boss
//
//  Created by XiaXianBing on 15/8/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSProjectItem.h"

@implementation BSProjectItem

- (id)init
{
    self = [super init];
    if (self)
    {
        self.projectImage = nil;
        self.projectID = [NSNumber numberWithInteger:0];
        self.projectName = @"";
        self.projectPrice = 0.0f;
        self.projectType = @"product";
        self.isActive = YES;
        self.canSale = YES;
        self.canBook = YES;
        self.canPurchase = YES;
        self.barcode = @"";
        self.defaultCode = @"";
        
        self.attributeLines = [NSMutableArray array];
        self.consumables = [NSMutableArray array];
        self.subItems = [NSMutableArray array];
    }
    
    return self;
}

@end
