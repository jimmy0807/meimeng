//
//  BSProjectItem.h
//  Boss
//
//  Created by XiaXianBing on 15/8/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSProjectItem : NSObject

@property (nonatomic, strong) UIImage *projectImage;
@property (nonatomic, assign) BOOL isImageEdit;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, assign) CGFloat projectPrice; //销售价
@property (nonatomic, assign) CGFloat standardPrice; //成本价
@property (nonatomic, assign) CGFloat memberPrice; //会员价
@property (nonatomic, strong) NSString *projectType;
@property (nonatomic, strong) CDProjectCategory *posCategory;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL canSale;
@property (nonatomic, assign) BOOL canBook;
@property (nonatomic, assign) BOOL canPurchase;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, assign) NSInteger onHandCount;
@property (nonatomic, assign) NSInteger *fuwuTime;


@property (nonatomic, strong) NSString *barcode;
@property (nonatomic, strong) NSString *defaultCode;
@property (nonatomic, strong) NSMutableArray *attributeLines; //规格
@property (nonatomic, strong) NSMutableArray *consumables;  //消耗品
@property (nonatomic, strong) NSMutableArray *packLines;  //组合套
@property (nonatomic, strong) NSMutableArray *subItems;


@property (nonatomic, assign) BOOL isSaleOnCashier;
@property (nonatomic, assign) BOOL isShowOnWeixin;
@property (nonatomic, assign) BOOL isTuijian;
@property (nonatomic, assign) BOOL isMain;
@property (nonatomic, assign) BOOL isInWeikaActive;
@property (nonatomic, assign) BOOL isShowOnWeika;

@property (nonatomic, assign) CGFloat exchangePoint; //多少积分


@end
