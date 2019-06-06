//
//  BSPrintPosOperateRequest.h
//  meim
//
//  Created by jimmy on 16/11/24.
//
//

#import <Foundation/Foundation.h>

@interface BSPrintPosOperateRequest : NSObject

- (void)printWithPosOperateID:(NSNumber*)posOperateID;
- (void)getBoardcastIP;

@end
