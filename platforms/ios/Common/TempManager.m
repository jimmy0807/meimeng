//
//  TempManager.m
//  meim
//
//  Created by jimmy on 2018/11/22.
//

#import "TempManager.h"

@implementation TempManager

+ (TempManager *)sharedInstance {
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

@end
