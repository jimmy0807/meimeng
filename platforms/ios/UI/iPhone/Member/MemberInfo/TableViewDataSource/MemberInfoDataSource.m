//
//  MemberInfoDataSource.m
//  Boss
//
//  Created by lining on 16/3/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberInfoDataSource.h"
#import "SettingHeadCell.h"
#import "BSEditCell.h"
#import "UIView+Frame.h"
#import "MemberCheckboxCell.h"
#import "UILabel+ColorFont.h"
#import "CBMessageView.h"

@interface MemberInfoDataSource ()<CheckBoxCellDelegate>
{
    bool expand;
    
//    UIImageView *arrowView;
//    UILabel *arrowLabel;
}
@property(strong, nonatomic) CDMember *member;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MemberInfoDataSource


- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.member = member;
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        if ([PersonalProfile currentProfile].roleOption == RoleOption_waiter && [PersonalProfile currentProfile].posID.integerValue == 0) {
            self.canEdit = false;
        }
        else
        {
            self.canEdit = true;
        }
        
        [self registerNofitificationForMainThread:kBSFetchMemberDetailResponse];
    }
    return self;
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberDetailResponse]) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (expand) {
        return kInfoSectionNum;
    }
    else
    {
        return kInfoSectionThree;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kInfoSectionOne) {
        return InfoSectionOne_row_num;
    }
    else if (section == kInfoSectionTwo)
    {
        return InfoSectionTwo_row_num;
    }
    else if (section == kInfoSectionThree)
    {
        return InfoSectionThree_row_num;
    }
    else if (section == kInfoSectionFour)
    {
        return InfoSectionFourRow_row_num;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kInfoSectionOne && row == InfoSection_row_pic) {
        static NSString *pic_cell = @"pic_cell";
        SettingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:pic_cell];
        if(cell==nil)
        {
            cell = [[SettingHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pic_cell];
        }
        
        cell.titleLabel.text = @"头像";
        if (self.picImage) {
            cell.headImageView.image = self.picImage;
        }
        else
        {
            __weak typeof(self) wself = self;
            [cell.headImageView setImageWithName:self.member.imageName tableName:@"born.member" filter:self.member.memberID fieldName:@"image" writeDate:self.member.lastUpdate placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:^(UIImage *image) {
                if (image == nil) {
                    wself.isHaveImage = false;
                }
                else
                {
                    wself.isHaveImage = true;
                }
            }];
        }
        return cell;
    }
    else if (section == kInfoSectionTwo && row == InfoSection_row_weika)
    {
        MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
        if (cell == nil) {
            cell = [MemberCheckboxCell createCell];
            cell.delegate = self;
            cell.canEdit = self.canEdit;
        }
        cell.canEdit = false;
        cell.indexPath = indexPath;
        cell.titleLabel.text = @"是否开通微卡";
        if ([self.member.isWevipCustom boolValue]) {
            cell.checkBoxImg.highlighted = true;
        }
        else
        {
            cell.checkBoxImg.highlighted = false;
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
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.contentField.delegate = self;
        }
        cell.contentField.enabled = true;
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        cell.arrowImageView.hidden = true;
        cell.contentField.placeholder = @"请输入";
        if (section == kInfoSectionOne) {
            if (row == InfoSection_row_name) {
                
                [cell.titleLabel setAttributeString:@"姓名 (必填)" colorString:@"(必填)" color:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                cell.contentField.text = self.member.memberName;
            }
            else if (row == InfoSection_row_no)
            {
                cell.titleLabel.text = @"会员编号";
                cell.contentField.text = self.member.memberNo;
            }
            else if (row == InfoSection_row_shop)
            {
                [cell.titleLabel setAttributeString:@"门店 (必填)" colorString:@"(必填)" color:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                cell.contentField.placeholder = @"请选择";
                cell.contentField.text = self.member.store.storeName;
                cell.contentField.enabled =false;
                cell.arrowImageView.hidden = true;
            }
            else if (row == InfoSection_row_phone)
            {
                [cell.titleLabel setAttributeString:@"电话 (必填)" colorString:@"(必填)" color:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                if (self.member.isWevipCustom.boolValue) {
                    cell.contentField.enabled = false;
                }
                else
                {
                    cell.contentField.enabled = true;
                }

                cell.contentField.text = self.member.mobile;
            }
            else if (row == InfoSectionRow_row_guwen)
            {
                cell.titleLabel.text = @"我的顾问";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                cell.contentField.enabled = false;
                if (self.member.member_guwen_name && ![self.member.member_guwen_name isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.guwen.name;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else if (row == InfoSectionRow_row_jishi)
            {
                cell.titleLabel.text = @"我的技师";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                cell.contentField.enabled = false;
                if (self.member.member_jishi_name && ![self.member.member_jishi_name isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.jishi.name;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
        }
        else if (section == kInfoSectionTwo)
        {
            if (row == InfoSection_row_birthday) {
                cell.contentField.enabled =false;
                cell.titleLabel.text = @"生日";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                if (self.member.birthday && ![self.member.birthday isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.birthday;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else if (row == InfoSection_row_gender)
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
                cell.contentField.enabled = false;
                cell.arrowImageView.hidden = false;
                cell.contentField.placeholder = @"请选择";
            }
            else if (row == InfoSection_row_weika)
            {
                cell.titleLabel.text = @"是否开通微卡";
                cell.contentField.text = @"是";
                cell.contentField.enabled = false;
            }
        }
        else if (section == kInfoSectionThree)
        {
            if (row == InfoSection_row_zhicheng) {
                cell.contentField.enabled = false;
                cell.arrowImageView.hidden = false;
                cell.titleLabel.text = @"职称";
                if (self.member.member_title_name && ![self.member.member_title_name isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_title_name;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                 cell.contentField.placeholder = @"请选择";
            }
            else if (row == InfoSection_row_qq)
            {
                cell.titleLabel.text = @"QQ号";
                if (self.member.member_qq && ![self.member.member_qq isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_qq;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                 cell.contentField.placeholder = @"请输入";
            }
            else if (row == InfoSection_row_weixin)
            {
                cell.titleLabel.text = @"微信号";
                if (self.member.member_wx && ![self.member.member_wx isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_wx;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else if (row == InfoSection_row_email)
            {
                cell.titleLabel.text = @"邮箱";
                if (self.member.email && ![self.member.email isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.email;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            else if (row == InfoSection_row_address)
            {
                cell.titleLabel.text = @"地址";
                if (self.member.member_address && ![self.member.member_address isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_address;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
            
            else if (row == InfoSection_row_date)
            {
                cell.titleLabel.text = @"登记日期";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                if (self.member.member_sign_date && ![self.member.member_sign_date isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_sign_date;
                }
                else
                {
                    cell.contentField.text = @"";
                }
            }
        }
        else if (section == kInfoSectionFour)
        {
            cell.arrowImageView.hidden = false;
            cell.contentField.enabled = false;
            cell.contentField.placeholder = @"请选择";
            if (row == InfoSectionRow_row_tuijian_vip) {
                cell.titleLabel.text = @"推荐人(会员)";
                cell.arrowImageView.hidden = false;
                cell.contentField.enabled = false;
                if (self.member.member_tuijian_vip_name && ![self.member.member_tuijian_vip_name isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_tuijian_vip_name;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                
            }
            else if (row == InfoSectionRow_row_tuijian_member)
            {
                cell.titleLabel.text = @"推荐人(员工)";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                cell.contentField.enabled = false;
                if (self.member.member_tuijian_staff_name && ![self.member.member_tuijian_staff_name isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_tuijian_staff_name;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                
            }
            else if (row == InfoSectionRow_row_fenlei)
            {
                cell.titleLabel.text = @"分类";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = false;
                cell.contentField.enabled = false;
                if (self.member.member_fenlei && ![self.member.member_fenlei isEqualToString:@"0"]) {
                    cell.contentField.text = self.member.member_fenlei;
                }
                else
                {
                    cell.contentField.text = @"";
                }

            }

        }
        if (!self.canEdit) {
            cell.contentField.enabled = false;
            cell.arrowImageView.hidden = true;
            cell.contentField.placeholder = @"暂无";
        }
        return cell;
    }
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == kInfoSectionOne && row == InfoSection_row_pic) {
        return 80;
    }
    else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == kInfoSectionTwo) {
        return 30;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];

    if (section == kInfoSectionTwo) {
        UIImage *arrow = [UIImage imageNamed:@"member_triangle_left.png"];
        UIImage *arrow_h = [UIImage imageNamed:@"member_triangle_up.png"];
        UIImageView *arrowView;
        if (!expand) {
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (30 - arrow.size.height)/2.0, arrow.size.width, arrow.size.height)];
        }
        else
        {
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (30 - arrow.size.height)/2.0, arrow_h.size.width, arrow_h.size.height)];
        }
        arrowView.image = arrow;
        arrowView.highlightedImage = arrow_h;
        [view addSubview:arrowView];
        
        UILabel *arrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrowView.right + 10, (30-20)/2.0, 100, 20)];
        arrowLabel.backgroundColor = [UIColor clearColor];
        arrowLabel.textColor = AppThemeColor;
        arrowLabel.textAlignment = NSTextAlignmentLeft;
        arrowLabel.text = @"更多信息";
        arrowLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:arrowLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(arrowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, 30);
        [view addSubview:btn];
        
        arrowView.highlighted = expand;
        if (!expand) {
            arrowLabel.text = @"更多信息";
        }
        else
        {
            arrowLabel.text = @"收起";
        }
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionOne) {
        if (row == InfoSection_row_name) {
            return;
        }
        else if (row == InfoSection_row_phone)
        {
            if (self.member.isWevipCustom.boolValue) {
                [[[CBMessageView alloc] initWithTitle:@"该客户已开通微卡，不能修改手机号码，如需更改，请客户在微卡app中修改"] show];
            }
            else
            {
                return;
            }
            
            return;
        }
        if (row == InfoSection_row_shop) {
            return;
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_phone || row == InfoSection_row_weika) {
            return;
        }
    }
    else if (section == kInfoSectionThree)
    {
        if (row != InfoSection_row_zhicheng) {
            return;
        }
    }
   
    if (!self.canEdit) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(didItemSelectedAtIndexPath:)]) {
        [self.delegate didItemSelectedAtIndexPath:indexPath];
    }
}
#pragma mark - arrow btn pressed
- (void)arrowBtnPressed:(UIButton *)btn
{
    expand = !expand;
    [self.tableView reloadData];
    if (expand) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:kInfoSectionThree];
        [indexSet addIndex:kInfoSectionFour];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    if ([self.delegate respondsToSelector:@selector(didEditTextField:atIndexPath:)]) {
        [self.delegate didEditTextField:textField atIndexPath:indexPath];
    }
}

#pragma mark - CheckBoxCellDelegate
- (void)didCheckboxSelected:(bool)selected indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didCheckBoxSelcted:atIndexPath:)]) {
        [self .delegate didCheckBoxSelcted:selected atIndexPath:indexPath];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
