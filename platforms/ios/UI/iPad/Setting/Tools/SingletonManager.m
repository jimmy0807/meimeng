//
//  SingletonManager.m
//  meim
//
//  Created by 波恩公司 on 2017/11/14.
//

#import "SingletonManager.h"

@implementation SingletonManager
+ (instancetype)sharedInstance {
    static SingletonManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SingletonManager new];
    });
    return instance;
}
@end
