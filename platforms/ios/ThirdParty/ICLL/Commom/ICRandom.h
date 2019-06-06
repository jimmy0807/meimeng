//
//  ICRandom.h
//  BetSize
//
//  Created by jimmy on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICRandom : NSObject

+(NSInteger)randomInt;
+(NSInteger)randomFrom:(NSInteger)from to:(NSInteger)to;

@end
