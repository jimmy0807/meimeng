//
//  MemberInfoViewController.m
//  Boss
//
//  Created by lining on 16/3/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "UIView+Frame.h"
#import "SettingHeadCell.h"
#import "BSEditCell.h"
#import "MemberInfoDataSource.h"
#import "BSFetchMemberDetailRequest.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSFetchMemberTezhengRequest.h"

#import "MemberTezhengDataSource.h"
#import "MemberQinyouDataSource.h"

#import "MemberAddTezhengViewController.h"
#import "DatePickerView.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBMessageView.h"
#import "BNRegularExpression.h"
#import "CBLoadingView.h"
#import "BSCreateMemberRequest.h"
#import "BSUpdateMemberRequest.h"
#import "BSFetchMemberRequest.h"
#import "BSFetchStaffRequest.h"
#import "BSFetchMemberTitleRequest.h"
#import "BSImagePickerManager.h"
#import "BSFetchProductPriceListRequest.h"

typedef enum ItemType
{
    ItemType_xiangqing,
    ItemType_tezheng,
    ItemType_qinyou
}ItemType;


@interface MemberInfoViewController ()<MemberInfoDataSourceDelegate,CBBackButtonItemDelegate,DatePickerViewDelegate,UIActionSheetDelegate,BSCommonSelectedItemViewControllerDelegate,BSImagePickerManagerDelegate>
{
    CGFloat constraint;
    ItemType currentType;
    
    
    UIImage *headImage;
    BNRightButtonItem *rightBtnItem;
}

@property(nonatomic, strong) NSArray *tezhengs;
@property(nonatomic, strong) NSArray *qinyous;
@property(nonatomic, strong) CDMember *orignMember;
@property(nonatomic, strong) NSMutableDictionary *params;

@property(nonatomic,strong)NSIndexPath *selectIndexPath;

@property(nonatomic, strong) MemberInfoDataSource *infoDataSource;
@property(nonatomic, strong) MemberTezhengDataSource *tezhengDataSource;
@property(nonatomic, strong) MemberQinyouDataSource *qinyouDataSource;

@property(nonatomic, strong) DatePickerView *pickerView;

@property (nonatomic, assign) bool isChanged;
@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    if (self.member) {
        self.type = MemberInfoType_edit;
        [self orignMemer:self.member];
        self.navigationItem.title = self.member.memberName;
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
        NSArray *shopIds = [PersonalProfile currentProfile].shopIds;
        if (shopIds.count == 1) {
            self.member.store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[shopIds objectAtIndex:0] forKey:@"storeID"];
        }
        
        self.type = MemberInfoType_create;
        
        self.navigationItem.title = @"新建会员";
        
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }

    BSFetchProductPriceListRequest *request = [[BSFetchProductPriceListRequest alloc]init];
    [request execute];
    
//    self.title = @"会员信息";
    
    constraint = self.lineLayoutConstraint.constant;
    
    self.saveBtn.enabled = false;

    [self initParams];
    [self initDataSource];
    
    [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    [self registerNofitificationForMainThread:kBSCreateMemberResponse];
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
}



#pragma mark - init data
#pragma mark - init data & view
- (void) initParams
{
    self.params = [NSMutableDictionary dictionary];
    if (self.type == MemberInfoType_create) {
        [self.params setObject:[[PersonalProfile currentProfile] getCurrentStore].storeID forKey:@"shop_id"];
    }
    
}

- (void) orignMemer:(CDMember *)member
{
    
    if (!self.orignMember) {
        self.orignMember = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
    }
    self.orignMember.memberName = member.memberName;
    self.orignMember.mobile = member.mobile;
    self.orignMember.birthday = member.birthday;
    self.orignMember.gender = member.gender;
    self.orignMember.email = member.email;
    self.orignMember.store = member.store;
//    self.orignMember.member_title_id = member.member_title_id;
    self.orignMember.member_qq = member.member_qq;
    self.orignMember.member_wx = member.member_wx;
    self.orignMember.member_address = member.member_address;
    
    self.orignMember.member_tuijian = member.member_tuijian;
    self.orignMember.staff_tuijian = member.staff_tuijian;
    self.orignMember.member_fenlei = member.member_fenlei;
    self.orignMember.guwen = member.guwen;
    self.orignMember.jishi = member.jishi;
    
    [[BSCoreDataManager currentManager] save:nil];
    
}

- (void)rollback
{
    [[BSCoreDataManager currentManager] rollback];
    
    [[BSCoreDataManager currentManager] deleteObject:self.orignMember];
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)setIsChanged:(bool)isChanged
{
    _isChanged = isChanged;
    if (self.type == MemberInfoType_edit && isChanged) {
        if (self.params.allKeys.count > 0) {
            self.navigationItem.rightBarButtonItem = rightBtnItem;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}

#pragma mark - CBBackButtonItemDelegate
- (void)didItemBackButtonPressed:(UIButton *)sender
{
    if( self.type == MemberInfoType_create )
    {
        if( [self.params allKeys].count > 1 )
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
            [view show];
        }
        else
        {
            [self rollback];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if ( [self.params allKeys].count > 0 )
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
            [view show];
        }
        else
        {
            [self rollback];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    [self handleMemberRequest];
}


#pragma mark - params
- (BOOL)paramsIsOK
{
    NSString *name = self.member.memberName;
    NSString *mobile = self.member.mobile;
    NSNumber *shop_id = self.member.store.storeID;
    
    if([name isEqualToString:@""]||name ==nil)
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"名字不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return NO;
    }
    else if ([mobile isEqualToString:@""]||mobile==nil)
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"手机号码不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return NO;
    }
    else if(![BNRegularExpression isMobileNumber:mobile])
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"手机号码格式错误" afterTimeHide:0.75];
        [message showInView:self.view];
        return NO;
    }
    else if ([shop_id isEqual:@0]||shop_id==nil)
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"门店不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberDetailResponse]) {
        [self orignMemer:self.member];
    }
    else if ([notification.name isEqualToString:kBSUpdateMemberResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            CBMessageView *messgae = [[CBMessageView alloc]initWithTitle:@"修改成功" afterTimeHide:0.75];
            [messgae showInView:self.view];
            
            [[BSCoreDataManager currentManager] deleteObject:self.orignMember];
            [[BSCoreDataManager currentManager] save:nil];
            [self performSelector:@selector(popController) withObject:nil afterDelay:0.75];
            
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:2.5];
            [message showInView:self.view];
        }

    }
    else if ([notification.name isEqualToString:kBSCreateMemberResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            CBMessageView *messgae = [[CBMessageView alloc]initWithTitle:@"添加成功" afterTimeHide:0.75];
            [messgae showInView:self.view];
            [self performSelector:@selector(popController) withObject:nil afterDelay:0.75];
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }

    }
}
#pragma mark - pop controller
- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
- (void)handleMemberRequest
{
    if ([self paramsIsOK]) {
        [[CBLoadingView shareLoadingView] show];
        if (self.type == MemberInfoType_create) {
            BSCreateMemberRequest *createRequest = [[BSCreateMemberRequest alloc]initWithMember:self.member params:self.params];
            [createRequest execute];
        }
        else if (self.type == MemberInfoType_edit)
        {
            BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.member params:self.params];
            [updateRequest execute];
        }
    }

}

#pragma mark - init DataSource
- (void) initDataSource
{
    self.infoDataSource = [[MemberInfoDataSource alloc] initWithMember:self.member tableView:self.infoTableView];
    self.infoDataSource.delegate = self;
    
    self.tezhengDataSource = [[MemberTezhengDataSource alloc] initWithMember:self.member tableView:self.teZhengTableView];
    
    self.qinyouDataSource = [[MemberQinyouDataSource alloc] initWithMember:self.member tableView:self.qinyouTableView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1001) {
        self.lineLayoutConstraint.constant = constraint + scrollView.contentOffset.x/3.0;
    }
}


#pragma mark - MemberInfoDataSourceDelegate
- (void)didItemSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionOne && row == InfoSection_row_pic) {
        UIActionSheet *actionSheet;
        if(!self.infoDataSource.isHaveImage)
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选择", nil];
            [actionSheet showInView:self.view];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选择",@"删除", nil];
            [actionSheet showInView:self.view];
        }
    }
    else if (section == kInfoSectionTwo && row == InfoSection_row_birthday)
    {
        [self showDatePicker];
    }
    else
    {
        BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        
        selectedView.delegate = self;
//        [self initCommonSelectedViewControllerData:selectedView];
//        
//        [self.navigationController pushViewController:selectedView animated:YES];
      if (section == kInfoSectionThree)
        {
            if (row == InfoSection_row_zhicheng) {
                
                BSFetchMemberTitleRequest *request = [[BSFetchMemberTitleRequest alloc] init];
                [request execute];
                
                selectedView.notificationName = kBSFetchMemberTitleResponse;
            }
        }
        else if (section == kInfoSectionFour)
        {
            if (row == InfoSectionRow_row_tuijian_vip) {
                
                BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithStoreID:self.member.store.storeID startIndex:0];
                request.count = 999;
                [request execute];
                
                selectedView.notificationName = kBSFetchMemberResponse;
                
            }
            else if (row == InfoSectionRow_row_tuijian_member)
            {
                BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
                request.shop = self.member.store;
                [request execute];
                selectedView.notificationName = kBSFetchStaffResponse;
            }
            else if (row == InfoSectionRow_row_guwen)
            {
                BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//                request.shop = self.member.store;
                [request execute];
                selectedView.notificationName = kBSFetchStaffResponse;
            }
            else if (row == InfoSectionRow_row_jishi)
            {
                BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
                //                request.shop = self.member.store;
                [request execute];
                selectedView.notificationName = kBSFetchStaffResponse;
            }
        }
        [self initCommonSelectedViewControllerData:selectedView];
        [self.navigationController pushViewController:selectedView animated:YES];
    }
}

- (void)didEditTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == kInfoSectionOne) {
        if (InfoSection_row_name) {
            if (![self.member.memberName isEqualToString:textField.text]) {
                self.member.memberName = textField.text;
                if ([self.member.memberName isEqualToString:self.orignMember.memberName])
                {
                    [self.params removeObjectForKey:@"name"];
                }
                else
                {
                    [self.params setObject:self.member.memberName forKey:@"name"];
                }
                self.isChanged = true;
            }
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_phone) {
            if (![self.member.mobile isEqualToString:textField.text]) {
                self.member.mobile = textField.text;
                if ([self.member.mobile isEqualToString:self.orignMember.mobile]) {
                    [self.params removeObjectForKey:@"mobile"];
                }
                else
                {
                    [self.params setObject:self.member.mobile forKey:@"mobile"];
                }
                self.isChanged = true;
            }
        }
    }
    else if (section == kInfoSectionThree)
    {
        if (row == InfoSection_row_qq) {
            if (![self.member.member_qq isEqualToString:textField.text]) {
                self.member.member_qq = textField.text;
                if ([self.member.member_qq isEqualToString:self.orignMember.member_qq]) {
                    [self.params removeObjectForKey:@"qq"];
                }
                else
                {
                    [self.params setObject:self.member.member_qq forKey:@"qq"];
                }
                self.isChanged = true;
            }
        }
        else if (row == InfoSection_row_weixin)
        {
            if (![self.member.member_wx isEqualToString:textField.text]) {
                self.member.member_wx = textField.text;
                if ([self.member.member_wx isEqualToString:self.orignMember.member_wx]) {
                    [self.params removeObjectForKey:@"wx"];
                }
                else
                {
                    [self.params setObject:self.member.member_wx forKey:@"wx"];
                }
                self.isChanged = true;
            }
        }
        else if (row == InfoSection_row_email)
        {
            if (![self.member.email isEqualToString:textField.text]) {
                self.member.email = textField.text;
                if ([self.member.email isEqualToString:self.orignMember.email])
                {
                    [self.params removeObjectForKey:@"email"];
                }
                else
                {
                    [self.params setObject:self.member.email forKey:@"email"];
                }
                
                self.isChanged = true;
            }
        }
        else if (row == InfoSection_row_address)
        {
            if (![self.member.member_address isEqualToString:textField.text]) {
                self.member.member_address = textField.text;
                if ([self.member.member_address isEqualToString:self.orignMember.member_address])
                {
                    [self.params removeObjectForKey:@"street"];
                }
                else
                {
                    [self.params setObject:self.member.member_address forKey:@"street"];
                }
                
                self.isChanged = true;
            }
        }
    }
    else if (section == kInfoSectionFour)
    {
        
    }
}

#pragma mark - init CommonSelectedData
- (void) initCommonSelectedViewControllerData:(BSCommonSelectedItemViewController *)selectedVC
{
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    
    if (section == kInfoSectionOne) {
        if (row == InfoSection_row_shop) {
            PersonalProfile *profile = [PersonalProfile currentProfile];
            NSArray *array = profile.shopIds;
            NSMutableArray *storeNames = [[NSMutableArray alloc]init];
            NSMutableArray *userData = [[NSMutableArray alloc] init];
            for(NSNumber *shopid in array)
            {
                CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:shopid forKey:@"storeID"];
                [storeNames addObject:store.storeName];
                [userData addObject:store];
            }
            selectedVC.dataArray = storeNames;
            selectedVC.userData = userData;
            
            selectedVC.currentSelectIndex = [selectedVC.dataArray indexOfObject:self.member.store.storeName];
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_gender) {
            selectedVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@"男",@"女"]];
            
            selectedVC.userData = selectedVC.dataArray;
            
            NSInteger currentIdx;
            if ([self.member.gender isEqualToString:@"Male"])
            {
                currentIdx = 0;
            }
            else
            {
                currentIdx = 1;
            }
            
            selectedVC.currentSelectIndex = currentIdx;
        }
    }
    else if (section == kInfoSectionThree)
    {
        if (row == InfoSection_row_zhicheng) {
            NSArray *titles = [[BSCoreDataManager currentManager] fetchItems:@"CDMemberTitle"];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDMemberTitle *memberTitle in titles) {
                if ([memberTitle.title_id integerValue] == [self.member.title.title_id integerValue]) {
                    currentIdx = [titles indexOfObject:memberTitle];
                }
                [names addObject:memberTitle.title_name];
            }
            selectedVC.dataArray = names;
            selectedVC.userData = titles;
            selectedVC.currentSelectIndex = currentIdx;
        }
    }
    else if (section == kInfoSectionFour)
    {
        if (row == InfoSectionRow_row_tuijian_vip) {
            NSArray *members = [[BSCoreDataManager currentManager] fetchAllMemberWithStoreID:self.member.store.storeID];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDMember *member in members) {
                if ([member.memberID integerValue] == [self.member.member_tuijian.memberID integerValue]) {
                    currentIdx = [members indexOfObject:member];
                }
                [names addObject:member.memberName];
            }
            selectedVC.dataArray = names;
            selectedVC.userData = members;
            selectedVC.currentSelectIndex = currentIdx;
        }
        else if (row == InfoSectionRow_row_tuijian_member)
        {
            NSArray *staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:self.member.store.storeID];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDStaff *staff in staffs) {
                if ([staff.staffID integerValue] == [self.member.staff_tuijian.staffID integerValue]) {
                    currentIdx = [staffs indexOfObject:staff];
                }
                [names addObject:staff.name];
            }
            selectedVC.dataArray = names;
            selectedVC.userData = staffs;
            selectedVC.currentSelectIndex = currentIdx;
        }
        else if (row == InfoSectionRow_row_fenlei)
        {
            selectedVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@"个人",@"团体",@"公司"]];
            
            selectedVC.userData = selectedVC.dataArray;
            
            NSInteger currentIdx = -1;
            for (NSString *string in selectedVC.dataArray) {
                if ([string isEqualToString:self.member.member_fenlei]) {
                    currentIdx  = [selectedVC.dataArray indexOfObject:string];
                    break;
                }
            }
            selectedVC.currentSelectIndex = currentIdx;
        }
        else if (row == InfoSectionRow_row_guwen)
        {
            NSArray *staffs = [[BSCoreDataManager currentManager] fetchAllStaffs];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDStaff *staff in staffs) {
                if ([staff.staffID integerValue] == [self.member.guwen.staffID integerValue]) {
                    currentIdx = [staffs indexOfObject:staff];
                }
                [names addObject:staff.name];
            }
            selectedVC.dataArray = names;
            selectedVC.userData = staffs;
            selectedVC.currentSelectIndex = currentIdx;
        }
        else if (row == InfoSectionRow_row_jishi)
        {
            NSArray *staffs = [[BSCoreDataManager currentManager] fetchAllStaffs];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDStaff *staff in staffs) {
                if ([staff.staffID integerValue] == [self.member.jishi.staffID integerValue]) {
                    currentIdx = [staffs indexOfObject:staff];
                }
                [names addObject:staff.name];
            }
            selectedVC.dataArray = names;
            selectedVC.userData = staffs;
            selectedVC.currentSelectIndex = currentIdx;
        }
    }
}


#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    if (section == kInfoSectionOne) {
        if (row == InfoSection_row_shop) {
            NSArray *shops = userData;
            CDStore *store = [shops objectAtIndex:index];
            self.member.store = store;
            self.member.storeName = store.storeName;
            self.member.storeID = store.storeID;
            if ([self.member.store.storeID integerValue] == [self.orignMember.storeID integerValue]) {
                [self.params removeObjectForKey:@"shop_id"];
            }
            else
            {
                [self.params setObject:self.member.store.storeID forKey:@"shop_id"];
            }

        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_gender)
        {
            NSArray *genders = userData;
            NSString *gender = [genders objectAtIndex:index];
            
            if ([gender isEqualToString:@"男"])
            {
                self.member.gender = @"Male";
            }
            else
            {
                self.member.gender = @"Female";
            }
            
            if ([self.member.gender isEqualToString:self.orignMember.gender])
            {
                [self.params removeObjectForKey:@"gender"];
            }
            else
            {
                [self.params setObject:self.member.gender forKey:@"gender"];
            }
        }
    }
    else if (section == kInfoSectionThree)
    {
        if (row == InfoSection_row_zhicheng) {
            NSArray *titles = userData;
            CDMemberTitle *title = [titles objectAtIndex:index];
            self.member.title = title;
            self.member.member_title_id = title.title_id;
            self.member.member_title_name = title.title_name;
            
            if ([self.member.title.title_id integerValue] == [self.orignMember.title.title_id integerValue])
            {
                [self.params removeObjectForKey:@"title"];
            }
            else
            {
                [self.params setObject:self.member.title.title_id forKey:@"title"];
            }
        }
    }
    else if (section == kInfoSectionFour)
    {
        if (row == InfoSectionRow_row_tuijian_vip) {
            NSArray *members = userData;
            CDMember *member = [members objectAtIndex:index];
            self.member.member_tuijian = member;
            self.member.member_tuijian_vip_id = member.memberID;
            self.member.member_tuijian_vip_name = member.memberName;
            
            if ([self.member.member_tuijian.memberID integerValue] == [self.orignMember.member_tuijian.memberID integerValue])
            {
                [self.params removeObjectForKey:@"recommend_type"];
            }
            else
            {
                [self.params setObject:self.member.member_tuijian.memberID forKey:@"recommend_type"];
            }
            
        }
        else if (row == InfoSectionRow_row_tuijian_member)
        {
            NSArray *staffs = userData;
            CDStaff *staff = [staffs objectAtIndex:index];
            self.member.staff_tuijian = staff;
            self.member.member_tuijian_staff_id = staff.staffID;
            self.member.member_tuijian_staff_name = staff.name;
            
            
            if ([self.member.staff_tuijian.staffID  integerValue] == [self.orignMember.staff_tuijian.staffID  integerValue])
            {
                [self.params removeObjectForKey:@"referee_name"];
            }
            else
            {
                [self.params setObject:self.member.staff_tuijian.staffID forKey:@"referee_name"];
            }
            
        }
        else if (row == InfoSectionRow_row_fenlei)
        {
            NSArray *fenleis = userData;
            NSString *fenlei = [fenleis objectAtIndex:index];
           
            self.member.member_fenlei = fenlei;
            
            if ([self.member.member_fenlei isEqualToString:self.orignMember.member_fenlei])
            {
                [self.params removeObjectForKey:@"category"];
            }
            else
            {
                NSString *feilei;
                if ([self.member.member_fenlei isEqualToString:@"个人"]) {
                    feilei = @"personal";
                }
                else if ([self.member.member_fenlei isEqualToString:@"团队"])
                {
                    feilei = @"team";
                }
                else if ([self.member.member_fenlei isEqualToString:@"公司"])
                {
                    feilei = @"company";
                }

                
                [self.params setObject:feilei forKey:@"category"];
            }
            
        }
        else if (row == InfoSectionRow_row_guwen)
        {
            NSArray *staffs = userData;
            CDStaff *staff = [staffs objectAtIndex:index];
            
            self.member.guwen = staff;
            self.member.member_guwen_id = staff.staffID;
            self.member.member_guwen_name = staff.name;
            if ([self.member.guwen.staffID integerValue] == [self.orignMember.guwen.staffID integerValue])
            {
                [self.params removeObjectForKey:@"employee_id"];
            }
            else
            {
                [self.params setObject:self.member.guwen.staffID forKey:@"employee_id"];
            }
        }
        else if (row == InfoSectionRow_row_jishi)
        {
            NSArray *staffs = userData;
            CDStaff *staff = [staffs objectAtIndex:index];
            
            self.member.jishi = staff;
            self.member.member_jishi_id = staff.staffID;
            self.member.member_jishi_name = staff.name;
            if ([self.member.jishi.staffID integerValue] == [self.orignMember.jishi.staffID integerValue])
            {
                [self.params removeObjectForKey:@"technician_id"];
            }
            else
            {
                [self.params setObject:self.member.jishi.staffID forKey:@"technician_id"];
            }

        }
    }

    self.isChanged = true;
    [self.infoTableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)willReloadViewController:(BSCommonSelectedItemViewController *)selectedView
{
    [self initCommonSelectedViewControllerData:selectedView];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        if (self.infoDataSource.isHaveImage)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSection_row_pic];
            SettingHeadCell *cell = (SettingHeadCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
            cell.headImageView.image  = [UIImage imageNamed:@"setting_profile.png"];
            self.infoDataSource.picImage = [UIImage imageNamed:@"setting_profile.png"];
            [self.params setObject:@"" forKey:@"image"];
            
            [self resetImageWriteDate];
            self.isChanged = true;
        }
        return;
    }
    
    if (buttonIndex == 3)
    {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0)
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [[BSImagePickerManager shareManager] startImagePickerWithType:sourceType delegate:self allowEdit:true];
}


#pragma mark - BSImagePickerManagerDelegate
- (void) didSelectedImage:(UIImage *)image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSection_row_pic];
    SettingHeadCell *cell = (SettingHeadCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    self.infoDataSource.picImage = image;
    cell.headImageView.image = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    
    [self.params setObject:[imageData base64Encoding] forKey:@"image"];
    self.isChanged = true;
    [self resetImageWriteDate];
}


- (void)resetImageWriteDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.member.lastUpdate = [dateFormatter stringFromDate:[NSDate date]];
    //    [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.member.imageName]];
    //    [[NSFileManager defaultManager] removeItemAtPath:[VDownloader defaultCachePathForUrl:self.member.imageName] error:nil];
}

#pragma mark - show DatePickerView
- (void)showDatePicker
{
    if (self.pickerView) {
        [self.pickerView show];
        return;
    }
    NSString *dateString = self.member.birthday;
    
    self.pickerView = [[DatePickerView alloc] initWithFrame:self.view.bounds dateString:dateString delegate:self];
    [self.view addSubview:self.pickerView];
    [self.pickerView show];
}

#pragma mark - DatePickerViewDelegate

- (void)didValueChanged:(NSString *)dateString
{
    self.member.birthday = dateString;
    if ([self.member.birthday isEqualToString:self.orignMember.birthday]) {
        [self.params removeObjectForKey:@"birth_date"];
    }
    else
    {
        [self.params setObject:self.member.birthday forKey:@"birth_date"];
    }
    
    [self.infoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:InfoSection_row_birthday inSection:kInfoSectionTwo]] withRowAnimation:UITableViewRowAnimationNone];
    self.isChanged = true;
}

#pragma mark - button action
- (IBAction)didTopBtnPressed:(UIButton *)sender {
    int type = sender.tag - 101;
    CGFloat xOffset = 0.0;
    if (type == ItemType_xiangqing) {
        NSLog(@"详情");
    }
    else if (type == ItemType_tezheng)
    {
        NSLog(@"特征");
        xOffset = self.view.width;
    }
    else if (type == ItemType_qinyou)
    {
        NSLog(@"亲友");
        xOffset = self.view.width * 2;
    }
    
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
   
    
}


#pragma mark - button action
- (IBAction)didBottomBtnPressed:(UIButton *)sender {
    int tag = sender.tag - 201;
    if (tag == ItemType_qinyou) {
        NSLog(@"亲友修改");
    }
    else if (tag == ItemType_xiangqing)
    {
        NSLog(@"详情修改");
    }
    else if (tag == ItemType_tezheng)
    {
        NSLog(@"特征修改");
        MemberAddTezhengViewController *addTZVC = [[MemberAddTezhengViewController alloc] init];
        addTZVC.member = self.member;
        [self.navigationController pushViewController:addTZVC animated:YES];
    }
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
