//
//  VUtil.h
//  Spark
//
//  Created by Vincent on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VUtil : NSObject

+ (NSString*)cachePath;
+ (BOOL)hasCache: (NSString*)fileName;
+ (NSString*)cacheFilePathFromName: (NSString*)fileName;

@end
