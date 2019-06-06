//
//  HZixunCreateViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HZixunCreateViewController.h"
#import "SeletctListViewController.h"
#import "ChineseToPinyin.h"
#import "HZixundanCreateRequest.h"
#import "CBLoadingView.h"

@interface HZixunCreateViewController ()

//add by ala 2017/04/27 layout design


@property(nonatomic, weak)IBOutlet UITextField* phoneLabel;  //电话
@property(nonatomic, weak)IBOutlet UITextField* nameLabel; //名称
@property(nonatomic, weak)IBOutlet UILabel* genderLabel; //性别
@property(nonatomic, weak)IBOutlet UISwitch* genderSwitch; //性别
@property(nonatomic, weak)IBOutlet UILabel* productLabel; //项目
@property(nonatomic, weak)IBOutlet UILabel* designerLabel; //设计师
@property(nonatomic, weak)IBOutlet UILabel* doctorsLabel; //医生
@property(nonatomic, weak)IBOutlet UILabel* employeeLabel;  //顾问
@property(nonatomic, weak)IBOutlet UITextView* conditionLabel;  //咨询内容
@property(nonatomic, weak)IBOutlet UITextView* adviceLabel; //处理意见

@property(nonatomic, strong)NSNumber* productId;
@property(nonatomic, strong)NSNumber* designerId;
@property(nonatomic, strong)NSNumber* doctorsId;
@property(nonatomic, strong)NSNumber* employeeId;

@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)NSArray* shgejishiArray;
@property(nonatomic, strong)NSArray* guwenArray;
@property(nonatomic, strong)NSArray* doctorArray;
@property(nonatomic, strong)NSArray* itemArray;
@property(nonatomic, strong)SeletctListViewController* selectVC;

@end

@implementation HZixunCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shopID = [PersonalProfile currentProfile].bshopId;
    
    self.nameLabel.text = self.zixun.name;
    self.phoneLabel.text=self.zixun.mobile;
    self.genderLabel.text = self.zixun.gender;
    self.productLabel.text = self.zixun.advisory_product_names;
    //性别genderSwitch
    //self.genderSwitch=zixun.
    self.designerLabel.text=self.zixun.designers_name;
    self.doctorsLabel.text=self.zixun.doctor_name;
    self.employeeLabel.text=self.zixun.employee_name;
    self.conditionLabel.text=self.zixun.condition;
    self.adviceLabel.text=self.zixun.advice;
    
    if ( [self.zixun.gender isEqualToString:@"Male"] )
    {
        self.self.genderSwitch.on = YES;
        self.genderLabel.text = @"男";
    }
    else
    {
        self.self.genderSwitch.on = NO;
        self.genderLabel.text = @"女";
    }
    
    [self registerNofitificationForMainThread:kHZixunCreateResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHZixunCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if ( [self.zixun.zixun_id integerValue] == 0 )
            {
                self.zixun.zixun_id = notification.object;
            }
            [[BSCoreDataManager currentManager] save:nil];
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
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
            
            if ( [self.zixun.zixun_id integerValue] == 0 )
            {
                [[BSCoreDataManager currentManager] deleteObject:self.zixun];
                self.zixun = nil;
            }
        }
 
    }
}

- (IBAction)didGenderChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.genderLabel.text = @"男";
    }
    else
    {
        self.genderLabel.text = @"女";
    }
}

- (void)didSaveButtonPressed
{
    CDHZixun* zixun = self.zixun;
    if ( zixun == nil )
    {
        zixun = [[BSCoreDataManager currentManager] insertEntity:@"CDHZixun"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.nameLabel.text forKey:@"name"];
    zixun.name = self.nameLabel.text;
    zixun.customer_name = self.nameLabel.text;
    
    zixun.nameLetter = [ChineseToPinyin pinyinFromChiniseString:zixun.name];
    zixun.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:zixun.name] uppercaseString];
    
    [params setObject:self.phoneLabel.text forKey:@"mobile"];
    zixun.mobile = self.phoneLabel.text;
    
    if ( self.genderSwitch.on )
    {
        [params setObject:@"Male" forKey:@"gender"];
        zixun.gender = @"Male";
    }
    else
    {
        [params setObject:@"Female" forKey:@"gender"];
        zixun.gender = @"Female";
    }
    
    if ( [self.productId integerValue] > 0 )
    {
        [params setObject:@[@[@(6),@(FALSE),@[self.productId]]] forKey:@"product_ids"];
        zixun.advisory_product_names = self.productLabel.text;
    }
    
    if ( [self.designerId integerValue]  > 0 )
    {
        [params setObject:self.designerId forKey:@"designers_id"];
        zixun.designers_id = self.designerId;
        zixun.designers_name = self.designerLabel.text;
    }

    if ( [self.doctorsId integerValue]  > 0 )
    {
        [params setObject:self.doctorsId forKey:@"doctor_id"];
        zixun.doctor_id = self.doctorsId;
        zixun.doctor_name = self.doctorsLabel.text;
    }
    
    if ( [self.employeeId integerValue]  > 0 )
    {
        [params setObject:self.employeeId forKey:@"employee_id"];
        zixun.employee_id = self.employeeId;
        zixun.employee_name = self.employeeLabel.text;
    }
    
    [params setObject:self.categoryName forKey:@"category"];
    zixun.category_name = self.categoryName;
    
    [params setObject:self.conditionLabel.text forKey:@"condition"];
    self.zixun.condition = self.conditionLabel.text;
    
    [params setObject:self.adviceLabel.text forKey:@"advice"];
    self.zixun.advice = self.adviceLabel.text;
    
    [[[HZixundanCreateRequest alloc] initWithMemberID:self.zixun.zixun_id params:params] execute];
    
    [[CBLoadingView shareLoadingView] show];
}

- (IBAction)didProjectButtonPressed:(id)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.itemArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDProjectItem* item = weakSelf.itemArray[index];
        return item.itemName;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDProjectItem* item = weakSelf.itemArray[index];
        weakSelf.productId = item.itemID;
        weakSelf.productLabel.text = item.itemName;
        //[weakSelf.tableView reloadData];
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didSheijshiButtonPressed:(id)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.shgejishiArray = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.shgejishiArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shgejishiArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = weakSelf.shgejishiArray[index];
        weakSelf.designerId = staff.staffID;
        weakSelf.designerLabel.text = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shgejishiArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didGuwenButtonPressed:(id)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.guwenArray = [[BSCoreDataManager currentManager] fetchGuwenStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.guwenArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.guwenArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = weakSelf.guwenArray[index];
        weakSelf.employeeId = staff.staffID;
        weakSelf.employeeLabel.text = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.guwenArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didDoctorButtonPressed:(id)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.doctorArray = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:self.shopID];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.doctorArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.doctorArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = weakSelf.doctorArray[index];
        weakSelf.doctorsId = staff.staffID;
        weakSelf.doctorsLabel.text = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.doctorArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

@end
