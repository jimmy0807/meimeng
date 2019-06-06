//
//  BSFetchMemberRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum kBSFetchMemberRequestType
{
    kBSFetchMemberRequestAll,
    kBSFetchMemberRequestByPage, //分页取
    kBSFetchMemberRequestSearch,
    kBSFetchMemberRequsetShopALL,//取一个门店全部
}kBSFetchMemberRequestType;

@interface BSFetchMemberRequest : ICRequest

@property(nonatomic, strong) NSString *filterString;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSNumber *guwenID;
- (id)initWithKeyword:(NSString *)keyword;
- (id)initWithStoreID:(NSNumber *)storeID startIndex:(NSInteger)index;
- (id)initWithStoreID:(NSNumber *)storeID;

@property(nonatomic)BOOL fetchID;

@end
