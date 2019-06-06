//
//  NSString+Additions.h
//  Spark
//
//  Created by Vincent on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString*) sha1Hash;

+ (NSString*) generateGUID;

- (BOOL)isUrl;

- (NSString *)urlEncode;
- (NSString *)urlDecode;

@end
