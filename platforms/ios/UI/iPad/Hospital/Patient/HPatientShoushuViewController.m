//
//  HPatientShoushuViewController.m
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import "HPatientShoushuViewController.h"
#import "HPatientShoushuCreateHeader.h"
#import "HPatientShoushuTableViewCell.h"
#import "HShoushuCreateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "SeletctListViewController.h"
#import "HPatientCreateShoushuLineContainerViewController.h"

@interface HPatientShoushuViewController ()
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)HPatientShoushuCreateHeader* headerView;
@property(nonatomic, strong)CDHBinglika* ka;
@property(nonatomic, strong)HPatientCreateShoushuLineContainerViewController* createVC;
@property(nonatomic, strong)NSArray* shoushuArray;
@end

@implementation HPatientShoushuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerView = [HPatientShoushuCreateHeader loadFromNib];
    self.tableView.tableHeaderView = self.headerView;
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120)];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, 30, self.tableView.frame.size.width - 60, 60);
    [btn setTitle:@"添加手术" forState:UIControlStateNormal];
    btn.backgroundColor = COLOR(82, 203, 201, 1);
    [btn addTarget:self action:@selector(didCreateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    self.tableView.tableFooterView = v;
    
    [self reloadData];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self registerNofitificationForMainThread:kHShoushuCreateResponse];
    [self registerNofitificationForMainThread:kHShoushuLinesResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHShoushuCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"信息修改成功"] show];
            [self reloadData];
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
    else if ([notification.name isEqualToString:kHShoushuLinesResponse])
    {
        [self reloadData];
    }
}

- (void)reloadData
{
    self.ka = [[BSCoreDataManager currentManager] findEntity:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
    self.shoushuArray = [self.headerView.shoushu.items sortedArrayUsingComparator:^NSComparisonResult(CDHShoushuLine*  _Nonnull obj1, CDHShoushuLine*  _Nonnull obj2) {
        return [obj1.operate_date compare:obj2.operate_date];
    }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPatientShoushuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HPatientShoushuTableViewCell"];
    
    CDHShoushuLine* shoushu = self.shoushuArray[indexPath.section];
    shoushu.sortIndex = @(indexPath.section + 1);
    cell.shoushu = shoushu;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shoushuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    v.backgroundColor = [UIColor clearColor];
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDHShoushuLine* shoushu = self.shoushuArray[indexPath.section];
    self.createVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"create_shoushu_line"];
    self.createVC.shoushuLine = shoushu;
    [self.parentViewController.view addSubview:self.createVC.view];
    
    WeakSelf;
    
    self.createVC.doReload = ^{
        [weakSelf reloadData];
    };
}

- (void)setShoushuIndex:(NSInteger)shoushuIndex
{
    _shoushuIndex = shoushuIndex;
    if ( shoushuIndex >= 0 )
    {
        self.headerView.shoushu = self.ka.shoushu[shoushuIndex];
    }
    else
    {
        self.headerView.shoushu = [[BSCoreDataManager currentManager] insertEntity:@"CDHShoushu"];
    }
    
    [self reloadData];
}

- (void)didCreateButtonPressed:(id)sender
{
    self.createVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"create_shoushu_line"];
    self.createVC.shoushuLine = [[BSCoreDataManager currentManager] insertEntity:@"CDHShoushuLine"];
    self.createVC.shoushuLine.shoushu = self.headerView.shoushu;
    WeakSelf;
    
    self.createVC.doReload = ^{
        [weakSelf reloadData];
    };
    [self.parentViewController.view addSubview:self.createVC.view];
}

- (void)didSaveHuizhenButtonPressed
{    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if ( self.headerView.nameTextField.text.length > 0 )
    {
        [params setObject:self.headerView.nameTextField.text forKey:@"name"];
        self.headerView.shoushu.name = self.headerView.nameTextField.text;
    }
    
    if ( [self.headerView.shoushu.doctor_id integerValue] > 0 )
    {
        [params setObject:self.headerView.shoushu.doctor_id forKey:@"doctor_id"];
    }
    
    if ( self.headerView.zhiruTimeTextField.text.length > 1 )
    {
        [params setObject:self.headerView.zhiruTimeTextField.text forKey:@"expander_in_date"];
        self.headerView.shoushu.expander_in_date = self.headerView.zhiruTimeTextField.text;
    }
    
    if ( self.headerView.fuzhenDayTextField.text.length > 1 )
    {
        [params setObject:self.headerView.fuzhenDayTextField.text forKey:@"expander_review_days_1"];
        self.headerView.shoushu.expander_review_days_1 = self.headerView.fuzhenDayTextField.text;
    }
    
    if ( self.headerView.shoushuTimeTextField.text.length > 1 )
    {
        [params setObject:self.headerView.shoushuTimeTextField.text forKey:@"first_treat_date"];
        self.headerView.shoushu.first_treat_date = self.headerView.shoushuTimeTextField.text;
    }
    
    [params setObject:self.member.memberID forKey:@"member_id"];
    [params setObject:self.member.record_id forKey:@"records_id"];
    
    if ( [self.headerView.shoushu.shoushu_id integerValue] == 0 )
    {
        NSMutableArray* array = [NSMutableArray array];
        for (CDHShoushuLine* line in self.shoushuArray )
        {
            NSMutableDictionary *lines = [NSMutableDictionary dictionary];
            if ( line.name.length != 0 )
            {
                [lines setObject:line.name forKey:@"name"];
            }
            
            if ( line.operate_date.length > 0  )
            {
                [lines setObject:line.operate_date forKey:@"operate_date"];
            }
            
            if ( line.note.length != 0 )
            {
                [lines setObject:line.note forKey:@"note"];
            }
            
            if ( [line.review_days integerValue]  > 0 )
            {
                [lines setObject:line.review_days forKey:@"review_days"];
            }
            
            if ( line.review_date.length > 0  )
            {
                //[lines setObject:line.review_date forKey:@"review_date"];
                NSMutableArray *requestArray = [[NSMutableArray alloc] init];
                NSArray *elementArray = [line.review_date componentsSeparatedByString:@","];
                for (int i = 0; i < elementArray.count; i++) {
                    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
                    NSArray *datePartArray = [elementArray[i] componentsSeparatedByString:@"@"];
                    if (datePartArray.count > 1){
                        NSString *datePartString = datePartArray[1];
                        [dateArray addObject:@0];
                        [dateArray addObject:@0];
                        NSDictionary *reviewDateDict = [NSDictionary dictionaryWithObject:datePartString forKey:@"review_date"];
                        [dateArray addObject:reviewDateDict];
                    }
                    [requestArray addObject:dateArray];
                }
                [lines setObject:requestArray forKey:@"review_date_ids"];
            }
            
            
            NSMutableArray* idsArray = [NSMutableArray array];
            for (NSString* n in [line.operate_tags componentsSeparatedByString:@","] )
            {
                if ( n.length > 0 )
                {
                    [idsArray addObject:@(n.integerValue)];
                }
            }
            
            [lines setObject:@[@[@(6),@(FALSE),@[idsArray]]] forKey:@"operate_tags_ids"];
            
            [lines setObject:line.doctor_id forKey:@"doctor_id"];
            [lines setObject:line.product_id forKey:@"product_id"];
            
            [array addObject:@[@(0),@(FALSE),lines]];
        }
        [params setObject:array forKey:@"line_ids"];
    }
    
    HShoushuCreateRequest* request = [[HShoushuCreateRequest alloc] initWithShoushuID:self.headerView.shoushu.shoushu_id params:params isEdit:NO];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)dealloc
{
    if ( [self.headerView.shoushu.shoushu_id integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.headerView.shoushu];
    }
}

@end
