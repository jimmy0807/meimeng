//
//  HPatientBingliRightHuizhenxinxiViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientBingliRightHuizhenxinxiViewController.h"
#import "HPatientRightHuizhenxinxiTableViewCell.h"
#import "HPatientCreateBingliViewController.h"
#import "YimeiFullScreenPhotoViewController.h"
#import "DeleteHuizhenRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "FetchHBinglikaDetailRequest.h"

@interface HPatientBingliRightHuizhenxinxiViewController ()
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)CDHBinglika* ka;
@property(nonatomic, weak)HPatientCreateBingliViewController* createVC;
@end

@implementation HPatientBingliRightHuizhenxinxiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kHHuizhenLinesResponse];
    [self registerNofitificationForMainThread:kHHuizhenCreateResponse];
    [self registerNofitificationForMainThread:kHBinglikaResponse];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 274;
    
    [self reloadData];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHHuizhenLinesResponse])
    {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kHHuizhenCreateResponse])
    {
        [[[FetchHBinglikaDetailRequest alloc] initWithBinglikaID:self.member.record_id] execute];
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kHBinglikaResponse])
    {
        [self reloadData];
    }
}

- (void)reloadData
{
    self.ka = [[BSCoreDataManager currentManager] findEntity:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
    //[self.ka insertObject:self.createVC.huizhen inHuizhenAtIndex:0];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPatientRightHuizhenxinxiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HPatientRightHuizhenxinxiTableViewCell"];
    
    CDHHuizhen* huizhen = self.ka.huizhen[indexPath.section];
    
    cell.huizhen = huizhen;
    
    WeakSelf;
    cell.huizhenPhotoButtonPressed = ^{
        NSMutableArray* array = [NSMutableArray array];
        for ( CDYimeiImage* image in huizhen.photos )
        {
            [array addObject:image.url];
        }
        YimeiFullScreenPhotoViewController* vc = [[YimeiFullScreenPhotoViewController alloc] initWithNibName:@"YimeiFullScreenPhotoViewController" bundle:nil];
        vc.photos = array;
        [weakSelf.parentViewController.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ka.huizhen.count;
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
    
    CDHHuizhen* huizhen = self.ka.huizhen[indexPath.section];
    self.createVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"createBingli"];
    self.createVC.huizhen = huizhen;
    self.editItemBlcok();
    [self.navigationController pushViewController:self.createVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDHHuizhen* huizhen = self.ka.huizhen[indexPath.section];
    //WeakSelf;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"record_line_id"] = huizhen.huizhen_id;
        DeleteHuizhenRequest* request = [[DeleteHuizhenRequest alloc] init];
        request.params = params;
        [request execute];
        [[CBLoadingView shareLoadingView] show];
        request.finished = ^(NSDictionary *params) {
            [[CBLoadingView shareLoadingView] hide];
            if ( [params[@"rc"] integerValue] == 0 )
            {
                huizhen.binglika = nil;
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [[[CBMessageView alloc] initWithTitle:params[@"rm"]] show];
            }
        };
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didCreateHuizhenButtonPressed
{
    self.createVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"createBingli"];
    self.createVC.huizhen = [[BSCoreDataManager currentManager] insertEntity:@"CDHHuizhen"];
    self.createVC.huizhen.binglika = self.ka;
    [self.navigationController pushViewController:self.createVC animated:YES];
}

- (void)didSaveHuizhenButtonPressed
{
    [self.createVC didSaveHuizhenButtonPressed];
}

- (void)didBackButtonPressed
{
    if ( [self.createVC.huizhen.huizhen_id integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.createVC.huizhen];
    }
}

- (void)popNavi
{
    [self.createVC.navigationController popViewControllerAnimated:YES];
}

@end
