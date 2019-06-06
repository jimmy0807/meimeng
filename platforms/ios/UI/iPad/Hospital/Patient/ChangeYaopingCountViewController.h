//
//  ChangeYaopingCountViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/4/10.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@interface ChangeYaopingCountViewController : ICCommonViewController

@property(nonatomic, copy)void (^changeFinish)(int count);
@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic) int yaopinCount;
- (id)initWithProduct;

@end
