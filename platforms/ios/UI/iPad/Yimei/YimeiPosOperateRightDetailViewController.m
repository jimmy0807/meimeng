//
//  YimeiPosOperateRightDetailViewController.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateRightDetailViewController.h"
#import "YimeiPosOperateRightPhotoViewController.h"
#import "YimeiSelectKeshiRightViewController.h"
#import "YimeiSelectOperateRightViewController.h"
#import "YimeiPeiyaoRightViewController.h"
#import "HPatientBinglikaViewController.h"

@interface YimeiPosOperateRightDetailViewController ()
@property(nonatomic, strong)YimeiPosOperateRightPhotoViewController* photoVc;
@property(nonatomic, strong)YimeiSelectKeshiRightViewController* selectKeshiVc;
@property(nonatomic, strong)YimeiSelectOperateRightViewController* selectOperateVc;
@property(nonatomic, strong)YimeiPeiyaoRightViewController *peiyaoVc;
@end

@implementation YimeiPosOperateRightDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger role = [self.washHand.role_option integerValue];
    if ( role == YimeiWorkFlow_TakePhoto )
    {
        self.photoVc = [[YimeiPosOperateRightPhotoViewController alloc] initWithNibName:@"YimeiPosOperateRightPhotoViewController" bundle:nil];
        self.photoVc.washHand = self.washHand;
        [self.view addSubview:self.photoVc.view];
    }
    else if ( role == YimeiWorkFlow_Fuzhujiancha )
    {
        self.photoVc = [[YimeiPosOperateRightPhotoViewController alloc] initWithNibName:@"YimeiPosOperateRightPhotoViewController" bundle:nil];
        self.photoVc.washHand = self.washHand;
        [self.view addSubview:self.photoVc.view];
    }
    else if ( role == YimeiWorkFlow_Dispatch )
    {
        self.selectKeshiVc = [[YimeiSelectKeshiRightViewController alloc] initWithNibName:@"YimeiSelectKeshiRightViewController" bundle:nil];
        self.selectKeshiVc.washHand = self.washHand;
        [self.view addSubview:self.selectKeshiVc.view];
    }
    else if ( role == YimeiWorkFlow_Operate )
    {
        WeakSelf;
        self.selectOperateVc = [[YimeiSelectOperateRightViewController alloc] initWithNibName:@"YimeiSelectOperateRightViewController" bundle:nil];
        self.selectOperateVc.writeBinglikaButtonPressed = ^{
            UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
            CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:weakSelf.washHand.member_id forKey:@"memberID"];
            member.record_id = weakSelf.washHand.binglika_id;
            member.doctor_name = weakSelf.washHand.doctor_name;
            member.doctor_id = weakSelf.washHand.doctor_id;
            HPatientBinglikaViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"binglika"];
            vc.member = member;
            vc.hideShoushu = YES;
            [((UIViewController*)weakSelf.delegate).navigationController pushViewController:vc animated:YES];
        };
        self.selectOperateVc.washHand = self.washHand;
        [self.view addSubview:self.selectOperateVc.view];
    }
    else if ( role == YimeiWorkFlow_Peiyao )
    {
        self.peiyaoVc = [[YimeiPeiyaoRightViewController alloc] initWithNibName:@"YimeiPeiyaoRightViewController" bundle:nil];
        self.peiyaoVc.washHand = self.washHand;
        [self.view addSubview:self.peiyaoVc.view];
    }
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 603, 693)];
    self.maskView.backgroundColor = COLOR(242, 245, 245, 1);
}

- (void)realoadData
{
    [self.photoVc realoadData];
}

- (void)scrollToEnd
{
    [self.photoVc scrollToEnd];
}

- (void)clearUploadingState
{
    [self.photoVc clearUploadingState];
}

- (void)clearTimer
{
    [self.photoVc clearTimer];
}

- (void)startTimer
{
    [self.photoVc startTimer];
}

- (void)removeNoti
{
    [self.selectOperateVc removeNoti];
}

- (void)dealloc
{
    
}

@end
