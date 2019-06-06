//
//  HPatientCreateViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientCreateViewController.h"
#import "BSMemberCreateRequest.h"
#import "CBLoadingView.h"
#import "PadDatePickerView.h"
#import "SeletctListViewController.h"

@interface HPatientCreateViewController ()

@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, weak)IBOutlet UITextField* nameLabel; //姓名
@property(nonatomic, weak)IBOutlet UISwitch* genderSwitch; //性别
@property(nonatomic, weak)IBOutlet UITextField* doctorLabel; //医生
@property(nonatomic, weak)IBOutlet UILabel* genderLabel; //性别
@property(nonatomic, weak)IBOutlet UITextField* ageLabel; //年龄
@property(nonatomic, weak)IBOutlet UITextField* mobileLabel; //电话
@property(nonatomic, weak)IBOutlet UITextField* IdentityLabel; //身份证
@property(nonatomic, weak)IBOutlet UITextField* streetLabel; //地址
@property(nonatomic, strong)NSNumber* memberID;
@end

@implementation HPatientCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.member.memberName;
    if ( [self.member.gender isEqualToString:@"Male"] )
    {
        self.genderLabel.text = @"男";
        self.genderSwitch.on = TRUE;
    }
    else
    {
        self.genderLabel.text = @"女";
        self.genderSwitch.on = FALSE;
    }
    
    self.ageLabel.text = self.member.birthday;
    self.mobileLabel.text = self.member.mobile;
    self.IdentityLabel.text = self.member.idCardNumber;
    self.streetLabel.text = self.member.member_address;
    
    NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    for ( CDStaff* staff in array )
    {
        if ( [[PersonalProfile currentProfile].employeeID isEqual:staff.staffID] )
        {
            self.doctorLabel.text = staff.name;
            self.memberID = staff.staffID;
        }
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didSaveButtonPressed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.nameLabel.text.length != 0 )
    {
        [params setObject:self.nameLabel.text forKey:@"name"];
    }
    else
    {
        [self showAlert:@"请输入姓名"];
        return;
    }
    
    if (self.mobileLabel.text.length != 0 )
    {
        
    }
    else
    {
        [self showAlert:@"请输入电话号码"];
        return;
    }

    
    if ( self.genderSwitch.on )
    {
        [params setObject:@"Male" forKey:@"gender"];
    }
    else
    {
        [params setObject:@"Female" forKey:@"gender"];
    }
    
    
    if (self.ageLabel.text.length != 0 )
    {
        //NSInteger age = self.ageLabel.text;
        [params setObject:self.ageLabel.text forKey:@"birth_date"];
    }
    
    if ( self.mobileLabel.text != 0 && ![self.member.mobile isEqualToString:self.mobileLabel.text] )
    {
        [params setObject:self.mobileLabel.text forKey:@"mobile"];
    }
    else if ( self.mobileLabel.text.length == 0 )
    {
        [self showAlert:@"请输入手机号码"];
        return;
    }
    
    if ( [self.memberID integerValue] > 0 )
    {
        [params setObject:self.memberID forKey:@"doctor_id"];
    }
    
    [params setObject:self.IdentityLabel.text forKey:@"id_card_no"];
    [params setObject:self.streetLabel.text forKey:@"street"];
    
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
    
    [[CBLoadingView shareLoadingView] show];
}

- (NSString*)age
{
    if ( [self.member.birthday length] > 0 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [dateFormat dateFromString:self.member.birthday];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSYearCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:[NSDate date]  options:0];
        
        return [NSString stringWithFormat:@"%d岁",comps.year];
    }
    
    return @"";
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

- (IBAction)didBirthdayButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDate;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.ageLabel.text = dateString;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didDoctorButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.doctorLabel.text = staff.name;
        weakSelf.memberID = staff.staffID;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)showAlert:(NSString*)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:str
                                                       delegate:nil
                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
