//
//  BSCardItem.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCardItem : NSObject

@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, assign) CGFloat productPrice;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) CGFloat unitPrice;
@property (nonatomic, assign) NSInteger importQty;
@property (nonatomic, assign) BOOL isLimited;
@property (nonatomic, strong) NSDate *limitedDate;
@property (nonatomic, strong) NSString *remark;

@end
