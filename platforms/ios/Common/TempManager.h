//
//  TempManager.h
//  meim
//
//  Created by jimmy on 2018/11/22.
//

#import <Foundation/Foundation.h>

@interface TempManager : NSObject

+ (TempManager *)sharedInstance;
@property(nonatomic)BOOL notSearchAll;

@end
