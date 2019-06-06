//
//  PadBookRightViewController.m
//  meim
//
//  Created by jimmy on 2017/5/24.
//
//

#import "PadBookRightViewController.h"
#import "SeletctListViewController.h"
#import "PadDatePickerView.h"
#import "BSFetchMemberRequest.h"
#import "BSHandleBookRequest.h"
#import "NSDate+Formatter.h"
#import "MobileListVC.h"

@interface PadBookRightViewController ()
@property(nonatomic, weak)IBOutlet UISwitch* dianjiaSwitch;
@property(nonatomic, weak)IBOutlet UISwitch* anestheticSwitch;
@property(nonatomic, weak)IBOutlet UISwitch* checkSwitch;
@property(nonatomic, weak)IBOutlet UILabel* categoryLabel;
@property(nonatomic, weak)IBOutlet UILabel* itemLabel;
@property(nonatomic, weak)IBOutlet UILabel* shejishiLabel;
@property(nonatomic, weak)IBOutlet UILabel* shejishi2Label;
@property(nonatomic, weak)IBOutlet UILabel* shejizongjianLabel;
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;
@property(nonatomic, weak)IBOutlet UILabel* startTimeLabel;
@property(nonatomic, weak)IBOutlet UILabel* endTimeLabel;

//2017年9月预约新增推荐人修改 cell的第二个label
@property (weak, nonatomic) IBOutlet UILabel *referralsLabel;
///名字输入框后面的删除按钮 主要是为了想改名字时用
@property (weak, nonatomic) IBOutlet UIButton *nameTextFiledCanclBtn;

@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, strong)NSNumber* shopID;
@end

@implementation PadBookRightViewController

#pragma mark - phoneNumberTextField监听
- (void)EditingDidBegin:(UITextField*)textField{
    //NSLog(@"EditingDidBegin textFieldkeytype = %d text=%@", textField.keyboardType,textField.text);
    
    ///清空电话框
    if (self.phoneNumberTextField==textField) {
        if (self.nameTextField.text.length!=0) {
            
            return;
        }
        else{
            
            //self.phoneNumberTextField.text = nil;
            //self.nameTextField.text = nil;
            self.nameTextField.enabled=YES;
        }
        
     
    }
    else if(self.nameTextField == textField){
        self.nameTextField.enabled = YES;
    }
    

}

- (void)EditingDidEnd:(UITextField*)textField {
    //NSLog(@"EditingDidEnd textField = %@", textField);
    
    if (textField.text.length<11) {
        self.nameTextField.enabled = YES;
    }
    if (textField.text.length == 0) {
        self.nameTextField.enabled = YES;
        return;
    }
    if ( self.phoneNumberTextField == textField )
    {
        self.book.telephone = textField.text;
        ///根据电话号码找会员
        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"mobile == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
        
        if (member)
        {
            self.book.booker_name = member.memberName;
            self.book.member_id = member.memberID;
            self.nameTextField.text = member.memberName;
            self.nameTextField.textColor = [UIColor grayColor];
            [self reloadData:member];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.nameTextField resignFirstResponder];
                [self.nameTextField endEditing:YES];
                self.nameTextField.enabled=NO;
                self.nameTextField.textColor = [UIColor grayColor];
                
                ///显示X按钮
                self.nameTextFiledCanclBtn.hidden = NO;
            });
        }
        else
        {
            if ( textField.text.length == 11 )
            {
                BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
                [request execute];
            }
        }
    }
    self.infoDidChanged = YES;
}

-(void)nameTextfieldEditingDidEnd:(UITextField*)textField {
    
    //NSLog(@"nameTextfieldEditingDidEnd %@",self.phoneNumberTextField.text);
    self.infoDidChanged = YES;
    if ([self.phoneNumberTextField.text isEqualToString:@""]||self.phoneNumberTextField.text==nil||self.phoneNumberTextField.text.length==0)
    {
        
        if (textField.text.length == 0) {
            
            return;
        }
        if ( self.nameTextField == textField )
        {
            self.book.name = textField.text;
            NSArray* members = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString2:[NSString stringWithFormat:@"memberName == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
            
            if (members.count>0)
            {
                if (members.count==1) {
                    CDMember *member = [members firstObject];

                    /// 如果名字==手机号码==
                    if (([self.nameTextField.text isEqualToString:member.mobile]&&[member.mobile isEqualToString:member.memberName]) || [self.nameTextField.text isEqualToString:member.memberName]) {
                        
                        self.book.telephone = member.mobile;
                        self.book.member_id = member.memberID;
                        self.book.booker_name = member.memberName;
                        self.phoneNumberTextField.text = member.mobile;
                        //NSLog(@"nameTextfieldEditingDidEnd %@",self.phoneNumberTextField.text);
                        self.nameTextField.textColor = [UIColor grayColor];
                        [self reloadData:member];
                        self.nameTextField.enabled = NO;
                        
                        self.nameTextFiledCanclBtn.hidden = NO;
                    }
                    else{
                        /// 如果名字!=手机号码
                        
                        
                        return;
                    }
                }
                else if (members.count>1){
                    //名字查手机号
                    NSMutableArray *membersArr = [NSMutableArray array];
                    //NSMutableArray *memberIds  = [NSMutableArray array];
                    for (CDMember *member in members) {
                        //NSLog(@"member.memberName=%@",member.memberName);
                        //不区分搜索关键字大小写
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",self.nameTextField.text];
                        if ([@[member.memberName] filteredArrayUsingPredicate:predicate].count>0) {
                            NSLog(@"member - mobile类型=%@",[member.mobile class]);
                            
                            //这句一写就崩
                            [membersArr addObject:member];
                            
                        }
                    }
                    [self popMobileList:membersArr];
                }
                
            }
            else
            {
                BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
                [request execute];
            }
        }
    }
    else{
        
//        self.phoneNumberTextField.text=nil;
//        self.nameTextField.text = nil;
        //补充完名字会走这里
        return;
    }
    
}

-(void)phoneNumberTextFieldChange :(UITextField*)textField{
    NSLog(@"phoneNumberTextFieldChange %@",textField.text);
    self.infoDidChanged = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSLog(@"shouldChangeCharactersInRange %@--%d",textField.text,textField.text.length);
    ///当输入11位手机号码最后一位时，打印长度10
    if (textField==self.phoneNumberTextField && textField.text.length<12) {
        self.nameTextField.enabled = YES;
        self.nameTextField.textColor = [UIColor blackColor];
        
        if (textField.text.length==10) {
            NSLog(@"shouldChangeCharactersInRange 11位啦");
//            self.book.telephone = self.phoneNumberTextField.text;
//            self.book.name = self.nameTextField.text;
            
        }
        else if(textField.text.length==11){
            ///当手机号是11位时 再往回删一位，会打印length = 11
            self.book.member_id = nil; ///这句代码是为了修复: 如果不存在该手机号会员就新建
//            self.nameTextField.enabled = YES;
//            self.nameTextField.textColor = [UIColor blackColor];
//            self.nameTextFiledCanclBtn.hidden = YES;
        }
    }
    return YES; // 能改变输入框的值
}

///当名字输入框后面的按钮被点击 清空手机和名字输入框 重置可输入状态
-(void)nameTextFiledCanclBtnPressed {
    self.nameTextField.text = nil;
    self.phoneNumberTextField.text = nil;
    self.nameTextField.enabled = YES;
    self.phoneNumberTextField.enabled = YES;
    self.nameTextFiledCanclBtn.hidden = YES;
    self.nameTextField.textColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ///名字输入框后面的删除按钮
    self.nameTextFiledCanclBtn.hidden = YES;
    [self.nameTextFiledCanclBtn addTarget:self action:@selector(nameTextFiledCanclBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    //控制光标在任意位置
    //self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    /*
     UIControlEventEditingDidBegin
     UIControlEventEditingChanged
     UIControlEventEditingDidEnd
     UIControlEventEditingDidEndOnExit
     */
    /**** 占位文字的监听 ****/
    
    //UIControlEventValueChanged
    [self.phoneNumberTextField addTarget:self action:@selector(phoneNumberTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    // addTarget可以多次添加,但是代理只能有一个,因为一个是add方法,一个set方法
    [self.phoneNumberTextField addTarget:self action:@selector(EditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.phoneNumberTextField addTarget:self action:@selector(EditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.nameTextField addTarget:self action:@selector(EditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.nameTextField addTarget:self action:@selector(nameTextfieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.shopID = [PersonalProfile currentProfile].bshopId;
    
    if ( self.book )
    {
        if (self.book.telephone.length!=0) {
            //已存在预约电话号码和名字都不能改
            self.phoneNumberTextField.enabled=NO;
            self.nameTextField.enabled=NO;
            self.nameTextField.textColor = [UIColor grayColor];
            self.phoneNumberTextField.textColor = [UIColor grayColor];
        }
        self.nameTextField.text = self.book.booker_name;
        self.phoneNumberTextField.text = self.book.telephone;
        self.dianjiaSwitch.on = [self.book.is_partner boolValue];
        self.anestheticSwitch.on = [self.book.is_anesthetic boolValue];
        self.checkSwitch.on = [self.book.is_checked boolValue];
        //self.nameTextField.textColor = [UIColor grayColor];
        NSLog(@"%@-%@-%@",self.book.booker_name,self.book.name,self.book.member_name);
        //测试1oo - BK32811711280743 - 测试113
        NSLog(@"%@%d",self.book.member_type,self.book.member_type.length);//0 1
//        if ( self.book.member_type.length > 0 )
//        {
//            self.categoryLabel.text = self.book.member_type;
//        }
        if ([self.book.member_type isEqualToString:@"0"]||self.book.member_type.length==1) {
            self.categoryLabel.text = @"";
        }
        else{
            self.categoryLabel.text = self.book.member_type;
        }
        
        NSArray* ids = [self.book.product_ids componentsSeparatedByString:@","];
        if ( ids.count > 0 )
        {
            CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:ids[0] forKey:@"itemID"];
            self.itemLabel.text = item.itemName;
        }
        
        self.shejishiLabel.text = self.book.designers_name;
        self.shejishi2Label.text = self.book.designers_service_name;
        self.shejizongjianLabel.text = self.book.director_employee_name;
        self.doctorLabel.text = self.book.doctor_name;
        self.startTimeLabel.text = self.book.start_date;
        self.endTimeLabel.text = self.book.end_date;
        self.remarkTextView.text = self.book.mark;
        
        //9月预约新增"推荐人" 需要在初始化的时候赋值 因为编辑某个已存在的预约时需要显示已存在数据
        //self.referralsLabel.text = self.book.recommend_member_phone;
        
        //新代码
        if ([self.book.recommend_member_phone isEqualToString:@"0"] || self.book.recommend_member_phone.length == 0) {
            self.referralsLabel.text = @"";
            
        }else{
            self.referralsLabel.text = self.book.recommend_member_phone;
        }
    }
    self.infoDidChanged = NO;
    //    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotificationOnMainThread:kBSFetchMemberResponse];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (IBAction)didCategryButtonPressed:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    
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
        NSString* type = array[index];
        weakSelf.book.member_type = [type lowercaseString];
        weakSelf.categoryLabel.text = weakSelf.book.member_type;
        weakSelf.infoDidChanged = YES;
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didItemButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return itemArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDProjectItem* item = itemArray[index];
        return item.itemName;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDProjectItem* item = itemArray[index];
        weakSelf.book.product_ids = [item.itemID stringValue];
        weakSelf.book.product_name = item.itemName;
        weakSelf.itemLabel.text = item.itemName;
        weakSelf.infoDidChanged = YES;
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didShejishiButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* staffArray = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return staffArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = staffArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = staffArray[index];
        weakSelf.book.designers_name = staff.name;
        weakSelf.book.designers_id = staff.staffID;
        weakSelf.shejishiLabel.text = staff.name;
        weakSelf.infoDidChanged = YES;
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didShejishi2ButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* staffArray = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return staffArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = staffArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = staffArray[index];
        weakSelf.book.designers_service_name = staff.name;
        weakSelf.book.designers_service_id = staff.staffID;
        weakSelf.shejishi2Label.text = staff.name;
        weakSelf.infoDidChanged = YES;
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didShejizongjianButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* staffArray = [[BSCoreDataManager currentManager] fetchShejizongjianStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return staffArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = staffArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = staffArray[index];
        weakSelf.book.director_employee_name = staff.name;
        weakSelf.book.director_employee_id = staff.staffID;
        weakSelf.shejizongjianLabel.text = staff.name;
        weakSelf.infoDidChanged = YES;
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didDoctorButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* staffArray = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return staffArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = staffArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = staffArray[index];
        weakSelf.book.doctor_name = staff.name;
        weakSelf.book.doctor_id = staff.staffID;
        weakSelf.doctorLabel.text = staff.name;
        weakSelf.infoDidChanged = YES;
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

//2017年9月预约新增推荐人修改 推荐人按钮 点击按钮会浮现另一个选择ListView 都是一样的 改变下数据源就可以了
- (IBAction)didReferralsButtonPressed:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    _rdpV = [[RecommedDetailPhoneNumberView alloc]init];
    _rdpV.view.backgroundColor = [UIColor clearColor];
    _rdpV.view.frame = mainWindow.bounds;
    NSLog(@"_rdpV.view = %@",_rdpV.view);
    
    self.referralsLabel.textAlignment = NSTextAlignmentRight;
    WeakSelf;
    _rdpV.textFieldPhoneBlock = ^(NSString * text) {
        weakSelf.referralsLabel.text = text;
        weakSelf.book.recommend_member_phone = text;
        weakSelf.infoDidChanged = YES;
    };
    [mainWindow addSubview:_rdpV.view];
    
}

- (IBAction)didStartTimeButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    if ( self.book.start_date.length > 0 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        v.date = [dateFormat dateFromString:self.book.start_date];
    }
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.startTimeLabel.text = dateString;
        weakSelf.book.start_date = dateString;
        weakSelf.infoDidChanged = YES;

        CDStaff *technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.book.technician_id forKey:@"staffID"];
        if ( [technician.book_time integerValue] > 0 )
        {
            NSDate* endDate = [date dateByAddingTimeInterval:[technician.book_time integerValue] * 60];
            weakSelf.book.end_date = [endDate dateString];
            weakSelf.endTimeLabel.text = weakSelf.book.end_date;
        }
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didEndTimeButtonPressed:(id)sender
{
    CDStaff *technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.book.technician_id forKey:@"staffID"];
    if ( [technician.book_time integerValue] > 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请修改开始时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    if ( self.book.end_date.length > 0 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        v.date = [dateFormat dateFromString:self.book.end_date];
    }
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.endTimeLabel.text = dateString;
        weakSelf.book.end_date = dateString;
        weakSelf.infoDidChanged = YES;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didGenderChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.book.is_partner = @(TRUE);
    }
    else
    {
        self.book.is_partner = @(FALSE);
    }
    self.infoDidChanged = YES;
}

- (IBAction)didAnestheticChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.book.is_anesthetic = @(TRUE);
    }
    else
    {
        self.book.is_anesthetic = @(FALSE);
    }
    self.infoDidChanged = YES;
}

- (IBAction)didCheckChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.book.is_checked = @(TRUE);
    }
    else
    {
        self.book.is_checked = @(FALSE);
    }
    self.infoDidChanged = YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField.text.length == 0) {
//        return;
//    }
//    
//    if ( self.nameTextField == textField )
//    {
//        //        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"memberName == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
//        //
//        //        if (member)
//        //        {
//        //            self.book.telephone = member.mobile;
//        //            self.book.member_id = member.memberID;
//        //            self.book.booker_name = member.memberName;
//        //            self.phoneNumberTextField.text = member.mobile;
//        //            [self reloadData:member];
//        //        }
//        //        else
//        //        {
//        //            BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
//        //            [request execute];
//        //        }
//    }
//    else if ( self.phoneNumberTextField == textField )
//    {
//        self.book.telephone = textField.text;
//        
//        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"mobile == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
//        
//        if (member)
//        {
//            self.book.booker_name = member.memberName;
//            self.book.member_id = member.memberID;
//            self.nameTextField.text = member.memberName;
//            [self reloadData:member];
//        }
//        else
//        {
//            if ( textField.text.length == 11 )
//            {
//                BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
//                [request execute];
//            }
//        }
//    }
//}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0) {
            NSArray *retArray = notification.object;
            if (retArray.count > 0)
            {
                NSLog(@"self.phoneNumberTextField.text = %d",self.phoneNumberTextField.text.length);//0
                if (self.phoneNumberTextField.text.length != 0)
                {
                    //手机号查名字
                    CDMember *member = retArray[0];
                    
                    if (![member.memberName isEqualToString:self.nameTextField.text]) {
                        if (self.book.telephone == member.mobile)
                        {
                            return;
                        }
                        self.book.telephone = member.mobile;
                        self.book.booker_name = member.memberName;
                        self.book.member_id = member.memberID;
                        self.phoneNumberTextField.text = member.mobile;
                        self.nameTextField.text = member.memberName;
                        self.nameTextField.textColor = [UIColor grayColor];
                        self.nameTextFiledCanclBtn.hidden = NO;
                        [self reloadData:member];
                        
                        ///填充了昵称
                        //self.nameTextField.enabled = NO;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self.nameTextField resignFirstResponder];
                            [self.nameTextField endEditing:YES];
                            self.nameTextField.enabled=NO;
                            self.nameTextField.textColor = [UIColor grayColor];
                            self.nameTextFiledCanclBtn.hidden = NO;
                        });
                    }
                    
                    
                }
                else{
                    
                    if (retArray.count == 1) {
                        
                        CDMember *member = [retArray firstObject];
                        
                        /// 如果名字==手机号码==会员名字 满足此条件 自动填充
                        if ([self.nameTextField.text isEqualToString:member.mobile]&&[member.mobile isEqualToString:member.memberName]) {
                            
                            self.book.telephone = member.mobile;
                            self.book.member_id = member.memberID;
                            self.book.booker_name = member.memberName;
                            self.phoneNumberTextField.text = member.mobile;
                            //NSLog(@"nameTextfieldEditingDidEnd %@",self.phoneNumberTextField.text);
                            self.nameTextField.textColor = [UIColor grayColor];
                            [self reloadData:member];
                            self.nameTextField.enabled = NO;
                            self.nameTextFiledCanclBtn.hidden = NO;
                            
                        }
                        else{
                            /**
                             名字!=手机号码 在名字框输入了手机号码
                             (第一次搜某个人名字也会走这里)
                             */
                            if([member.memberName isEqualToString:self.nameTextField.text]){
                                //NSLog(@"当前线程%@",[NSThread currentThread]);
                                self.book.telephone = member.mobile;
                                self.book.member_id = member.memberID;
                                self.book.booker_name = member.memberName;
                                self.phoneNumberTextField.text = member.mobile;
                                //NSLog(@"nameTextfieldEditingDidEnd %@",self.phoneNumberTextField.text);
                                self.nameTextField.textColor = [UIColor grayColor];///第一次搜素某人名字 设置颜色无效

                                [self reloadData:member];
                                self.nameTextField.enabled = NO;
                                self.nameTextFiledCanclBtn.hidden = NO;
                            }
                            else {
                                return;
                            }
                        
                        }
                        
                    }
                    else if (retArray.count > 1){
                        //名字查手机号
                        NSMutableArray *members = [NSMutableArray array];
                        for (CDMember *member in retArray)
                        {
                            NSLog(@"member - mobile=%@",member.mobile);
                            ///完全相同才符合条件
                            if ([member.memberName isEqualToString:self.nameTextField.text]) {
                                [members addObject:member];
                            }
                            
                            
                        }
                        //self.mobileArray = (NSArray *)mobiles;
                        //[self popMobileList:mobiles];
                        if (members.count>0) {
                            [self popMobileList:(NSArray *)members];
                        }else{
                            return;
                        }
                        
                    }
                    }
                
            }
            else{
                ///未填充昵称
                if (self.nameTextField.text.length!=0)
                {
                    return;
                }
                else
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                    });
                    self.nameTextField.enabled=YES;
                    [self.nameTextField endEditing:NO];
                    [self.nameTextField becomeFirstResponder];
                }
                
            }
        }
    }
}



- (IBAction)didDeleteButtonPressed:(id)sender
{
    self.deleteButtonPressed();
}

- (void)reloadData:(CDMember*)member
{
    if ( member )
    {
        self.shejishiLabel.text = member.member_shejishi_name;
        self.shejizongjianLabel.text = member.director_employee;
        self.doctorLabel.text = member.doctor_name;
        self.categoryLabel.text = member.yimei_member_type;
        
        self.book.doctor_name = member.doctor_name;
        self.book.doctor_id = member.doctor_id;
        self.book.designers_id = member.member_shejishi_id;
        self.book.designers_name = member.member_shejishi_name;
        self.book.director_employee_id = member.director_employee_id;
        self.book.director_employee_name = member.director_employee;
        
        self.book.member_type = member.yimei_member_type;
        
        ///预约推荐人不能为0修改
        
        //9月预约新增"推荐人" 需要在初始化的时候赋值 因为编辑某个已存在的预约时需要显示已存在数据
        //老代码
        //self.referralsLabel.text = self.book.recommend_member_phone;
        
        //新代码
        if ([self.book.recommend_member_phone isEqualToString:@"0"] || self.book.recommend_member_phone.length == 0) {
            self.referralsLabel.text = @"";
            
        }else{
            self.referralsLabel.text = self.book.recommend_member_phone;
        }
    }
}

- (CDMember*)fetchMember
{
    if ( self.phoneNumberTextField.text.length > 0 )
    {
        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"mobile == \"%@\"",self.phoneNumberTextField.text]];
        
        return member;
    }
    
    return nil;
}

//-(void)popMobileList:(NSArray *)mobileArray{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
//    MobileListVC *mobileListVC = [[MobileListVC alloc]init];
//    mobileListVC.mobileArray = mobileArray;
//    mobileListVC.returnTextBlock = ^(NSString *showText) {
//        self.phoneNumberTextField.text=showText;
//        self.nameTextField.enabled=NO;
//    };
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.phoneNumberTextField resignFirstResponder];
//    });
//    mobileListVC.view.frame = mainWindow.bounds;
//    [self.parentViewController addChildViewController:mobileListVC];
//    [self.parentViewController.view addSubview:mobileListVC.view];
//
//}
-(void)popMobileList:(NSArray *)members{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    MobileListVC *mobileListVC = [[MobileListVC alloc]init];
    mobileListVC.members = members;
    
    WeakSelf
    mobileListVC.returnTextBlock = ^(NSString *showText, CDMember *member) {
        
        if ([showText isKindOfClass:[NSString class]]) {
            ///这句话作用是 如果不存在，手动输入名字就会在会员中心新建一位会员
            self.book.telephone = member.mobile;
            self.book.booker_name = member.memberName;
            
            weakSelf.book.member_id = member.memberID;
            weakSelf.phoneNumberTextField.text=showText;
            weakSelf.nameTextField.enabled=NO;
            
            ///补充了名字 输入框变灰
            weakSelf.nameTextField.text = member.memberName;
            weakSelf.nameTextField.textColor = [UIColor grayColor];
            
            weakSelf.nameTextFiledCanclBtn.hidden = NO;
            
            ///这个方法中会自动填充设计师 客户类别...
            [self reloadData:member];
        }
        
        
        //self.nameTextField.backgroundColor = [UIColor lightGrayColor];
//        for (id sub in self.nameTextField.superview.subviews) {
//            //NSLog(@"补充了名字 输入框变灰%@",sub);
//            if ([sub isKindOfClass:[UIButton class]]) {
//                UIButton *subButton = (UIButton *)sub;
//                subButton.backgroundColor = COLOR(228, 228, 228, 1                                                                                                                                                                                                                                           );
//                [subButton setBackgroundImage:[UIImage imageNamed:@"h_cell_bg_m                                                                                                                                                                                 "] forState:UIControlStateNormal];
//            }
//        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.phoneNumberTextField resignFirstResponder];
    });
    mobileListVC.view.frame = mainWindow.bounds;
    [self.parentViewController addChildViewController:mobileListVC];
    [self.parentViewController.view addSubview:mobileListVC.view];
    
}
@end
