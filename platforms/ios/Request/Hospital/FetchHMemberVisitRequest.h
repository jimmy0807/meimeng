//
//  FetchHMemberVisitRequest.h
//  meim
//
//  Created by jimmy on 2017/4/28.
//
//

#import "ICRequest.h"

@interface FetchHMemberVisitRequest : ICRequest

typedef enum kFetchHMemberVisitRequestType
{
    HMemberVisitAll,
    HMemberVisitQianzai,
    HMemberVisitShuhou,
    HMemberVisitLaoke,
    HMemberVisitRichang,
    HMemberVisitTousu,
}kFetchHMemberVisitRequestType;

@property (nonatomic, assign) NSInteger startIndex;
@property(nonatomic, strong)NSString* keyword;
@property(nonatomic)kFetchHMemberVisitRequestType type;

@end
