//
//  YimeiCreateMultiKeshiViewController.h
//  meim
//
//  Created by 波恩公司 on 2017/11/20.
//

#import <UIKit/UIKit.h>
#import "PadMaskView.h"

@interface YimeiCreateMultiKeshiViewController : ICCommonViewController

@property (nonatomic, weak) PadMaskView *maskView;
@property (nonatomic, weak) CDPosOperate *operate;
@property (nonatomic, retain) NSMutableArray *productArray;
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, copy) void (^keshiSelectFinished)(CDKeShi* first, CDStaff* second);

@end
