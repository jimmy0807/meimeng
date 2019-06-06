//
//  YimeiPosOperateLeftDetailViewController.m
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import "YimeiPosOperateLeftDetailViewController.h"
#import "YimeiPosOperateLeftDetailStepTableViewCell.h"
#import "YimeiPosOperateLeftDetailInfoTableViewCell.h"
#import "YimeiPosOperateLeftDetailItemTableViewCell.h"
#import "YimeiPosOperateLeftDetailFumaTableViewCell.h"
#import "YimeiPosOperateLeftDetailRemarkTableViewCell.h"
#import "UIImage+Orientation.h"
#import "UIImage+Scale.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "FetchYimeiOperateActivityRequest.h"
#import "BSYimeiEditOperateActivityRequest.h"
#import "MBProgressHUD.h"
#import "YimeiFumaPhotoView.h"
#import "BSFetchOperateRequest.h"
#import "EditWashHandRequest.h"
#import "CBLoadingView.h"
#import "BSPrintPosOperateRequestNew.h"
#import "BNCameraView.h"
#import <CoreMotion/CoreMotion.h>
#import "SeletctListViewController.h"
#import "FetchWorkHandDetailRequest.h"
#import "BSUserDefaultsManager.h"

typedef enum YimeiPosOperateLeftDetailView
{
    YimeiPosOperateLeftDetailView_Step,
    YimeiPosOperateLeftDetailView_Info,
    YimeiPosOperateLeftDetailView_Keshi,
    YimeiPosOperateLeftDetailView_Remark,
//    YimeiPosOperateLeftDetailView_Chufang,
//    YimeiPosOperateLeftDetailView_Zhuyuan,
    YimeiPosOperateLeftDetailView_Count,
    YimeiPosOperateLeftDetailView_Item,
}YimeiPosOperateLeftDetailView;

static NSInteger YimeiPosOperateLeftDetailViewInfoRow_Queue = 0;
static NSInteger YimeiPosOperateLeftDetailViewInfoRow_Doctor = 1;
static NSInteger YimeiPosOperateLeftDetailViewInfoRow_Member = 2;
static NSInteger YimeiPosOperateLeftDetailViewInfoRow_Fuma = 200;
static NSInteger YimeiPosOperateLeftDetailViewInfoRow_Count = 3;

@interface YimeiPosOperateLeftDetailViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAccelerometerDelegate>
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, weak)IBOutlet UIView* twoButtonView;
@property(nonatomic, weak)IBOutlet UIButton* bigStartButton;
@property(nonatomic, weak)IBOutlet UIButton* twoButtonLeftView;
@property(nonatomic, weak)IBOutlet UIButton* twoButtonRightView;
@property(nonatomic, strong)NSMutableArray* itemsArray;
@property(nonatomic, strong)NSMutableArray* photosArray;
@property(nonatomic, strong)NSArray* workNameArray;
@property (nonatomic, strong) CMMotionManager *mgr; // 保证不死
@property (nonatomic, assign) CMAcceleration lastAcceleration;
@property (nonatomic, assign) CMRotationRate lastRotationRate;
@property (nonatomic, assign) double lastSpeed;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isManuallyFocus;
@property(nonatomic, strong)NSString* takeTime;
@property(nonatomic, strong)NSMutableArray* uploadArray;
@property(nonatomic, strong)UIView* zhuyuanView;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property (nonatomic, assign) BOOL isZhuyuanSettled;
@property (nonatomic, assign) int huliLevel;

@end

@implementation YimeiPosOperateLeftDetailViewController
- (CMMotionManager *)mgr
{
    if (_mgr == nil) {
        _mgr = [[CMMotionManager alloc] init];
    }
    return _mgr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPosOperateLeftDetailStepTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPosOperateLeftDetailStepTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPosOperateLeftDetailInfoTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPosOperateLeftDetailInfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPosOperateLeftDetailItemTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPosOperateLeftDetailItemTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPosOperateLeftDetailRemarkTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPosOperateLeftDetailRemarkTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPosOperateLeftDetailFumaTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPosOperateLeftDetailFumaTableViewCell"];
//    self.itemsArray = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:self.posOperate];
    self.itemsArray = [NSMutableArray array];
    [self fetchItems];
    
    //self.itemsArray = self.posOperate.products.array;
    
//    FetchYimeiOperateActivityRequest* request = [[FetchYimeiOperateActivityRequest alloc] init];
//    request.posOperate = self.posOperate;
//    [request execute];
    
    [self registerNofitificationForMainThread:kFetchWashHandDetailResponse];
    [self registerNofitificationForMainThread:kEditWashHandResponse];
    [self registerNofitificationForMainThread:@"DeviceMoved"];
    [self registerNofitificationForMainThread:@"PhotoSaved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeManuallyFocus)
                                                 name:@"ManuallyFocus" object:nil];

    [self getGyro];

//    [self registerNofitificationForMainThread:kFetchPosConsumeProductResponse];
//    [self registerNofitificationForMainThread:kBSFetchYimeiOperateActivityResponse];
//    [self registerNofitificationForMainThread:kEidtYimeiOperateActivityResponse];
//    [self registerNofitificationForMainThread:kBSFetchWorkFlowActivityResponse];
    self.isZhuyuanSettled = NO;
    self.takeTime = @"before";
    [self checkWorkFlowState:FALSE];
    //[self didLeftButtonPressed:nil];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self checkWorkFlowState:FALSE];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationOnMainThread:kFetchWashHandDetailResponse];
}

-(void)changeManuallyFocus{
    _isManuallyFocus = YES;
}

-(void)getGyro{
    //先判断陀螺仪是否可用
    if (![self.mgr isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
        return;
    }
    //2 设置采样间隔
    self.mgr.gyroUpdateInterval = 0.3;
    
    [self.mgr startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        CMRotationRate rate =    gyroData.rotationRate;
        //获取陀螺仪 三个xyz值
        if ([self movingCheck:rate] && _isMoving && !_isManuallyFocus){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceMoved" object:nil];
            _isMoving = NO;
        }
        _lastRotationRate = rate;
    }];
}

-(BOOL)movingCheck:(CMRotationRate)newRate
{
    double newSpeed = fabs(_lastRotationRate.x-newRate.x) + fabs(_lastRotationRate.y-newRate.y) + fabs(_lastRotationRate.z-newRate.z);
    if (fabs(_lastRotationRate.x-newRate.x) > 0.1 || fabs(_lastRotationRate.y-newRate.y) > 0.1 || fabs(_lastRotationRate.z-newRate.z) > 0.1){
        _isMoving = YES;
    }
    else {
        newSpeed = 0;
    }
    if (newSpeed > 0.3 && _isManuallyFocus){
        _isManuallyFocus = NO;
    }
    if (_lastSpeed == 0 && newSpeed == 0){
        return YES;
    }
    _lastSpeed = newSpeed;
    return NO;
}

- (void)fetchItems
{
#if 0
    self.itemsArray = [NSMutableArray array];
    NSArray *consume_prodcuts = [[BSCoreDataManager currentManager] fetchConsumeProductsWithOperate:self.posOperate];
   
    for (CDPosProduct* p in self.posOperate.products )
    {
        if ( [p.product.bornCategory integerValue] == kPadBornCategoryCourses || [p.product.bornCategory integerValue] == kPadBornCategoryPackage || [p.product.bornCategory integerValue] == kPadBornCategoryPackageKit )
        {
            continue;
        }
        
        BOOL bFind = FALSE;
        for (CDPosConsumeProduct *c in consume_prodcuts )
        {
            if ( [c.product_id isEqualToNumber:p.product.itemID] )
            {
                bFind = TRUE;
                break;
            }
        }
        
        if ( !bFind )
        {
            continue;
        }
        
        [self.itemsArray addObject:p];
    }
#endif
}

- (void)reloadData
{
    self.workNameArray = [self.washHand.work_names componentsSeparatedByString:@","];
    
    //if ( [self.washHand.flow_end boolValue] )
    {
        YimeiPosOperateLeftDetailViewInfoRow_Fuma = 3;
        YimeiPosOperateLeftDetailViewInfoRow_Count = 4;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kFetchWashHandDetailResponse] )
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self checkWorkFlowState:FALSE];
            [self reloadData];
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [view show];
        }
        
        [[CBLoadingView shareLoadingView] hide];
    }
    else if ( [notification.name isEqualToString:kEditWashHandResponse] )
    {
        [MBProgressHUD hideHUDForView:((UIViewController*)self.delegate).view animated:YES];
        [[CBLoadingView shareLoadingView] hide];
        
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0)
        {
            FetchWorkHandDetailRequest* request = [[FetchWorkHandDetailRequest alloc] init];
            NSLog(@"%@",self.washHand.operate_id);
            request.washHand = self.washHand;
            [request execute];
            [self checkWorkFlowState:TRUE];
            [self reloadData];
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [view show];
        }
        
    }
    else if ( [notification.name isEqualToString:kFetchPosOperateProductResponse]||[notification.name isEqualToString:kFetchPosConsumeProductResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self fetchItems];
            if ( YimeiPosOperateLeftDetailView_Item < YimeiPosOperateLeftDetailView_Count )
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:YimeiPosOperateLeftDetailView_Item] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    else if ( [notification.name isEqualToString:kEidtYimeiOperateActivityResponse] )
    {
        BSYimeiEditOperateActivityRequest* request = notification.object;
        if ( request.isBack )
        {
            NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
            if ( result == 0 )
            {
                [self didBackButtonPressed:nil];
            }
            else
            {
                NSString *message = [notification.userInfo objectForKey:@"rm"];
                UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [view show];
            }
            
            return;
        }
        
        [self checkWorkFlowState:FALSE];
        [MBProgressHUD hideHUDForView:((UIViewController*)self.delegate).view animated:YES];
        NSInteger result = [[notification.userInfo valueForKey:@"rc"] integerValue];
        if ( result == 0 )
        {
            
        }
        else
        {
            NSString *message = [notification.userInfo objectForKey:@"rm"];
            UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [view show];
        }
    }
    else if ( [notification.name isEqualToString:@"PhotoSaved"] )
    {
        [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
    }
}

- (void)checkWorkFlowState:(BOOL)isPop
{
    NSLog(@"%@",self.washHand);
    self.titleLabel.text = self.washHand.name;
    
    self.workNameArray = [self.washHand.work_names componentsSeparatedByString:@","];
    NSInteger role = [self.washHand.role_option integerValue];

    if ( [self.washHand.state isEqualToString:@"temp"] )
    {
        self.washHand.state = @"done";
        [[BSCoreDataManager currentManager] save];
        if ( role == YimeiWorkFlow_Peiyao )
        {
            [self.bigStartButton setTitle:@"打印" forState:UIControlStateNormal];
        }
        else
        {
            [self didBackButtonPressed:nil];
        }
    }
    else if ( [self.washHand.state isEqualToString:@"draft"] )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.washHand];
        [[BSCoreDataManager currentManager] save];
        [self didBackButtonPressed:nil];
    }
    else if ( [self.washHand.state isEqualToString:@"waiting"] )
    {
        self.twoButtonView.hidden = YES;
        if ( role == YimeiWorkFlow_Peiyao )
        {
            [self.bigStartButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        else
        {
            [self.bigStartButton setTitle:@"开始准备" forState:UIControlStateNormal];
        }
    }
    else if ( [self.washHand.state isEqualToString:@"doing"] || [self.washHand.state isEqualToString:@"done"] )
    {
        if ( role == YimeiWorkFlow_TakePhoto )
        {
            self.twoButtonView.hidden = NO;
            [self.twoButtonLeftView setTitle:@"iPad拍照" forState:UIControlStateNormal];
            [self.twoButtonRightView setTitle:@"完成" forState:UIControlStateNormal];
        }
        else if ( role == YimeiWorkFlow_Peiyao )
        {
            self.twoButtonView.hidden = YES;
            [self.bigStartButton setTitle:@"打印" forState:UIControlStateNormal];
        }
        else if (role == YimeiWorkFlow_Fuzhujiancha)
        {
            self.twoButtonView.hidden = NO;
            [self.twoButtonLeftView setTitle:@"iPad拍照" forState:UIControlStateNormal];
            [self.twoButtonRightView setTitle:@"完成" forState:UIControlStateNormal];
            
        }
        else
        {
            if ([self.washHand.state isEqualToString:@"done"] )
            {
                self.twoButtonView.hidden = YES;
                [self.bigStartButton setTitle:@"已完成" forState:UIControlStateNormal];
            }
            else
            {
                if ( role == 6 )
                {
//                    self.twoButtonView.hidden = NO;
//                    [self.twoButtonLeftView setTitle:@"安排住院" forState:UIControlStateNormal];
//                    [self.twoButtonRightView setTitle:@"完成" forState:UIControlStateNormal];
                    self.twoButtonView.hidden = YES;
                    [self.bigStartButton setTitle:@"完成" forState:UIControlStateNormal];
                }
                else
                {
                    self.twoButtonView.hidden = YES;
                    [self.bigStartButton setTitle:@"完成" forState:UIControlStateNormal];
                }
//                self.twoButtonView.hidden = YES;
//                [self.bigStartButton setTitle:@"完成" forState:UIControlStateNormal];
            }
        }
    }
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self removeNotificationOnMainThread:kEditWashHandResponse];
    [self.delegate didYimeiPosOperateLeftDetailViewBackButtonPressed];
}

- (void)showYimeiSignAfterOperationViewController:(NSMutableDictionary*)params
{
    [self.delegate showYimeiSignAfterOperationViewController:params];
}

- (void)signFinished
{
    //[self goNextState];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == YimeiPosOperateLeftDetailView_Step )
    {
        return 1;
    }
    else if ( section == YimeiPosOperateLeftDetailView_Info )
    {
        return YimeiPosOperateLeftDetailViewInfoRow_Count;
    }
    else if ( section == YimeiPosOperateLeftDetailView_Item )
    {
        return self.itemsArray.count;
    }
    else if ( section == YimeiPosOperateLeftDetailView_Keshi )
    {
        return 1;
    }
    else if ( section == YimeiPosOperateLeftDetailView_Remark )
    {
        return 1;
    }
//    else if ( section == YimeiPosOperateLeftDetailView_Chufang)
//    {
//        return 1;
//    }
//    else if ( section == YimeiPosOperateLeftDetailView_Zhuyuan)
//    {
//        return 1;
//    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == YimeiPosOperateLeftDetailView_Step )
    {
        return [self tableView:tableView cellForStepRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Info )
    {
        return [self tableView:tableView cellForInfoRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Item )
    {
        return [self tableView:tableView cellForItemRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Keshi )
    {
        return [self tableView:tableView cellForKeshiRowAtIndexPath:indexPath];
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Remark )
    {
        return [self tableView:tableView cellForRemarkRowAtIndexPath:indexPath];
    }
//    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Chufang)
//    {
//        return [self tableView:tableView cellForChufangRowAtIndexPath:indexPath];
//    }
//    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Zhuyuan)
//    {
//        return [self tableView:tableView cellForZhuyuanRowAtIndexPath:indexPath];
//    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForStepRowAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiPosOperateLeftDetailStepTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailStepTableViewCell"];
    cell.washHand = self.washHand;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForInfoRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == YimeiPosOperateLeftDetailViewInfoRow_Fuma )
    {
        YimeiPosOperateLeftDetailFumaTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailFumaTableViewCell"];
        if ( ![self.washHand.fumayao_time isEqualToString:@"0"] )
        {
            cell.leftLabel.text = self.washHand.fumayao_time;
        }
        else
        {
            cell.leftLabel.text = @"";
        }
//        if (self.washHand.currentWorkflowID.integerValue == 8) {
//            cell.rightLabel.text = @"检查照片";
//        }
        WeakSelf;
        cell.rightLabelClick = ^{
            [YimeiFumaPhotoView showWithOperate:weakSelf.washHand];
        };
        
        return cell;
    }
    
    YimeiPosOperateLeftDetailInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailInfoTableViewCell"];
    
    if ( indexPath.row == YimeiPosOperateLeftDetailViewInfoRow_Queue )
    {
        cell.leftLabel.text = self.washHand.yimei_queueID;
        cell.rightLabel.text = self.washHand.operate_date_detail;
        [cell showLine:YES];
    }
    else if ( indexPath.row == YimeiPosOperateLeftDetailViewInfoRow_Doctor )
    {
        //CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.posOperate.member_id forKey:@"memberID"];
        cell.leftLabel.text = [NSString stringWithFormat:@"医生: %@",self.washHand.doctor_name];
        if ( [self.washHand.yimei_shejizongjianName length] > 0 )
        {
            cell.rightLabel.text = [NSString stringWithFormat:@"设计总监: %@",self.washHand.yimei_shejizongjianName];
        }
        else
        {
            cell.rightLabel.text = @"";
        }
        
        [cell showLine:YES];
    }
    else if ( indexPath.row == YimeiPosOperateLeftDetailViewInfoRow_Member )
    {
        //CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.posOperate.member_id forKey:@"memberID"];
        cell.leftLabel.text = [NSString stringWithFormat:@"客户: %@",self.washHand.member_name_detail];
        
        if ( [self.washHand.yimei_shejishiName length] > 0 )
        {
            cell.rightLabel.text = [NSString stringWithFormat:@"设计师: %@",self.washHand.yimei_shejishiName];
        }
        else
        {
            cell.rightLabel.text = @"";
        }
        
        if ( YimeiPosOperateLeftDetailViewInfoRow_Fuma < YimeiPosOperateLeftDetailViewInfoRow_Count )
        {
            [cell showLine:YES];
        }
        else
        {
            [cell showLine:NO];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemRowAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiPosOperateLeftDetailItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailItemTableViewCell"];
    
    CDPosProduct* p = self.itemsArray[indexPath.row];
    cell.product = p;
    cell.isLastLine = ( indexPath.row + 1 == self.itemsArray.count ) ? TRUE : FALSE;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForKeshiRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailKeshiTableViewCell"];
    
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YimeiPosOperateLeftDetailKeshiTableViewCell"];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 23, 201, 22)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.tag = 101;
        titleLabel.textColor = COLOR(190, 190, 190, 1);
        [cell.contentView addSubview:titleLabel];
        
        UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 67, 420, 1)];
        lineImageView.backgroundColor = COLOR(240, 241, 241, 1);
        [cell.contentView addSubview:lineImageView];
    }
    self.workNameArray = [self.washHand.work_names componentsSeparatedByString:@","];
    NSInteger role = [self.washHand.role_option integerValue];
    if (role == YimeiWorkFlow_Fuzhujiancha) {
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:101];
        titleLabel.text = [NSString stringWithFormat:@"抽血检查x1"];
    }
    else
    {
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:101];
        titleLabel.text = [NSString stringWithFormat:@"科室: %@",self.washHand.keshi_name];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRemarkRowAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiPosOperateLeftDetailRemarkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailRemarkTableViewCell"];
    cell.remarkString = self.washHand.remark;
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForChufangRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailChufangTableViewCell"];
//    
//    if ( cell == nil )
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YimeiPosOperateLeftDetailChufangTableViewCell"];
//        
//        cell.backgroundColor = COLOR(96, 211, 212, 1);
//        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 420, 60)];
//        titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        titleLabel.tag = 101;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.textColor = [UIColor whiteColor];
//        [cell.contentView addSubview:titleLabel];
//        UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, 420, 1)];
//        lineImageView.backgroundColor = [UIColor whiteColor];
//        [cell.contentView addSubview:lineImageView];
//    }
//    
//    UILabel* titleLabel = (UILabel*)[cell viewWithTag:101];
//    titleLabel.text = [NSString stringWithFormat:@"开处方药"];
//    
//    return cell;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForZhuyuanRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPosOperateLeftDetailZhuyuanTableViewCell"];
//    
//    if ( cell == nil )
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YimeiPosOperateLeftDetailZhuyuanTableViewCell"];
//        cell.backgroundColor = COLOR(96, 211, 212, 1);
//        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 420, 60)];
//        titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        titleLabel.tag = 101;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.textColor = [UIColor whiteColor];
//        [cell.contentView addSubview:titleLabel];
//        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 420, 60)];
//        [button addTarget:self action:@selector(addZhuyuanView) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:button];
//    }
//    
//    UILabel* titleLabel = (UILabel*)[cell viewWithTag:101];
//    titleLabel.text = [NSString stringWithFormat:@"安排住院"];
//    
//    return cell;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.workNameArray = [self.washHand.work_names componentsSeparatedByString:@","];
    NSInteger role = [self.washHand.role_option integerValue];
    if (role == YimeiWorkFlow_Fuzhujiancha) {
        return YimeiPosOperateLeftDetailView_Count-1;
    }
    return YimeiPosOperateLeftDetailView_Count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == YimeiPosOperateLeftDetailView_Step )
    {
        return 40;
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Item )
    {
        CDPosProduct* p = self.itemsArray[indexPath.row];
        CGSize s = [YimeiPosOperateLeftDetailItemTableViewCell buweiHeightString:p.part_display_name];
        return 68 + (s.height > 0 ? 10 : 0 ) + s.height;
    }
    else if ( indexPath.section == YimeiPosOperateLeftDetailView_Remark )
    {
        CGSize s = [YimeiPosOperateLeftDetailRemarkTableViewCell getHeight:self.washHand.remark];
        if (s.height > 0 )
        {
            return 30 + s.height;
        }
        
        return 0;
    }

    return 68;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.section == YimeiPosOperateLeftDetailView_Chufang)
//    {
//
//    }
//    else if (indexPath.section == YimeiPosOperateLeftDetailView_Zhuyuan)
//    {
//        [self addZhuyuanView];
//    }
//}

- (void)addZhuyuanView
{
    if (self.zhuyuanView == nil)
    {
        self.zhuyuanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.zhuyuanView.backgroundColor = [UIColor clearColor];
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        bgView.backgroundColor = COLOR(0, 0, 0, 0.4);
        [self.zhuyuanView addSubview:bgView];
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 724, 768)];
        mainView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 724, 75)];
        naviView.image = [UIImage imageNamed:@"pad_navi_background"];
        [mainView addSubview:naviView];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        [closeButton setImage:[UIImage imageNamed:@"pad_close_button_n"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeZhuyuan) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:closeButton];
        
        UILabel *zhuyuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 124, 72)];
        zhuyuanLabel.text = @"安排住院";
        zhuyuanLabel.font = [UIFont systemFontOfSize:18];
        zhuyuanLabel.textColor = COLOR(37, 37, 37, 1);
        [mainView addSubview:zhuyuanLabel];
        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(625, 0, 99, 72)];
        confirmButton.backgroundColor = COLOR(96, 211, 212, 1);
        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmZhuyuan) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:confirmButton];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 95, 124, 34)];
        dayLabel.text = @"住院天数";
        dayLabel.font = [UIFont systemFontOfSize:16];
        dayLabel.textColor = COLOR(149, 171, 171, 1);
        [mainView addSubview:dayLabel];
        
        UIView *dayView = [[UIView alloc] initWithFrame:CGRectMake(60, 140, 604, 60)];
        dayView.layer.borderWidth = 1;
        dayView.layer.borderColor = COLOR(220, 224, 224, 1).CGColor;
        dayView.layer.cornerRadius = 6;
        
        UIButton *dayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 604, 60)];
        [dayButton setTitle:@"1天" forState:UIControlStateNormal];
        [dayButton setTitleColor:COLOR(37, 37, 37, 1) forState:UIControlStateNormal];
        [dayButton addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
        [dayView addSubview:dayButton];
        [mainView addSubview:dayView];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 215, 124, 34)];
        levelLabel.text = @"护理级别";
        levelLabel.font = [UIFont systemFontOfSize:16];
        levelLabel.textColor = COLOR(149, 171, 171, 1);
        [mainView addSubview:levelLabel];
        
        UIView *levelView = [[UIView alloc] initWithFrame:CGRectMake(60, 260, 604, 60)];
        levelView.layer.borderWidth = 1;
        levelView.layer.borderColor = COLOR(220, 224, 224, 1).CGColor;
        levelView.layer.cornerRadius = 6;
        levelView.tag = 10;
        for (int i = 0; i < 3; i++) {
            UIImageView *huliLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(201*i+50, 21, 18, 18)];
            huliLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_huli_level_%d_n",i]];
            huliLevelImageView.tag = i+100;
            [levelView addSubview:huliLevelImageView];
            
            UILabel *levelTitle = [[UILabel alloc] initWithFrame:CGRectMake(201*i+50, 0, 151, 60)];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:i+1]];
            levelTitle.text = [NSString stringWithFormat:@"%@级护理", string];
            levelTitle.textColor = COLOR(37, 37, 37, 1);
            levelTitle.font = [UIFont systemFontOfSize:18];
            levelTitle.textAlignment = NSTextAlignmentCenter;
            [levelView addSubview:levelTitle];
            
            if (i < 2)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(201*i+201, 0, 1, 60)];
                line.backgroundColor = COLOR(220, 224, 224, 1);
                [levelView addSubview:line];
            }
            
            UIButton *levelButton = [[UIButton alloc] initWithFrame:CGRectMake(201*i+50, 0, 151, 60)];
            levelButton.tag = i;
            [levelButton addTarget:self action:@selector(levelSelect:) forControlEvents:UIControlEventTouchUpInside];
            [levelView addSubview:levelButton];
        }
        [mainView addSubview:levelView];

        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 330, 124, 34)];
        noteLabel.text = @"备注";
        noteLabel.font = [UIFont systemFontOfSize:16];
        noteLabel.textColor = COLOR(149, 171, 171, 1);
        [mainView addSubview:noteLabel];
        
        UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(60, 375, 604, 190)];
        noteView.layer.borderWidth = 1;
        noteView.layer.borderColor = COLOR(220, 224, 224, 1).CGColor;
        noteView.layer.cornerRadius = 6;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 594, 180)];
        
        [noteView addSubview:textView];
        [mainView addSubview:noteView];
        
        [self.zhuyuanView addSubview:mainView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.zhuyuanView];
    }
    else
    {
        UIView *levelView = [self.zhuyuanView viewWithTag:10];
        for (int i = 0; i < 3; i++) {
            UIImageView *huliLevelImageView = [levelView viewWithTag:i+100];
            if (self.huliLevel == i)
            {
                huliLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_huli_level_%d_h",i]];
            }
            else
            {
                huliLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pad_huli_level_%d_n",i]];
            }
        }
    }
}

- (void)levelSelect:(UIButton *)button
{
    self.huliLevel = button.tag;
    [self addZhuyuanView];
}

- (void)selectDay:(UIButton *)button
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    NSArray* daysArray = [NSArray arrayWithObjects:@"1天", @"2天", @"3天", @"4天", @"5天", @"6天", @"7天", @"10天", @"15天", @"30天", nil];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return daysArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        return daysArray[index];
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        [button setTitle:daysArray[index] forState:UIControlStateNormal];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)closeZhuyuan
{
    [self.zhuyuanView removeFromSuperview];
    self.zhuyuanView = nil;
}

- (void)confirmZhuyuan
{
    self.isZhuyuanSettled = YES;
    [self.twoButtonLeftView setTitle:@"已安排住院" forState:UIControlStateNormal];
    [self.zhuyuanView removeFromSuperview];
    self.zhuyuanView = nil;
}

- (IBAction)didStartButtonPressed:(id)sender
{
    NSInteger role = [self.washHand.role_option integerValue];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if ( role == YimeiWorkFlow_Dispatch )
    {
        if ( [self.washHand.keshi_id integerValue] == 0 )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您还没有选择科室" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            
            return;
        }
        
        CDKeShi* keshi = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.washHand.keshi_id forKey:@"keshi_id"];
        if ( [keshi.parentID integerValue] == 0 )
        {
            NSArray* secondKeshi = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            if ( secondKeshi.count > 0 )
            {
                UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您还没有选择二级科室" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [v show];
                
                return;
            }
        }
        
        NSArray* doctorArray = keshi.staff.array;
        if ( doctorArray.count > 0 && [self.washHand.doctor_id integerValue] == 0 )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您还没有选择医生" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            
            return;
        }
        
        if ( self.washHand.keshi_id )
        {
            [params setObject:self.washHand.keshi_id forKey:@"departments_id"];
        }
        
        if ( self.washHand.doctor_id )
        {
            [params setObject:self.washHand.doctor_id forKey:@"doctor_id"];
        }
    }
    else if ( role == YimeiWorkFlow_Operate )
    {
        NSMutableString* names = [NSMutableString string];

        if ( self.washHand.yimei_operate_employee_ids.length > 0 )
        {
            NSMutableArray* finalArray = [NSMutableArray array];
                
            NSArray* array = [self.washHand.yimei_operate_employee_ids componentsSeparatedByString:@","];
            NSInteger i = 0;
            for ( NSString* n in array )
            {
                [finalArray addObject:[NSNumber numberWithInteger:[n integerValue]]];
                CDStaff* staff = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:@([n integerValue]) forKey:@"staffID"];
                if ( i == 0 )
                {
                    [names appendString:staff.name];
                }
                else
                {
                    [names appendFormat:@",%@",staff.name];
                }
                i++;
            }
            self.washHand.yimei_operate_employee_name = names;
            [params setObject:self.washHand.yimei_operate_employee_ids forKey:@"operate_employee_ids"];
        }
        else
        {
//            CDKeShi* keshi = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.washHand.keshi_id forKey:@"keshi_id"];
//            if ( sender && keshi.operate_machine.array.count > 0 )
//            {
//                UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"还没有选择操作者, 是否继续提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"仍要提交", nil];
//                v.tag = 982;
//                [v show];
//                
//                return;
//            }
        }
        
        if ( self.washHand.medical_note )
        {
            [params setObject:self.washHand.medical_note forKey:@"medical_note"];
        }
        
        if ( [self.washHand.doctor_id integerValue] > 0 )
        {
            [params setObject:self.washHand.doctor_id forKey:@"doctor_id"];
        }
    }
    else if ( role == YimeiWorkFlow_TakePhoto )
    {
        if ( self.photosArray.count > 0 )
        {
            [self uploadBeforePhoto];
            //[self uploadAfterPhoto];
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:((UIViewController*)self.delegate).view animated:YES];
            HUD.label.text = @"正在提交数据 请稍后...";
            return;
//            [params setObject:[self.photosArray componentsJoinedByString:@","] forKey:@"image_urls"];
//            [params setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>]
        }
    }
    else if ( role == YimeiWorkFlow_Fuzhujiancha )
    {
        if ( self.photosArray.count > 0 )
        {
            [params setObject:[self.photosArray componentsJoinedByString:@","] forKey:@"image_urls"];
            [params setObject:@"report" forKey:@"take_time"];
        }
    }
    else if ( role == YimeiWorkFlow_Peiyao )
    {
        if ( [self.washHand.state isEqualToString:@"done"] )
        {
            BSPrintPosOperateRequestNew* request = [[BSPrintPosOperateRequestNew alloc] init];
            request.hand = self.washHand;
            [request execute];
            
            return;
        }
        else
        {
            self.washHand.state = @"doing";
            [params setObject:self.washHand.medical_note forKey:@"medical_note"];
        }
    }
    
    if ( role == YimeiWorkFlow_Operate )
    {
        if ( [self.washHand.state isEqualToString:@"waiting"] )
        {
            
        }
        else
        {
            [self showYimeiSignAfterOperationViewController:params];
            return;
        }
    }
    
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.wash = self.washHand;
    [request execute];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:((UIViewController*)self.delegate).view animated:YES];
    HUD.label.text = @"正在提交数据 请稍后...";
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要返回上一个流程吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    v.tag = 9876;
    [v show];
}

- (IBAction)didLeftButtonPressed:(id)sender
{
//    [self.delegate didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed];
//    return;
    if (self.washHand.role_option.integerValue == 7) {
        self.takeTime = @"report";
        WeakSelf;
        [weakSelf.delegate didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed];
//        [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
//            [weakSelf dealPhotoImage:image];
//        }];
    }
    else if (self.washHand.role_option.integerValue == 6) {
        [self addZhuyuanView];
    }
    else {
        self.takeTime = @"before";
        WeakSelf;
        [weakSelf.delegate didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed];
        return;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"术前照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.takeTime = @"before";
            WeakSelf;
            [weakSelf.delegate didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed];
//            [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
//                [weakSelf dealPhotoImage:image];
//            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"术后照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.takeTime = @"after";
            WeakSelf;
            
            [weakSelf.delegate didYimeiPosOperateLeftDetailViewtakePhotoButtonPressed];
//            [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
//                [weakSelf dealPhotoImage:image];
//            }];
        }]];
        
        alert.popoverPresentationController.sourceView = sender;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)takePhotoByPad
{
    WeakSelf;
    [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
        [weakSelf dealPhotoImage:image];
    }];
    //[weakSelf savePhotoByCameraWitBigUrl:@"http://192.168.2.164:80/raw/%2Fstore_00020001%2FDCIM%2F101CANON%2FIMG_0002.JPG" subImageUrl:@""];
}

- (void)selectPhotoFromCamera
{
    self.takeTime = @"before";
    WeakSelf;
    [weakSelf.delegate showBrowser];
    return;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"术前照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.takeTime = @"before";
        WeakSelf;
        [weakSelf.delegate showBrowser];
        //            [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
        //                [weakSelf dealPhotoImage:image];
        //            }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"术后照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.takeTime = @"after";
        WeakSelf;
        [weakSelf.delegate showBrowser];
        //            [BNCameraView showinView:((UIViewController*)self.delegate).view takPhoto:^(UIImage *image) {
        //                [weakSelf dealPhotoImage:image];
        //            }];
    }]];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(925, 0, 99, 72);    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}

- (void)savePhotoByCamera:(UIImage *)image subImage:(UIImage*)subImage
{
    [self dealPhotoImage:image subImage:subImage];
}

- (void)savePhotoByCameraWitBigUrl:(NSString *)url subImage:(UIImage*)subImage
{
    [self dealPhotoImageUrl:url subImage:subImage];
}

- (void)savePhotoByCameraWitBigUrl:(NSString *)url subImageUrl:(NSString*)subImageUrl
{
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = url;
    yimeiImage.small_url = subImageUrl;
    yimeiImage.washhand = self.washHand;
//    yimeiImage.bigImageUrl = url;
    if (self.washHand.role_option.integerValue == 7) {
        yimeiImage.take_time = @"report";
    }
    else {
        yimeiImage.take_time = self.takeTime;
    }
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    
    NSString* s = yimeiImage.url;
    if ( ![BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        NSString* a = [s substringFromIndex:[s rangeOfString:@"raw/%2F"].location + 7];
        NSString* b = [a substringFromIndex:[a rangeOfString:@"%2F"].location + 3];
        
        yimeiImage.bigImageUrl = b;
    }
    
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
}

- (IBAction)didRightButtonPressed:(id)sender
{
    self.photosArray = [NSMutableArray array];
    self.uploadArray = [NSMutableArray array];
    BOOL isFailed = FALSE;
    for ( CDYimeiImage* image in self.washHand.yimei_before )
    {
        if ( [BSUserDefaultsManager sharedManager].useBigPhoto )
        {
            if ( [image.status isEqualToString:@"success"] )
            {
                [self.photosArray addObject:image.url];
                [self.uploadArray addObject:image];
            }
            else
            {
                isFailed = TRUE;
            }
        }
        else
        {
            [self.photosArray addObject:image.url];
            [self.uploadArray addObject:image];
        }
    }

    if ( isFailed && [BSUserDefaultsManager sharedManager].useBigPhoto )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"警告" message:@"还有文件尚未上传成功,点击\"仍要提交\"忽略没有上传成功的图片\n点击\"取消\"手动在右侧重新上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"仍要提交", nil];
        [v show];
    }
    else
    {
        [self doPhotoFinish];
    }
//    [self doPhotoFinish];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        if ( alertView.tag == 982 )
        {
            [self didStartButtonPressed:nil];
        }
        else if ( alertView.tag == 9876 )
        {
            EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
            request.wash = self.washHand;
            request.isCancel = YES;
            [request execute];
            
            //BSYimeiEditOperateActivityRequest* request = [[BSYimeiEditOperateActivityRequest alloc] initWithOperateActivityToNextState:self.currentOperateActivity];
            //request.isBack = TRUE;
            //[request execute];
        }
        else
        {
            [self doPhotoFinish];
        }
    }
}

- (void)doPhotoFinish
{
//    NSMutableArray* imageIDs = [NSMutableArray array];
//    for ( NSString* url in self.photosArray )
//    {
//        NSArray *array = @[@(0), @(NO), @{@"take_time":@"before", @"image_url":url}];
//        [imageIDs addObject:array];
//    };
//    
//    //BSYimeiEditPosOperateRequest* request = [[BSYimeiEditPosOperateRequest alloc] initWithPosOperate:self.posOperate params:@{@"image_ids":imageIDs}];
//    //[request execute];
    
    [self didStartButtonPressed:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing)
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
//    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
    
    [self dealPhotoImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)dealPhotoImage:(UIImage*)image subImage:(UIImage*)subImage
{
    if ( subImage == nil )
    {
        [self dealPhotoImage:image];
        return;
    }
    
    NSString* small_url = [NSString stringWithFormat:@"small_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    [[SDWebImageManager sharedManager] saveImageToCache:subImage forURL:[NSURL URLWithString:small_url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = @"";
    yimeiImage.small_url = small_url;
    yimeiImage.washhand = self.washHand;
    if (self.washHand.role_option.integerValue == 7) {
        yimeiImage.take_time = @"report";
    }
    else {
        yimeiImage.take_time = self.takeTime;
    }
    yimeiImage.type = @"local";
    yimeiImage.status = @"subAdded";
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
    dispatch_async(queue, ^{
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        CGFloat imageDestWidth = imageWidth;
        CGFloat imageDestHeight = imageHeight;
        if (imageWidth > 1024)
        {
            imageDestWidth = 1024;
            imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
        }
        
        UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
        
        NSString* url = [NSString stringWithFormat:@"big_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
        [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            yimeiImage.url = url;
            yimeiImage.status = @"prepare";
            [[BSCoreDataManager currentManager] save:nil];
            [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
        });
    });
}

- (void)dealPhotoImageUrl:(NSString*)url subImage:(UIImage*)subImage
{
    NSString* small_url = [NSString stringWithFormat:@"small_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    [[SDWebImageManager sharedManager] saveImageToCache:subImage forURL:[NSURL URLWithString:small_url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = @"";
    yimeiImage.small_url = small_url;
    yimeiImage.washhand = self.washHand;
    yimeiImage.bigImageUrl = url;
    if (self.washHand.role_option.integerValue == 7) {
        yimeiImage.take_time = @"report";
    }
    else {
        yimeiImage.take_time = self.takeTime;
    }
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
}

- (void)dealPhotoImage:(UIImage*)image
{
    //image = [image orientation];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 1024)
    {
        imageDestWidth = 1024;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    NSString* url = [NSString stringWithFormat:@"big_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
    
    imageDestWidth = 200;
    imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    NSString* small_url = [NSString stringWithFormat:@"small_%lld",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:small_url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = url;
    yimeiImage.small_url = small_url;
    yimeiImage.washhand = self.washHand;
    if (self.washHand.role_option.integerValue == 7) {
        yimeiImage.take_time = @"report";
    }
    else {
        yimeiImage.take_time = self.takeTime;
    }
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.delegate didYimeiPosOperateLeftDetailViewPhotoAdded];
}

- (void)dealloc
{
    
}

- (void)  uploadBeforePhoto
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableArray *beforeUrlArray = [NSMutableArray array];
    NSMutableArray *afterUrlArray = [NSMutableArray array];
    
    NSMutableArray *beforeBigUrlArray = [NSMutableArray array];
    NSMutableArray *afterBigUrlArray = [NSMutableArray array];
    
//    NSMutableArray *beforeSmallUrlArray = [NSMutableArray array];
//    NSMutableArray *afterSmallUrlArray = [NSMutableArray array];
    
    for (CDYimeiImage *yimeiImage in self.uploadArray)
    {
        if ( [yimeiImage.status isEqualToString:@"success"] )
        {
            if ([yimeiImage.take_time isEqualToString:@"before"])
            {
                [beforeUrlArray addObject:yimeiImage.url];
            }
            else if ([yimeiImage.take_time isEqualToString:@"after"])
            {
                [afterUrlArray addObject:yimeiImage.url];
            }
        }
        
        if ( yimeiImage.bigImageUrl.length > 0 )
        {
            if ([yimeiImage.take_time isEqualToString:@"before"])
            {
                [beforeBigUrlArray addObject:[NSString stringWithFormat:@"%@@%@",yimeiImage.bigImageUrl,yimeiImage.small_url]];
                //[beforeSmallUrlArray addObject:yimeiImage.small_url];
            }
            else if ([yimeiImage.take_time isEqualToString:@"after"])
            {
                [afterBigUrlArray addObject:[NSString stringWithFormat:@"%@@%@",yimeiImage.bigImageUrl,yimeiImage.small_url]];
                //[afterSmallUrlArray addObject:yimeiImage.small_url];
            }
        }
    }
    [params setObject:[NSString stringWithFormat:@"%@|%@|", [beforeUrlArray componentsJoinedByString:@","], [afterUrlArray componentsJoinedByString:@","]] forKey:@"image_urls"];
    
    [params setObject:[NSString stringWithFormat:@"%@|%@|", [beforeBigUrlArray componentsJoinedByString:@","], [afterBigUrlArray componentsJoinedByString:@","]] forKey:@"image_local_names"];
    
    //[params setObject:[NSString stringWithFormat:@"%@|%@|", [beforeSmallUrlArray componentsJoinedByString:@","], [afterSmallUrlArray componentsJoinedByString:@","]] forKey:@"image_local_names"];
    
    //[params setObject:[photoUrlArray componentsJoinedByString:@","] forKey:@"image_urls"];
    //[params setObject:@"before" forKey:@"take_time"];
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.uploadArray = self.uploadArray;
    request.notGoNext = NO;
    request.wash = self.washHand;
    [request execute];
}

- (void)uploadAfterPhoto
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableArray *photoUrlArray = [NSMutableArray array];
    NSMutableArray *afterBigUrlArray = [NSMutableArray array];
    
    for (CDYimeiImage *yimeiImage in self.uploadArray)
    {
        if ( [yimeiImage.status isEqualToString:@"success"] )
        {
            if ([yimeiImage.take_time isEqualToString:@"after"])
            {
                [photoUrlArray addObject:yimeiImage.url];
            }
        }
        
        if ( yimeiImage.bigImageUrl.length > 0 )
        {
            [afterBigUrlArray addObject:yimeiImage.bigImageUrl];
        }
    }
    [params setObject:[photoUrlArray componentsJoinedByString:@","] forKey:@"image_urls"];
    [params setObject:[afterBigUrlArray componentsJoinedByString:@","] forKey:@"image_local_names"];
    [params setObject:@"after" forKey:@"take_time"];
    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
    request.params = params;
    request.notGoNext = NO;
    request.wash = self.washHand;
    [request execute];
}

@end
