//
//  FetchHPCustomerRequest.h
//  meim
//
//  Created by jimmy on 2017/4/12.
//
//

#import "ICRequest.h"

typedef enum kBSFetchCustomerRequestType
{
    kBSFetchCustomerRequestAll,
    kBSFetchCustomerRequestByPage, //分页取
    kBSFetchCustomerRequestSearch,
    kBSFetchCustomerRequsetShopALL,//取一个门店全部
}kBSFetchCustomerRequestType;

@interface FetchHCustomerRequest : ICRequest

@property(nonatomic, strong) NSString *filterString;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSNumber *guwenID;
- (id)initWithKeyword:(NSString *)keyword;
- (id)initWithStoreID:(NSNumber *)storeID startIndex:(NSInteger)index;
- (id)initWithStoreID:(NSNumber *)storeID;

@end
