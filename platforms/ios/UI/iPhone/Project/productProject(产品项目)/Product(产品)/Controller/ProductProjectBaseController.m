//
//  ProductProjectBaseController.m
//  Boss
//
//  Created by jiangfei on 16/8/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductProjectBaseController.h"

@interface ProductProjectBaseController ()

@end

@implementation ProductProjectBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSMutableDictionary*)parmasDict
{
    if (!_parmasDict) {
        _parmasDict = [[NSMutableDictionary alloc]init];
    }
    return _parmasDict;
}

@end
