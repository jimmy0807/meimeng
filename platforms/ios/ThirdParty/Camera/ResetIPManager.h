//
//  ResetIPManager.h
//  meim
//
//  Created by jimmy on 2018/8/13.
//

#import <Foundation/Foundation.h>

@interface ResetIPManager : NSObject

+ (ResetIPManager *)sharedInstance;
- (void)reload;

@end
