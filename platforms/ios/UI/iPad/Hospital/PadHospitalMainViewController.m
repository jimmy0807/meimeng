//
//  PadHospitalMainViewController.m
//  meim
//
//  Created by jimmy on 2017/4/11.
//
//

#import "PadHospitalMainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HospitalMainTableViewCell.h"
#import "PadMaskView.h"
#import "PadHospitalCreateCustomerViewController.h"
#import "PadHospitalCustomerMainViewController.h"
#import "PadHospitalFenzhenListViewController.h"
#import "HJiaoHaoListViewController.h"
#import "HPartnerListViewController.h"
#import "HHuifangListViewController.h"
#import "PadHospitalPatientMainViewController.h"
#import "BSFetchStaffRequest.h"

static NSInteger SectionZixun = 0;
static NSInteger SectionYiyuan = 1;
static NSInteger SectionPartner = 2;
static NSInteger SectionShouhou = 3;
static NSInteger SectionCount = 4;
static NSInteger SectionManager = 111;

static NSInteger RowZixunCustomer = 0;
static NSInteger RowZixunZixundan = 1;
static NSInteger RowZixunCount = 2;
static NSInteger RowZixunFenzhendan = 111;

static NSInteger RowYiyuanJiaohao = 0;
static NSInteger RowYiyuanBinren = 1;
static NSInteger RowYiyuanCount = 2;
static NSInteger RowYiyuanZhuyuan = 3;

static NSInteger RowPartnerHezuoshang = 0;
static NSInteger RowPartnerCount = 1;

static NSInteger RowManagerQudaoshang = 0;
static NSInteger RowManagerCount = 1;

static NSInteger RowShouhouGenjinhuifang = 0;
static NSInteger RowShouhouTousu = 1;
static NSInteger RowShouhouFuwu = 2;
static NSInteger RowShouhouCount = 3;

@interface PadHospitalMainViewController ()
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property (nonatomic, strong) PadMaskView *maskView;
@end

@implementation PadHospitalMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.maskView = [[PadMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"HospitalMainTableViewCell" bundle: nil] forCellReuseIdentifier:@"HospitalMainTableViewCell"];
    
    //BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
    //[request execute];
}

- (IBAction)didMenuButtonPressed:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == SectionZixun )
    {
        return RowZixunCount;
    }
    else if ( section == SectionYiyuan )
    {
        return RowYiyuanCount;
    }
    else if ( section == SectionPartner )
    {
        return RowPartnerCount;
    }
    else if ( section == SectionShouhou )
    {
        return RowShouhouCount;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HospitalMainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HospitalMainTableViewCell"];
    cell.rightIconButton.hidden = NO;
    
    __weak PadHospitalMainViewController* weakSelf = self;
    cell.addPressed = ^{
        if ( indexPath.section == SectionZixun )
        {
            if ( indexPath.row == RowZixunCustomer )
            {
//                PadHospitalCreateCustomerViewController *viewController = [[PadHospitalCreateCustomerViewController alloc] initWithMember:nil];
//                viewController.maskView = self.maskView;
//                weakSelf.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
//                weakSelf.maskView.navi.navigationBarHidden = YES;
//                weakSelf.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
//                [weakSelf.maskView addSubview:self.maskView.navi.view];
//                [weakSelf.maskView show];
            }
            else if ( indexPath.row == RowZixunFenzhendan )
            {
            }
            else if ( indexPath.row == RowZixunZixundan )
            {
            }
        }
        else if ( indexPath.section == SectionYiyuan )
        {
            if ( indexPath.row == RowYiyuanJiaohao )
            {
            }
            else if ( indexPath.row == RowYiyuanBinren )
            {
            }
            else if ( indexPath.row == RowYiyuanZhuyuan )
            {
            }
        }
        else if ( indexPath.section == SectionPartner )
        {
            if ( indexPath.row == RowPartnerHezuoshang )
            {
            }
        }
        else if ( indexPath.section == SectionShouhou )
        {
            if ( indexPath.row == RowShouhouGenjinhuifang )
            {
            }
            else if ( indexPath.row == RowShouhouTousu )
            {
            }
            else if ( indexPath.row == RowShouhouFuwu )
            {
            }
        }
    };
    
    if ( indexPath.section == SectionZixun )
    {
        if ( indexPath.row == RowZixunCustomer )
        {
            cell.titleLabel.text = @"客户";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_kehu"] forState:UIControlStateNormal];
        }
        else if ( indexPath.row == RowZixunFenzhendan )
        {
            cell.titleLabel.text = @"分诊单";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_fenzhendan"] forState:UIControlStateNormal];
        }
        else if ( indexPath.row == RowZixunZixundan )
        {
            cell.titleLabel.text = @"咨询单";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_zixundan"] forState:UIControlStateNormal];
        }
    }
    else if ( indexPath.section == SectionManager )
    {
        if ( indexPath.row == RowManagerQudaoshang )
        {
            cell.titleLabel.text = @"渠道商";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_qudaoshang"] forState:UIControlStateNormal];
        }
    }
    else if ( indexPath.section == SectionShouhou )
    {
        if ( indexPath.row == RowShouhouGenjinhuifang )
        {
            cell.titleLabel.text = @"跟进回访";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_huifang"] forState:UIControlStateNormal];
        }
        else if ( indexPath.row == RowShouhouTousu )
        {
            cell.titleLabel.text = @"投诉";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_tousu"] forState:UIControlStateNormal];
        }
        else if ( indexPath.row == RowShouhouFuwu )
        {
            cell.titleLabel.text = @"服务";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_kefu"] forState:UIControlStateNormal];
        }
    }
    else if ( indexPath.section == SectionYiyuan )
    {
        if ( indexPath.row == RowYiyuanJiaohao )
        {
            cell.titleLabel.text = @"排队叫号";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_paiduijiaohao"] forState:UIControlStateNormal];
            cell.rightIconButton.hidden = YES;
        }
        else if ( indexPath.row == RowYiyuanBinren )
        {
            cell.titleLabel.text = @"病人档案";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_binrendangan"] forState:UIControlStateNormal];
        }
        else if ( indexPath.row == RowYiyuanZhuyuan )
        {
            cell.titleLabel.text = @"住院";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_zhuyuan"] forState:UIControlStateNormal];
        }
    }
    else if ( indexPath.section == SectionPartner )
    {
        if ( indexPath.row == RowPartnerHezuoshang )
        {
            cell.titleLabel.text = @"合作商";
            [cell.iconImageView setImage:[UIImage imageNamed:@"hospital_main_icon_qudaoshang"] forState:UIControlStateNormal];
        }
    }
    
    cell.rightIconButton.hidden = YES;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 56)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(35, 31, 100, 16)];
    l.font = [UIFont systemFontOfSize:15];
    l.textColor = COLOR(136, 159, 159, 1);
    [v addSubview:l];
    
    if ( section == SectionZixun )
    {
        l.text = @"咨询";
    }
    else if ( section == SectionManager )
    {
        l.text = @"医院管理";
    }
    else if ( section == SectionShouhou )
    {
        l.text = @"售后";
    }
    else if ( section == SectionYiyuan )
    {
        l.text = @"医院";
    }
    else if ( section == SectionPartner )
    {
        l.text = @"合作伙伴";
    }
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 55, 576, 1)];
    lineImageView.backgroundColor = COLOR(240, 241, 241, 1);
    [v addSubview:lineImageView];
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == SectionZixun )
    {
        if ( indexPath.row == RowZixunCustomer )
        {
            PadHospitalCustomerMainViewController* vc = [[PadHospitalCustomerMainViewController alloc] initWithNibName:@"PadHospitalCustomerMainViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowZixunFenzhendan )
        {
            PadHospitalFenzhenListViewController* vc = [[PadHospitalFenzhenListViewController alloc] initWithNibName:@"PadHospitalFenzhenListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowZixunZixundan )
        {
            PadHospitalFenzhenListViewController* vc = [[PadHospitalFenzhenListViewController alloc] initWithNibName:@"PadHospitalFenzhenListViewController" bundle:nil];
            vc.categoryName = @"advisory";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ( indexPath.section == SectionManager )
    {
        if ( indexPath.row == RowManagerQudaoshang )
        {
        }
    }
    else if ( indexPath.section == SectionShouhou )
    {
        if ( indexPath.row == RowShouhouGenjinhuifang )
        {
            HHuifangListViewController* vc = [[HHuifangListViewController alloc] initWithNibName:@"HHuifangListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowShouhouTousu )
        {
            PadHospitalFenzhenListViewController* vc = [[PadHospitalFenzhenListViewController alloc] initWithNibName:@"PadHospitalFenzhenListViewController" bundle:nil];
            vc.categoryName = @"complaints";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowShouhouFuwu )
        {
            PadHospitalFenzhenListViewController* vc = [[PadHospitalFenzhenListViewController alloc] initWithNibName:@"PadHospitalFenzhenListViewController" bundle:nil];
            vc.categoryName = @"service";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ( indexPath.section == SectionYiyuan )
    {
        if ( indexPath.row == RowYiyuanJiaohao )
        {
            HJiaoHaoListViewController* vc = [[HJiaoHaoListViewController alloc] initWithNibName:@"HJiaoHaoListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowYiyuanBinren )
        {
            PadHospitalPatientMainViewController* vc = [[PadHospitalPatientMainViewController alloc] initWithNibName:@"PadHospitalPatientMainViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( indexPath.row == RowYiyuanZhuyuan )
        {
        }
    }
    else if ( indexPath.section == SectionPartner )
    {
        if ( indexPath.row == RowPartnerHezuoshang )
        {
            HPartnerListViewController* vc = [[HPartnerListViewController alloc] initWithNibName:@"HPartnerListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)dealloc
{
    
}

@end
