//
//  FetchHFenzhenRequest.h
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "ICRequest.h"

typedef enum kFetchHFenzhenRequestType
{
    kFetchHFenzhenRequestAll,
    kFetchHFenzhenRequestByPage, //分页取
    kFetchHFenzhenRequestSearch,
    kFetchHFenzhenRequestShopALL,//取一个门店全部
}kFetchHFenzhenRequestType;

@interface FetchHFenzhenRequest : ICRequest

@property(nonatomic, strong) NSString *filterString;
@property(nonatomic, assign) NSInteger count;
- (id)initWithKeyword:(NSString *)keyword;
- (id)initWithStoreID:(NSNumber *)storeID startIndex:(NSInteger)index;
- (id)initWithStoreID:(NSNumber *)storeID;

@end
