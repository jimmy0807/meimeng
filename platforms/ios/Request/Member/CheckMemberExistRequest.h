//
//  CheckMemberExistRequest.h
//  meim
//
//  Created by jimmy on 2017/8/23.
//
//

#import "ICRequest.h"

@interface CheckMemberExistRequest : ICRequest

@property(nonatomic, strong)NSString* phoneNumber;
@property(nonatomic, copy)void (^gotMeber)(NSNumber* memberID);

@end
