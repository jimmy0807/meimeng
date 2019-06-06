//
//  PadMemberTiYanCreateViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadMemberTiYanCreateViewController.h"
#import "PadProjectConstant.h"
#import "BSMemberCreateRequest.h"
#import "UIImage+Resizable.h"
#import "UIImage+Orientation.h"
#import "UIImagePickerController+Landscape.h"
#import "CBLoadingView.h"
#import "UIView+Frame.h"
#import "BSFetchMemberSourceRequest.h"

@interface PadMemberTiYanCreateViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL isAnimation;
    BOOL expand;
    CGFloat expandContentSizeY;
    CGFloat normalContentSizeY;
}
@property(nonatomic)CDMember* member;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *memberAvatar;
@property (nonatomic, strong) UITextField *memberName;
@property (nonatomic, strong) UITextField *memberGender;
@property (nonatomic, strong) UIButton *genderButton;
@property (nonatomic, strong) UITextField *memberBirthday;
@property (nonatomic, strong) UITextField *memberInfoFrom;
@property (nonatomic, strong) UITextField *memberPhoneNumber;

@property (nonatomic, strong) UIImageView *downImageView;
@property (nonatomic, strong) UIButton *hiddenButton;

@property (nonatomic, strong) UIImageView *infoPickerDownImageView;
@property (nonatomic, strong) UIButton *infoPickerHiddenButton;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIImageView *pickerViewBackground;

@property (nonatomic, strong) UIPickerView *infoFromPicker;
@property (nonatomic, strong) UIImageView *infoFromPickerBackground;

@property (nonatomic, strong) UIImageView* arrowView;
@property (nonatomic, strong) UILabel* arrowLabel;
@property (nonatomic, strong) UIView* expandView;

@property (nonatomic, strong) UITextField *memberQQ;
@property (nonatomic, strong) UITextField *memberWeixin;
@property (nonatomic, strong) UITextField *memberEmail;
@property (nonatomic, strong) UITextField *memberIdentify;
@property (nonatomic, strong) UITextField *memberAddress;

@property (nonatomic, strong) UIView* emptyMaskView;

@property(nonatomic, strong)NSArray* memberSourceArray;

@end


@implementation PadMemberTiYanCreateViewController

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
    
    BSFetchMemberSourceRequest* request = [[BSFetchMemberSourceRequest alloc] init];
    [request execute];
    
    self.memberSourceArray = [[BSCoreDataManager currentManager] fetchMemberSource];
    
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
        titleLabel.text = @"新建体验会员";
    }
    
    [navi addSubview:titleLabel];
    
    [self registerNofitificationForMainThread:kBSFetchMemberSourceResponse];
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
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
    
    CGFloat originY = 28.0;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, self.contentView.frame.size.width - 2 * kPadNaviHeight, 20.0)];
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
    originY += 60.0 + 28.0;
    
    //信息来源
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"信息来源";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    self.memberInfoFrom = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberInfoFrom.backgroundColor = [UIColor clearColor];
    self.memberInfoFrom.font = [UIFont systemFontOfSize:16.0];
    self.memberInfoFrom.textAlignment = NSTextAlignmentCenter;
    self.memberInfoFrom.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberInfoFrom.placeholder = @"无";
    self.memberInfoFrom.enabled = NO;
    self.memberInfoFrom.userInteractionEnabled = NO;
    [background addSubview:self.memberInfoFrom];
    
    self.infoFromPickerBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY + 60.0 - 4.0, kPadMaskViewContentWidth, 272.0)];
    self.infoFromPickerBackground.backgroundColor = [UIColor clearColor];
    self.infoFromPickerBackground.image = [[UIImage imageNamed:@"pad_picker_view_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    self.infoFromPickerBackground.userInteractionEnabled = YES;
    self.infoFromPickerBackground.alpha = 0.0;
    
    UIImageView *separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, background.frame.size.width, 1.0)];
    separatedImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
    [self.infoFromPickerBackground addSubview:separatedImageView];
    
    self.infoFromPicker = [[UIPickerView alloc] initWithFrame:self.infoFromPickerBackground.bounds];
    self.infoFromPicker.backgroundColor = [UIColor clearColor];
    self.infoFromPicker.showsSelectionIndicator = YES;
    self.infoFromPicker.dataSource = self;
    self.infoFromPicker.delegate = self;
    [self.infoFromPickerBackground addSubview:self.infoFromPicker];
    
    UIImage *downImage = [UIImage imageNamed:@"pad_user_info_drop_down"];
    self.infoPickerDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 24.0 - downImage.size.width, (background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
    self.infoPickerDownImageView.backgroundColor = [UIColor clearColor];
    self.infoPickerDownImageView.image = downImage;
    [background addSubview:self.infoPickerDownImageView];
    
    UIButton *infoPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoPickerButton.backgroundColor = [UIColor clearColor];
    infoPickerButton.frame = CGRectMake(0.0, 0.0, background.frame.size.width, background.frame.size.height);
    [infoPickerButton addTarget:self action:@selector(didInfoPickerButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:infoPickerButton];
    
    UIImage *confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
    self.infoPickerHiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoPickerHiddenButton.backgroundColor = [UIColor clearColor];
    self.infoPickerHiddenButton.frame = CGRectMake(background.frame.size.width - 12.0 - confirmImage.size.width, (background.frame.size.height - confirmImage.size.height)/2.0, confirmImage.size.width, confirmImage.size.height);
    [self.infoPickerHiddenButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
    self.infoPickerHiddenButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self.infoPickerHiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.infoPickerHiddenButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [self.infoPickerHiddenButton addTarget:self action:@selector(didInfoPickerHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.infoPickerHiddenButton.alpha = 0.0;
    [background addSubview:self.infoPickerHiddenButton];
    originY += 60.0 + 28.0;
    
    //生日
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
    
    separatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 3.0, background.frame.size.width, 1.0)];
    separatedImageView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
    [self.pickerViewBackground addSubview:separatedImageView];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:self.pickerViewBackground.bounds];
    self.datePicker.backgroundColor = [UIColor clearColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];
    self.datePicker.maximumDate = [NSDate date];
    [self.datePicker addTarget:self action:@selector(didDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.pickerViewBackground addSubview:self.datePicker];
    if (background.frame.origin.y + background.frame.size.height + self.pickerViewBackground.frame.size.height + 32.0 > self.contentScrollView.frame.size.height)
    {
        normalContentSizeY = background.frame.origin.y + background.frame.size.height + self.pickerViewBackground.frame.size.height + 32.0;
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, normalContentSizeY);
    }
    
    self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background.frame.size.width - 24.0 - downImage.size.width, (background.frame.size.height - downImage.size.height)/2.0, downImage.size.width, downImage.size.height)];
    self.downImageView.backgroundColor = [UIColor clearColor];
    self.downImageView.image = downImage;
    [background addSubview:self.downImageView];
    
    UIButton *birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    birthdayButton.backgroundColor = [UIColor clearColor];
    birthdayButton.frame = CGRectMake(0.0, 0.0, background.frame.size.width, background.frame.size.height);
    [birthdayButton addTarget:self action:@selector(didBirthdayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:birthdayButton];
    
    confirmImage = [UIImage imageNamed:@"pad_confirm_n"];
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
    
    originY = self.contentView.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY, self.contentView.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.contentView addSubview:lineImageView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:confirmButton];
    
    [self.contentScrollView addSubview:self.pickerViewBackground];
    [self.contentScrollView addSubview:self.infoFromPickerBackground];

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
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, expandContentSizeY);
    }
    else
    {
        self.arrowView.frame = CGRectMake(kPadMaskLeftRightMarginWidth, self.arrowView.frame.origin.y - 1, 5, 7);
        self.arrowView.image = [UIImage imageNamed:@"member_triangle_left.png"];
        self.arrowLabel.text = @"更多信息";
        
        self.emptyMaskView.hidden = NO;
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width, normalContentSizeY);
    }
}

- (void)initExpandView:(CGFloat)originY
{
    CGFloat maskViewOriginY = originY;
    
    /* QQ */
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"QQ";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberQQ = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberQQ.backgroundColor = [UIColor clearColor];
    self.memberQQ.font = [UIFont systemFontOfSize:16.0];
    self.memberQQ.textAlignment = NSTextAlignmentCenter;
    self.memberQQ.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberQQ.keyboardType = UIKeyboardTypeNumberPad;
    self.memberQQ.placeholder =@"请输入QQ号";
    self.memberQQ.delegate = self;
    self.memberQQ.text = self.member.member_qq;
    [background addSubview:self.memberQQ];
    
    originY += 60.0 + 28.0;
    
    /* 微信 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"微信";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
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
    
    originY += 60.0 + 28.0;
    
    /* 电子邮箱 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"电子邮箱";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
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
    
    originY += 60.0 + 28.0;
    
    /* 身份证 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"身份证";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.contentScrollView addSubview:background];
    
    self.memberIdentify = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 0.0, background.frame.size.width - 2 * 12.0, background.frame.size.height)];
    self.memberIdentify.backgroundColor = [UIColor clearColor];
    self.memberIdentify.font = [UIFont systemFontOfSize:16.0];
    self.memberIdentify.textAlignment = NSTextAlignmentCenter;
    self.memberIdentify.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.memberIdentify.keyboardType = UIKeyboardTypeNumberPad;
    self.memberIdentify.placeholder =@"请输入身份证号";
    self.memberIdentify.delegate = self;
    self.memberIdentify.text = self.member.idCardNumber;
    [background addSubview:self.memberIdentify];
    
    originY += 60.0 + 28.0;
    
    /* 居住地址 */
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"居住地址";
    [self.contentScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
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
    
    originY += 60.0 + 28.0;
    
    expandContentSizeY = originY;
    
    self.emptyMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, maskViewOriginY, self.contentScrollView.frame.size.width, 600)];
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
    else if (!isAnimation && self.infoFromPickerBackground.alpha == 1.0)
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.infoPickerDownImageView.alpha = 1.0;
            self.infoPickerHiddenButton.alpha = 0.0;
            self.infoFromPickerBackground.alpha = 0.0;
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

- (void)didInfoPickerButtonButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (isAnimation)
    {
        return;
    }
    
    isAnimation = YES;
    if (self.infoFromPickerBackground.alpha == 0.0)
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.infoPickerDownImageView.alpha = 0.0;
            self.infoPickerHiddenButton.alpha = 1.0;
            self.infoFromPickerBackground.alpha = 1.0;
            CGPoint offset = self.contentScrollView.contentOffset;
            offset.y = self.contentScrollView.contentSize.height - self.contentScrollView.bounds.size.height;
            if (self.memberInfoFrom.text.length == 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd";
                //self.memberInfoFrom.text = [dateFormatter stringFromDate:self.datePicker.date];
            }
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.32 animations:^{
            self.infoPickerDownImageView.alpha = 1.0;
            self.infoPickerHiddenButton.alpha = 0.0;
            self.infoFromPickerBackground.alpha = 0.0;
        } completion:^(BOOL finished) {
            isAnimation = NO;
        }];
    }
}

- (void)didDatePickerHiddenButtonClick:(id)sender
{
    [self didBirthdayButtonClick:nil];
}

- (void)didInfoPickerHiddenButtonClick:(id)sender
{
    [self didInfoPickerButtonButtonClick:nil];
    if ( [self.infoFromPicker selectedRowInComponent:0] == 0 )
    {
        self.memberInfoFrom.text = @"无";
    }
    else
    {
        self.memberInfoFrom.text = ((CDMemberSource*)self.memberSourceArray[[self.infoFromPicker selectedRowInComponent:0] - 1]).name;
    }
    
}

- (void)didDatePickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.memberBirthday.text = [dateFormatter stringFromDate:self.datePicker.date];
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
    
    if ( self.memberAddress.text.length != 0 && ![self.memberAddress.text isEqualToString:self.member.member_address] )
    {
        [params setObject:self.memberAddress.text forKey:@"street"];
    }
    
    [params setObject:@(1) forKey:@"is_ad"];
    if ( self.memberSourceArray.count > 0 && [self.infoFromPicker selectedRowInComponent:0] != 0 )
    {
        [params setObject:((CDMemberSource*)self.memberSourceArray[[self.infoFromPicker selectedRowInComponent:0] - 1]).source_id forKey:@"member_source"];
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
    }
    else
    {
        BSMemberCreateRequest *request = [[BSMemberCreateRequest alloc] initWithParams:params];
        [request execute];
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
    else if ([notification.name isEqualToString:kBSFetchMemberSourceResponse])
    {
        self.memberSourceArray = [[BSCoreDataManager currentManager] fetchMemberSource];
        [self.infoFromPicker reloadAllComponents];
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
                imagePicker.allowsEditing = YES;
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.memberSourceArray.count + 1;
}


#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( row == 0 )
        return @"无";
    
    return ((CDMemberSource*)self.memberSourceArray[row - 1]).name;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( row == 0 )
    {
        self.memberInfoFrom.text = @"无";
    }
    else
    {
        self.memberInfoFrom.text = ((CDMemberSource*)self.memberSourceArray[row - 1]).name;
    }
}

@end
