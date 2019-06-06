//
//  PadHospitalFenzhenListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import "PadHospitalFenzhenListViewController.h"
#import "UIImage+Resizable.h"
#import "HFenzhenListTableViewCell.h"
#import "MJRefresh.h"
#import "FetchHZixunRequest.h"
#import "HZixunCreateContainerViewController.h"
#import "PadProjectViewController.h"
#import "HZixunQianzaikeRequest.h"

@interface PadHospitalFenzhenListViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)UISearchBar* headSearchBar;
@property(nonatomic, strong)NSArray* fenzhemArray;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@end

@implementation PadHospitalFenzhenListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FetchHZixunRequest* request = [[FetchHZixunRequest alloc] initWithStoreID:nil startIndex:0];
    request.categoryName = self.categoryName;
    [request execute];
    
    [self initHeaderView];
    [self initFooterView];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"HFenzhenListTableViewCell" bundle: nil] forCellReuseIdentifier:@"HFenzhenListTableViewCell"];
    
    self.fenzhemArray = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:nil categoryName:self.categoryName];
    
    [self registerNofitificationForMainThread:kFetchHZixunResponse];
    [self registerNofitificationForMainThread:kHZixunCreateResponse];
    
    if ( [self.categoryName isEqualToString:@"advisory"] )
    {
        self.titleLabel.text = @"咨询";
    }
    else if ( [self.categoryName isEqualToString:@"complaints"] )
    {
        self.titleLabel.text = @"投诉";
    }
    else if ( [self.categoryName isEqualToString:@"service"] )
    {
        self.titleLabel.text = @"客服";
    }
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 82)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.headSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 18.5, self.tableView.frame.size.width, 45)];
    [self.headSearchBar setBackgroundImage:[UIImage imageNamed:@"pad_background_white_color"]];
    //UIImage *searchFieldImage = [[UIImage imageNamed:@"pad_member_search_field"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    //[self.headSearchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    self.headSearchBar.returnKeyType = UIReturnKeySearch;
    self.headSearchBar.placeholder = @"搜索客户";
    self.headSearchBar.delegate = self;
    [headerView addSubview:self.headSearchBar];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)initFooterView
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        FetchHZixunRequest* request = [[FetchHZixunRequest alloc] initWithStoreID:nil startIndex:self.fenzhemArray.count];
        request.categoryName = self.categoryName;
        [request execute];
    }];
    [self.tableView.mj_footer endRefreshing];
    [(MJRefreshAutoNormalFooter*)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
}


- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchHZixunResponse])
    {
        self.fenzhemArray = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:nil categoryName:self.categoryName];
        NSLog(@"查询self.fenzhemArray=%@",self.fenzhemArray);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    else if ([notification.name isEqualToString:kHZixunCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            self.fenzhemArray = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:nil categoryName:self.categoryName];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            FetchHZixunRequest* request = [[FetchHZixunRequest alloc] initWithStoreID:nil startIndex:self.fenzhemArray.count];
            request.categoryName = self.categoryName;
            [request execute];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fenzhemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFenzhenListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HFenzhenListTableViewCell"];
    
    WeakSelf;
    CDHZixun* zixun = self.fenzhemArray[indexPath.row];
    cell.zixun = zixun;
    
    cell.cellButtonPressed = ^(CDHZixun *zixun) {
        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HZixunBoard" bundle:nil];
        HZixunCreateContainerViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createZixun"];
        vc.zixun = zixun;
        vc.categoryName = self.categoryName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.kaidanButtonPressed = ^{
        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:zixun.mobile forKey:@"mobile"];
        PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:member.card.firstObject couponCard:nil handno:@""];
        [self.navigationController pushViewController:viewController animated:YES];
    };
    
    cell.qianzaikeButtonPressed = ^{
        HZixunQianzaikeRequest* request = [[HZixunQianzaikeRequest alloc] init];
        request.zixun = zixun;
        [request execute];
    };

    CDHCustomer* c = [[BSCoreDataManager currentManager] findEntity:@"CDHCustomer" withValue:zixun.customer_id forKey:@"memberID"];
    
    [cell.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",zixun.customer_id, self.zixun.customer_name] tableName:@"born.medical.customer" filter:zixun.customer_id fieldName:@"image" writeDate:c.lastUpdate placeholderString:@"user_default" cacheDictionary:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    
}

- (IBAction)didCreateButtonPressed:(id)sender
{
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HZixunBoard" bundle:nil];
    HZixunCreateContainerViewController* vc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createZixun"];
    vc.categoryName = self.categoryName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.fenzhemArray = [[BSCoreDataManager currentManager] fetchAllHZixunWithStoreID:nil keyword:searchText categoryName:self.categoryName];
    [self.tableView reloadData];
}

@end
