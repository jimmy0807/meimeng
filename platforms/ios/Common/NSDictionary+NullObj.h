//
//  NSDictionary+NullObj.h
//  CardBag
//
//  Created by jimmy on 13-8-23.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullObj)

- (NSString*)stringValueForKey:(NSString *)key;
- (NSString*)onlyStringValueForKey:(NSString *)key;
- (NSNumber*)numberValueForKey:(NSString *)key;
- (NSArray*)arrayValueForKey:(NSString *)key;
- (NSString*)arrayNameValueForKey:(NSString *)key;
- (NSNumber *)arrayIDValueForKey:(NSString *)key;
- (NSNumber *)arrayNotNullIDValueForKey:(NSString *)key;

@end
