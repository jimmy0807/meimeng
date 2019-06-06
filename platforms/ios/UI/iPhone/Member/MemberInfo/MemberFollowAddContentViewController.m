//
//  MemberFollowAddContentViewController.m
//  Boss
//
//  Created by lining on 16/5/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberFollowAddContentViewController.h"
#import "BSEditCell.h"
#import "TextViewCell.h"
#import "BSFetchStaffRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBLoadingView.h"
#import "BSUpdateMemberFollowRequest.h"
#import "CBMessageView.h"
#import "NSDate+Formatter.h"

typedef enum kSection
{
    kSection_one = 0,
    kSection_two,
    kSection_num
}kSection;

typedef enum seciton_row_one
{
    section_row_name,
    section_row_guwen,
    section_row_shop,
    section_row_one_num
}seciton_row_one;


typedef enum section_row_two
{
    section_row_note,
    section_row_two_num
}section_row_two;

@interface MemberFollowAddContentViewController ()<UITextViewDelegate,BSCommonSelectedItemViewControllerDelegate>
{
    BNRightButtonItem *rightBtnItem;
}
@property (nonatomic, strong) CDMemberFollowContent *orignFollowContent;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) bool isChanged;
@property(nonatomic,strong)NSIndexPath *selectIndexPath;
@end

@implementation MemberFollowAddContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.params = [NSMutableDictionary dictionary];
    
    if (self.followContent) {
        self.type = kContentType_edit;
        self.navigationItem.title = self.followContent.name;
        [self orignFollowContent:self.followContent];
    }
    else
    {
        self.type = kContentType_create;
        self.navigationItem.title = @"新建跟进";
        self.followContent = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberFollowContent"];
        CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[PersonalProfile currentProfile].bshopId forKey:@"storeID"];
        self.followContent.shop_id  = store.storeID;
        self.followContent.shop_name = store.storeName;
        
        NSString *dateString = [[NSDate date] dateStringWithFormatter:@"yyyy-MM-dd"];
        self.followContent.name = [NSString stringWithFormat:@"%@跟进表",dateString];
        
        self.followContent.guwen_id = [PersonalProfile currentProfile].userID;
        self.followContent.guwen_name = [PersonalProfile currentProfile].userName;
        
        [self.params setObject:self.followContent.guwen_id forKey:@"employee_id"];
        [self.params setObject:self.followContent.shop_id forKey:@"shop_id"];
        [self.params setObject:self.followContent.name forKey:@"name"];
    }

    
    rightBtnItem= [[BNRightButtonItem alloc] initWithTitle:@"完成"];
    rightBtnItem.delegate = self;
    
   
    
    self.bgBtn.hidden = true;
    [self registerNofitificationForMainThread:kBSUpdateMemberFollowResponse];
}

- (void)orignFollowContent:(CDMemberFollowContent *)followCotnent
{
    if (!self.orignFollowContent) {
        self.orignFollowContent = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberFollowContent"];
    }
    self.orignFollowContent.name = followCotnent.name;
    self.orignFollowContent.note = followCotnent.note;
    self.orignFollowContent.guwen_id = followCotnent.guwen_id;
    self.orignFollowContent.guwen_name = followCotnent.guwen_name;
    self.orignFollowContent.shop_id = followCotnent.shop_id;
    self.orignFollowContent.shop_name = followCotnent.shop_name;
    
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.followContent.note.length == 0) {
//        TextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:section_row_note inSection:kSection_two]];
//        [cell.textView becomeFirstResponder];
//    }
    
    TextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:section_row_note inSection:kSection_two]];
    [cell.textView becomeFirstResponder];
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self handleFollowRequest];
}

#pragma mark - request
- (void)handleFollowRequest
{
    if (self.followContent.guwen_id == nil) {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"顾问不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return;

    }
    
    if (self.followContent.note.length == 0) {
        CBMessageView *message = [[CBMessageView alloc]initWithTitle:@"备注不能为空" afterTimeHide:0.75];
        [message showInView:self.view];
        return;
        
    }
    [[CBLoadingView shareLoadingView] show];
    NSMutableArray *array = [NSMutableArray array];
    if (self.type == kContentType_edit) {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataUpdate],self.followContent.content_id,self.params];
        [array addObject:subArray];
    }
    else if (self.type == kContentType_create)
    {
        NSArray *subArray = @[[NSNumber numberWithInt:kBSDataAdded],@0,self.params];
        [array addObject:subArray];
    }
     NSDictionary *dict = @{@"line_ids":array};
    
    BSUpdateMemberFollowRequest *reqeust = [[BSUpdateMemberFollowRequest alloc] initWithFollow:self.follow params:dict];
    [reqeust execute];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
     [[CBLoadingView shareLoadingView] hide];
    if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
        [[[CBMessageView alloc] initWithTitle:@"更改成功"] show];
        [self rollback];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1 afterDelay:0.75];
    }
    else
    {
        [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rm"]] show];
    }
   

   
}

#pragma mark - roll back

- (void)rollback
{
    [[BSCoreDataManager currentManager] rollback];
    [[BSCoreDataManager currentManager] deleteObject:self.orignFollowContent];
    [[BSCoreDataManager currentManager] save:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_one) {
        return section_row_one_num;
    }
    else if (section == kSection_two)
    {
        return section_row_two_num;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kSection_one) {
        NSString *cell_identifier = @"cell_identifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
            
            cell.contentField.delegate = self;
        }
        cell.contentField.enabled = false;
        cell.contentField.tag = indexPath.section * 100 + indexPath.row;
        cell.arrowImageView.hidden = false;
        if (row == section_row_name) {
            cell.arrowImageView.hidden = true;
            cell.titleLabel.text = @"名字";
            cell.contentField.enabled = true;
            cell.contentField.placeholder = @"请输入";
            
            
            if (self.followContent.name.length > 0) {
                cell.contentField.text = self.followContent.name;
            }
        }
        else if (row == section_row_guwen)
        {
            cell.titleLabel.text = @"跟进顾问";
//            cell.contentField.enabled = true;
            cell.contentField.placeholder = @"请选择";
            if (self.followContent.guwen_name.length > 0) {
                cell.contentField.text = self.followContent.guwen_name;
            }
        }
        else if (row == section_row_shop)
        {
            cell.titleLabel.text = @"跟进门店";
//            cell.contentField.enabled = true;
            cell.contentField.placeholder = @"请选择";
            if (self.followContent.shop_name.length > 0) {
                cell.contentField.text = self.followContent.shop_name;
            }
        }
       
        return cell;
    }
    else if (section == kSection_two)
    {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        if (cell == nil) {
            cell = [TextViewCell createCell];
            cell.textView.delegate = self;
        }
        cell.textView.text = self.followContent.note;
        return cell;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSection_one) {
        return 50;
    }
    else if (indexPath.section == kSection_two)
    {
        return 100;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    if (section == kSection_one) {
        
    }
    else if (section == kSection_two)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor grayColor];
        label.text = @"备注";
        [view addSubview:label];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.selectIndexPath = indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kSection_one) {
        
        if (row == section_row_name) {
            return;
        }
        BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        
        selectedView.delegate = self;
        if (row == section_row_guwen) {
            BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//            request.shopID = self.followContent.shop_id;
            [request execute];
            selectedView.notificationName = kBSFetchStaffResponse;
        }
        else if (row == section_row_shop)
        {
            
        }
        [self initCommonSelectedViewControllerData:selectedView];
        [self.navigationController pushViewController:selectedView animated:YES];
    }
    
}

- (void) initCommonSelectedViewControllerData:(BSCommonSelectedItemViewController *)selectedVC
{
    int section = self.selectIndexPath.section;
    int row  = self.selectIndexPath.row;
    
    if (section == kSection_one) {
        if (row == section_row_shop) {
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
            
            selectedVC.currentSelectIndex = [selectedVC.dataArray indexOfObject:self.followContent.shop_name];
        }
        else if (row == section_row_guwen)
        {
            NSArray *staffs = [[BSCoreDataManager currentManager] fetchStaffsWithShopID:nil];
            int currentIdx = -1;
            NSMutableArray *names = [NSMutableArray array];
            for (CDStaff *staff in staffs) {
                if ([staff.staffID integerValue] == [self.followContent.guwen_id integerValue]) {
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
    if (section == kSection_one) {
        if (row == section_row_guwen) {
            NSArray *staffs = userData;
            CDStaff *staff = [staffs objectAtIndex:index];
            self.followContent.guwen_id = staff.staffID;
            self.followContent.guwen_name = staff.name;
            if ([self.followContent.guwen_id  integerValue] == [self.orignFollowContent.guwen_id  integerValue])
            {
                [self.params removeObjectForKey:@"employee_id"];
            }
            else
            {
                [self.params setObject:self.followContent.guwen_id forKey:@"employee_id"];
            }
        }
        else if (row == section_row_shop)
        {
            NSArray *shops = userData;
            CDStore *store = [shops objectAtIndex:index];
           
            self.followContent.shop_name = store.storeName;
            self.followContent.shop_id = store.storeID;
            if ([self.followContent.shop_id integerValue] == [self.orignFollowContent.shop_id integerValue]) {
                [self.params removeObjectForKey:@"shop_id"];
            }
            else
            {
                [self.params setObject:self.followContent.shop_id forKey:@"shop_id"];
            }
        }
        self.isChanged = true;
        [self.tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(void)willReloadViewController:(BSCommonSelectedItemViewController *)contoller
{
    [self initCommonSelectedViewControllerData:contoller];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.bgBtn.hidden = false;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if (textView.text.length == 0) {
//        return;
//    }
    self.bgBtn.hidden = true;
    if (![self.followContent.note isEqualToString:textView.text]) {
        self.followContent.note = textView.text;
        if ([self.followContent.note isEqualToString:self.orignFollowContent.note])
        {
            [self.params removeObjectForKey:@"note"];
        }
        else
        {
            [self.params setObject:self.followContent.note forKey:@"note"];
        }
        self.isChanged = true;
    }

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.bgBtn.hidden = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.bgBtn.hidden = true;
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
    if (section == kSection_one) {
        if (row == section_row_name) {
            if (![self.followContent.name isEqualToString:textField.text]) {
                self.followContent.name = textField.text;
                if ([self.followContent.name isEqualToString:self.orignFollowContent.name])
                {
                    [self.params removeObjectForKey:@"name"];
                }
                else
                {
                    [self.params setObject:self.followContent.name forKey:@"name"];
                }
                self.isChanged = true;
            }
        }
    }
}


- (IBAction)hideKeyboard:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
