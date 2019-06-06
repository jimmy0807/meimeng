//
//  PanDianViewController.h
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kPandianTag
{
    kPandianTag_draft, //草稿
    kPandianTag_confirm, //进行中
    kPandianTag_done   //已完成
}kPandianTag;

@interface PanDianViewController : ICCommonViewController

@property(nonatomic, assign) kPandianTag panDianTag;

@end
