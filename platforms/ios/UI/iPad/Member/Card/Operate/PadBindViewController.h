//
//  PadBindViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/7/23.
//

#import "ICCommonViewController.h"
#import "PadMaskView.h"

@interface PadBindViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PadMaskView *maskView;

- (id)initWithMemberCard:(CDMemberCard *)memberCard;

@end
