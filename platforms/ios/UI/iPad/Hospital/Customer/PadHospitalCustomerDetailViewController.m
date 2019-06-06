//
//  PadHospitalCustomerDetailViewController.m
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import "PadHospitalCustomerDetailViewController.h"
#import "PadHospitalCreateCustomerViewController.h"
#import "SeletctListViewController.h"
#import "HCustomerCreateRequest.h"

@interface PadHospitalCustomerDetailViewController ()

//add by ala 2017/04/27 layout design
@property(nonatomic, weak)IBOutlet UIImageView* logoImageView;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* phoneLabel;
@property(nonatomic, weak)IBOutlet UILabel* genderLabel;
@property(nonatomic, weak)IBOutlet UILabel* isOperateLabel;
@property(nonatomic, weak)IBOutlet UILabel* registDateLabel;
@property(nonatomic, weak)IBOutlet UILabel* streetLabel;
@property(nonatomic, weak)IBOutlet UILabel* noteLabel;
@property(nonatomic, weak)IBOutlet UILabel* splitNoteLabel;
@property(nonatomic)NSInteger selectSplitNoteID;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@end



@implementation PadHospitalCustomerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.customer.memberName;
    self.phoneLabel.text = self.customer.mobile;
    self.isOperateLabel.text = [self.customer.is_operate boolValue] ? @"是" : @"否";
    self.registDateLabel.text = self.customer.create_date;
    if ( [self.customer.gender isEqualToString:@"Male"] )
    {
        self.genderLabel.text = @"男";
    }
    else
    {
        self.genderLabel.text = @"女";
    }
    self.streetLabel.text = self.customer.member_address;
    self.noteLabel.text = self.customer.remark;
    
    [self.logoImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",self.customer.memberID, self.customer.memberName] tableName:@"born.medical.customer" filter:self.customer.memberID fieldName:@"image" writeDate:self.customer.lastUpdate placeholderString:@"pad_avatar_default" cacheDictionary:nil];
}

- (IBAction)didFenzhenButtonPressed:(id)sender
{
    NSNumber* shopID = [[PersonalProfile currentProfile].shopIds firstObject];
    NSArray* guwenArray = [[BSCoreDataManager currentManager] fetchGuwenStaffsWithShopID:shopID];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return guwenArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = guwenArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = guwenArray[index];
        weakSelf.splitNoteLabel.text = staff.name;
        weakSelf.selectSplitNoteID = staff.staffID;
        [weakSelf.tableView reloadData];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:staff.staffID forKey:@"employee_id"];
        
        HCustomerCreateRequest *request = [[HCustomerCreateRequest alloc] initWithMemberID:weakSelf.customer.memberID params:params];
        [request execute];
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PadHospitalCreateCustomerViewController* vc = [segue destinationViewController];
    vc.customer = self.customer;
}

@end
