//
//  NSDictionary+JSON.h
//  YUNIO
//
//  Created by Vincent Xiao on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

+ (id)dictionaryWithJSONData: (NSData*)data;

@end
