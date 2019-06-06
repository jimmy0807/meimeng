//
//  MemberDetailViewController.m
//  Boss
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#define kCellHeight         60
#define kSearchBarHeight    44
#define kFilterHeight       70
#define kMarginSize         20

#import "BSFetchProductPriceListRequest.h"

#import "BSFetchPosConfigRequest.h"
#import "MemberCreateCardViewController.h"
#import "MemberCardDetailViewController.h"
#import "MemberViewController.h"
#import "BSUpdateMemberRequest.h"
#import "BSCreateMemberRequest.h"
#import "CBMessageView.h"
#import "BSCommonSelectedItemViewController.h"
#import "BSEditCell.h"
#import "SettingHeadCell.h"
#import "BSFetchMemberDetailRequest.h"
#import "UIImage+Resizable.h"
#import "BossPermissionManager.h"
#import "MemberDetailViewController.h"
#import "ImportMemberCardViewController.h"
#import "DatePickerView.h"
#import "BSImagePickerManager.h"
#import "CBLoadingView.h"


#define kBottomViewHeight 70

typedef enum kSection
{
    kSection_one = 0,
    kSection_two,
    kSection_three,
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


@interface MemberDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BSCommonSelectedItemViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BNRightButtonItemDelegate,CBBackButtonItemDelegate,UIAlertViewDelegate,DatePickerViewDelegate,BSImagePickerManagerDelegate>
{
    bool isFirstLoadView;
    UIButton *openBtn, *importBtn, *activeBtn;
    UIImage *headImage;
    BNRightButtonItem *rightBtnItem;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton* addCardButton;
@property (nonatomic, strong) UIButton* importCardButton;
@property (nonatomic, strong) UIButton* activeCardButton;
@property (nonatomic, strong) DatePickerView *pickerView;
@property (nonatomic, strong) NSArray *memberCards;
@property (nonatomic, assign) bool isChanged;
@property (nonatomic, strong) CDMember *orignMember; //保存最开始传进来的member的基本信息数据。

@end

@implementation MemberDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hideKeyBoardWhenClickEmpty  = true;
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    if (self.member) {
        self.type = MemberDetailType_edit;
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

        self.type = MemberDetailType_create;
        
        self.navigationItem.title = @"新建会员";

        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    
    isFirstLoadView = true;
    
    self.memberCards = self.member.card.array;
    [self initParams];
    
    [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    [self registerNofitificationForMainThread:kBSCreateMemberResponse];
    [self registerNofitificationForMainThread:kBSImportMemberCardResponse];
    [self registerNofitificationForMainThread:kBSPopMemberDetailVCUpdate];
    
    [self sendBaseRequest];
    
    [self fetchMemberDetailRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initTableView];
        [self initBottomView];
//        [self initDatePicker];
    }
    isFirstLoadView = false;
    NSLog(@"%s",__FUNCTION__);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - init data & view
- (void) initParams
{
    self.params = [NSMutableDictionary dictionary];
    if (self.type == MemberDetailType_create) {
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
    if (self.type == MemberDetailType_edit && isChanged) {
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomViewHeight) style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomViewHeight, IC_SCREEN_WIDTH, kBottomViewHeight)];
//    bottomView.autoresizingMask = 0xff;
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

//    [self.view addSubview:bottomView];
   
    UIImage *img = [UIImage imageNamed:@"member_add"];
    openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(IC_SCREEN_WIDTH/2.0 - img.size.width - 1, (kBottomViewHeight - img.size.height)/2.0, img.size.width, img.size.height);
    [openBtn setBackgroundImage:img forState:UIControlStateNormal];
    [openBtn setTitle:@"开卡" forState:UIControlStateNormal];
    openBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    openBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [openBtn addTarget:self action:@selector(openCard:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:openBtn];
    
    
    
    img = [[UIImage imageNamed:@"member_improt"] imageResizableWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    importBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    importBtn.frame = CGRectMake(IC_SCREEN_WIDTH/2.0 + 1, (kBottomViewHeight - img.size.height)/2.0, img.size.width, img.size.height);
    importBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin ;
    [bottomView addSubview:importBtn];
   
    [importBtn setBackgroundImage:img forState:UIControlStateNormal];
    importBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    importBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [importBtn addTarget:self action:@selector(importCard) forControlEvents:UIControlEventTouchUpInside];
    [importBtn setTitle:@"导入会员卡" forState:UIControlStateNormal];
    self.importCardButton = importBtn;
    

    img = [UIImage imageNamed:@"member_active"];
    activeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activeBtn.frame = CGRectMake((self.view.frame.size.width - img.size.width)/2.0, (kBottomViewHeight - img.size.height)/2.0, img.size.width, img.size.height);
    [bottomView addSubview:activeBtn];
  
  
    activeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [activeBtn setBackgroundImage:img forState:UIControlStateNormal];
    [activeBtn addTarget:self action:@selector(didActiveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadBottomView];
}

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

#pragma mark - reload view
- (void)reloadView
{
    [self.tableView reloadData];
    [self reloadBottomView];
}

- (void)reloadBottomView
{
    if ( [self.member.isAcitve boolValue] || self.type == MemberDetailType_create)
    {
        openBtn.hidden = NO;
        importBtn.hidden = NO;
        activeBtn.hidden = YES;
    }
    else
    {
        openBtn.hidden = YES;
        importBtn.hidden = YES;
        activeBtn.hidden = NO;
    }
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
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_two_row_birthday inSection:kSection_two]] withRowAnimation:UITableViewRowAnimationNone];
    self.isChanged = true;
}

#pragma mark - request & notification

- (void) sendBaseRequest
{
    [self fetchPayModeRequest];
    [self fetchCardTypeRequest];
    [self fetchPayModeRequest];
}

- (void)fetchMemberDetailRequest
{
    [[CBLoadingView shareLoadingView] show];
    BSFetchMemberDetailRequest *request = [[BSFetchMemberDetailRequest alloc] initWithMember:self.member];
    [request execute];
}

- (void)fetchCardTypeRequest
{
    BSFetchProductPriceListRequest *request = [[BSFetchProductPriceListRequest alloc]init];
    [request execute];
}

- (void)fetchPayModeRequest
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    if(profile.posID != nil && ![profile.posID isEqual:@0])
    {
        BSFetchPosConfigRequest *request = [[BSFetchPosConfigRequest alloc] initWithPosID:profile.posID];
        [request execute];
    }
}

- (void)handleMemberRequest
{
    if ([self paramsIsOK]) {
        [[CBLoadingView shareLoadingView] show];
        if (self.type == MemberDetailType_create) {
            BSCreateMemberRequest *createRequest = [[BSCreateMemberRequest alloc]initWithMember:self.member params:self.params];
            [createRequest execute];
        }
        else if (self.type == MemberDetailType_edit)
        {
            BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.member params:self.params];
            [updateRequest execute];
        }
    }
   
}


- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqual:kBSFetchMemberCardResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self orignMemer:self.member];
             self.memberCards = self.member.card.array;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSection_three] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberDetailResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self.tableView reloadData];
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
        
    }
    else if([notification.name isEqual:kBSUpdateMemberResponse])
    {
//        [self initParams];
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
    else if([notification.name isEqual:kBSCreateMemberResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if(self.shouldCreateCard == YES)
            {
//                [self createCardWithMemberID:[notification.userInfo objectForKey:@"data"]];
                [self pushToCreateCardVC];
            }
            else
            {
                CBMessageView *messgae = [[CBMessageView alloc]initWithTitle:@"添加成功" afterTimeHide:0.75];
                [messgae showInView:self.view];
                [self performSelector:@selector(popController) withObject:nil afterDelay:0.75];
            }
            self.shouldCreateCard = false;
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.5];
            [message showInView:self.view];
        }
    }
    else if ([notification.name isEqualToString:kBSPopMemberDetailVCUpdate])
    {
        [self fetchMemberDetailRequest];
    }
}


#pragma mark - navigaton & button action

- (void)didItemBackButtonPressed:(UIButton *)sender
{
    if( self.type == MemberDetailType_create )
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

- (void)didRightBarButtonItemClick:(id)sender
{
    [self handleMemberRequest];
}

//开卡
- (void)openCard:(UIButton *)button
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.posID.integerValue > 0 )
    {
        if ( [profile.havePos boolValue] )
        {
            
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"您的账号不能开卡,请确认您选择的POS里是否有支付方式"];
            [view showInView:self.view];
            return;
        }
    }
    else
    {
        CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"你的账号没有绑定POS"];
        [view showInView:self.view];
        return;
    }
    
    if(self.type == MemberDetailType_create)
    {
        [self handleMemberRequest];
        self.shouldCreateCard = YES;
        
    }
    else if(self.type == MemberDetailType_edit)
    {
        [self pushToCreateCardVC];
    }
}

//激活
- (void)didActiveButtonPressed:(id)sender
{
    [self.params setObject:@"done" forKey:@"state"];
    self.member.isAcitve = @true;
    [self handleMemberRequest];
}

//导入卡
- (void)importCard
{
    if([[[PersonalProfile currentProfile].reachItems objectForKey:BossReachItems_Vip] integerValue] != BossAccountManager)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"OnlyManagerCanImportMemberCard")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        ImportMemberCardViewController *viewController = [[ImportMemberCardViewController alloc] initWithMember:self.member];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - push to VC
- (void) pushToCreateCardVC
{
    MemberCreateCardViewController *createCard = [[MemberCreateCardViewController alloc]initWithNibName:NIBCT(@"MemberCreateCardViewController") bundle:nil];
    PersonalProfile *profile = [PersonalProfile currentProfile];
    char c = 'A'+arc4random_uniform(26);
    int n = (arc4random()%901)+100;
    NSRange range = NSMakeRange(7, 4);
    NSString *phoneNumber = self.member.mobile;
    if([self.member.mobile isEqualToString:@"0"]||[self.member.mobile isEqualToString:@""]||self.member.mobile==nil)
    {
        phoneNumber = [NSString stringWithFormat:@"%d",(arc4random()%9001)+1000];
    }
    NSString *subString = [phoneNumber substringWithRange:range];
    NSString *memberNo = [NSString stringWithFormat:@"%@%c%d%@",profile.businessId,c,n,subString];
    createCard.randomString = memberNo;
    createCard.memberID = self.member.memberID;
    [self.navigationController pushViewController:createCard animated:YES];
}


#pragma mark - 验证参数是否完整
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
    else if(![self isMobileNumber:mobile])
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

#pragma mark -  验证 email 和 手机 格式

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length == 11)
    {
        return  true;
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



#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
        return self.member.card.count;
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
            [cell.headImageView setImageWithName:self.member.imageName tableName:@"born.member" filter:self.member.memberID fieldName:@"image" writeDate:self.member.lastUpdate placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:^(UIImage *image) {
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
        
        if (section == kSection_one) {
            cell.contentField.text = @"";
            if (row == section_one_row_name) {
                cell.titleLabel.text = @"会员姓名";
                cell.contentField.placeholder = @"请输入";
                cell.contentField.text = self.member.memberName;
                
            }
            else if (row == section_one_row_telephone)
            {
                cell.titleLabel.text = @"电话号码";
                cell.contentField.placeholder = @"请输入";
                cell.contentField.text = self.member.mobile;
            }
        }
        else if( section == kSection_two )
        {
            cell.contentField.text = @"";
            if (row == section_two_row_birthday) {
                cell.titleLabel.text = @"生日";
                cell.contentField.placeholder = @"请选择";
                if (self.member.birthday && ![self.member.birthday isEqualToString:@"0"]) {
                     cell.contentField.text = self.member.birthday;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                cell.contentField.enabled =false;
            }
            else if (row == section_two_row_gender)
            {
                cell.titleLabel.text = @"性别";
                cell.contentField.placeholder = @"请选择";
                if ([self.member.gender isEqualToString:@"Male"]) {
                    cell.contentField.text = @"男";
                }
                else if ([self.member.gender isEqualToString:@"Female"])
                {
                    cell.contentField.text = @"女";
                }
                else
                {
                    cell.contentField.text = @"";
                }
                cell.contentField.enabled =false;
            }
            else if (row == section_two_row_email)
            {
                cell.titleLabel.text = @"邮箱";
                cell.contentField.placeholder = @"请输入";
                if (self.member.email && ![self.member.email isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.email;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                
            }
            else if (row == section_two_row_shop)
            {
                cell.titleLabel.text = @"所属门店";
                cell.contentField.text = @"请选择";
                cell.contentField.text = self.member.store.storeName;
                cell.contentField.enabled =false;
            }
        }
        else if (section == kSection_three)
        {
            cell.contentField.enabled =false;
            CDMemberCard *memberCard = [self.memberCards objectAtIndex:row];
            cell.titleLabel.text = memberCard.priceList.name;
            cell.contentField.text = [NSString stringWithFormat:@"卡号: %@",memberCard.cardNo];
        }
        return cell;
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSection_one && indexPath.row == section_one_row_pic) {
        return 80;
    }
    else
    {
        return 50;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    if (self.memberCards.count > 0 && section == kSection_three) {
        label.backgroundColor = COLOR(242, 242, 242, 1.0);
        label.text = @"     会员卡";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
    }
    
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndexPath = indexPath;
    
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
        if( section == kSection_two )
        {
            if (row == section_two_row_birthday) {
                [self showDatePicker];
            }
            else if (row == section_two_row_gender)
            {
                BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
                selectedView.delegate = self;
                selectedView.dataArray = [[NSMutableArray alloc]initWithArray:@[@"男",@"女"]];
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                selectedView.userData = selectedView.dataArray;
                NSString *str = cell.contentField.text;
                selectedView.currentSelectIndex = [selectedView.dataArray indexOfObject:str];
                [self.navigationController pushViewController:selectedView animated:YES];
            }
            
            else if (row == section_two_row_shop)
            {
                BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
               
                selectedView.delegate = self;
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
                selectedView.dataArray = storeNames;
                selectedView.userData = userData;
                BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                NSString *str = cell.contentField.text;
                selectedView.currentSelectIndex = [selectedView.dataArray indexOfObject:str];
                [self.navigationController pushViewController:selectedView animated:YES];
            }
        }
        else if (section == kSection_three)
        {
            CDMemberCard *memberCard = [self.memberCards objectAtIndex:row];
            MemberCardDetailViewController * memberCardVC = [[MemberCardDetailViewController alloc]initWithNibName:NIBCT(@"MemberCardDetailViewController") bundle:nil];
            memberCardVC.card = memberCard;
            
            [self.navigationController pushViewController:memberCardVC animated:YES];
        }

    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    if (section == kSection_one)
    {
        if (row == section_one_row_name)
        {
            if (![self.member.memberName isEqualToString:textField.text])
            {
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
        else if (row == section_one_row_telephone)
        {
            if (![self.member.mobile isEqualToString:textField.text])
            {
                
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
    else if( section == kSection_two )
    {
       if (row == section_two_row_email)
        {
            if (![self.member.email isEqualToString:textField.text])
            {
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
    }
}


#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    
    if (section == kSection_two)
    {
        if (row == section_two_row_gender)
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
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_two_row_gender inSection:kSection_two]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (row == section_two_row_shop)
        {
            NSArray *shops = userData;
            self.member.store = [shops objectAtIndex:index];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section_two_row_shop inSection:kSection_two]] withRowAnimation:UITableViewRowAnimationNone];
            if ([self.member.store.storeID integerValue] == [self.orignMember.storeID integerValue]) {
                [self.params removeObjectForKey:@"shop_id"];
            }
            else
            {
                [self.params setObject:self.member.store.storeID forKey:@"shop_id"];
            }
        }
        self.isChanged = true;
    }
}

#pragma mark - pop
- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self rollback];
    }
    else
    {
        [self handleMemberRequest];
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
    self.member.lastUpdate = [dateFormatter stringFromDate:[NSDate date]];
//    [VFileImage removeFileImage:[VDownloader defaultCachePathForUrl:self.member.imageName]];
//    [[NSFileManager defaultManager] removeItemAtPath:[VDownloader defaultCachePathForUrl:self.member.imageName] error:nil];
}

@end
