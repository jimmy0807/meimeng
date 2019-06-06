//
//  HPatientShoushuCreateHeader.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "HPatientShoushuCreateHeader.h"
#import "SeletctListViewController.h"
#import "PadDatePickerView.h"

@interface HPatientShoushuCreateHeader ()
@property(nonatomic, strong)SeletctListViewController* selectVC;
@end

@implementation HPatientShoushuCreateHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)didDoctorButtonPressed:(id)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    NSArray* doctorArray = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return doctorArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = doctorArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = doctorArray[index];
        weakSelf.shoushu.doctor_id = staff.staffID;
        weakSelf.shoushu.doctor_name = staff.name;
        weakSelf.doctorTextField.text = staff.name;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didZhirushijianButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.zhiruTimeTextField.text = dateString;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didShoushushijianButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.shoushuTimeTextField.text = dateString;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (void)setShoushu:(CDHShoushu *)shoushu
{
    if ( [_shoushu.shoushu_id integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:_shoushu];
    }
    
    _shoushu =  shoushu;
    
    self.nameTextField.text = shoushu.name;
    
    self.zhiruTimeTextField.text = shoushu.expander_in_date;
    self.fuzhenDayTextField.text = shoushu.expander_review_days_1;
    self.shoushuTimeTextField.text = shoushu.first_treat_date;
    
    if ( [shoushu.doctor_id integerValue] > 0 )
    {
        self.doctorTextField.text = shoushu.doctor_name;
    }
    else
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
        for ( CDStaff* staff in array )
        {
            if ( [[PersonalProfile currentProfile].employeeID isEqual:staff.staffID] )
            {
                self.doctorTextField.text = staff.name;
                shoushu.doctor_name = staff.name;
                shoushu.doctor_id = staff.staffID;
            }
        }
    }
}

@end
