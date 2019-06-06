//
//  HPatientCreateRecipeViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/9/19.
//
//

#import "HPatientCreateRecipeViewController.h"
#import "SeletctListViewController.h"
#import "CBLoadingView.h"
#import "HPatientRecipeCreateTableViewCell.h"
#import "PadSideBarViewController.h"
#import "HPatientBinglikaViewController.h"
#import "HPatientNewRecipeViewController.h"
#import "HPatientRecipeTempletViewController.h"
#import "HPatientAddYaopinViewController.h"
#import "PadMaskView.h"

@interface HPatientCreateRecipeViewController ()<UITableViewDataSource,UITableViewDelegate,HPatientRecipeTempletViewControllerDelegate>

@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, strong)HPatientNewRecipeViewController* createNewVC;
@property(nonatomic, strong)HPatientRecipeTempletViewController* templetVC;
@property(nonatomic, weak)IBOutlet UILabel* recipeTypeLabel;
@property(nonatomic, weak)IBOutlet UILabel* officeLabel;
@property(nonatomic, weak)IBOutlet UILabel* zhenduanLabel;
@property(nonatomic, weak)IBOutlet UITextField* zhenduanTextField;
@property(nonatomic, weak)IBOutlet UITextView* noteTextView;
@property(nonatomic, weak)IBOutlet UILabel* memzhenLabel;
@property(nonatomic, weak)IBOutlet UITableView* createRecipeTableView;
@property(nonatomic, strong)NSMutableOrderedSet* indexSet;
@property(nonatomic, weak)NSArray* yaopinArray;
@property (nonatomic, strong) PadMaskView *maskView;

@end

@implementation HPatientCreateRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.createRecipeTableView registerNib:[UINib nibWithNibName:@"HPatientRecipeCreateTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipeCreateTableViewCell"];
    self.maskView = [[PadMaskView alloc] initWithFrame:self.view.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];

}

- (IBAction)didTypeButtonPressed:(id)sender
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
        weakSelf.recipeTypeLabel.text = staff.name;
        weakSelf.recipeTypeLabel.textColor = COLOR(37, 37, 37, 1);
        weakSelf.huizhen.doctors_id = staff.staffID;
        weakSelf.huizhen.doctors_name = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    for (UIViewController *v in vc.childViewControllers) {
        if ([v isKindOfClass:[CBRotateNavigationController class]]) {
            for (UIViewController *v1 in v.childViewControllers) {
                if ([v1 isKindOfClass:[HPatientBinglikaViewController class]]) {
                    NSLog(@"%@",v.childViewControllers);
                    [v1.view addSubview:self.selectVC.view];
                }
            }
        }
    }
    [self.selectVC showWithAnimation];
}

- (IBAction)didOfficeButtonPressed:(id)sender
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
        weakSelf.officeLabel.text = staff.name;
        weakSelf.officeLabel.textColor = COLOR(37, 37, 37, 1);
        weakSelf.huizhen.doctors_id = staff.staffID;
        weakSelf.huizhen.doctors_name = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    for (UIViewController *v in vc.childViewControllers) {
        if ([v isKindOfClass:[CBRotateNavigationController class]]) {
            for (UIViewController *v1 in v.childViewControllers) {
                if ([v1 isKindOfClass:[HPatientBinglikaViewController class]]) {
                    NSLog(@"%@",v.childViewControllers);
                    [v1.view addSubview:self.selectVC.view];
                }
            }
        }
    }
    [self.selectVC showWithAnimation];
}

- (IBAction)didZhenduanButtonPressed:(id)sender
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
        weakSelf.zhenduanTextField.text = staff.name;
//        weakSelf.zhenduanTextField.textColor = COLOR(37, 37, 37, 1);
        weakSelf.huizhen.doctors_id = staff.staffID;
        weakSelf.huizhen.doctors_name = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    for (UIViewController *v in vc.childViewControllers) {
        if ([v isKindOfClass:[CBRotateNavigationController class]]) {
            for (UIViewController *v1 in v.childViewControllers) {
                if ([v1 isKindOfClass:[HPatientBinglikaViewController class]]) {
                    NSLog(@"%@",v.childViewControllers);
                    [v1.view addSubview:self.selectVC.view];
                }
            }
        }
    }
    [self.selectVC showWithAnimation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 50;
    }
    else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724, 50)];
        
        UILabel * recipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 22, 100, 18)];
        recipeLabel.text = @"处方";
        recipeLabel.textColor = COLOR(149, 171, 171, 1);
        recipeLabel.font = [UIFont systemFontOfSize:18];
        [view addSubview:recipeLabel];
        
        UIButton * templetButton = [[UIButton alloc] initWithFrame:CGRectMake(572, 24, 100, 16)];
        [templetButton setTitle:@"选择处方模板" forState: UIControlStateNormal];
        [templetButton addTarget:self action:@selector(didTempletButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [templetButton setTitleColor:COLOR(47, 143, 255, 1) forState:UIControlStateNormal];
        templetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        templetButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:templetButton];
        
        return view;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return self.yaopinArray.count + 2;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 60;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCreateTableViewCell" forIndexPath:indexPath];
        HPatientRecipeCreateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCreateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
//            cell.recipeStatusButtonPressed = ^{
//                
//            }
            [cell.statusButton setBackgroundImage:[UIImage imageNamed:@"pos_add"] forState:UIControlStateNormal];
            [cell.statusButton setBackgroundImage:[UIImage imageNamed:@"pos_add"] forState:UIControlStateHighlighted];
            cell.statusButton.enabled = NO;
            cell.recipeStatusButtonPressed = ^{
                
            };
            cell.mainLabel.text = @"添加";
            cell.mainLabel.textColor = COLOR(155, 155, 155, 1);
        }
        else {
            [cell.statusButton setBackgroundImage:[UIImage imageNamed:@"pad_delete_n"] forState:UIControlStateNormal];
            [cell.statusButton setBackgroundImage:[UIImage imageNamed:@"pad_delete_n"] forState:UIControlStateHighlighted];
            cell.mainLabel.text = @"阿司匹林";
            cell.mainLabel.textColor = COLOR(37, 37, 37, 1);
            cell.additionLabel.text = @"用法：每日三次，每次2片";
            cell.recipeStatusButtonPressed = ^{
                
            };
            

        }
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIViewController *viewController = nil;
            HPatientAddYaopinViewController *returnItemViewController = [[HPatientAddYaopinViewController alloc] initWithMemberCard:nil couponCard:nil];
            returnItemViewController.maskView = self.maskView;
            viewController = (UIViewController *)returnItemViewController;
            if (viewController)
            {
                self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
                self.maskView.navi.navigationBarHidden = YES;
                self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
                [self.maskView addSubview:self.maskView.navi.view];
                [self.maskView show];
            }
//            self.createNewVC = [[HPatientNewRecipeViewController alloc] initWithNibName:@"HPatientNewRecipeViewController" bundle:nil];
//            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
//            for (UIViewController *v in vc.childViewControllers) {
//                if ([v isKindOfClass:[CBRotateNavigationController class]]) {
//                    for (UIViewController *v1 in v.childViewControllers) {
//                        if ([v1 isKindOfClass:[HPatientBinglikaViewController class]]) {
//                            [v1.view addSubview:self.createNewVC.view];
//                        }
//                    }
//                }
//            }
//            [self.createNewVC showWithAnimation];

//            UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
//            HPatientCreateRecipeContainerViewController* viewc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createRecipeContainer"];
//            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
            
        }
        else
        {
            
        }
    }
}

- (void)didTempletButtonPressed
{
    /*
    self.templetVC = [[HPatientRecipeTempletViewController alloc] initWithNibName:@"HPatientRecipeTempletViewController" bundle:nil];
    
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.templetVC.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.templetVC.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.templetVC.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.templetVC.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.officeLabel.text = staff.name;
        weakSelf.officeLabel.textColor = COLOR(37, 37, 37, 1);
        weakSelf.huizhen.doctors_id = staff.staffID;
        weakSelf.huizhen.doctors_name = staff.name;
    };
    self.templetVC.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    for (UIViewController *v in vc.childViewControllers) {
        if ([v isKindOfClass:[CBRotateNavigationController class]]) {
            for (UIViewController *v1 in v.childViewControllers) {
                if ([v1 isKindOfClass:[HPatientBinglikaViewController class]]) {
                    [v1.view addSubview:self.templetVC.view];
                }
            }
        }
    }*/
    UIViewController *viewController = nil;
    HPatientRecipeTempletViewController *returnItemViewController = [[HPatientRecipeTempletViewController alloc] initWithMemberCard:nil couponCard:nil];
    returnItemViewController.maskView = self.maskView;
    viewController = (UIViewController *)returnItemViewController;
    if (viewController)
    {
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
    //[self.createNewVC showWithAnimation];
}

- (void)didHPatientRecipeTempletViewControllerConfirmButtonPressed:(NSArray*)itemArray
{
    NSLog(@"%@",itemArray);
    //self.cardProjectArray = [NSMutableArray arrayWithArray:itemArray];
    //    [self.tableView reloadData];
    //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:PadAdjustCardItemSection_Item];
    //[self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
