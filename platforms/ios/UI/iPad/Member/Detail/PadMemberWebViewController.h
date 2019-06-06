//
//  PadMemberWebViewController.h
//  meim
//
//  Created by 波恩公司 on 2018/7/17.
//

#import "ICCommonViewController.h"

@interface PadMemberWebViewController : ICCommonViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard;
- (id)initWithMemberID:(NSNumber *)memberID;

//@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) NSNumber *memberID;
//@property (nonatomic, strong) CDCouponCard *couponCard;
//@property (nonatomic, weak) UIViewController *parentVC;
//@property (nonatomic, strong)PadMemberInfoView *padMemberInfoView;
//- (void)reloadData;
//- (void)clearMember;


@end
