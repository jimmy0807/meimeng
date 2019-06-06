//
//  HJiaoHaoListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HJiaoHaoListViewController.h"
#import "HJiaohHaoListTableViewCell.h"
#import "FetchHJiaoHaoRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "MJRefresh.h"
#import "HJiaohaoCancelRequest.h"
#import "CBLoadingView.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
#import "SpecialButton.h"
@interface HJiaoHaoListViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* jiaohaoArray;
@property(nonatomic, strong)IBOutlet UISearchBar* searchBar;
@property(nonatomic, weak)IBOutlet UIImageView* departmentIconImageView;
@property(nonatomic, weak)IBOutlet UIImageView* finishIconImageView;
@property(nonatomic, weak)IBOutlet UIImageView* printIconImageView;
@property(nonatomic, weak)IBOutlet UIImageView* cancelIconImageView;
@property(nonatomic, weak)IBOutlet UIImageView* modifyIconImageView;
@property(nonatomic, weak)IBOutlet UIButton* backButton;

@property(nonatomic)BOOL isLoading;

#pragma mark - 9月份新修改
//tableView的header上新改按钮
@property(nonatomic, strong)SpecialButton *wodeBtn;
@property(nonatomic, strong)SpecialButton *finishedBtn;
@property(nonatomic, strong)SpecialButton *canceledBtn;
@property(nonatomic, strong)SpecialButton *yigaidanBtn;
@property(nonatomic, strong)SpecialButton *weidayinBtn;

@property(nonatomic, strong)NSIndexPath* deletePath;
@property(nonatomic, strong)HJiaoHaoRightContainerViewController* rightVc;

@end

@implementation HJiaoHaoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData:nil];
    
    [[CBLoadingView shareLoadingView] show];
    self.isLoading = YES;
    [self performSelector:@selector(stopLoadingView) withObject:nil afterDelay:5];
    
    [[[FetchHJiaoHaoRequest alloc] init] execute];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"HJiaohHaoListTableViewCell" bundle: nil] forCellReuseIdentifier:@"HJiaohHaoListTableViewCell"];
    
    WeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf fetchDataFromServer];
    }];
    
    [self setHeaderView];
    
    self.tableView.estimatedRowHeight = 96;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchHJiaoHaoResponse])
    {
        if ( [notification.object isKindOfClass:[NSArray class]] )
        {
            self.jiaohaoArray = notification.object;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadData:self.searchBar.text];
            });
            [self.tableView.mj_header endRefreshing];
        }
        
        [[CBLoadingView shareLoadingView] hide];
        self.isLoading = NO;
    }
    else if ([notification.name isEqualToString:kHJiaoHaoCancelResponse])
    {
        [self fetchDataFromServer];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSPrinterSuccessResponse])
    {
        [self fetchDataFromServer];
    }
    else if ([notification.name isEqualToString:@"DidBecomeActive"])
    {
        [self fetchDataFromServer];
    }
    else if ([notification.name isEqualToString:@"WillResignActive"])
    {
        self.backButton.enabled = YES;
        [self.tableView.mj_header endRefreshing];
        [[CBLoadingView shareLoadingView] hide];
        self.isLoading = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableView.mj_header endRefreshing];
    [[CBLoadingView shareLoadingView] hide];
    self.isLoading = NO;
    
    [self removeNotificationOnMainThread:kFetchHJiaoHaoResponse];
    [self removeNotificationOnMainThread:kHJiaoHaoCancelResponse];
    [self removeNotificationOnMainThread:kBSPrinterSuccessResponse];
    [self removeNotificationOnMainThread:@"DidBecomeActive"];
    [self removeNotificationOnMainThread:@"WillResignActive"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNofitificationForMainThread:kFetchHJiaoHaoResponse];
    [self registerNofitificationForMainThread:kHJiaoHaoCancelResponse];
    [self registerNofitificationForMainThread:kBSPrinterSuccessResponse];
    [self registerNofitificationForMainThread:@"DidBecomeActive"];
    [self registerNofitificationForMainThread:@"WillResignActive"];
}

- (void)fetchDataFromServer
{
    FetchHJiaoHaoRequest* request = [[FetchHJiaoHaoRequest alloc] init];
    
#pragma mark - 9月份新修改
    //NSLog(@"按钮状态: %d \n %d",self.finishedBtn.isSelected,self.weidayinBtn.isSelected);
    request.isDone = self.finishedBtn.isSelected;
    request.isPrint = self.weidayinBtn.isSelected;
    request.isMySelf = self.wodeBtn.isSelected;
    request.isCancel = self.canceledBtn.isSelected;
    request.isModify = self.yigaidanBtn.isSelected;
    
    request.keyword = self.searchBar.text;
    [request execute];
    [[CBLoadingView shareLoadingView] show];
    self.isLoading = YES;
    [self performSelector:@selector(stopLoadingView) withObject:nil afterDelay:5];
}

- (void)stopLoadingView
{
    [[CBLoadingView shareLoadingView] hide];
    self.isLoading = NO;
}

- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 725, 130.0)];
    //headerView.backgroundColor = [UIColor clearColor];
    
    #pragma mark - 9月份新修改新按钮部分
    SpecialButton *shaixuanBtn = [SpecialButton initWithTitle:@"筛选:" andRect:CGRectMake(0,22,64,26) andCanClick:NO andBlock:^{}];
    [headerView addSubview:shaixuanBtn];
    
    self.wodeBtn = [SpecialButton initWithTitle:@"我的" andRect:CGRectMake(CGRectGetMaxX(shaixuanBtn.frame)+30,22,64,26) andCanClick:YES andBlock:^{}];
    [headerView addSubview:_wodeBtn];
    
    UILabel *shuxian1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.wodeBtn.frame)+10, CGRectGetMinY(self.wodeBtn.frame)+5, 1, CGRectGetHeight(self.wodeBtn.frame)-10)];
    shuxian1.backgroundColor = [UIColor colorWithRed:149/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [headerView addSubview:shuxian1];
    
    self.finishedBtn = [SpecialButton initWithTitle:@"已完成" andRect:CGRectMake(CGRectGetMaxX(_wodeBtn.frame)+30,22,64,26) andCanClick:YES andBlock:^{
        [self fetchDataFromServer];
    }];
    [headerView addSubview:_finishedBtn];
    
    UILabel *shuxian2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.finishedBtn.frame)+10, CGRectGetMinY(self.finishedBtn.frame)+5, 1, CGRectGetHeight(self.finishedBtn.frame)-10)];
    shuxian2.backgroundColor = [UIColor colorWithRed:149/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [headerView addSubview:shuxian2];
    
    self.canceledBtn = [SpecialButton initWithTitle:@"已取消" andRect:CGRectMake(CGRectGetMaxX(_finishedBtn.frame)+30,22,64,26) andCanClick:YES andBlock:^{
        [self fetchDataFromServer];
    }];
    [headerView addSubview:_canceledBtn];
    
    UILabel *shuxian3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.canceledBtn.frame)+10, CGRectGetMinY(self.canceledBtn.frame)+5, 1, CGRectGetHeight(self.canceledBtn.frame)-10)];
    shuxian3.backgroundColor = [UIColor colorWithRed:149/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [headerView addSubview:shuxian3];
    
    self.yigaidanBtn = [SpecialButton initWithTitle:@"已改单" andRect:CGRectMake(CGRectGetMaxX(_canceledBtn.frame)+30,22,64,26) andCanClick:YES andBlock:^{
        [self fetchDataFromServer];
    }];
    [headerView addSubview:_yigaidanBtn];
    
    UILabel *shuxian4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.yigaidanBtn.frame)+10, CGRectGetMinY(self.yigaidanBtn.frame)+5, 1, CGRectGetHeight(self.yigaidanBtn.frame)-10)];
    shuxian4.backgroundColor = [UIColor colorWithRed:149/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [headerView addSubview:shuxian4];
    
    self.weidayinBtn = [SpecialButton initWithTitle:@"未打印" andRect:CGRectMake(CGRectGetMaxX(_yigaidanBtn.frame)+30,22,64,26) andCanClick:YES andBlock:^{
        [self fetchDataFromServer];
    }];
    [headerView addSubview:_weidayinBtn];
    //9月份新修改 因为headerView上加了按钮 所以高度加大
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 725, 46.0)];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"pad_background_white_color"]];
    //UIImage *searchFieldImage = [[UIImage imageNamed:@"pad_member_search_field"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)];
    //[self.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = @"请输入";
    self.searchBar.delegate = self;
    [headerView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = headerView;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    if (self.isLoading) {
        return;
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 9月份新修改 要修改下关键变量
- (void)reloadData:(NSString*)keyword
{
    self.jiaohaoArray = [[BSCoreDataManager currentManager] fetchAllJiaoHao:keyword isDepart:self.wodeBtn.isSelected isFinish:self.finishedBtn.isSelected isPrint:self.weidayinBtn.isSelected];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jiaohaoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJiaohHaoListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HJiaohHaoListTableViewCell"];
    cell.jiaohao = self.jiaohaoArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* tableViewStoryboard = [UIStoryboard storyboardWithName:@"HJiaoHaoBoard" bundle:nil];
    self.rightVc = [tableViewStoryboard instantiateInitialViewController];
    self.rightVc.jiaohao = self.jiaohaoArray[indexPath.row];
    WeakSelf;
    self.rightVc.editFinished = ^{
        [weakSelf fetchDataFromServer];
    };
    
    [self.view addSubview:self.rightVc.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDHJiaoHao* jiaohao = self.jiaohaoArray[indexPath.row];
    WeakSelf;
    
    UITableViewRowAction* rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:jiaohao.jump_name handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您确定要%@吗?",jiaohao.jump_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [v show];
        weakSelf.deletePath = indexPath;
    }];
    
    rowAction.backgroundColor = COLOR(251, 198, 9, 1);
    
    return @[rowAction];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 && self.deletePath )
    {
        CDHJiaoHao* jiaohao = self.jiaohaoArray[self.deletePath.row];
        HJiaohaoCancelRequest* request = [[HJiaohaoCancelRequest alloc] init];
        request.jiaohao = jiaohao;
        [request execute];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
    
    CDHJiaoHao* jiaohao = self.jiaohaoArray[indexPath.row];
    if ( jiaohao.jump_name.length > 1 )
    {
        return TRUE;
    }
    
    return FALSE;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadData:searchText];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self fetchDataFromServer];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

#pragma mark - 9月份新修改（选定与没选定发不同的API）最后修改的话Xib中控件要去掉
//- (IBAction)didDepartmentPressed:(id)sender
//{
//    self.departmentIconImageView.highlighted = !self.departmentIconImageView.highlighted;
//    [self fetchDataFromServer];
//}
//
//- (IBAction)didFinsihedPressed:(id)sender
//{
//    self.finishIconImageView.highlighted = !self.finishIconImageView.highlighted;
//    [self fetchDataFromServer];
//}
//
//- (IBAction)didPrintedPressed:(id)sender
//{
//    self.printIconImageView.highlighted = !self.printIconImageView.highlighted;
//    [self fetchDataFromServer];
//}
//
//- (IBAction)didIsCancelPressed:(id)sender
//{
//    self.cancelIconImageView.highlighted = !self.cancelIconImageView.highlighted;
//    [self fetchDataFromServer];
//}

- (IBAction)didModifyPressed:(id)sender
{
    self.modifyIconImageView.highlighted = !self.modifyIconImageView.highlighted;
    [self fetchDataFromServer];
}

@end
