//
//  BluetoothPrinterManager.m
//  Boss
//
//  Created by jimmy on 16/3/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BluetoothPrinterManager.h"

static BluetoothPrinterManager *s_sharedManager;

@implementation BluetoothPrinterManager

+ (BluetoothPrinterManager *)sharedManager
{
    if ( s_sharedManager == nil)
    {
        s_sharedManager = [[self alloc] init];
    }
    
    return s_sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    
    return self;
}


#pragma mark -- 

@end
