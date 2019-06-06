//
//  StaffDetailViewController.m
//  Boss
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CDStaffRole.h"
#import "BSFetchStaffRoleRequest.h"
#import "BNRightButtonItem.h"
#import "BSStaffCreateRequest.h"
#import "BSFetchSpecialStaffRequest.h"
#import "BSFetchStaffRequest.h"
#import "BSUpdateStaffInfoRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBMessageView.h"
#import "StaffSwitchCell.h"
#import "SettingHeadCell.h"
#import "BSEditCell.h"
#import "NSDictionary+NullObj.h"
#import "StaffDetailViewController.h"
#import "DatePickerView.h"
#import "CBLoadingView.h"
#import "BSImagePickerManager.h"
#import "UILabel+ColorFont.h"

typedef enum kSection
{
    kSection_one = 0,
    kSection_two,
    kSection_three,
    kSection_four,
    kSection_num
}kSection;

typedef enum section_one_row
{
    section_one_row_pic = 0,
    section_one_row_name,
    section_one_row_telephone,
    section_one_row_num
}section_one_row;


typedef enum section_two_row
{
    section_two_row_birthday = 0,
    section_two_row_gender,
    section_two_row_email,
    section_two_row_shop,
    section_two_row_num
}section_two_row;

typedef enum section_three_row
{
    section_three_row_islogin = 0,
    section_three_row_role = 1,
    section_three_row_num = 2,
    section_three_row_loginUser = 1,
    section_three_row_pw = 2,
    section_three_row_pos = 3,
    section_three_row_islogin_num = 4
}section_three_row;

typedef enum section_four_row
{
    section_four_row_department = 0,
    section_four_row_job = 1,
    section_four_row_isbook = 2,
    section_four_row_num
}section_four_row;


@interface StaffDetailViewController ()<StaffSwitchCellDelegate,BSCommonSelectedItemViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,BNRightButtonItemDelegate,DatePickerViewDelegate,BSImagePickerManagerDelegate>
{
    bool isFirstLoadView;
    UIImage *headImage;
    BNRightButtonItem *rightBtnItem;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DatePickerView *pickerView;
@property (nonatomic, assign) bool isChanged;
@property (nonatomic, strong) CDStaff *orignStaff; //保存最开始传进来的staff的基本信息数据。
@end

@implementation StaffDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.params = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    

    rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    if (self.staff) {
        self.type = StaffDetailType_edit;
        [self orignStaff:self.staff];
        self.navigationItem.title = @"员工详情";
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.staff = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
        self.type = StaffDetailType_create;
        
        self.navigationItem.title = @"新建员工";
        
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    
    isFirstLoadView = true;
    
    [self registerNofitificationForMainThread:kBSUpdateDepartAndJob];
    [self registerNofitificationForMainThread:kBSStaffCreateResponse];
    [self registerNofitificationForMainThread:kBSFetchSpecialStaffRequest];
    [self registerNofitificationForMainThread:kBSUpdateStaffInfoResponse];
    [self registerNofitificationForMainThread:kBSFetchStaffPermission];
    
    
    [self fetchStaffDetailRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initTableView];
//        [self initDatePicker];
    }
    isFirstLoadView = false;
    NSLog(@"%s",__FUNCTION__);
    
}



#pragma mark - init data & view

- (void) orignStaff:(CDStaff *)staff
{
    if (!self.orignStaff) {
        self.orignStaff = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
    }
    self.orignStaff.name = staff.name;
    self.orignStaff.mobile_phone = staff.mobile_phone;
    self.orignStaff.birthday = staff.birthday;
    self.orignStaff.gender = staff.gender;
    self.orignStaff.email = staff.email;
    self.orignStaff.store = staff.store;
    self.orignStaff.is_login = staff.is_login;
    self.orignStaff.user = staff.user;
    self.orignStaff.role = staff.role;
    self.orignStaff.password = staff.password;
    self.orignStaff.pos = staff.pos;
    self.orignStaff.department = staff.department;
    self.orignStaff.job = staff.job;
    self.orignStaff.is_book = staff.is_book;
//    return self.orignStaff;
    [[BSCoreDataManager currentManager] save:nil];
}

- (void) rollBack
{
    [[BSCoreDataManager currentManager] rollback];
    [[BSCoreDataManager currentManager] deleteObject:self.orignStaff];
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)setIsChanged:(bool)isChanged
{
    _isChanged = isChanged;
    if (self.type == StaffDetailType_edit && isChanged) {
        if (self.params.allKeys.count > 0) {
            self.navigationItem.rightBarButtonItem = rightBtnItem;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}

- (void) initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (void)showDatePicker
{
    if (self.pickerView) {
        
        [self.pickerView show];
        return;
    }
    NSString *dateString = self.staff.birthday;
    
    self.pickerView = [[DatePickerView alloc] initWithFrame:self.view.bounds dateString:dateString delegate:self];
    [self.view addSubview:self.pickerView];
    [self.pickerView show];
}

#pragma mark - left & right buttton action
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if ( [self.params allKeys].count > 0 )
    {
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"是否保存更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
        [view show];
    }
    else
    {
        [self rollBack];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didRightBarButtonItemClick:(id)sender
{
    [self handleStaffRequest];
}


#pragma mark - DatePickerViewDelegate

- (void)didValueChanged:(NSString *)dateString
{
    self.staff.birthday = dateString;
    if ([self.staff.birthday isEqualToString:self.orignStaff.birthday]) {
        [self.params removeObjectForKey:@"birthday"];
    }
    else
    {
        [self.params setObject:self.staff.birthday forKey:@"birthday"];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_two_row_birthday inSection:kSection_two]] withRowAnimation:UITableViewRowAnimationNone];
    self.isChanged = true;
}

#pragma mark - request & notification

- (void)fetchStaffDetailRequest
{
    BSFetchSpecialStaffRequest *request = [[BSFetchSpecialStaffRequest alloc] initWithStaff:self.staff];
    [request execute];
}
- (void)handleStaffRequest
{
    if ([self paramsIsOK]) {
        [[CBLoadingView shareLoadingView] show];
        if (self.type == StaffDetailType_create) {
            BSStaffCreateRequest *request = [[BSStaffCreateRequest alloc]initWithStaff:self.staff params:self.params];
            [request execute];
        }
        else if (self.type == StaffDetailType_edit)
        {
            BSUpdateStaffInfoRequest *request = [[BSUpdateStaffInfoRequest alloc]initWithStaffID:self.staff.staffID attributeDic:self.params];
            [request execute];
        }
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSUpdateStaffInfoResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"修改成功" afterTimeHide:1.5];
            [message showInView:self.view];
            [self performSelector:@selector(popController) withObject:nil afterDelay:1.5];

        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
    }else if ([notification.name isEqualToString:kBSFetchSpecialStaffRequest])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self orignStaff:self.staff];
            [self.tableView reloadData];
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
    }
    else if([notification.name isEqualToString:kBSStaffCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
//            BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc]init];
//            [request execute];
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"添加成功" afterTimeHide:1.5];
            [message showInView:self.view];
            [self performSelector:@selector(popController) withObject:nil afterDelay:1.5];
        }else{
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
    }
}

#pragma mark - 验证参数是否完整
- (BOOL)paramsIsOK
{
    NSString *name = self.staff.name;
    NSString *mobile = self.staff.mobile_phone;
    NSString *email = self.staff.email;
    
    if( name.length == 0 )
    {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"名字不能为空" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }
//    else if (email==nil)
//    {
//        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"邮件不能为空" afterTimeHide:1.25];
//        [message showInView:self.view];
//        return NO;
//    }
    else if (![self isValidateEmail:email] && email.length > 1 )
    {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"邮件格式错误" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }
    else if ( mobile.length == 0 )
    {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"电话号码不能为空" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }
    else if (![self isMobileNumber:mobile] && mobile.length > 0 )
    {
        CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"电话号码格式错误" afterTimeHide:1.25];
        [message showInView:self.view];
        return NO;
    }else{
        
        if([self.staff.is_login boolValue])
        {
            CDStaffRole *role = self.staff.role;
            NSString *password = self.staff.password;
            
            
            
            if(role == nil)
            {
                CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"角色不能为空" afterTimeHide:1.25];
                [message showInView:self.view];
                return NO;
            }
            else if (password == nil)
            {
                CBMessageView *message= [[CBMessageView alloc]initWithTitle:@"密码不能为空" afterTimeHide:1.25];
                [message showInView:self.view];
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else
        {
            return YES;
        }
    }
    
}

#pragma mark -  验证 email 和 手机 格式
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length == 11) {
        return true;
    }
    else
    {
        return false;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - popController

- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_one) {
        return section_one_row_num;
    }
    else if (section == kSection_two)
    {
        return section_two_row_num;
    }
    else if (section == kSection_three)
    {
        if ([self.staff.is_login boolValue]) {
            return section_three_row_islogin_num;
        }
        else
        {
            return section_three_row_num;
        }
    }
    else if (section == kSection_four)
    {
        return section_four_row_num;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    
    if(section == kSection_one && row == section_one_row_pic)
    {
        static NSString *pic_cell = @"pic_cell";
        SettingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:pic_cell];
        if(cell==nil)
        {
            cell = [[SettingHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pic_cell];
        }
        
        cell.titleLabel.text = @"头像";
        if (headImage) {
            cell.headImageView.image = headImage;
        }
        else
        {
            __weak typeof(self) wself = self;
            [cell.headImageView setImageWithName:self.staff.imgName tableName:@"hr.employee" filter:self.staff.staffID fieldName:@"image_medium" writeDate:self.staff.last_time placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:^(UIImage *image) {
                if ([image isEqual:[UIImage imageNamed:@"setting_profile.png"]]) {
                    wself.isHaveImage = false;
                }
                else
                {
                    wself.isHaveImage = true;
                }
            }];
            
            if ([cell.headImageView.image isEqual:[UIImage imageNamed:@"setting_profile.png"]]) {
                self.isHaveImage = false;
            }
            else
            {
                self.isHaveImage = true;
            }
        }
        return cell;
    }
    else if (section == kSection_three && row == section_three_row_islogin)
    {
        StaffSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        if(cell == nil)
        {
            cell = [[StaffSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchCell"];
            cell.delegate = self;
        }
        
        cell.titleLabel.text = @"开通账户";
        cell.cellSwitch.on = [self.staff.is_login boolValue];
        return cell;
    }
    else
    {
        static NSString *other_cell = @"other_cell";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:other_cell];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:other_cell];
            cell.contentField.delegate = self;
        }
        cell.contentField.enabled = true;
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        cell.contentField.keyboardType = UIKeyboardTypeDefault;
        cell.contentField.secureTextEntry = false;
        
        if (section == kSection_one) {
            if (row == section_one_row_name) {
                [cell.titleLabel setAttributeString:@"员工姓名 (必填)" colorString:@"(必填)" color:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                cell.contentField.placeholder = @"请输入";
                cell.contentField.text = self.staff.name;
                
            }
            else if (row == section_one_row_telephone)
            {
                [cell.titleLabel setAttributeString:@"电话号码 (必填)" colorString:@"(必填)" color:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                cell.contentField.placeholder = @"请输入";
                cell.contentField.text = self.staff.mobile_phone;
                cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        else if( section == kSection_two )
        {
            if (row == section_two_row_birthday) {
                cell.titleLabel.text = @"生日";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.enabled =false;
                if (self.staff.birthday && ![self.staff.birthday isEqualToString:@"0"]) {
                    cell.contentField.text = self.staff.birthday;
                }
            }
            else if (row == section_two_row_gender)
            {
                cell.titleLabel.text = @"性别";
                cell.contentField.placeholder = @"请选择";
                if ([self.staff.gender isEqualToString:@"male"]) {
                    cell.contentField.text = @"男";
                }
                else if ([self.staff.gender isEqualToString:@"female"])
                {
                    cell.contentField.text = @"女";
                }
                
                cell.contentField.enabled =false;
            }
            else if (row == section_two_row_email)
            {
                cell.titleLabel.text = @"邮箱";
                cell.contentField.placeholder = @"请输入";
                if (self.staff.email && ![self.staff.email isEqualToString:@"0"]) {
                    cell.contentField.text = self.staff.email;
                }
            }
            else if (row == section_two_row_shop)
            {
                cell.titleLabel.text = @"所属门店";
                cell.contentField.text = @"请选择";
                cell.contentField.text = self.staff.store.storeName;
                cell.contentField.enabled =false;
            }
        }
        else if (section == kSection_three)
        {
            if ([self.staff.is_login boolValue]) {
                if (row == section_three_row_role) {
                    cell.titleLabel.text = @"角色";
                    cell.contentField.placeholder = @"请选择";
                    cell.contentField.text = self.staff.role.roleName;
                    cell.contentField.enabled = false;
                }
                else if (row == section_three_row_pw)
                {
                    cell.titleLabel.text = @"密码";
                    cell.contentField.placeholder = @"请输入";
                    cell.contentField.secureTextEntry = true;
                    if (self.staff.password && ![self.staff.password isEqualToString:@"0"]) {
                       cell.contentField.text = self.staff.password;
                    }
                }
                else if (row == section_three_row_pos)
                {
                    cell.titleLabel.text = @"收银配置";
                    cell.contentField.placeholder = @"请选择";
                    cell.contentField.text = self.staff.pos.posName;
                    cell.contentField.enabled = false;
                }
            }
            else
            {
                if (row == section_three_row_loginUser) {
                    cell.titleLabel.text = @"登录账户";
                    cell.contentField.placeholder = @"请选择";
                    cell.contentField.text = self.staff.user.name;
                    cell.contentField.enabled = false;
                }
            }
        }
        else if (section == kSection_four)
        {
            if (row == section_four_row_department) {
                cell.titleLabel.text = @"部门";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.staff.department.department_name;
                cell.contentField.enabled = false;
            }
            else if (row == section_four_row_job)
            {
                cell.titleLabel.text = @"职位";
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.staff.job.job_name;
                cell.contentField.enabled = false;
            }
            else if (row == section_four_row_isbook)
            {
                cell.titleLabel.text = @"是否接受预约";
                cell.contentField.placeholder = @"请选择";
                if (self.staff.is_login) {
                    if ([self.staff.is_login boolValue]) {
                        cell.contentField.text = @"是";
                    }
                    else
                    {
                        cell.contentField.text = @"否";
                    }
                }
                cell.contentField.enabled = false;
            }
        }
        return cell;
    }
    
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == kSection_one && indexPath.section == section_one_row_pic)
    {
        return 80;
    }
    else
    {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == kSection_four)
    {
        return 20;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedIndexPath = indexPath;
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    if(section == kSection_one && row == section_one_row_pic)
    {
        UIActionSheet *actionSheet;
        if(!self.isHaveImage)
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
    else
    {
        BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        selectedVC.delegate = self;
        
        if( section == kSection_two )
        {
            if (row == section_two_row_birthday) {
                [self showDatePicker];
            }
            else if (row == section_two_row_gender)
            {
                BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                selectedVC.delegate = self;
                selectedVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@"男",@"女"]];
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                selectedVC.userData = selectedVC.dataArray;
                NSString *str = cell.contentField.text;
                selectedVC.currentSelectIndex = [selectedVC.dataArray indexOfObject:str];
                [self.navigationController pushViewController:selectedVC animated:YES];
            }
            else if (row == section_two_row_shop)
            {
                BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                
                selectedVC.delegate = self;
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
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                NSString *str = cell.contentField.text;
                selectedVC.currentSelectIndex = [selectedVC.dataArray indexOfObject:str];
                [self.navigationController pushViewController:selectedVC animated:YES];
            }
        }
        else if (section == kSection_three)
        {
            
            if ([self.staff.is_login integerValue]) {
                if (row == section_three_row_role) {
                    BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                    selectedVC.delegate = self;
                    int currentSelectedIndex = -1;
    
                    NSMutableArray *titles = [[NSMutableArray alloc]init];
                    NSArray *roles = [[BSCoreDataManager currentManager] fetchAllStaffRoles];
                    
                    for(CDStaffRole *role in roles)
                    {
                        if (role.roleID == self.staff.role.roleID) {
                            currentSelectedIndex = [roles indexOfObject:role];
                        }
                        [titles addObject:role.roleName];
                    }
                    
                    selectedVC.userData = roles;
                    selectedVC.dataArray = titles;
                    selectedVC.currentSelectIndex = currentSelectedIndex;
                    [self.navigationController pushViewController:selectedVC animated:YES];
                }
                else if (row == section_three_row_pos)
                {
                    BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                    selectedVC.delegate = self;
                    int currentSelectedIndex = -1;
                    
                    NSMutableArray *titles = [[NSMutableArray alloc]init];
                    NSArray *posConfigs = [[BSCoreDataManager currentManager] fetchAllPosConfig];
                    for(CDPosConfig *posConfig in posConfigs)
                    {
                        if (posConfig.posID.integerValue == self.staff.pos.posID.integerValue)
                        {
                            currentSelectedIndex = [posConfigs indexOfObject:posConfig];
                        }
                        [titles addObject:posConfig.posName];
                    }
                 
                    selectedVC.userData = posConfigs;
                    selectedVC.dataArray = titles;
                    selectedVC.currentSelectIndex = currentSelectedIndex;
                    [self.navigationController pushViewController:selectedVC animated:YES];
                }
                
            }
            else
            {
                if (row == section_three_row_loginUser) {
                    BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                    selectedVC.delegate = self;
                    int currentSelectedIndex = -1;
                    
                    NSMutableArray *titles = [[NSMutableArray alloc]init];
                    NSArray *users = [[BSCoreDataManager currentManager] fetchAllUser];
                    
                    for(CDUser *user in users)
                    {
                        if (user.user_id == self.staff.user.user_id) {
                            currentSelectedIndex = [users indexOfObject:user];
                        }
                        [titles addObject:user.name];
                    }
                    selectedVC.userData = users;
                    selectedVC.dataArray = titles;
                    selectedVC.currentSelectIndex = currentSelectedIndex;
                    [self.navigationController pushViewController:selectedVC animated:YES];
                }
            }
            
        }
        else if (section == kSection_four)
        {
            BSCommonSelectedItemViewController *selectedVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
            selectedVC.delegate = self;
            
            if (row == section_four_row_department) {
                int currentSelectedIndex = -1;
                
                NSMutableArray *titles = [[NSMutableArray alloc]init];
                NSArray *departments = [[BSCoreDataManager currentManager] fetchAllStaffDepartments];
                
                for(CDStaffDepartment *department in departments)
                {
                    if (department.department_id == self.staff.department.department_id) {
                        currentSelectedIndex = [departments indexOfObject:department];
                    }
                    [titles addObject:department.department_name];
                }
                selectedVC.hasAddButton = true;
                selectedVC.userData = departments;
                selectedVC.dataArray = titles;
                selectedVC.currentSelectIndex = currentSelectedIndex;
            }
            else if (row == section_four_row_job)
            {
                int currentSelectedIndex = -1;
                
                NSMutableArray *titles = [[NSMutableArray alloc]init];
                NSArray *jobs = [[BSCoreDataManager currentManager] fetchAllStaffJobs];
                
                for(CDStaffJob *job in jobs)
                {
                    if (job.job_id == self.staff.job.job_id) {
                        currentSelectedIndex = [jobs indexOfObject:job];
                    }
                    [titles addObject:job.job_name];
                }
                selectedVC.hasAddButton = true;
                selectedVC.userData = jobs;
                selectedVC.dataArray = titles;
                selectedVC.currentSelectIndex = currentSelectedIndex;
            }
            else if (row == section_four_row_isbook)
            {
                selectedVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@"是",@"否"]];
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                selectedVC.userData = selectedVC.dataArray;
                NSString *str = cell.contentField.text;
                selectedVC.currentSelectIndex = [selectedVC.dataArray indexOfObject:str];
            }
            [self.navigationController pushViewController:selectedVC animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    if (section == kSection_one)
    {
        if (row == section_one_row_name)
        {
            if (![self.staff.name isEqualToString:textField.text])
            {
                self.staff.name = textField.text;
                if ([self.staff.name isEqualToString:self.orignStaff.name])
                {
                    [self.params removeObjectForKey:@"name"];
                }
                else
                {
                    [self.params setObject:self.staff.name forKey:@"name"];
                }
                self.isChanged = true;
            }
        }
        else if (row == section_one_row_telephone)
        {
            if (![self.staff.mobile_phone isEqualToString:textField.text])
            {
                
                self.staff.mobile_phone = textField.text;
                if ([self.staff.mobile_phone isEqualToString:self.orignStaff.mobile_phone]) {
                    [self.params removeObjectForKey:@"mobile_phone"];
                }
                else
                {
                    [self.params setObject:self.staff.mobile_phone forKey:@"mobile_phone"];
                }
                self.isChanged = true;
            }
        }
    }
    else if( section == kSection_two )
    {
        if (row == section_two_row_email)
        {
            if (![self.staff.email isEqualToString:textField.text])
            {
                self.staff.email = textField.text;
                if ([self.staff.email isEqualToString:self.orignStaff.email])
                {
                    [self.params removeObjectForKey:@"work_email"];
                }
                else
                {
                    [self.params setObject:self.staff.email forKey:@"work_email"];
                }
                
                self.isChanged = true;
            }
        }
    }
    else if (section == kSection_three)
    {
        if (row == section_three_row_pw) {
            if (![self.staff.password isEqualToString:textField.text])
            {
                self.staff.password = textField.text;
                if ([self.staff.password isEqualToString:self.orignStaff.password])
                {
                    [self.params removeObjectForKey:@"password"];
                }
                else
                {
                    [self.params setObject:self.staff.password forKey:@"password"];
                }
                
                self.isChanged = true;
            }
        }
    }
}


#pragma mark - StaffSwitchCellDelegate

-(void)switchValueChanged:(BOOL)on
{
    self.staff.is_login = [NSNumber numberWithBool:on];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSection_three] withRowAnimation:UITableViewRowAnimationNone];
    if ([self.staff.is_login integerValue] == [self.orignStaff.is_login integerValue]) {
        [self.params removeObjectForKey:@"is_login"];
    }
    else
    {
        [self.params setObject:self.staff.is_login forKey:@"is_login"];
    }
    self.isChanged = true;
}
#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    int section = self.selectedIndexPath.section;
    int row  = self.selectedIndexPath.row;
    
    if( section == kSection_two )
    {
       if (row == section_two_row_gender)
        {
            NSArray *genders = userData;
            NSString *gender = [genders objectAtIndex:index];
            cell.contentField.text = gender;
            if ([gender isEqualToString:@"男"])
            {
                self.staff.gender = @"male";
            }
            else
            {
                self.staff.gender = @"female";
            }
            
            if ([self.staff.gender isEqualToString:self.orignStaff.gender])
            {
                [self.params removeObjectForKey:@"gender"];
            }
            else
            {
                [self.params setObject:self.staff.gender forKey:@"gender"];
            }
            
        }
        else if (row == section_two_row_shop)
        {
            NSArray *shops = userData;
            self.staff.store = [shops objectAtIndex:index];
            cell.contentField.text = self.staff.store.storeName;
            if ([self.staff.store.storeID integerValue] == [self.orignStaff.store.storeID integerValue])
            {
                [self.params removeObjectForKey:@"shop_id"];
            }
            else
            {
                [self.params setObject:self.staff.store.storeID forKey:@"shop_id"];
            }

        }
    }
    else if (section == kSection_three)
    {
        
        if ([self.staff.is_login integerValue]) {
            if (row == section_three_row_role) {
                NSArray *roles = userData;
                self.staff.role = [roles objectAtIndex:index];
                cell.contentField.text = self.staff.role.roleName;
                if ([self.staff.role.roleID integerValue] == [self.orignStaff.role.roleID integerValue])
                {
                    [self.params removeObjectForKey:@"template_id"];
                }
                else
                {
                    [self.params setObject:self.staff.role.roleID forKey:@"template_id"];
                }

            }
            else if (row == section_three_row_pos)
            {
                NSArray *poses = userData;
                self.staff.pos = [poses objectAtIndex:index];
                cell.contentField.text = self.staff.pos.posName;
                if ([self.staff.pos.posID integerValue] == [self.orignStaff.pos.posID integerValue])
                {
                    [self.params removeObjectForKey:@"pos_config_id"];
                }
                else
                {
                    [self.params setObject:self.staff.pos.posID forKey:@"pos_config_id"];
                }
            }
        }
        else
        {
            if (row == section_three_row_loginUser) {
                NSArray *users = userData;
                self.staff.user = [users objectAtIndex:index];
                cell.contentField.text = self.staff.user.name;
                if ([self.staff.user.user_id integerValue] == [self.orignStaff.user.user_id integerValue])
                {
                    [self.params removeObjectForKey:@"user_id"];
                }
                else
                {
                    [self.params setObject:self.staff.user.user_id forKey:@"user_id"];
                }
            }
        }
        
    }
    else if (section == kSection_four)
    {
        if (row == section_four_row_department) {
            
            NSArray *departments = userData;
            self.staff.department = [departments objectAtIndex:index];
            cell.contentField.text = self.staff.department.department_name;
            if ([self.staff.department.department_id integerValue] == [self.orignStaff.department.department_id integerValue])
            {
                [self.params removeObjectForKey:@"department_id"];
            }
            else
            {
                [self.params setObject:self.staff.department.department_id forKey:@"department_id"];
            }
        }
        else if (row == section_four_row_job)
        {
            NSArray *jobs = userData;
            self.staff.job = [jobs objectAtIndex:index];
            cell.contentField.text = self.staff.job.job_name;
            if ([self.staff.job.job_id integerValue] == [self.orignStaff.job.job_id integerValue])
            {
                [self.params removeObjectForKey:@"job_id"];
            }
            else
            {
                [self.params setObject:self.staff.job.job_id forKey:@"job_id"];
            }
        }
        else if (row == section_four_row_isbook)
        {
            NSArray *titles = userData;
            NSString *title = [titles objectAtIndex:index];
            cell.contentField.text = title;
            if ([title isEqualToString:@"是"])
            {
                self.staff.is_book = @1;
            }
            else
            {
                self.staff.is_book = @0;
            }
            
            if ([self.staff.is_book intValue] == [self.orignStaff.is_book intValue])
            {
                [self.params removeObjectForKey:@"isbook"];
            }
            else
            {
                [self.params setObject:self.staff.is_book forKey:@"isbook"];
            }
        }
    }
    self.isChanged = true;
}

- (void)didAddButtonPressed:(id)userData
{
    int section = self.selectedIndexPath.section;
    int row  = self.selectedIndexPath.row;
    
    if( section == kSection_two )
    {
        if (row == section_two_row_shop)
        {
            StaffAddShopViewController *addShop = [[StaffAddShopViewController alloc]initWithNibName:NIBCT(@"StaffAddShopViewController") bundle:nil];
            [self.navigationController pushViewController:addShop animated:YES];
        }
    }
    else if (section == kSection_three)
    {
        
        if ([self.staff.is_login integerValue]) {
            if (row == section_three_row_role) {
                
                
            }
            else if (row == section_three_row_pos)
            {
               
            }
            
        }
        else
        {
            if (row == section_three_row_loginUser) {
                
            }
        }
        
    }
    else if (section == kSection_four)
    {
        if (row == section_four_row_department) {
            
            StaffCreateDepartmentViewController *createDepartment = [[StaffCreateDepartmentViewController alloc]initWithNibName:NIBCT(@"StaffCreateDepartmentViewController") bundle:nil];
            [self.navigationController pushViewController:createDepartment animated:YES];
        }
        else if (row == section_four_row_job)
        {
            StaffCreateJobViewController *createJob = [[StaffCreateJobViewController alloc]initWithNibName:NIBCT(@"StaffCreateJobViewController") bundle:nil];
            [self.navigationController pushViewController:createJob animated:YES];
        }

    }

//        [self pushViewControllerWithIndexPath:self.selectedIndexPath withISLogin:self.didSwitchOn];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self rollBack];
    }
    else
    {
        [self handleStaffRequest];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        if (self.isHaveImage)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kSection_one inSection:section_one_row_pic];
            SettingHeadCell *cell = (SettingHeadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.headImageView.image  = [UIImage imageNamed:@"setting_profile.png"];
            headImage = [UIImage imageNamed:@"setting_profile.png"];
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
    SettingHeadCell *cell = (SettingHeadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kSection_one inSection:section_one_row_pic]];
    headImage = image;
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
    self.staff.last_time = [dateFormatter stringFromDate:[NSDate date]];
    //    [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.member.imageName]];
    //    [[NSFileManager defaultManager] removeItemAtPath:[VDownloader defaultCachePathForUrl:self.member.imageName] error:nil];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end
