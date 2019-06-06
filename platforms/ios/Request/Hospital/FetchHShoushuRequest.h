//
//  FetchHShoushuRequest.h
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "ICRequest.h"

@interface FetchHShoushuRequest : ICRequest

-(id)initWithShoushuID:(NSArray*)shoushuIDs;
@property(nonatomic, strong)CDHBinglika* ka;

@end
