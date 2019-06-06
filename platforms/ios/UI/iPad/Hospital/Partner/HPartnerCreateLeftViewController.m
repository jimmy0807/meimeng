//
//  HPartnerCreateLeftViewController.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "HPartnerCreateLeftViewController.h"
#import "SeletctListViewController.h"
#import "CBLoadingView.h"
#import "ChineseToPinyin.h"
#import "HPartnerCreateRequest.h"

@interface HPartnerCreateLeftViewController ()

@property(nonatomic, strong)SeletctListViewController* selectVC;

@property(nonatomic, weak)IBOutlet UITextField* nameLabel;       //名称
@property(nonatomic, weak)IBOutlet UILabel* categoryLabel;       //类型
@property(nonatomic, weak)IBOutlet UITextField* cityRegionLabel;      //区域
@property(nonatomic, weak)IBOutlet UILabel* signDateLabel;    //签约日期
@property(nonatomic, weak)IBOutlet UITextField* mobileLabel;    //手机
@property(nonatomic, weak)IBOutlet UILabel* designerNameLabel;   //设计
@property(nonatomic, weak)IBOutlet UILabel* businessNameLabel;    //业务
@property(nonatomic, weak)IBOutlet UITextField* identificationLabel;    //身份证

@end

@implementation HPartnerCreateLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.partner.name;
    if ( [self.partner.partner_category isEqualToString:@"dj"] )
    {
        self.categoryLabel.text = @"店家";
    }
    else if ( [self.partner.partner_category isEqualToString:@"dd"] )
    {
        self.categoryLabel.text = @"督导";
    }
    else if ( [self.partner.partner_category isEqualToString:@"dl"] )
    {
        self.categoryLabel.text = @"代理商";
    }
    
    self.cityRegionLabel.text = self.partner.street;
    self.signDateLabel.text = self.partner.sign_date;
    self.mobileLabel.text = self.partner.mobile;
    self.designerNameLabel.text = self.partner.designer_employee_name;
    self.businessNameLabel.text = self.partner.business_employee_name;
    self.identificationLabel.text = self.partner.identification;
}

- (IBAction)didCategoryButonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = @[@"店家", @"督导", @"代理商"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.noSort = YES;
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        return array[index];
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        if ( index == 0 )
        {
            weakSelf.partner.partner_category = @"dj";
        }
        else if ( index == 1 )
        {
            weakSelf.partner.partner_category = @"dd";
        }
        else if ( index == 2 )
        {
            weakSelf.partner.partner_category = @"dl";
        }
        weakSelf.categoryLabel.text = array[index];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];

}

- (IBAction)didShejishiButonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.noSort = YES;
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.designerNameLabel.text = staff.name;
        weakSelf.partner.designer_employee_name = staff.name;
        weakSelf.partner.designer_employee_id = staff.staffID;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didShejiZongjianButonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchShejizongjianStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.noSort = YES;
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.businessNameLabel.text = staff.name;
        weakSelf.partner.business_employee_name = staff.name;
        weakSelf.partner.business_employee_id = staff.staffID;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)didSaveButtonPressed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.nameLabel.text forKey:@"name"];
    self.partner.name = self.nameLabel.text;
    self.partner.nameLetter = [ChineseToPinyin pinyinFromChiniseString:self.partner.name];
    self.partner.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:self.partner.name] uppercaseString];
    
    [params setObject:self.partner.partner_category forKey:@"partner_category"];
    
    self.partner.street = self.cityRegionLabel.text;
    [params setObject:self.cityRegionLabel.text forKey:@"street"];
    
    self.partner.sign_date = self.signDateLabel.text;
    [params setObject:self.signDateLabel.text forKey:@"sign_date"];
    
    self.partner.mobile = self.mobileLabel.text;
    [params setObject:self.mobileLabel.text forKey:@"mobile"];
    
    self.partner.identification = self.identificationLabel.text;
    [params setObject:self.identificationLabel.text forKey:@"identification"];
    
    [params setObject:self.partner.designer_employee_id forKey:@"designer_employee_id"];
    [params setObject:self.partner.business_employee_id forKey:@"business_employee_id"];
    
    [[[HPartnerCreateRequest alloc] initWithPartnerID:self.partner.partner_id params:params] execute];
    
    [[CBLoadingView shareLoadingView] show];
}

@end
