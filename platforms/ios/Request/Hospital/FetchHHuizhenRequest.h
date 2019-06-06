//
//  FetchHHuizhenRequest.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "ICRequest.h"

@interface FetchHHuizhenRequest : ICRequest

-(id)initWithBinglikaID:(NSArray*)huizhenIDs;
@property(nonatomic, strong)CDHBinglika* ka;

@end
