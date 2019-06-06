//
//  FetchWashHandRequest.h
//  meim
//
//  Created by jimmy on 2017/6/26.
//
//

#import "ICRequest.h"

@interface FetchWashHandRequest : ICRequest

@property(nonatomic, strong)NSNumber* workID;
@property(nonatomic, strong)NSNumber* role_option;
@property(nonatomic, strong)NSString* keyword;
@property(nonatomic)BOOL bFetchDone;

@end
