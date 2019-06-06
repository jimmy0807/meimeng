//
//  NSArray+JSON.h
//  YUNIO
//
//  Created by Vincent Xiao on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

+ (id)arrayWithJSONData: (NSData*)data;

- (NSData *)toJsonData;
- (NSString *)toJsonString;

@end
