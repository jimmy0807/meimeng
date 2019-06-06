//
//  FetchHZixunRequest.h
//  meim
//
//  Created by jimmy on 2017/4/17.
//
//

#import "ICRequest.h"

typedef enum kFetchHZixunRequestType
{
    kFetchHZixunRequestAll,
    kFetchHZixunRequestByPage, //分页取
    kFetchHZixunRequestSearch,
    kFetchHZixunRequestShopALL,//取一个门店全部
}kFetchHZixunRequestType;

@interface FetchHZixunRequest : ICRequest

@property(nonatomic, strong)NSString* categoryName;

@property(nonatomic, strong) NSString *filterString;
@property(nonatomic, assign) NSInteger count;
- (id)initWithKeyword:(NSString *)keyword;
- (id)initWithStoreID:(NSNumber *)storeID startIndex:(NSInteger)index;
- (id)initWithStoreID:(NSNumber *)storeID;

@end
