//
//  HPatientDetailViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientDetailViewController.h"
#import "HPatientCreateContainerViewController.h"
#import "HPatientBinglikaViewController.h"
#import "CBLoadingView.h"
#import "PadDatePickerView.h"
#import "SeletctListViewController.h"
#import "HHuizhenCreateRequest.h"
#import "PadDatePickerView.h"

@interface HPatientDetailViewController ()




//add by ala 2017/04/27 layout design
@property(nonatomic, weak)IBOutlet UIImageView* logoImageView;  //图像
@property(nonatomic, weak)IBOutlet UILabel* nameLabel; //姓名
@property(nonatomic, weak)IBOutlet UILabel* phoneLabel; //电话
@property(nonatomic, weak)IBOutlet UILabel* ageLabel; // 年龄
@property(nonatomic, weak)IBOutlet UILabel* generLabel; //性别
@property(nonatomic, weak)IBOutlet UILabel* firstTreatDateLabel; //初诊时间
@property(nonatomic, weak)IBOutlet UILabel* doctorNameLabel; //医生
@property(nonatomic, weak)IBOutlet UILabel* amountLabel;  //余额
@property(nonatomic, weak)IBOutlet UILabel* pointLabel; //积分
@property(nonatomic, weak)IBOutlet UILabel* pointTitleLabel; //积分标题

@property(nonatomic, weak)IBOutlet UILabel* recordNoteLabel; //最后就诊处理意见
@property(nonatomic, weak)IBOutlet UILabel* recordTimeLabel; //最后就诊处理时间
@property(nonatomic, strong)SeletctListViewController* selectVC;
@end

@implementation HPatientDetailViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.destinationViewController isKindOfClass:[HPatientCreateContainerViewController class]] )
    {
        HPatientCreateContainerViewController* vc = segue.destinationViewController;
        vc.member = self.member;
    }
    else if ( [segue.destinationViewController isKindOfClass:[HPatientBinglikaViewController class]] )
    {
        HPatientBinglikaViewController* vc = segue.destinationViewController;
        vc.member = self.member;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self reloadData];
    
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
}

- (void)reloadData
{
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.member.image_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
    self.nameLabel.text = self.member.memberName;
    self.phoneLabel.text = self.member.mobile;
    
    self.ageLabel.text = [self age];
    
    if ( [self.member.gender isEqualToString:@"Male"] )
    {
        self.generLabel.text = @"男";
    }
    else
    {
        self.generLabel.text = @"女";
    }
    
    if ( self.member.first_treat_date.length > 0 )
    {
        self.firstTreatDateLabel.text = self.member.first_treat_date;
    }
    else
    {
        self.firstTreatDateLabel.text = @"无";
    }
    
    if ( self.member.doctor_name.length )
    {
        self.doctorNameLabel.text = self.member.doctor_name;
    }
    else
    {
        self.doctorNameLabel.text = @"无";
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"%.02f",self.member.amount.floatValue];
    
    if ( [self.member.point integerValue] > 0 )
    {
        self.pointLabel.text = [NSString stringWithFormat:@"%@",self.member.point];
        self.pointTitleLabel.hidden = NO;
    }
    else
    {
        self.pointLabel.text = @"";
        self.pointTitleLabel.hidden = YES;
    }
    
    self.recordNoteLabel.text = self.member.record_note;
    self.recordTimeLabel.text = @"点击查看详情";//self.member.record_time;
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
    
    return @"未填";
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        [self reloadData];
    }
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
        weakSelf.doctorNameLabel.text = staff.name;
        weakSelf.member.doctor_id = staff.staffID;
        weakSelf.member.doctor_name = staff.name;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:weakSelf.member.doctor_id forKey:@"doctors_id"];
        
        HHuizhenCreateRequest *request = [[HHuizhenCreateRequest alloc] initWithHuizhenID:weakSelf.member.record_id params:params isEdit:NO];
        [request execute];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didChuzhenTimeButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.firstTreatDateLabel.text = [dateString stringByAppendingString:@":00"];
        weakSelf.member.first_treat_date = [dateString stringByAppendingString:@":00"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:weakSelf.member.first_treat_date forKey:@"first_treat_date"];
        
        HHuizhenCreateRequest *request = [[HHuizhenCreateRequest alloc] initWithHuizhenID:weakSelf.member.record_id params:params isEdit:NO];
        [request execute];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

@end
