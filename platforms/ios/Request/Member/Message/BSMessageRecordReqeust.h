//
//  BSMessageRecordReqeust.h
//  meim
//
//  Created by lining on 2016/11/30.
//
//

#import "ICRequest.h"

@interface BSMessageRecordReqeust : ICRequest
- (instancetype) initWithStartIndex:(NSInteger)index;
@end
