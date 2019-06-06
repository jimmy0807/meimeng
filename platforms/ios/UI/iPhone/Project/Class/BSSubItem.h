//
//  BSSubItem.h
//  Boss
//
//  Created by XiaXianBing on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSubItem : NSObject

@property (nonatomic, strong) NSNumber *relatedID;
@property (nonatomic, strong) NSNumber *itemID;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSNumber *parentItemID;
@property (nonatomic, strong) NSString *parentItemName;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat itemPrice;
@property (nonatomic, assign) CGFloat itemSetPrice;
@property (nonatomic, assign) BOOL isShowMore;
@property (nonatomic, assign) BOOL isUnlimited;
@property (nonatomic, assign) NSInteger unlimitedDays;
@property (nonatomic, assign) kPadBornCategoryType projectType;
@property (nonatomic, strong) NSMutableArray *sameItems;
@property (nonatomic, strong) CDProjectItem *projectItem;
@property (nonatomic, assign) BOOL samePriceReplace;
@property (nonatomic, assign) CGFloat samePriceReplaceMax;
@property (nonatomic, assign) CGFloat samePriceReplaceMin;


@end
