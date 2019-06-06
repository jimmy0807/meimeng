//
//  PadMemberCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadMemberCreateViewController.h"
#import "PadProjectConstant.h"
#import "BSMemberCreateRequest.h"
#import "UIImage+Resizable.h"
#import "UIImage+Orientation.h"
#import "UIImagePickerController+Landscape.h"
#import "CBLoadingView.h"
#import "UIView+Frame.h"
#import "BSFetchStaffRequest.h"
#import "BSFetchMemberSourceRequest.h"
#import "BSFetchPartnerRequest.h"
#import "SeletctListViewController.h"
#import "BSFetchMemberDetailRequest.h"
#import "CheckMemberExistRequest.h"
#import "BSFetchMemberDetailReqeustN.h"
#import "BSFetchMemberRequest.h"
#import "UIButton+WebCache.h"

typedef enum PickerViewEnum
{
    //PickEnum_Guwen,
    PickEnum_Shejishi,
    PickEnum_Shejizongjian,
    PickEnum_MemberType,
    PickEnum_Dianjia,
    PickEnum_Dudao,
    PickEnum_Dailishang,
    PickEnum_Source,
    PickEnum_Count,
}PickerViewEnum;

@interface PadMemberCreateViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL isAnimation;
    BOOL expand;
    CGFloat expandContentSizeY;
    CGFloat normalContentSizeY;
    CGFloat originY;
}
@property(nonatomic)CDMember* member;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *memberAvatar;
@property (nonatomic, strong) UITextField *memberName;
@property (nonatomic, strong) UITextField *memberGender;
@property (nonatomic, strong) UIButton *genderButton;
@property (nonatomic, strong) UITextField *memberBirthday;
@property (nonatomic, strong) UITextField *memberPhoneNumber;

@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) UIButton *hiddenButton;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIImageView *pickerViewBackground;

@property (nonatomic, strong) UIImageView* arrowView;
@property (nonatomic, strong) UILabel* arrowLabel;
@property (nonatomic, strong) UIView* expandView;

@property (nonatomic, strong) UITextField *memberQQ;
@property (nonatomic, strong) UITextField *memberWeixin;
@property (nonatomic, strong) UITextField *memberEmail;
@property (nonatomic, strong) UITextField *memberIdentify;
@property (nonatomic, strong) UITextField *tuijianren;//推荐人
@property (nonatomic, strong) UITextField *memberAddress;

@property (nonatomic, strong) UIView* emptyMaskView;

@property (nonatomic, strong) NSMutableArray* infoBgArray;
@property (nonatomic, strong) UIView* lastBackgroundView;

@property (nonatomic, strong) UIView* currentInfoFromPickerBackground;
@property (nonatomic, strong) NSMutableArray* infoFromPickerArray;
@property (nonatomic, strong) NSMutableArray* textFieldInfoArray;
@property (nonatomic, strong) NSMutableDictionary* infoFromPickerParams;
@property (nonatomic, strong) NSArray* sendToServerKey;
@property (nonatomic, strong) NSString* keyword;

@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)SeletctListViewController* selectVC;

@property(nonatomic, strong)NSMutableDictionary* selectDictionary;
@end

#define BeingTag 2731

@implementation PadMemberCreateViewController

- (id)init
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    }
    
    return self;
}

- (id)initWithMember:(CDMember*)member
{
    self = [super initWithNibName:@"PadCardCreateViewController" bundle:nil];
    if (self)
    {
        self.member = member;
        self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    [self initContentScrollView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.contentView.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.contentView addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.contentView.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    if ( self.member )
    {
        titleLabel.text = @"编辑信息";
    }
    else
    {
        titleLabel.text = LS(@"PadCreateMember");
    }
    
    [navi addSubview:titleLabel];
    
    self.shopID = [[PersonalProfile currentProfile].shopIds firstObject];
    [self initPickerViewInfo];
    
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.shopID;
//    [request execute];
    
//    [[[BSFetchMemberSourceRequest alloc] init] execute];
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        //[[[BSFetchPartnerRequest alloc] init] execute];
    }
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberSourceResponse];
    [self registerNofitificationForMainThread:kBSFetchPartnerResponse];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationOnMainThread:kBSMemberCreateResponse];
    [self removeNotificationOnMainThread:kBSFetchStaffResponse];
    [self removeNotificationOnMainThread:kBSFetchMemberSourceResponse];
    [self removeNotificationOnMainThread:kBSFetchPartnerResponse];
}

- (void)initPickerViewInfo
{
    self.infoFromPickerParams = [NSMutableDictionary dictionary];
    self.sendToServerKey = @[@"designers_id",@"director_employee_id",@"member_type",@"dj_partner_id",@"dd_partner_id",@"dl_partner_id",@"member_source"];
    //@[@"employee_id",@"designers_id",@"director_employee_id",@"dj_partner_id",@"dd_partner_id",@"dl_partner_id",@"member_source"];
    //顾问/设计师 设计总监
    [self reloadStaff];
    
    //客户来源
    [self reloadSource];
    
    [self reloadPartner];
}

- (void)reloadPartner
{

}

- (void)reloadSource
{
    
}

- (void)reloadStaff
{
    
}

- (void)initContentScrollView
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.contentView.frame.size.width, self.contentView.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0)];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 4.0);
    [self.contentView addSubview:self.contentScrollView];
    
    UIButton *contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contentButton.backgroundColor = [UIColor clearColor];
    contentButton.frame = self.contentScrollView.bounds;
    [contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:contentButton];
    
    originY = 28.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadMemberAvatar");
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake((self.contentView.frame.size.width - kPadMemberAvatarWidth)/2.0, originY, kPadMemberAvatarWidth, kPadMemberAvatarHeight);
    avatarButton.backgroundColor = [UIColor clearColor];
    [avatarButton addTarget:self action:@selector(didAvatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ( self.member )
    {
        [avatarButton sd_setImageWithURL:[NSURL URLWithString:self.member.image_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pad_member_default"]];
    }
    else
    {
        [avatarButton setBackgroundImage:[UIImage imageNamed:@"pad_add_avatar"] forState:UIControlStateNormal];
    }
    
    [self.contentScrollView addSubview:avatarButton];
    
    self.memberAvatar = [[UIImageView alloc] initWithFrame:avatarButton.bounds];
    self.memberAvatar.backgroundColor = [UIColor clearColor];
    [avatarButton addSubview:self.memberAvatar];
    UIImageView *avatarMaskView = [[UIImageView alloc] initWithFrame:self.memberAvatar.bounds];
    avatarMaskView.backgroundColor = [UIColor clearColor];
    avatarMaskView.image = [UIImage imageNamed:@"pad_member_upload_avatar"];
    [self.memberAvatar addSubview:avatarMaskView];
    originY += kPadMemberAvatarHeight + 28.0;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.contentScrollView addSubview:lineImageView];
    originY += 28.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, self.contentView.frame.size.width - 2 * kPadNaviHeight, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadMemberName");
    [self.contentScrollView addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth + 320.0 + 32.0, originY, kPadMaskViewContentWidth - 320.0 - 32.0, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadMemberGender");
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, 320.0, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberName = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 0, background.frame.size.width - 2 * 8.0, background.frame.size.height)];
    self.memberName.backgroundColor = [UIColor clearColor];
    self.memberName.font = [UIFont systemFontOfSize:16.0];
    self.memberName.textAlignment = NSTextAlignmentCenter;
    self.memberName.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberName.placeholder = LS(@"PadMemberNamePlaceholder");
    self.memberName.delegate = self;
    self.memberName.text = self.member.memberName;
    [background addSubview:self.memberName];
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth + 320.0 + 32.0, originY, kPadMaskViewContentWidth - 320.0 - 32.0, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    UIImage *genderImage = [UIImage imageNamed:@"pos_switch_off"];
    self.memberGender = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - genderImage.size.width - 12.0 - 20.0, background.frame.size.height)];
    self.memberGender.font = [UIFont systemFontOfSize:16.0];
    self.memberGender.textAlignment = NSTextAlignmentCenter;
    self.memberGender.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberGender.backgroundColor = [UIColor clearColor];
    self.memberGender.enabled = NO;
    self.memberGender.userInteractionEnabled = NO;
    self.memberGender.text = LS(@"PadGenderFemale");
    [background addSubview:self.memberGender];
    
    self.genderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.genderButton.frame = CGRectMake(background.frame.size.width - genderImage.size.width - 20.0, (background.frame.size.height - genderImage.size.height)/2.0, genderImage.size.width, genderImage.size.height);
    self.genderButton.backgroundColor = [UIColor clearColor];
    [self.genderButton addTarget:self action:@selector(didGenderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:self.genderButton];
    originY += 60.0 + 28.0;
    
    if ( [self.member.gender isEqualToString:@"Male"] )
    {
        self.memberGender.text = LS(@"PadGenderMale");
        [self.genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_on"] forState:UIControlStateNormal];
        [self.genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_off"] forState:UIControlStateHighlighted];
    }
    else if ([self.memberGender.text isEqualToString:LS(@"PadGenderFemale")])
    {
        self.memberGender.text = LS(@"PadGenderFemale");
        [self.genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_off"] forState:UIControlStateNormal];
        [self.genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_on"] forState:UIControlStateHighlighted];
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadMemberBirthday");
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    self.memberBirthday = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberBirthday.backgroundColor = [UIColor clearColor];
    self.memberBirthday.font = [UIFont systemFontOfSize:16.0];
    self.memberBirthday.textAlignment = NSTextAlignmentCenter;
    self.memberBirthday.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberBirthday.placeholder = LS(@"PadMemberBirthdayPlaceholder");
    self.memberBirthday.enabled = NO;
    self.memberBirthday.userInteractionEnabled = NO;
    self.memberBirthday.text = self.member.birthday;
    [background addSubview:self.memberBirthday];
    
    self.pickerViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY + 60.0 - 4.0, kPadMaskViewContentWidth, 272.0)];
    self.pickerViewBackground.backgroundColor = [UIColor clearColor];
    self.pickerViewBackground.image = [[UIImage imageNamed:@"pad_picker_view_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    self.pickerViewBackground.userInteractionEnabled = YES;
    self.pickerViewBackground.alpha = 0.0;
    
    UIImageView *separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, background.frame.size.width, 1.0)];
    separatedImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
    [self.pickerViewBackground addSubview:separatedImageView];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:self.pickerViewBackground.bounds];
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(didDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.pickerViewBackground addSubview:self.datePicker];
    
    UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
    self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 24.0 - downImage.size.width, (background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
    self.downImageView.backgroundColor = [UIColor clearColor];
    self.downImageView.image = downImage;
    [background addSubview:self.downImageView];
    
    UIButton *birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    birthdayButton.backgroundColor = [UIColor clearColor];
    birthdayButton.frame = CGRectMake(0.0, 0.0, background.frame.size.width, background.frame.size.height);
    [birthdayButton addTarget:self action:@selector(didBirthdayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:birthdayButton];
    
    UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
    self.hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hiddenButton.backgroundColor = [UIColor clearColor];
    self.hiddenButton.frame = CGRectMake(background.frame.size.width - 12.0 - confirmImage.size.width, (background.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
    [self.hiddenButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    self.hiddenButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.hiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hiddenButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.hiddenButton addTarget:self action:@selector(didDatePickerHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.hiddenButton.alpha = 0.0;
    [background addSubview:self.hiddenButton];
    originY += 60.0 + 28.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadMemberPhoneNumber");
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberPhoneNumber.backgroundColor = [UIColor clearColor];
    self.memberPhoneNumber.font = [UIFont systemFontOfSize:16.0];
    self.memberPhoneNumber.textAlignment = NSTextAlignmentCenter;
    self.memberPhoneNumber.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.memberPhoneNumber.placeholder = LS(@"PadMemberPhoneNumberPlaceholder");
    self.memberPhoneNumber.text = self.member.mobile;
    self.memberPhoneNumber.delegate = self;
//    if ( self.member )
//    {
//        self.memberPhoneNumber.enabled = NO;
//    }
    
    [background addSubview:self.memberPhoneNumber];
    
    originY = self.contentView.frame.size.height - 32.0 - 60.0 - 32.0;
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY, self.contentView.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.contentView addSubview:lineImageView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY + 32, kPadMaskViewContentWidth, 60.0);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:confirmButton];
    
    [self.contentScrollView addSubview:self.pickerViewBackground];
    
    originY = background.bottom + 28;
    
    [self createYimeiInfomation];
    
    originY = originY + 28;
    
    if ( [PersonalProfile currentProfile].is_accept_see_partner )
    {
        /* more */
        UIImage *arrow = [UIImage imageNamed:@"member_triangle_left.png"];
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY + 6, arrow.size.width, arrow.size.height)];
        self.arrowView.image = arrow;
        [self.contentScrollView addSubview:self.arrowView];
        [self.contentScrollView sendSubviewToBack:self.arrowView];
        
        self.arrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.arrowView.right + 10, originY, 100, 20)];
        self.arrowLabel.backgroundColor = [UIColor clearColor];
        self.arrowLabel.textColor = COLOR(12, 169, 250,1);
        self.arrowLabel.textAlignment = NSTextAlignmentLeft;
        self.arrowLabel.text = @"更多信息";
        self.arrowLabel.font = [UIFont systemFontOfSize:14];
        [self.contentScrollView addSubview:self.arrowLabel];
        [self.contentScrollView sendSubviewToBack:self.arrowLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(arrowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY - 5, self.contentScrollView.frame.size.width - kPadMaskLeftRightMarginWidth*2, 30);
        [self.contentScrollView addSubview:btn];
        
        self.lastBackgroundView = self.arrowLabel;
        
        [self initExpandView:originY + 20 + 28];
    }
    else
    {
        
    }
    
    for (UIView* v in self.infoBgArray )
    {
        [self.contentScrollView addSubview:v];
    }
    
    UIView* lastBgView = self.infoBgArray.lastObject;
    normalContentSizeY = self.lastBackgroundView.frame.origin.y + self.lastBackgroundView.frame.size.height + lastBgView.frame.size.height + 32.0;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, normalContentSizeY + 150);
}

- (void)createYimeiInfomation
{
    NSArray* titleArray = nil;
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        titleArray = @[@"设计师",@"设计总监",@"类别"];
    }
    else
    {
        titleArray = @[@"顾问/设计师"];
    }
    
    self.infoBgArray = [NSMutableArray array];
    self.infoFromPickerArray = [NSMutableArray array];
    self.textFieldInfoArray = [NSMutableArray array];
    
    [titleArray enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL * _Nonnull stop)
    {
        //信息来源
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = title;
        [self.contentScrollView addSubview:titleLabel];
        originY += 20.0 + 12.0;
        
        UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        self.lastBackgroundView = background;
        [self.contentScrollView addSubview:background];
        
        UITextField* textFieldInfo = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
        textFieldInfo.backgroundColor = [UIColor clearColor];
        textFieldInfo.font = [UIFont systemFontOfSize:16.0];
        textFieldInfo.textAlignment = NSTextAlignmentCenter;
        textFieldInfo.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        textFieldInfo.placeholder = @"无";
        textFieldInfo.enabled = NO;
        textFieldInfo.userInteractionEnabled = NO;
        textFieldInfo.tag = BeingTag + idx * 100 + 0;
        [self.textFieldInfoArray addObject:textFieldInfo];
        [background addSubview:textFieldInfo];
        if ( idx == /*PickEnum_Guwen*/100000 )
        {
            textFieldInfo.text = self.member.employee_name;
        }
        else if ( idx == PickEnum_Shejishi )
        {
            textFieldInfo.text = self.member.member_shejishi_name;
        }
        else if ( idx == PickEnum_Shejizongjian )
        {
            textFieldInfo.text = self.member.director_employee;
        }
        else if ( idx == PickEnum_Source )
        {
            textFieldInfo.text = self.member.member_source;
        }
        else if ( idx == PickEnum_Dianjia )
        {
            textFieldInfo.text = self.member.dj_partner;
        }
        else if ( idx == PickEnum_Dudao )
        {
            textFieldInfo.text = self.member.dd_partner;
        }
        else if ( idx == PickEnum_Dailishang )
        {
            textFieldInfo.text = self.member.dl_partner;
        }
        else if ( idx == PickEnum_MemberType )
        {
            if ( [self.member.yimei_member_type isEqualToString:@"pt"] )
            {
                textFieldInfo.text = @"PT";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"wip"] )
            {
                textFieldInfo.text = @"WIP";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"dd"] )
            {
                textFieldInfo.text = @"DD";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"dl"] )
            {
                textFieldInfo.text = @"DL";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"yg"] )
            {
                textFieldInfo.text = @"YG";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"vip"] )
            {
                textFieldInfo.text = @"VIP";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"dj"] )
            {
                textFieldInfo.text = @"DJ";
            }
            else if ( [self.member.yimei_member_type isEqualToString:@"dq"] )
            {
                textFieldInfo.text = @"DQ";
            }
            else
            {
                textFieldInfo.text = @"DQ";
                self.selectDictionary[@(PickEnum_MemberType)] = textFieldInfo.text;
            }
        }
        
        UIImageView* infoFromPickerBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY + 60.0 - 4.0, kPadMaskViewContentWidth, 272.0)];
        infoFromPickerBackground.backgroundColor = [UIColor clearColor];
        infoFromPickerBackground.image = [[UIImage imageNamed:@"pad_picker_view_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        infoFromPickerBackground.userInteractionEnabled = YES;
        infoFromPickerBackground.alpha = 0.0;
        infoFromPickerBackground.tag = BeingTag + idx * 100 + 1;
        [self.infoBgArray addObject:infoFromPickerBackground];
        
        UIImageView *separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, background.frame.size.width, 1.0)];
        separatedImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [infoFromPickerBackground addSubview:separatedImageView];
        
        UIPickerView* infoFromPicker = [[UIPickerView alloc] initWithFrame:infoFromPickerBackground.bounds];
        infoFromPicker.backgroundColor = [UIColor clearColor];
        infoFromPicker.showsSelectionIndicator = YES;
        infoFromPicker.dataSource = self;
        infoFromPicker.delegate = self;
        infoFromPicker.tag = BeingTag + idx * 100 + 2;
        [self.infoFromPickerArray addObject:infoFromPicker];
        [infoFromPickerBackground addSubview:infoFromPicker];
        
        UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
        UIImageView* infoPickerDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 24.0 - downImage.size.width, (background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
        infoPickerDownImageView.backgroundColor = [UIColor clearColor];
        infoPickerDownImageView.image = downImage;
        infoPickerDownImageView.tag = BeingTag + idx * 100 + 3;
        [background addSubview:infoPickerDownImageView];
        
        UIButton *infoPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        infoPickerButton.tag = BeingTag + idx * 100 + 4;
        infoPickerButton.backgroundColor = [UIColor clearColor];
        infoPickerButton.frame = CGRectMake(0.0, 0.0, background.frame.size.width, background.frame.size.height);
        [infoPickerButton addTarget:self action:@selector(didInfoPickerButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [background addSubview:infoPickerButton];
        
        UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
        UIButton *infoPickerHiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        infoPickerHiddenButton.tag = BeingTag + idx * 100 + 5;
        infoPickerHiddenButton.backgroundColor = [UIColor clearColor];
        infoPickerHiddenButton.frame = CGRectMake(background.frame.size.width - 12.0 - confirmImage.size.width, (background.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
        [infoPickerHiddenButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
        infoPickerHiddenButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [infoPickerHiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [infoPickerHiddenButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
        [infoPickerHiddenButton addTarget:self action:@selector(didInfoPickerHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        infoPickerHiddenButton.alpha = 0.0;
        [background addSubview:infoPickerHiddenButton];
        originY += 60.0 + 28.0;
    }];
    
    CGFloat originYLocal = originY;
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        /* 身份证 */
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = @"身份证";
        [self.contentScrollView addSubview:titleLabel];
        originYLocal += 20.0 + 12.0;
        
        UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentScrollView addSubview:background];
        
        self.memberIdentify = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
        self.memberIdentify.backgroundColor = [UIColor clearColor];
        self.memberIdentify.font = [UIFont systemFontOfSize:16.0];
        self.memberIdentify.textAlignment = NSTextAlignmentCenter;
        self.memberIdentify.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.memberIdentify.placeholder =@"请输入身份证号";
        self.memberIdentify.delegate = self;
        self.memberIdentify.text = self.member.idCardNumber;
        [background addSubview:self.memberIdentify];
        
        originYLocal += 60.0 + 28.0;
    }
    
    originY = originYLocal;
    
    CGFloat originYLocal2 = originY;
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        /* 推荐人 */
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = @"推荐人";
        [self.contentScrollView addSubview:titleLabel];
        originYLocal2 += 20.0 + 12.0;
        
        UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal2, kPadMaskViewContentWidth, 60.0)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        background.userInteractionEnabled = YES;
        [self.contentScrollView addSubview:background];
        
        self.tuijianren = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
        self.tuijianren.backgroundColor = [UIColor clearColor];
        self.tuijianren.font = [UIFont systemFontOfSize:16.0];
        self.tuijianren.textAlignment = NSTextAlignmentCenter;
        self.tuijianren.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        self.tuijianren.placeholder =@"请输入推荐人手机号";
        self.tuijianren.keyboardType = UIKeyboardTypeNumberPad;
        self.tuijianren.delegate = self;
        self.tuijianren.text = self.member.parent_id;
        [background addSubview:self.tuijianren];
        
        originYLocal2 += 60.0 + 28.0;
    }
    
    originY = originYLocal2;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( self.memberIdentify == textField )
    {
        if ( self.memberIdentify.text.length == 18 )
        {
            NSString* birthaday = [self.memberIdentify.text substringWithRange:NSMakeRange(6, 8)];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyyMMdd";
            NSDate *date = [dateFormat dateFromString:birthaday];
            dateFormat.dateFormat = @"yyyy-MM-dd";
            self.memberBirthday.text = [dateFormat stringFromDate:date];
        }
    }
    else if (self.memberPhoneNumber == textField)
    {
        CheckMemberExistRequest* request = [[CheckMemberExistRequest alloc] init];
        request.phoneNumber = self.memberPhoneNumber.text;
        [request execute];
        WeakSelf
        request.gotMeber = ^(NSNumber *memberID) {
            if ( memberID )
            {
                BSFetchMemberDetailRequestN* request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:memberID];
                [request execute];
                request.finished = ^(NSDictionary *params) {
                    [[CBLoadingView shareLoadingView] hide];
                    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
                    if ( member )
                    {
                        weakSelf.memberName.text = member.memberName;
                    }
                    else
                    {
                        [weakSelf doCreate]; // 不应该走这里
                    }
                };
            }
            else
            {
                [[CBLoadingView shareLoadingView] hide];
//                [weakSelf doCreate];
            }
        };
    }
}

- (void)createYimeiInfomationMore
{
    NSArray* titleArray = nil;
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        titleArray = @[@"DJ",@"DD",@"DL",@"客户来源"];
    }
    
    //self.infoBgArray = [NSMutableArray array];
    //self.infoFromPickerArray = [NSMutableArray array];
    //self.textFieldInfoArray = [NSMutableArray array];
    
    [titleArray enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL * _Nonnull stop)
     {
         idx = idx + PickEnum_Dianjia;
         //信息来源
         UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
         titleLabel.backgroundColor = [UIColor clearColor];
         titleLabel.textAlignment = NSTextAlignmentLeft;
         titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
         titleLabel.font = [UIFont systemFontOfSize:16.0];
         titleLabel.text = title;
         [self.contentScrollView addSubview:titleLabel];
         originY += 20.0 + 12.0;
         
         UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
         background.backgroundColor = [UIColor clearColor];
         background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
         background.userInteractionEnabled = YES;
         self.lastBackgroundView = background;
         [self.contentScrollView addSubview:background];
         
         UITextField* textFieldInfo = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
         textFieldInfo.backgroundColor = [UIColor clearColor];
         textFieldInfo.font = [UIFont systemFontOfSize:16.0];
         textFieldInfo.textAlignment = NSTextAlignmentCenter;
         textFieldInfo.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
         textFieldInfo.placeholder = @"无";
         textFieldInfo.enabled = NO;
         textFieldInfo.userInteractionEnabled = NO;
         textFieldInfo.tag = BeingTag + idx * 100 + 0;
         [self.textFieldInfoArray addObject:textFieldInfo];
         [background addSubview:textFieldInfo];
         if ( idx == /*PickEnum_Guwen*/1000000 )
         {
             textFieldInfo.text = self.member.employee_name;
         }
         else if ( idx == PickEnum_Shejishi )
         {
             textFieldInfo.text = self.member.member_shejishi_name;
         }
         else if ( idx == PickEnum_Shejizongjian )
         {
             textFieldInfo.text = self.member.director_employee;
         }
         else if ( idx == PickEnum_Source )
         {
             textFieldInfo.text = self.member.member_source;
         }
         else if ( idx == PickEnum_Dianjia )
         {
             textFieldInfo.text = self.member.dj_partner;
         }
         else if ( idx == PickEnum_Dudao )
         {
             textFieldInfo.text = self.member.dd_partner;
         }
         else if ( idx == PickEnum_Dailishang )
         {
             textFieldInfo.text = self.member.dl_partner;
         }
         
         UIImageView* infoFromPickerBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY + 60.0 - 4.0, kPadMaskViewContentWidth, 272.0)];
         infoFromPickerBackground.backgroundColor = [UIColor clearColor];
         infoFromPickerBackground.image = [[UIImage imageNamed:@"pad_picker_view_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
         infoFromPickerBackground.userInteractionEnabled = YES;
         infoFromPickerBackground.alpha = 0.0;
         infoFromPickerBackground.tag = BeingTag + idx * 100 + 1;
         [self.infoBgArray addObject:infoFromPickerBackground];
         
         UIImageView *separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, background.frame.size.width, 1.0)];
         separatedImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
         [infoFromPickerBackground addSubview:separatedImageView];
         
         UIPickerView* infoFromPicker = [[UIPickerView alloc] initWithFrame:infoFromPickerBackground.bounds];
         infoFromPicker.backgroundColor = [UIColor clearColor];
         infoFromPicker.showsSelectionIndicator = YES;
         infoFromPicker.dataSource = self;
         infoFromPicker.delegate = self;
         infoFromPicker.tag = BeingTag + idx * 100 + 2;
         [self.infoFromPickerArray addObject:infoFromPicker];
         [infoFromPickerBackground addSubview:infoFromPicker];
         
         UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
         UIImageView* infoPickerDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 24.0 - downImage.size.width, (background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
         infoPickerDownImageView.backgroundColor = [UIColor clearColor];
         infoPickerDownImageView.image = downImage;
         infoPickerDownImageView.tag = BeingTag + idx * 100 + 3;
         [background addSubview:infoPickerDownImageView];
         
         UIButton *infoPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
         infoPickerButton.tag = BeingTag + idx * 100 + 4;
         infoPickerButton.backgroundColor = [UIColor clearColor];
         infoPickerButton.frame = CGRectMake(0.0, 0.0, background.frame.size.width, background.frame.size.height);
         [infoPickerButton addTarget:self action:@selector(didInfoPickerButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         [background addSubview:infoPickerButton];
         
         UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
         UIButton *infoPickerHiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
         infoPickerHiddenButton.tag = BeingTag + idx * 100 + 5;
         infoPickerHiddenButton.backgroundColor = [UIColor clearColor];
         infoPickerHiddenButton.frame = CGRectMake(background.frame.size.width - 12.0 - confirmImage.size.width, (background.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
         [infoPickerHiddenButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
         infoPickerHiddenButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
         [infoPickerHiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [infoPickerHiddenButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
         [infoPickerHiddenButton addTarget:self action:@selector(didInfoPickerHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         infoPickerHiddenButton.alpha = 0.0;
         [background addSubview:infoPickerHiddenButton];
         originY += 60.0 + 28.0;
     }];
}


#pragma mark - arrow btn pressed
- (void)arrowBtnPressed:(UIButton *)btn
{
    expand = !expand;
    if (expand)
    {
        self.arrowView.frame = CGRectMake(kPadMaskLeftRightMarginWidth, self.arrowView.frame.origin.y + 1, 7, 5);
        self.arrowView.image = [UIImage imageNamed:@"member_triangle_up.png"];
        self.arrowLabel.text = @"收起";
        
        self.emptyMaskView.hidden = YES;
        if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
        {
            self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, expandContentSizeY);
        }
    }
    else
    {
        self.arrowView.frame = CGRectMake(kPadMaskLeftRightMarginWidth, self.arrowView.frame.origin.y - 1, 5, 7);
        self.arrowView.image = [UIImage imageNamed:@"member_triangle_left.png"];
        self.arrowLabel.text = @"更多信息";
        
        self.emptyMaskView.hidden = NO;
        if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
        {
            self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, normalContentSizeY);
        }
    }
}

- (void)initExpandView:(CGFloat)originYLocal
{
    CGFloat maskViewOriginY = originYLocal;
    
    /* QQ */
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"QQ";
    //[self.contentScrollView addSubview:titleLabel];
    //originYLocal += 20.0 + 12.0;
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    //[self.contentScrollView addSubview:background];
    
    self.memberQQ = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberQQ.backgroundColor = [UIColor clearColor];
    self.memberQQ.font = [UIFont systemFontOfSize:16.0];
    self.memberQQ.textAlignment = NSTextAlignmentCenter;
    self.memberQQ.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberQQ.keyboardType = UIKeyboardTypeNumberPad;
    self.memberQQ.placeholder =@"请输入QQ号";
    self.memberQQ.delegate = self;
    self.memberQQ.text = self.member.member_qq;
    //[background addSubview:self.memberQQ];
    
   // originYLocal += 60.0 + 28.0;
    originY = originYLocal;
    [self createYimeiInfomationMore];
    originYLocal = originY;
    
    /* 微信 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"微信";
    [self.contentScrollView addSubview:titleLabel];
    originYLocal += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberWeixin = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberWeixin.backgroundColor = [UIColor clearColor];
    self.memberWeixin.font = [UIFont systemFontOfSize:16.0];
    self.memberWeixin.textAlignment = NSTextAlignmentCenter;
    self.memberWeixin.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberWeixin.placeholder =@"请输入微信号";
    self.memberWeixin.delegate = self;
    self.memberWeixin.text = self.member.member_wx;
    [background addSubview:self.memberWeixin];
    
    originYLocal += 60.0 + 28.0;
    
    /* 电子邮箱 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"电子邮箱";
    [self.contentScrollView addSubview:titleLabel];
    originYLocal += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberEmail = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberEmail.backgroundColor = [UIColor clearColor];
    self.memberEmail.font = [UIFont systemFontOfSize:16.0];
    self.memberEmail.textAlignment = NSTextAlignmentCenter;
    self.memberEmail.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberEmail.keyboardType = UIKeyboardTypeEmailAddress;
    self.memberEmail.placeholder =@"请输入电子邮箱";
    self.memberEmail.delegate = self;
    self.memberEmail.text = self.member.email;
    [background addSubview:self.memberEmail];
    
    originYLocal += 60.0 + 28.0;
    
    /* 居住地址 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"居住地址";
    [self.contentScrollView addSubview:titleLabel];
    originYLocal += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originYLocal, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberAddress = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberAddress.backgroundColor = [UIColor clearColor];
    self.memberAddress.font = [UIFont systemFontOfSize:16.0];
    self.memberAddress.textAlignment = NSTextAlignmentCenter;
    self.memberAddress.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberAddress.placeholder =@"请输入居住地址";
    self.memberAddress.delegate = self;
    self.memberAddress.text = self.member.member_address;
    [background addSubview:self.memberAddress];
    
    originYLocal += 60.0 + 28.0;
    
    originY = originYLocal;
    
    expandContentSizeY = originYLocal;
    
    self.emptyMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, maskViewOriginY, self.contentScrollView.frame.size.width, 1200)];
    self.emptyMaskView.backgroundColor = [UIColor whiteColor];
    self.emptyMaskView.userInteractionEnabled = NO;
    [self.contentScrollView addSubview:self.emptyMaskView];
    
    [self.contentScrollView bringSubviewToFront:self.pickerViewBackground];
}

- (void)didCloseButtonClick:(id)sender
{
    [self.maskView hidden];
}

- (void)didAvatarButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.memberAvatar.image != nil)
    {
        BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:[NSArray arrayWithObjects:LS(@"Camera"), LS(@"ChooseFromAlbum"), LS(@"Delete"), nil] cancelTitle:LS(@"Cancel") delegate:self];
        [actionSheet show];
    }
    else
    {
        BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:[NSArray arrayWithObjects:LS(@"Camera"), LS(@"ChooseFromAlbum"), nil] cancelTitle:LS(@"Cancel") delegate:self];
        [actionSheet show];
    }
}

- (void)didGenderButtonClick:(id)sender
{
    UIButton *genderButton = (UIButton *)sender;
    if ([self.memberGender.text isEqualToString:LS(@"PadGenderMale")])
    {
        self.memberGender.text = LS(@"PadGenderFemale");
        [genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_off"] forState:UIControlStateNormal];
        [genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_on"] forState:UIControlStateHighlighted];
    }
    else if ([self.memberGender.text isEqualToString:LS(@"PadGenderFemale")])
    {
        self.memberGender.text = LS(@"PadGenderMale");
        [genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_on"] forState:UIControlStateNormal];
        [genderButton setBackgroundImage:[UIImage imageNamed:@"pos_switch_off"] forState:UIControlStateHighlighted];
    }
}

- (void)didContentButtonClick:(id)sender
{
    if (!isAnimation && self.pickerViewBackground.alpha == 1.0)
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.downImageView.alpha = 1.0;
            self.hiddenButton.alpha = 0.0;
            self.pickerViewBackground.alpha = 0.0;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
}

- (void)didBirthdayButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    if (self.pickerViewBackground.alpha == 0.0)
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.downImageView.alpha = 0.0;
            self.hiddenButton.alpha = 1.0;
            self.pickerViewBackground.alpha = 1.0;
            CGPoint offset = self.contentScrollView.contentOffset;
            offset.y = self.contentScrollView.contentSize.height - self.contentScrollView.bounds.size.height;
            if (self.memberBirthday.text.length == 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd";
                self.memberBirthday.text = [dateFormatter stringFromDate:self.datePicker.date];
            }
            //self.contentScrollView.contentOffset = offset;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.downImageView.alpha = 1.0;
            self.hiddenButton.alpha = 0.0;
            self.pickerViewBackground.alpha = 0.0;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
}

- (void)didDatePickerHiddenButtonClick:(id)sender
{
    [self didBirthdayButtonClick:nil];
}

- (void)didDatePickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.memberBirthday.text = [dateFormatter stringFromDate:self.datePicker.date];
}
///无输入的手机号码对应的会员存在时会走这里
- (void)doCreate
{
    if ( !self.member && ( self.memberName.text.length == 0 || self.memberPhoneNumber.text.length == 0 ) )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberNameAndPhoneCanNotBeNULL")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.memberPhoneNumber.text forKey:[NSString stringWithFormat:@"storeID = %@ && mobile", storeID]];
    if ( member && !self.member )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberPhoneIsExist")
                                                           delegate:self
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:LS(@"PadMemberView"), nil];
        [alertView show];
        return;
    }
    
    //NSString *regex = @"^1[3|4|5|8|7][0-9]\\d{8}$";
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //if (![predicate evaluateWithObject:self.memberPhoneNumber.text])
    if ( self.memberPhoneNumber.text.length != 11 )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberPhoneNumberNotCorrect")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.memberName.text.length != 0 && ![self.memberName.text isEqualToString:self.member.memberName] )
    {
        [params setObject:self.memberName.text forKey:@"name"];
    }
    if ([self.memberGender.text isEqualToString:LS(@"PadGenderMale")] && ![@"Male" isEqualToString:self.member.gender] )
    {
        [params setObject:@"Male" forKey:@"gender"];
    }
    else if ([self.memberGender.text isEqualToString:LS(@"PadGenderFemale")] && ![@"Female" isEqualToString:self.member.gender] )
    {
        [params setObject:@"Female" forKey:@"gender"];
    }
    if (self.memberBirthday.text.length != 0 && ![self.memberBirthday.text isEqualToString:self.member.birthday] )
    {
        [params setObject:self.memberBirthday.text forKey:@"birth_date"];
    }
    if (self.memberPhoneNumber.text.length != 0 && ![self.memberPhoneNumber.text isEqualToString:self.member.mobile] )
    {
        [params setObject:self.memberPhoneNumber.text forKey:@"mobile"];
    }
    
    if ( self.memberQQ.text.length != 0 && ![self.memberQQ.text isEqualToString:self.member.member_qq] )
    {
        [params setObject:self.memberQQ.text forKey:@"qq"];
    }
    
    if ( self.memberWeixin.text.length != 0 && ![self.memberWeixin.text isEqualToString:self.member.member_wx] )
    {
        [params setObject:self.memberWeixin.text forKey:@"wx"];
    }
    
    if ( self.memberEmail.text.length != 0 && ![self.memberEmail.text isEqualToString:self.member.email] )
    {
        [params setObject:self.memberEmail.text forKey:@"email"];
    }
    
    if ( self.memberIdentify.text.length != 0 && ![self.memberIdentify.text isEqualToString:self.member.idCardNumber] )
    {
        [params setObject:self.memberIdentify.text forKey:@"id_card_no"];
    }
    if ( self.tuijianren.text.length != 0 && ![self.tuijianren.text isEqualToString:self.member.parent_id] )
    {
        [params setObject:self.tuijianren.text forKey:@"parent_phone"];
    }
    
    if ( self.memberAddress.text.length != 0 && ![self.memberAddress.text isEqualToString:self.member.member_address] )
    {
        [params setObject:self.memberAddress.text forKey:@"street"];
    }
    
    for ( NSInteger i = 0; i < PickEnum_Count; i++ )
    {
        id obj = self.selectDictionary[@(i)];
        if ( obj )
        {
            [params setObject:obj forKey:self.sendToServerKey[i]];
            UITextField* textFieldInfo = [self.contentScrollView viewWithTag:BeingTag + i * 100];
            NSString* name = textFieldInfo.text;
            
            if ( i == /*PickEnum_Guwen*/100000 )
            {
                self.member.employee_name = name;
            }
            else if ( i == PickEnum_Shejishi )
            {
                self.member.member_shejishi_name = name;
                self.member.member_shejishi_id = self.selectDictionary[@(i)];
            }
            else if ( i == PickEnum_Shejizongjian )
            {
                self.member.director_employee = name;
                self.member.director_employee_id = self.selectDictionary[@(i)];
            }
            else if ( i == PickEnum_Source )
            {
                self.member.member_source = name;
            }
            else if ( i == PickEnum_Dianjia )
            {
                self.member.dj_partner = name;
            }
            else if ( i == PickEnum_Dudao )
            {
                self.member.dd_partner = name;
            }
            else if ( i == PickEnum_Dailishang )
            {
                self.member.dl_partner = name;
            }
            else if ( i == PickEnum_MemberType )
            {
                if ( [name isEqualToString:@"PT"] )
                {
                    [params setObject:@"pt" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"WIP"] )
                {
                    [params setObject:@"wip" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"DD"] )
                {
                    [params setObject:@"dd" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"DL"] )
                {
                    [params setObject:@"dl" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"YG"] )
                {
                    [params setObject:@"yg" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"VIP"] )
                {
                    [params setObject:@"vip" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"DJ"] )
                {
                    [params setObject:@"dj" forKey:@"member_type"];
                }
                else if ( [name isEqualToString:@"DQ"] )
                {
                    [params setObject:@"dq" forKey:@"member_type"];
                }
                else
                {
                    [params setObject:@"dq" forKey:@"member_type"];
                }
                
                self.member.yimei_member_type = name;
            }
        }
    }
    
    if (self.memberAvatar.image != nil)
    {
        NSData *data = UIImageJPEGRepresentation(self.memberAvatar.image, 0.7);
        NSString *imagestr = [data base64Encoding];
        [params setObject:imagestr forKey:@"image"];
    }
    else
    {
        if ( self.member )
        {
            
        }
        else
        {
            [params setObject:[NSNumber numberWithBool:NO] forKey:@"image"];
        }
    }
    
    [[CBLoadingView shareLoadingView] show];
    
    if ( self.member )
    {
        BSMemberCreateRequest *request = [[BSMemberCreateRequest alloc] initWithMemberID:self.member.memberID params:params];
        [request execute];
        self.keyword = self.member.memberName;
        BSFetchMemberRequest *request2 = [[BSFetchMemberRequest alloc] initWithKeyword:self.keyword];
        [request2 execute];
    }
    else
    {
        BSMemberCreateRequest *request = [[BSMemberCreateRequest alloc] initWithParams:params];
        [request execute];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    WeakSelf;
    if ( self.member == nil )
    {
        if ( self.memberPhoneNumber.text.length != 11 )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"PadMemberPhoneNumberNotCorrect")
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        
        [[CBLoadingView shareLoadingView] show];
        CheckMemberExistRequest* request = [[CheckMemberExistRequest alloc] init];
        request.phoneNumber = self.memberPhoneNumber.text;
        [request execute];
        request.gotMeber = ^(NSNumber *memberID) {
            if ( memberID )
            {
                BSFetchMemberDetailRequestN* request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:memberID];
                [request execute];
                request.finished = ^(NSDictionary *params) {
                    [[CBLoadingView shareLoadingView] hide];
                    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
                    if ( member )
                    {
                        self.keyword = member.memberName;
                        BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:self.keyword];
                        [request execute];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberCreateResponse object:memberID userInfo:nil];
                    }
                    else
                    {
                        [weakSelf doCreate]; // 不应该走这里
                    }
                };
            }
            else
            {
                [[CBLoadingView shareLoadingView] hide];
                [weakSelf doCreate];
            }
        };
    }
    else
    {
        [self doCreate];
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self.maskView hidden];
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:notification.object forKey:@"memberID"];
            if ( self.member )
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadEditMemberFinish object:member userInfo:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberFinish object:member userInfo:@{@"CreateCard":@(YES)}];
            }
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ( [notification.name isEqualToString:kBSFetchStaffResponse] )
    {
        [self reloadStaff];
    }
    else if ( [notification.name isEqualToString:kBSFetchMemberSourceResponse] )
    {
        [self reloadSource];
    }
    else if ( [notification.name isEqualToString:kBSFetchPartnerResponse] )
    {
        [self reloadPartner];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.maskView hidden];
        NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
        CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.memberPhoneNumber.text forKey:[NSString stringWithFormat:@"storeID = %@ && mobile", storeID]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberFinish object:member userInfo:nil];
    }
}


#pragma mark -
#pragma mark BNActionSheetDelegate Methods

- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
            
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
            
        case 2:
        {
            if (self.memberAvatar.image != nil)
            {
                self.memberAvatar.image = nil;
            }
        }
            break;
            
        default:
            break;
    }
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
    self.memberAvatar.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)didInfoPickerButtonButtonClick:(UIButton*)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    if (isAnimation)
//    {
//        return;
//    }
    
    //isAnimation = YES;
    
    NSInteger tag;
    if ( sender )
    {
        tag = sender.tag;
    }
    else
    {
        tag = self.currentInfoFromPickerBackground.tag + 3;
    }
    
    UIImageView* infoPickerDownImageView = (UIImageView*)[self.contentScrollView viewWithTag:tag - 1];
    UIButton* infoPickerHiddenButton = (UIButton*)[self.contentScrollView viewWithTag:tag + 1];
    UIView* infoFromPickerBackground = (UIView*)[self.contentScrollView viewWithTag:tag - 3];
#if 0
    if ( self.currentInfoFromPickerBackground.alpha == 0.0)
    {
        [UIView animateWithDuration:0.32 animations:^{
            infoPickerDownImageView.alpha = 0.0;
            infoPickerHiddenButton.alpha = 1.0;
            infoFromPickerBackground.alpha = 1.0;
            self.currentInfoFromPickerBackground = infoFromPickerBackground;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.32 animations:^{
            infoPickerDownImageView.alpha = 1.0;
            infoPickerHiddenButton.alpha = 0.0;
            self.currentInfoFromPickerBackground.alpha = 0.0;
            self.currentInfoFromPickerBackground = nil;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
#else
    NSInteger index = (tag - BeingTag - 4 ) / 100;
    if ( index == PickEnum_Shejishi )
    {
        [self showShejishiSelect];
    }
    else if ( index == PickEnum_Shejizongjian )
    {
        [self showShejizongjianSelect];
    }
    else if ( index == PickEnum_Source )
    {
        [self showSourceSelect];
    }
    else if ( index == PickEnum_Dianjia )
    {
        [self showDianjiaSelect];
    }
    else if ( index == PickEnum_Dudao )
    {
        [self showDudaoSelect];
    }
    else if ( index == PickEnum_Dailishang )
    {
        [self showDailishangSelect];
    }
    else if ( index == PickEnum_MemberType )
    {
        [self showMemberTypeSelect];
    }
#if 0
    NSObject* object = array[row];
    
    if ( [object isKindOfClass:[NSString class]] )
    {
        return (NSString*)object;
    }
    else if ( [object isKindOfClass:[CDStaff class]] )
    {
        return ((CDStaff*)object).name;
    }
    else if ( [object isKindOfClass:[CDMemberSource class]] )
    {
        return ((CDMemberSource*)object).name;
    }
    else if ( [object isKindOfClass:[CDPartner class]] )
    {
        return ((CDPartner*)object).name;
    }
#endif
#endif
}

- (void)didInfoPickerHiddenButtonClick:(id)sender
{
    [self didInfoPickerButtonButtonClick:nil];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"select");
}

- (void)showShejishiSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Shejishi * 100];
        CDStaff* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Shejishi)] = staff.staffID;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showShejizongjianSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchShejizongjianStaffsWithShopID:self.shopID];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Shejizongjian * 100];
        CDStaff* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Shejizongjian)] = staff.staffID;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showMemberTypeSelect
{
    WeakSelf;
    NSArray* array = @[@"WIP", @"VIP", @"PT", @"DJ", @"DD", @"DL", @"YG",@"DQ"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.noSort = YES;
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        return array[index];
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_MemberType * 100];
        textFieldInfo.text = array[index];
        weakSelf.selectDictionary[@(PickEnum_MemberType)] = textFieldInfo.text;
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showDianjiaSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchPartner:@"dj"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Dianjia * 100];
        CDPartner* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Dianjia)] = staff.partner_id;
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showDudaoSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchPartner:@"dd"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Dudao * 100];
        CDPartner* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Dudao)] = staff.partner_id;
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showDailishangSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchPartner:@"dl"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Dailishang * 100];
        CDPartner* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Dailishang)] = staff.partner_id;
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showSourceSelect
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchMemberSource];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDMemberSource* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        UITextField* textFieldInfo = [weakSelf.contentScrollView viewWithTag:BeingTag + PickEnum_Source * 100];
        CDMemberSource* staff = array[index];
        textFieldInfo.text = staff.name;
        weakSelf.selectDictionary[@(PickEnum_Source)] = staff.source_id;
    };
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}
@end
