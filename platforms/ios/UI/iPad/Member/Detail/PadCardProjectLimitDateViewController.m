//
//  PadCardProjectLimitDateViewController.m
//  meim
//
//  Created by jimmy on 2017/8/17.
//
//

#import "PadCardProjectLimitDateViewController.h"
#import "PadDatePickerView.h"

@interface PadCardProjectLimitDateViewController ()
@property(nonatomic, weak)IBOutlet UISwitch* isLimitSwitch;
@property(nonatomic, weak)IBOutlet UITextField* dateLabel;
@end

@implementation PadCardProjectLimitDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isLimitSwitch.on = self.project.isLimited.boolValue;
    self.dateLabel.text = self.project.limitedDate;
}

- (IBAction)didValueChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.project.isLimited = @(TRUE);
    }
    else
    {
        self.project.isLimited = @(FALSE);
    }
}

- (IBAction)didLimitDateButtonPressed:(UIButton*)sender
{
    if ( !self.project.isLimited.boolValue )
    {
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDate;
    
    if ( self.project.limitedDate.length > 6 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        v.date = [dateFormat dateFromString:self.project.limitedDate];
    }
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.dateLabel.text = dateString;
        weakSelf.project.limitedDate = dateString;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

@end
