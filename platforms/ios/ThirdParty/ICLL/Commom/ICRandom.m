//
//  ICRandom.m
//  BetSize
//
//  Created by jimmy on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICRandom.h"

//arc4random()不需要生成随机种子

@implementation ICRandom

+(NSInteger)randomInt
{
    return arc4random();
}

+(NSInteger)randomFrom:(NSInteger)from to:(NSInteger)to
{
    return arc4random()%(to - from + 1) + from;
}

@end
