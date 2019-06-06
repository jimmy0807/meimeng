//
//  HPatientBinglikaViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientBinglikaViewController.h"
#import "FetchHBinglikaDetailRequest.h"
#import "HPatientBingliLeftViewController.h"
#import "HPatientBingliRightHuizhenxinxiViewController.h"
#import "HPatientCreateBingliViewController.h"
#import "HPatientShoushuViewController.h"
#import "HPatientShoushuListViewController.h"
#import "HPatientCreateContainerViewController.h"
#import "HPatientElectonicRecipeViewController.h"
#import "HPatientMubanCategoryViewController.h"
#import "BSPopoverBackgroundView.h"

@interface HPatientBinglikaViewController ()
//@property(nonatomic, strong)HPatientBingliLeftViewController* leftChildVc;
@property(nonatomic, strong)HPatientBingliRightHuizhenxinxiViewController* rightHuizhenzixunChildVc;
@property(nonatomic, strong)HPatientShoushuViewController* rightShoushuChildVc;
@property(nonatomic, strong)HPatientShoushuListViewController* rightShoushuListChildVc;
@property(nonatomic, strong)HPatientElectonicRecipeViewController* rightElectronicRecipeChildVc;
@property(nonatomic, weak)IBOutlet UIImageView* centerButtonView;
@property(nonatomic, weak)IBOutlet UIButton* centerButton;
@property(nonatomic, weak)IBOutlet UIButton* rightBackButton;
@property(nonatomic, weak)IBOutlet UIButton* saveButton;
@property(nonatomic, weak)IBOutlet UIView* rightShoushuView;
@property(nonatomic, weak)IBOutlet UIView* rightHuizhenView;
@property(nonatomic, weak)IBOutlet UIView* rightShoushuListView;
@property(nonatomic, weak)IBOutlet UIView* rightElectronicRecipeView;
@property(nonatomic, weak)IBOutlet UILabel* rightViewTitleLabel;
@property (nonatomic, strong) UIPopoverController *typePopover;
@property (nonatomic, strong) HPatientMubanCategoryViewController *typeViewController;

@end

@implementation HPatientBinglikaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[FetchHBinglikaDetailRequest alloc] initWithBinglikaID:self.member.record_id] execute];
    self.rightViewTitleLabel.text = @"问诊信息";
    self.rightBackButton.hidden = YES;
    [self.saveButton setTitle:@"新建" forState:UIControlStateNormal];
    
    [self registerNofitificationForMainThread:kHHuizhenCreateResponse];
    [self registerNofitificationForMainThread:@"AddSubShoushu"];
    
    self.typeViewController = [[HPatientMubanCategoryViewController alloc] initWithBornCategory:nil];
    self.typeViewController.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.typeViewController];
    navi.navigationBarHidden = YES;
    self.typePopover = [[UIPopoverController alloc] initWithContentViewController:navi];
    self.typePopover.backgroundColor = [UIColor whiteColor];
    self.typePopover.popoverBackgroundViewClass = [BSPopoverBackgroundView class];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHHuizhenCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            self.rightBackButton.hidden = YES;
            [self.saveButton setTitle:@"新建" forState:UIControlStateNormal];
            self.rightViewTitleLabel.hidden = NO;
            self.centerButton.hidden = YES;
            self.centerButtonView.hidden = YES;
        }
    }
    else if ([notification.name isEqualToString:@"AddSubShoushu"])
    {
        self.saveButton.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.rightBackButton.hidden = YES;
    //[self.saveButton setTitle:@"新建" forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue destinationViewController] isKindOfClass:[HPatientBingliLeftViewController class]] )
    {
        HPatientBingliLeftViewController* vc = [segue destinationViewController];
        vc.member = self.member;
        vc.hideShoushu = self.hideShoushu;
        self.leftChildVc = vc;
        WeakSelf;
        vc.huizhenPressed = ^{
            weakSelf.rightViewTitleLabel.text = @"问诊信息";
            weakSelf.rightHuizhenView.hidden = NO;
            weakSelf.rightShoushuView.hidden = YES;
            weakSelf.rightShoushuListView.hidden = YES;
            weakSelf.rightBackButton.hidden = YES;
            weakSelf.rightElectronicRecipeView.hidden = YES;
            [weakSelf.saveButton setTitle:@"新建" forState:UIControlStateNormal];
            weakSelf.saveButton.hidden = NO;
            [weakSelf.rightHuizhenzixunChildVc popNavi];
        };
        vc.shoushuPressed = ^{
            weakSelf.rightViewTitleLabel.text = @"手术信息";
            weakSelf.rightHuizhenView.hidden = YES;
            weakSelf.rightShoushuView.hidden = YES;
            weakSelf.rightShoushuChildVc.shoushuIndex = -1;
            weakSelf.rightShoushuListView.hidden = NO;
            weakSelf.rightShoushuListChildVc.shoushuIndex = index;
            weakSelf.rightElectronicRecipeView.hidden = YES;
            [weakSelf.saveButton setTitle:@"新建" forState:UIControlStateNormal];
            weakSelf.saveButton.hidden = NO;
            weakSelf.rightBackButton.hidden = YES;
        };
        vc.shoushuCreatePressed = ^{
            weakSelf.rightViewTitleLabel.text = @"新建手术";
            weakSelf.rightHuizhenView.hidden = YES;
            weakSelf.rightShoushuView.hidden = NO;
            weakSelf.rightShoushuChildVc.shoushuIndex = -1;
            weakSelf.rightShoushuListView.hidden = YES;
            weakSelf.rightShoushuListChildVc.shoushuIndex = -1;
            weakSelf.rightElectronicRecipeView.hidden = YES;
            [weakSelf.saveButton setTitle:@"保存" forState:UIControlStateNormal];
            weakSelf.saveButton.hidden = NO;
            weakSelf.rightBackButton.hidden = YES;
        };
        vc.shoushuItemPressed = ^(CDHShoushu *shoushu, NSInteger index) {
            weakSelf.rightViewTitleLabel.text = @"手术信息";
            weakSelf.rightHuizhenView.hidden = YES;
            weakSelf.rightShoushuView.hidden = NO;
            weakSelf.rightShoushuChildVc.shoushuIndex = index;
            weakSelf.rightShoushuListView.hidden = YES;
            weakSelf.rightShoushuListChildVc.shoushuIndex = -1;
            weakSelf.rightElectronicRecipeView.hidden = YES;
            [weakSelf.saveButton setTitle:@"保存" forState:UIControlStateNormal];
            weakSelf.saveButton.hidden = NO;
            weakSelf.rightBackButton.hidden = YES;
        };
        vc.peiyaoPressed = ^{
            weakSelf.rightViewTitleLabel.text = @"新建处方";
            weakSelf.rightHuizhenView.hidden = YES;
            weakSelf.rightShoushuView.hidden = YES;
            weakSelf.rightShoushuChildVc.shoushuIndex = -1;
            weakSelf.rightShoushuListView.hidden = YES;
            weakSelf.rightShoushuListChildVc.shoushuIndex = -1;
            weakSelf.rightElectronicRecipeView.hidden = NO;
            [weakSelf.saveButton setTitle:@"新增" forState:UIControlStateNormal];
            weakSelf.saveButton.hidden = NO;
            weakSelf.rightBackButton.hidden = YES;
            [weakSelf.rightElectronicRecipeChildVc popNavi];
        };

    }
    else if ( [[segue destinationViewController] isKindOfClass:[UINavigationController class]] )
    {
        HPatientBingliRightHuizhenxinxiViewController* vc = ((UINavigationController*)[segue destinationViewController]).viewControllers[0];
        vc.member = self.member;
        WeakSelf;
        vc.editItemBlcok = ^{
            weakSelf.rightBackButton.hidden = NO;
            [weakSelf.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        };
        self.rightHuizhenzixunChildVc = vc;
    }
    else if ( [[segue destinationViewController] isKindOfClass:[HPatientShoushuViewController class]] )
    {
        HPatientShoushuViewController* vc = [segue destinationViewController];
        vc.member = self.member;
        self.rightShoushuChildVc = vc;
    }
    else if ( [[segue destinationViewController] isKindOfClass:[HPatientShoushuListViewController class]] )
    {
        HPatientShoushuListViewController* vc = [segue destinationViewController];
        vc.member = self.member;
        self.rightShoushuListChildVc = vc;
    }
    else if ( [[segue destinationViewController] isKindOfClass:[HPatientElectonicRecipeViewController class]] )
    {
        HPatientElectonicRecipeViewController* vc = [segue destinationViewController];
        vc.member = self.member;
        self.rightElectronicRecipeChildVc = vc;
    }
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.rightHuizhenzixunChildVc didBackButtonPressed];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didEditMemberInfoButtonPressed:(id)sender
{
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
    HPatientCreateContainerViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createPatient"];
    vc.member = self.member;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didRightBackButtonPressed:(id)sender
{
    if (self.rightHuizhenView.hidden == NO) {
        self.rightViewTitleLabel.hidden = NO;
        self.centerButton.hidden = YES;
        self.centerButtonView.hidden = YES;
        [self.rightHuizhenzixunChildVc.navigationController popViewControllerAnimated:YES];
    }
    if (self.rightElectronicRecipeView.hidden == NO) {
        [self.rightElectronicRecipeChildVc.createVC.view removeFromSuperview];
    }
    self.rightBackButton.hidden = YES;
    [self.saveButton setTitle:@"新建" forState:UIControlStateNormal];
}

- (IBAction)didCreateButtonPressed:(id)sender
{
    if (self.rightBackButton.hidden && self.rightShoushuView.hidden && self.rightHuizhenView.hidden && !self.rightElectronicRecipeView.hidden)
    {
        self.rightBackButton.hidden = NO;
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.rightElectronicRecipeChildVc didCreateRecipeButtonPressed];
        return;
    }
    if ( self.rightBackButton.hidden )
    {
        if ( self.rightShoushuView.hidden )
        {
            if ( self.rightHuizhenView.hidden )
            {
                self.rightShoushuView.hidden = NO;
                self.rightShoushuChildVc.shoushuIndex = -1;
                self.saveButton.enabled = NO;
                [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
            }
            else
            {
                self.rightViewTitleLabel.hidden = YES;
                self.centerButton.hidden = NO;
                self.centerButtonView.hidden = NO;
                [self.rightHuizhenzixunChildVc didCreateHuizhenButtonPressed];
                self.rightBackButton.hidden = NO;
                [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
            }
        }
        else
        {
            [self.rightShoushuChildVc didSaveHuizhenButtonPressed];
        }
    }
    else
    {
        if ( self.rightShoushuView.hidden )
        {
            [self.rightHuizhenzixunChildVc didSaveHuizhenButtonPressed];
        }
        else
        {
            [self.rightShoushuChildVc didSaveHuizhenButtonPressed];
        }
    }
}

- (IBAction)showMubanView:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIButton *button = (UIButton *)sender;
    UIView *parentView = button.superview;
    [self.typePopover presentPopoverFromRect:CGRectMake(parentView.frame.origin.x + button.frame.origin.x + button.frame.size.width/2.0, button.frame.origin.y + button.frame.size.height, 0.0, 0.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}

- (void)shouShoushuView:(NSInteger)index
{
    WeakSelf;
    weakSelf.rightHuizhenView.hidden = YES;
    weakSelf.rightShoushuView.hidden = NO;
    weakSelf.rightShoushuChildVc.shoushuIndex = index;
    weakSelf.rightShoushuListView.hidden = YES;
    weakSelf.rightShoushuListChildVc.shoushuIndex = -1;
    [weakSelf.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    weakSelf.saveButton.hidden = NO;
    weakSelf.rightBackButton.hidden = YES;
}

- (void)dealloc
{
}

@end
