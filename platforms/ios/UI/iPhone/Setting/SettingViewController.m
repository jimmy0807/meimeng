//
//  SettingViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/4/2.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "SettingUpdatePwdViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "BSPersonalInfoRequest.h"
#import "BSUpdatePersonalInfoRequest.h"
#import "SettingHeadCell.h"
#import "BSEditCell.h"
#import "NSData+Additions.h"
#import "CBMessageView.h"
#import "ICCacheManager.h"
#import "LoginScrollViewController.h"
#import "CBRotateNavigationController.h"
#import "UINavigationBar+Background.h"
#import "MessageViewController.h"
#import "BNCheckNewVersionManager.h"
#import "NSDate+Formatter.h"
#import "CBLoadingView.h"
#import "BSPosSessionOperateRequest.h"
#import "BSFetchPosSessionRequest.h"

enum
{
    Profile_section = 0,
    Version_section = 1,
    LoginOut_section = 2,
};

NSInteger VersionRow_CheckUpdate = 0;
NSInteger VersionRow_About = 1;
NSInteger VersionRow_Count = 2;

enum{
    First_row = 0,
    Second_row,
    Third_row,
    Fourth_row,
    Profile_Row_Count,
};

enum{
    First_rowHeight = 80,
    Other_rowHeight = 50,
    SectionHeader_height = 20,
    Section_number = 3,
    Cell_number = 6,
};



#define SettingActionSheetPicTag        101
#define SettingActionSheetCasierTag     102
#define SettingActionSheetLogoutTag     103


#define SettingAlertViewCheckUpdateTag 201

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    NSInteger row_logout,row_cashier;
    BOOL isOpen; //是否为开账
}
@property(nonatomic,strong)PersonalProfile *profile;
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kBSFetchPersonalInfoResponse];
    [self registerNofitificationForMainThread:kBSUpdatePersonalInfoResponse];
    [self registerNofitificationForMainThread:kFetchUnReadMessageResponse];
    [self registerNofitificationForMainThread:kCheckNewVersionResponse];
    
    [self registerNofitificationForMainThread:kBSFetchPosSessionResponse];
    [self registerNofitificationForMainThread:kBSPosSessionOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchStartPosResponse];
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDict objectForKey:@"CFBundleIdentifier"];
    
    if ( ![identifier isEqualToString:@"com.born.boss"] )
    {
        VersionRow_About = 0;
        VersionRow_Count = 1;
    }
    
    //如果不是收银员收银关账不显示
    if ([PersonalProfile currentProfile].posID.integerValue > 0) {
        row_cashier = 0;
        row_logout = 1;
    }
    else
    {
        row_cashier = -1;
        row_logout = 0;
    }
    
    self.profile = [PersonalProfile currentProfile];
    [self initTableView];
}

- (void)initPersonalInfo
{
    self.profile = [PersonalProfile currentProfile];
    BSPersonalInfoRequest *request = [[BSPersonalInfoRequest alloc]initWithPersonalUserID:self.profile.userID];
    [request execute];
}

- (void)initTableView
{
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.imageName = [NSString stringWithFormat:@"%@_%@_ProfileHeadImage",self.profile.userID,self.profile.sql];
    self.infoTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.autoresizingMask = 0xff;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.view addSubview:self.infoTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initPersonalInfo];
    [self.infoTableView reloadData];
    self.tabBarController.navigationItem.title = @"设置";
    [self setNaviBackButtonItem];
    
    [[BNCheckNewVersionManager sharedManager] fetchServerVersion];
    
    [super viewWillAppear:animated];
}

- (void)setNaviBackButtonItem
{
    BNBackButtonItem *leftButtonItem;
    if ( [[BSCoreDataManager currentManager] fetchMessageLastCreateTime].length > 0 )
    {
        if ([[BSCoreDataManager currentManager] fetchUnReadMessage].count > 0)
        {
            leftButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_news_exist_n"] highlightedImage:[UIImage imageNamed:@"navi_news_exist_h"]];
        }
        else
        {
            leftButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_news_n"] highlightedImage:[UIImage imageNamed:@"navi_news_h"]];
        }
    }
    leftButtonItem.delegate = self;
    self.tabBarController.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)didBackBarButtonItemClick:(id)sender
{
    MessageViewController *viewController = [[MessageViewController alloc] initWithNibName:NIBCT(@"MessageViewController") bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchPersonalInfoResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] ==0)
        {
            self.profile = [PersonalProfile currentProfile];
            [self.infoTableView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchStartPosResponse] || [notification.name isEqualToString:kBSFetchPosSessionResponse] || [notification.name isEqualToString:kBSPosSessionOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            
            if (isOpen) {
                CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"开账成功"];
                [messageView show];
            }
            else
            {
                CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"关账成功"];
                [messageView show];
            }
            [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:LoginOut_section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rc"]];
            [messageView show];
        }
        
    }
    else if ([notification.name isEqualToString:kBSUpdatePersonalInfoResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue]==0)
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"修改成功" afterTimeHide:1.25];
            [message show];
        }
        else
        {
            CBMessageView *message = [[CBMessageView alloc]initWithTitle:[notification.userInfo objectForKey:@"rm"] afterTimeHide:1.25];
            [message show];
        }
    }
    else if ([notification.name isEqualToString:kFetchUnReadMessageResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self setNaviBackButtonItem];
        }
    }
    else if ( [notification.name isEqualToString:kCheckNewVersionResponse] )
    {
        [self.infoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:VersionRow_CheckUpdate inSection:Version_section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma infoTableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == Profile_section)
    {
        return Profile_Row_Count;
    }
    else if(section == Version_section)
    {
        return VersionRow_Count;
    }
    else
    {
        return row_logout + 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==Profile_section&&indexPath.row==First_row)
    {
        SettingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if(cell==nil)
        {
            cell = [[SettingHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
        cell.titleLabel.text = @"头像";
        [cell.headImageView setImageWithName:self.imageName tableName:@"res.users" filter:self.profile.userID fieldName:@"image" writeDate:[PersonalProfile currentProfile].writeDate placeholderString:@"setting_profile.png" cacheDictionary:[NSMutableDictionary dictionary] completion:nil];
        return cell;
    }
    else if(indexPath.section==Profile_section&&indexPath.row==Second_row)
    {
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell"];
        }
        cell.arrowImageView.hidden = NO;
        cell.titleLabel.text = @"姓名";
        cell.contentField.delegate = self;
        cell.contentField.enabled = YES;
        cell.contentField.text = self.profile.name;
        cell.contentField.placeholder = @"";
        return cell;
    }
    else if(indexPath.section==Profile_section&&indexPath.row == Third_row)
    {
//        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pwdCell"];
//        if(cell==nil)
//        {
//            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pwdCell"];
//        }
//        cell.titleLabel.text = @"更改密码";
//        cell.contentField.hidden = YES;

        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emailCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emailCell"];
        }
        cell.titleLabel.text = @"登录帐号(手机)";
        cell.arrowImageView.hidden = YES;
        cell.contentField.enabled = false;
        cell.contentField.delegate = self;
        cell.contentField.placeholder = @"";
        cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentField.text = self.profile.userName;
        
        return cell;
    }
    else if(indexPath.section==Profile_section&&indexPath.row==Fourth_row)
    {
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emailCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emailCell"];
        }
        
        cell.arrowImageView.hidden = NO;
        cell.titleLabel.text = @"邮箱";
        cell.contentField.enabled = YES;
        cell.contentField.delegate = self;
        cell.contentField.placeholder = @"";
        cell.contentField.text = self.profile.email;
        return cell;
    }
    else if (indexPath.section == Version_section )
    {
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        }
        
        if ( indexPath.row == VersionRow_About )
        {
            cell.titleLabel.text = @"关于";
            cell.arrowImageView.hidden = NO;
        }
        else
        {
            if ( [BNCheckNewVersionManager sharedManager].hasNewVersion )
            {
                cell.titleLabel.text = [NSString stringWithFormat:@"有最新版本(%@) 点我更新",[BNCheckNewVersionManager sharedManager].serverVersion];
                cell.arrowImageView.hidden = NO;
            }
            else
            {
                cell.titleLabel.text = [NSString stringWithFormat:@"已是最新版本(%@)",[BNCheckNewVersionManager sharedManager].localVersion];
                cell.arrowImageView.hidden = YES;
            }
        }
        
        cell.contentField.placeholder = @"";
        
        return cell;
    }
    else if(indexPath.section == LoginOut_section)
    {
        static NSString *CellIdentifier = @"AttributeValueCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.bounds = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, Other_rowHeight);
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_n"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bs_common_cell_h"]];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (Other_rowHeight - 20.0)/2.0, IC_SCREEN_WIDTH, 20.0)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
    
            titleLabel.tag = 101;
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, Other_rowHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:lineImageView];
        }
        
        UILabel *titleLabel = [cell.contentView viewWithTag:101];
        if (indexPath.row == row_cashier) {
            
            titleLabel.textColor = COLOR(18, 151, 254,1);
            PersonalProfile *profile = [PersonalProfile currentProfile];
        
            if (profile.sessionID.integerValue != 0)
            {
                titleLabel.text = @"收银关账";
            }
            else
            {
                titleLabel.text = @"收银开账";
            }
        }
        else if (indexPath.row == row_logout)
        {
            titleLabel.textColor = COLOR(247, 132, 133, 1.0);
            titleLabel.text = @"退出";
            
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==Profile_section&&indexPath.row == First_row)
   {
       return First_rowHeight;
   }
   else
   {
       return Other_rowHeight;
   }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeader_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if( indexPath.section==Version_section )
    {
        if ( indexPath.row == VersionRow_About )
        {
            AboutViewController *about = [[AboutViewController alloc]initWithNibName:NIBCT(@"AboutViewController") bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
        }
        else if ( indexPath.row == VersionRow_CheckUpdate )
        {
            if ( [BNCheckNewVersionManager sharedManager].hasNewVersion )
            {
                UIAlertView* view = [[UIAlertView alloc] initWithTitle:[BNCheckNewVersionManager sharedManager].serverVersion message:[BNCheckNewVersionManager sharedManager].versionDescription delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                view.tag = SettingAlertViewCheckUpdateTag;
                [view show];
            }
        }
    }
    else if(indexPath.section==Profile_section&&indexPath.row == Third_row)
    {
//        SettingUpdatePwdViewController *updatePwd = [[SettingUpdatePwdViewController alloc]initWithNibName:NIBCT(@"SettingUpdatePwdViewController") bundle:nil];
//        [self.navigationController pushViewController:updatePwd animated:YES];
    }
    else if (indexPath.section==Profile_section&&indexPath.row==First_row)
    {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [self showActionSheet];
    }
    else if(indexPath.section == LoginOut_section)
    {
        if (indexPath.row == row_cashier) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
             PersonalProfile *profile = [PersonalProfile currentProfile];
            
            NSString *title = nil;
            NSString *otherTitle = nil;
            NSString *destructTitle = nil;
            if (profile.sessionID.integerValue != 0)
            {
                if(profile.openDate)
                {
                    title = [NSString stringWithFormat:@"上次开账时间\n%@",[profile.openDate dateString]];
                }
                destructTitle = @"关账";

            }
            else
            {
                if(profile.openDate)
                {
                    title = [NSString stringWithFormat:@"上次关账时间\n%@",[profile.openDate dateString]];
                };
                otherTitle = @"开账";
                
            }

            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:destructTitle
                                                            otherButtonTitles:otherTitle,nil];
            actionSheet.tag = SettingActionSheetCasierTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else if (indexPath.row == row_logout) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LS(@"确定要退出吗？")
                                                                     delegate:self
                                                            cancelButtonTitle:LS(@"取消")
                                                       destructiveButtonTitle:LS(@"是的,退出")
                                                            otherButtonTitles:nil];
            actionSheet.tag = SettingActionSheetLogoutTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == SettingAlertViewCheckUpdateTag && buttonIndex == 1 )
    {
        [[BNCheckNewVersionManager sharedManager] update];
    }
}

#pragma ActionSheet
- (void)showActionSheet
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:First_row inSection:Profile_section];
    SettingHeadCell *cell = (SettingHeadCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    if(![cell.headImageView.image isEqual:[UIImage imageNamed:@"setting_profile.png"] ])
    {
        self.didUpdateImage = YES;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选取",@"删除上传", nil];
        actionSheet.tag = SettingActionSheetPicTag;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        self.didUpdateImage = NO;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选取", nil];
        actionSheet.tag = SettingActionSheetPicTag;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

#pragma actionSheet delegate 

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == SettingActionSheetPicTag)
    {
        int sourceType = 4;
        if(buttonIndex == 0)
        {
            if([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera ])
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        }
        else if (buttonIndex == 1)
        {
            if([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        else if (buttonIndex == 2&&self.didUpdateImage){
            [self updateProfileAttribute:@"" attributeName:@"image"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:First_row inSection:Profile_section];
            SettingHeadCell *cell = (SettingHeadCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
            cell.headImageView.image = [UIImage imageNamed:@"setting_profile.png"];
            
        }else
        {
            
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        if(sourceType!=4)
        {
            imagePicker.sourceType = sourceType;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if (actionSheet.tag == SettingActionSheetCasierTag)
    {
        if (buttonIndex == 0) {
            [[CBLoadingView shareLoadingView] show];
            PersonalProfile *profile = [PersonalProfile currentProfile];
            if (profile.sessionID.integerValue != 0)
            {
                isOpen = false;
                BSPosSessionOperateRequest *request = [[BSPosSessionOperateRequest alloc] initWithType:kBSPosSessionClose];
                [request execute];
            }
            else
            {
                isOpen = true;
                BSFetchPosSessionRequest *request = [[BSFetchPosSessionRequest alloc] init];
                [request execute];
            }
        }
    }
    else if (actionSheet.tag == SettingActionSheetLogoutTag)
    {
        if (buttonIndex == 0)
        {
            [PersonalProfile deleteProfile];
            LoginScrollViewController *loginScollVC = [[LoginScrollViewController alloc] initWithNibName:NIBCT(@"LoginScrollViewController") bundle:nil];
            CBRotateNavigationController *loginNav = [[CBRotateNavigationController alloc] initWithRootViewController:loginScollVC];
            [loginNav.navigationBar setCustomizedNaviBar:YES];
            [self performSelector:@selector(delayToSetSelect) withObject:nil afterDelay:0.3];
            
            [self.navigationController presentViewController:loginNav animated:NO completion:nil];
        }
    }
}

- (void)delayToSetSelect
{
    [self.tabBarController setSelectedIndex:0];
}

#pragma imagePickDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickImage = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(pickImage,0.6);
    NSString *imageDataString = [data base64Encoding];
    [self updateProfileAttribute:imageDataString attributeName:@"image"];
    [ICCacheManager saveCache:self.imageName fileData:data];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:First_row inSection:Profile_section];
    SettingHeadCell *cell = (SettingHeadCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    cell.headImageView.image = pickImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma update profile info

- (void)updateProfileAttribute:(NSString *)attribute attributeName:(NSString *)attributeName
{
    BSUpdatePersonalInfoRequest *request = [[BSUpdatePersonalInfoRequest alloc]initWithAttribute:attribute attributeName:attributeName];
    request.profile = self.profile;
    [request execute];
}

#pragma UITextFieldDelegate 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldShouldReturn:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *field = nil;
    BSEditCell *cell = nil;
    if(IS_SDK8)
    {
        cell = (BSEditCell *)[[textField superview] superview];
    }else
    {
        cell = (BSEditCell *)[[[textField superview] superview] superview];
    }
    
    if([cell.titleLabel.text isEqualToString:@"姓名"])
    {
        field = @"name";
        if(![cell.contentField.text isEqualToString:self.profile.name]&&![cell.contentField.text isEqualToString:@""])
        {
            self.profile.name = cell.contentField.text;
            [self updateProfileAttribute:textField.text attributeName:field];
        }
        else
        {
            cell.contentField.text = self.profile.name;
        }
    }
    else if ([cell.titleLabel.text isEqualToString:@"邮箱"])
    {
        field = @"email";
        if(![cell.contentField.text isEqualToString:self.profile.email]&&![cell.contentField.text isEqualToString:@""])
        {
            if([self isValidateEmail:textField.text])
            {
                self.profile.email = cell.contentField.text;
                [self updateProfileAttribute:textField.text attributeName:field];
            }
            else
            {
                CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"邮箱格式错误" afterTimeHide:1.25];
                [message show];
            }
        }
        else
        {
            cell.contentField.text = self.profile.email;
        }
    }
    else if ([cell.titleLabel.text isEqualToString:@"登录帐号(手机)"])
    {
        field = @"login";
        if(![cell.contentField.text isEqualToString:self.profile.userName]&&![cell.contentField.text isEqualToString:@""])
        {
            if([self isValidatePhoneNumber:textField.text])
            {
                self.profile.userName = cell.contentField.text;
                [self updateProfileAttribute:textField.text attributeName:field];
            }
            else
            {
                CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"手机格式错误" afterTimeHide:1.25];
                [message show];
            }
        }
        else
        {
            cell.contentField.text = self.profile.userName;
        }
    }

    [textField resignFirstResponder];
    return YES;
}

#pragma 验证邮箱格式
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

-(BOOL)isValidatePhoneNumber:(NSString *)phone
{
    if ( phone.length != 11 )
    {
        return FALSE;
    }
    return TRUE;
}

@end
