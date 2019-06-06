//
//  PadHospitalPatientMainViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "PadHospitalPatientMainViewController.h"
#import "HPatientCreateContainerViewController.h"
#import "HPatientListCollectionViewCell.h"
#import "FetchHPatientRequest.h"
#import "HCustomerListHeadReusableView.h"
#import "HPatientDetailContainerViewController.h"
#import "MJRefresh.h"
#import "HospitalBarCodeView.h"
#import "HFetchWxShopQrCodeRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "HPatientTypeFilterViewController.h"
#import "HPatientBinglikaViewController.h"
#import "CBLoadingView.h"
#import "SpecialButton.h"
@interface PadHospitalPatientMainViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UICollectionView* collectionView;
@property(nonatomic, weak)IBOutlet UIButton* qrCodeButton;
@property(nonatomic, weak)IBOutlet UIButton* backButton;
@property(nonatomic, weak)IBOutlet UIButton* categroyFilterButton;

//@property(nonatomic, weak)IBOutlet UIImageView* myPatientButton;
//@property(nonatomic, weak)IBOutlet UIView* myPatientView;
#pragma mark - 9月份新修改 注释我的病人按钮 改成自定义的
//@property(nonatomic, weak)IBOutlet UIImageView* myPatientButton;
//@property(nonatomic, weak)IBOutlet UIView* myPatientView;
@property (nonatomic, strong) SpecialButton *myPatientButton;
//竖线1
@property (weak, nonatomic) IBOutlet UILabel *shuxian1;
//竖线2
@property (weak, nonatomic) IBOutlet UILabel *shuxian2;

@property (nonatomic, strong) NSString *qrCodeUrl;
@property (nonatomic, strong) NSNumber *storeID;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *keyword;
@property(nonatomic, strong)NSMutableDictionary* imageCacheDictionary;
@property(nonatomic, weak)IBOutlet UIImageView* headerBgImageView;
@property(nonatomic)HPatientListType listType;
@property(nonatomic, weak)HCustomerListHeadReusableView* headerSearchBar;
@property(nonatomic, strong)NSMutableSet* set;
@property(nonatomic, strong)NSArray* filterIDArray;
@end

@implementation PadHospitalPatientMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    
    if ( self.isMenuButton )
    {
        [self.backButton setImage:[UIImage imageNamed:@"common_menu_icon"] forState:UIControlStateNormal];
    }
    
    self.listType = HPatientListType_Wait;
    self.imageCacheDictionary = [NSMutableDictionary dictionary];
    
    self.storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    
    [self doRefresh:0];
    
    [self registerNofitificationForMainThread:kHPatientResponse];
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
    [self registerNofitificationForMainThread:kRefreshHospitalMain];
    [self registerNofitificationForMainThread:kHFetchWxShopQrCodeResponse];
    
    [self.collectionView registerNib:[UINib nibWithNibName: @"HPatientListCollectionViewCell" bundle: nil] forCellWithReuseIdentifier:@"HPatientListCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName: @"HCustomerListHeadReusableView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HCustomerListHeadReusableView"];
    
    [self reloadMember:nil];
    [self setHeader];
    
#pragma mark - 9月份新修改 代码创建我的病人按钮
    NSLog(@"self.headerBgImageView的父view %@",self.navigationController.view);
    
    self.myPatientButton = [SpecialButton initWithTitle:@"我的" andRect:CGRectMake(CGRectGetMinX(self.categroyFilterButton.frame)-90,CGRectGetMinY(self.categroyFilterButton.frame)+7,60,30) andCanClick:YES andBlock:^{
        NSLog(@"病人页面我的按钮被点击...%d",self.filterIDArray.count);
        NSLog(@"self.keyword %@",self.keyword);
        //点击“我的”按钮 筛选我的病人
        if ( self.filterIDArray.count == 0 )
        {
            [self reloadMember:self.keyword];
        }
        else
        {
            self.members = [NSArray array];
            [self.collectionView reloadData];
        }
        
        [self doRefresh:0];
    }];
    [self.navigationController.view addSubview:self.myPatientButton];
    //隐藏二维码 如果后台有配置二维码图片 就会接收到通知 根据是否接收到通知 判断是否要显示
    
    self.qrCodeButton.hidden = YES;
    
    WeakSelf;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf doRefresh:0];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf doRefresh:self.members.count];
    }];
    
    [[[HFetchWxShopQrCodeRequest alloc] init] execute];
#if 0
    if ( [PersonalProfile currentProfile].roleOption >= 5 )
    {
        self.myPatientButton.hidden = YES;
    }
    else
    {
        self.myPatientButton.hidden = NO;
    }
#endif
    #pragma mark - 9月份新修改 注释myPatientView
    //self.myPatientView.hidden = NO;
}
#pragma mark - 9月份新修改
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.myPatientButton.hidden=NO;
}

- (void)setHeader
{
    HCustomerListHeadReusableView* v = (HCustomerListHeadReusableView*)[UIView loadNibNamed:@"HCustomerListHeadReusableView"];
    v.searchBar.delegate = self;
    v.frame = CGRectMake(0, 75, 1024, 64);
    [self.view addSubview:v];
    
    self.headerSearchBar = v;
}

#pragma mark - 9月份新修改isSelected 不是highlighted
- (void)reloadMember:(NSString*)keyword
{
    NSLog(@"self.myPatientButton.isSelected %d",self.myPatientButton.isSelected);
    self.members = [[BSCoreDataManager currentManager] fetchAllPatientWithKeyword:keyword type:self.listType isMyPatient:self.myPatientButton.isSelected];
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHPatientResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( notification.object )
            {
                self.members = notification.object;
                [self.collectionView reloadData];
            }
            else
            {
                [self reloadMember:self.keyword];
            }
        });
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
    else if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self doRefresh:0];
        }
    }
    else if ([notification.name isEqualToString:kRefreshHospitalMain])
    {
        [self doRefresh:0];
    }
    else if ([notification.name isEqualToString:kHFetchWxShopQrCodeResponse])
    {
        self.qrCodeUrl = notification.userInfo[@"url"];
        self.qrCodeButton.hidden = NO;
    }
}

- (void)doRefresh:(NSInteger)offset
{
    [[CBLoadingView shareLoadingView] show];
    FetchHPatientRequest* request = [[FetchHPatientRequest alloc] init];
    request.keyword = self.keyword;
    
    if ( self.listType == HPatientListType_Wait )
    {
        request.type = @"wait";
        request.categoryString = [self.filterIDArray componentsJoinedByString:@","];
    }
    else if ( self.listType == HPatientListType_Today )
    {
        request.type = @"today";
        request.categoryString = [self.filterIDArray componentsJoinedByString:@","];
    }
    else
    {
        request.type = @"all";
        request.offset = offset;
    }
    
    request.listType = self.listType;
    request.isMyPatient = self.myPatientButton.isSelected;
    [request execute];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.members.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPatientListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HPatientListCollectionViewCell" forIndexPath:indexPath];
    
    CDMember* member = self.members[indexPath.row];
    cell.member = member;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(323,109);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 16, 25, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
#if 0
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(1024,64);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HCustomerListHeadReusableView *cell = (HCustomerListHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HCustomerListHeadReusableView" forIndexPath:indexPath];
    cell.searchBar.delegate = self;
    
    return cell;
}
#endif
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDMember* member = self.members[indexPath.row];
    
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
    HPatientBinglikaViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"binglika"];
    vc.member = member;
    [self.navigationController pushViewController:vc animated:YES];
    ///9月份新修改 隐藏"我的"按钮
    self.myPatientButton.hidden=YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = searchText;
    [self reloadMember:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyword = searchBar.text;
    [self doRefresh:0];
}

- (IBAction)didCreatePartnerButtonPressed:(id)sender
{
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
    HPatientCreateContainerViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createPatient"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    if ( self.isMenuButton )
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)didTitleButtonPressed:(UIButton*)sender
{
    NSInteger index = sender.tag - 100;
    self.headerBgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"patient_list_%d",index]];
    
    if ( index == 0 )
    {
        self.listType = HPatientListType_Wait;
        self.categroyFilterButton.hidden = FALSE;
        self.shuxian1.hidden=FALSE;
        self.shuxian2.hidden=FALSE;
    }
    else if ( index == 1 )
    {
        self.listType = HPatientListType_Today;
        self.categroyFilterButton.hidden = FALSE;
        self.shuxian1.hidden=FALSE;
        self.shuxian2.hidden=FALSE;
    }
//    else if ( index == 2 )
//    {
//        self.listType = HPatientListType_Recent;
//    }
    else if ( index == 2 )
    {
        self.listType = HPatientListType_ALL;
        self.categroyFilterButton.hidden = TRUE;
        self.shuxian1.hidden=TRUE;
        self.shuxian2.hidden=TRUE;
    }
    
    self.headerSearchBar.searchBar.text = @"";
    self.keyword = nil;
    
    if ( self.listType == HPatientListType_ALL )
    {
        [self reloadMember:self.keyword];
    }
    else
    {
        if ( self.filterIDArray.count == 0 )
        {
            [self reloadMember:self.keyword];
        }
        else
        {
            self.members = [NSArray array];
            [self.collectionView reloadData];
        }
    }
    
    [self doRefresh:0];
}

- (IBAction)didRefreshButtonPressed:(UIButton*)sender
{
    [self doRefresh:0];
}

- (IBAction)didQrCodeButtonPressed:(id)sender
{
    [HospitalBarCodeView showWithUrl:self.qrCodeUrl];
}
#pragma mark - 9月份新修改 注释我的病人按钮
//- (IBAction)didMyPatientButtonPressed:(id)sender
//{
//    self.myPatientButton.highlighted = !self.myPatientButton.highlighted;
//    
//    if ( self.filterIDArray.count == 0 )
//    {
//        [self reloadMember:self.keyword];
//    }
//    else
//    {
//        self.members = [NSArray array];
//        [self.collectionView reloadData];
//    }
//    
//    [self doRefresh:0];
//}

- (IBAction)didFilterButtonPressed:(id)sender
{
#pragma mark - 9月份新修改点击分类按钮 隐藏“我的”按钮
    self.myPatientButton.hidden=YES;
    WeakSelf;
    HPatientTypeFilterViewController* vc = [[HPatientTypeFilterViewController alloc] initWithNibName:@"HPatientTypeFilterViewController" bundle:nil];
    vc.set = self.set;
    vc.selectFinished = ^(NSMutableSet *items, NSArray* filterArray) {
        weakSelf.set = items;
        weakSelf.filterIDArray = filterArray;
        [weakSelf doRefresh:0];
        if ( items.count == 0 )
        {
            [self.categroyFilterButton setImage:[UIImage imageNamed:@"patient_filter_n"] forState:UIControlStateNormal];
        }
        else
        {
            [self.categroyFilterButton setImage:[UIImage imageNamed:@"patient_filter_h"] forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:vc animated:TRUE];
}

@end
