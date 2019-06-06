//
//  MemberQinyouDetailViewController.m
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberQinyouDetailViewController.h"
#import "SettingHeadCell.h"
#import "BSEditCell.h"
#import "MemberMarkCell.h"
#import "DatePickerView.h"
#import "BSImagePickerManager.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSUpdateMemberRequest.h"

typedef enum kInfoSection
{
    kInfoSectionOne,
    kInfoSectionTwo,
    kInfoSectionNum,
    kInfoSectionThree,
    
    
}kInfoSection;


typedef enum InfoSectionOneRow
{
    InfoSection_row_pic,
    InfoSection_row_name,
    InfoSection_row_birthday,
    InfoSection_row_gender,
    InfoSection_row_phone,
    InfoSectionOne_row_num,
}InfoSectionOneRow;


typedef enum InfoSectionTwoRow
{
    InfoSection_row_sharecard,
    InfoSection_row_code,
    InfoSectionTwo_row_num,
    InfoSection_row_remark,
    
}InfoSectionTwoRow;

typedef enum InfoSectionThreeRow
{
    InfoSection_row_note,
    InfoSectionThree_row_num,

}InfoSectionThreeRow;




@interface MemberQinyouDetailViewController ()<UIActionSheetDelegate,DatePickerViewDelegate,BSImagePickerManagerDelegate,BSCommonSelectedItemViewControllerDelegate>
{
    BNRightButtonItem *rightBtnItem;
}

@property (nonatomic, strong) UIImage *picImage;
@property (nonatomic,assign) BOOL isHaveImage;
@property (nonatomic, strong) CDMemberQinyou *orignQinyou;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) bool isChanged;
@property(nonatomic,strong)NSIndexPath *selectIndexPath;
@property(nonatomic, strong) DatePickerView *pickerView;
@end

@implementation MemberQinyouDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBBackButtonItem *backButtonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    
    if (self.qinyou) {
        self.type = QinyouType_edit;
    }
    
    if (self.type == QinyouType_create) {
        self.navigationItem.title = @"创建亲友";
        self.qinyou = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberQinyou"];
        self.qinyou.partner_id = self.member.memberID;
        self.qinyou.partner_name = self.member.memberName;
    }
    else
    {
        self.navigationItem.title = @"编辑亲友";
        self.navigationItem.title = self.qinyou.name;
        [self orignQinyou:self.qinyou];
        
    }

    [self registerNofitificationForMainThread:kBSUpdateMemberResponse];
    self.params = [NSMutableDictionary dictionary];
}


- (void)orignQinyou:(CDMemberQinyou *)qy
{
    if (!self.orignQinyou) {
        self.orignQinyou = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberQinyou"];
    }
    self.orignQinyou.name = self.qinyou.name;
    self.orignQinyou.birthday = self.qinyou.birthday;
    self.orignQinyou.gender = self.qinyou.gender;
    self.orignQinyou.telephone = self.qinyou.telephone;
    self.orignQinyou.card_id = self.orignQinyou.card_id;
    self.orignQinyou.card_no = self.orignQinyou.card_no;
    
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)setIsChanged:(bool)isChanged
{
    _isChanged = isChanged;
    if (self.params.allKeys.count > 0) {
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - CBBackButtonItemDelegate
- (void)didItemBackButtonPressed:(UIButton *)sender
{
    [self rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - roll back

- (void)rollback
{
    [[BSCoreDataManager currentManager] rollback];
    
    [[BSCoreDataManager currentManager] deleteObject:self.orignQinyou];
    [[BSCoreDataManager currentManager] save:nil];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    [self handleMemberRequest];
}


#pragma mark - request
- (void)handleMemberRequest
{
    if([self.qinyou.name isEqualToString:@""]||self.qinyou.name ==nil)
    {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"名字不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return;
    }

    [[CBLoadingView shareLoadingView] show];
    NSMutableArray *array = [NSMutableArray array];
    if (self.type == QinyouType_edit) {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataUpdate],self.qinyou.qy_id,self.params];
        [array addObject:subArray];
    }
    else if (self.type == QinyouType_create)
    {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataAdded],@0,self.params];
        [array addObject:subArray];
        
        
    }
    NSDictionary *dict = @{@"relatives_ids":array};

    BSUpdateMemberRequest *updateRequest = [[BSUpdateMemberRequest alloc]initWithMember:self.member params:dict];
    [updateRequest execute];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSUpdateMemberResponse]) {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo stringValueForKey:@"rc"] integerValue] == 0) {
            NSString *title;
            if (self.type == QinyouType_edit) {
                title = @"修改成功";
            }
            else
            {
                title = @"添加成功";
            }
            CBMessageView *messgae = [[CBMessageView alloc]initWithTitle:title afterTimeHide:0.75];
            [messgae showInView:self.view];
            
            [self rollback];
 
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:1.5];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kInfoSectionNum;
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
            
            [cell.headImageView setImageWithName:self.qinyou.image_name tableName:@"born.relatives" filter:self.qinyou.qy_id fieldName:@"image" writeDate:self.qinyou.last_update placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:^(UIImage *image) {
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
    else if (section == kInfoSectionTwo && row == InfoSection_row_remark)
    {
        MemberMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberMarkCell"];
        if (cell == nil) {
            cell = [MemberMarkCell createCell];
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
                cell.titleLabel.text = @"姓名";
                if (self.qinyou.name &&![self.qinyou.name isEqualToString:@"0"]) {
                    cell.contentField.text = self.qinyou.name;
                }
                cell.contentField.placeholder = @"请输入";
            }
            if (row == InfoSection_row_birthday) {
                cell.contentField.enabled =false;
                cell.titleLabel.text = @"生日";
                cell.contentField.placeholder = @"请选择";
                cell.arrowImageView.hidden = true;
                if (self.qinyou.birthday && ![self.qinyou.birthday isEqualToString:@"0"]) {
                    cell.contentField.text = self.qinyou.birthday;
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
                if ([self.qinyou.gender isEqualToString:@"Male"]) {
                    cell.contentField.text = @"男";
                }
                else if ([self.qinyou.gender isEqualToString:@"Female"])
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
            else if (row == InfoSection_row_phone)
            {
                cell.titleLabel.text = @"电话";
                if (self.qinyou.telephone && ![self.qinyou.telephone isEqualToString:@"0"]) {
                    cell.contentField.text = self.qinyou.telephone;
                }
                else
                {
                    cell.contentField.text = @"";
                }

                cell.contentField.placeholder = @"请输入";
            }
        }
        else if (section == kInfoSectionTwo)
        {
            if (row == InfoSection_row_sharecard)
            {
                cell.titleLabel.text = @"共享会员卡";

                if (self.qinyou.relative_card_no && ![self.qinyou.relative_card_no isEqualToString:@"0"]) {
                    cell.contentField.text = self.qinyou.relative_card_no;
                }
                else
                {
                    cell.contentField.text = @"";
                }

                cell.contentField.enabled = false;
                cell.arrowImageView.hidden = false;
                cell.contentField.placeholder = @"请选择";
            }
            if (row == InfoSection_row_code)
            {
                cell.titleLabel.text = @"卡识别码";
                if (self.qinyou.card_no && ![self.qinyou.card_no isEqualToString:@"0"]) {
                    cell.contentField.text = self.qinyou.card_no;
                }
                else
                {
                    cell.contentField.text = @"";
                }
                
                cell.contentField.placeholder = @"请输入";
                cell.contentField.enabled = true;
            }
        }
        else if (section == kInfoSectionThree)
        {
            
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
    else if (section == kInfoSectionTwo && row == InfoSection_row_remark)
    {
        return 120;
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
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.selectIndexPath = indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionOne && row == InfoSection_row_pic) {
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
    else if (section == kInfoSectionOne && row == InfoSection_row_birthday)
    {
        [self showDatePicker];
    }
    else
    {
        BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        selectedView.delegate = self;
        [self initCommonSelectedViewControllerData:selectedView];
        [self.navigationController pushViewController:selectedView animated:YES];
    }
    
    
    
}
#pragma mark - init CommonSelectedData
- (void) initCommonSelectedViewControllerData:(BSCommonSelectedItemViewController *)selectedVC
{
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    if (section == kInfoSectionOne)
    {
        if (row == InfoSection_row_gender) {
            selectedVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@"男",@"女"]];
            
            selectedVC.userData = selectedVC.dataArray;
            
            NSInteger currentIdx;
            if (self.qinyou.gender.length == 0) {
                currentIdx = -1;
            }
            else
            {
                if ([self.qinyou.gender isEqualToString:@"Male"])
                {
                    currentIdx = 0;
                }
                else
                {
                    currentIdx = 1;
                }
            }
            
            selectedVC.currentSelectIndex = currentIdx;
        }
    }
    else
    {
        if (row == InfoSection_row_sharecard) {
            NSArray *memberCards = self.member.card.array;
            selectedVC.userData = memberCards;
            selectedVC.dataArray = [NSMutableArray array];
            int currentIdx = -1;
            for (CDMemberCard *card in memberCards) {
                [selectedVC.dataArray addObject:card.cardNo];
                if ([self.qinyou.relative_card_no isEqualToString:card.cardNo]) {
                    currentIdx = [memberCards indexOfObject:card];
                }
            }
            
            selectedVC.currentSelectIndex = currentIdx;
            
        }
    }

}

#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    if (section == kInfoSectionOne)
    {
        if (row == InfoSection_row_gender)
        {
            NSArray *genders = userData;
            NSString *gender = [genders objectAtIndex:index];
            
            if ([gender isEqualToString:@"男"])
            {
                self.qinyou.gender = @"Male";
            }
            else
            {
                self.qinyou.gender = @"Female";
            }
            
            if ([self.qinyou.gender isEqualToString:self.orignQinyou.gender])
            {
                [self.params removeObjectForKey:@"gender"];
            }
            else
            {
                [self.params setObject:self.qinyou.gender forKey:@"gender"];
            }
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_sharecard)
        {
            NSArray *cards = userData;
            CDMemberCard *card = [cards objectAtIndex:index];
            self.qinyou.relative_card_no = card.cardNo;
            if ([self.qinyou.relative_card_no isEqualToString:self.orignQinyou.relative_card_no]) {
                [self.params removeObjectForKey:@"relatives_card_no"];
                [self.params removeObjectForKey:@"card_id"];
            }
            else
            {
                [self.params setObject:self.qinyou.relative_card_no forKey:@"relatives_card_no"];
                [self.params setObject:card.cardID forKey:@"card_id"];
            }
        }
    }
    self.isChanged = true;
    [self.tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    self.qinyou.birthday = dateString;
    if ([self.qinyou.birthday isEqualToString:self.orignQinyou.birthday]) {
        [self.params removeObjectForKey:@"birth_date"];
    }
    else
    {
        [self.params setObject:self.qinyou.birthday forKey:@"birth_date"];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:InfoSection_row_birthday inSection:kInfoSectionOne]] withRowAnimation:UITableViewRowAnimationNone];
    self.isChanged = true;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        if (self.isHaveImage)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSection_row_pic];
            SettingHeadCell *cell = (SettingHeadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.headImageView.image  = [UIImage imageNamed:@"setting_profile.png"];
            self.picImage = [UIImage imageNamed:@"setting_profile.png"];
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
    SettingHeadCell *cell = (SettingHeadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.picImage = image;
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
    self.qinyou.last_update = [dateFormatter stringFromDate:[NSDate date]];
}


#pragma mark - 
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return;
    }
    
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    
    if (section == kInfoSectionOne) {
        if (row == InfoSection_row_name) {
            if (![self.qinyou.name isEqualToString:textField.text]) {
                self.qinyou.name = textField.text;
                if ([self.qinyou.name isEqualToString:self.orignQinyou.name])
                {
                    [self.params removeObjectForKey:@"name"];
                }
                else
                {
                    [self.params setObject:self.qinyou.name forKey:@"name"];
                }
                self.isChanged = true;
            }
        }
        else if (row == InfoSection_row_phone) {
            if (![self.qinyou.telephone isEqualToString:textField.text]) {
                self.qinyou.telephone = textField.text;
                if ([self.qinyou.telephone isEqualToString:self.orignQinyou.telephone]) {
                    [self.params removeObjectForKey:@"mobile"];
                }
                else
                {
                    [self.params setObject:self.qinyou.telephone forKey:@"mobile"];
                }
                self.isChanged = true;
            }
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSection_row_code)
        {
            if (![self.qinyou.card_no isEqualToString:textField.text]) {
                self.qinyou.card_no = textField.text;
                if ([self.qinyou.card_no isEqualToString:self.orignQinyou.card_no]) {
                    [self.params removeObjectForKey:@"card_no"];
                }
                else
                {
                    [self.params setObject:self.qinyou.card_no forKey:@"card_no"];
                }
                self.isChanged = true;
            }
        }
    }
}



#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
