//
//  BNRegularExpression.h
//  Boss
//
//  Created by lining on 16/4/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRegularExpression : NSObject
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
@end
