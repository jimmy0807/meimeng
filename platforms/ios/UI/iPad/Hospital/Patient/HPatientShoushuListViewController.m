//
//  HPatientShoushuListViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/9/15.
//
//

#import "HPatientShoushuListViewController.h"
#import "HPatientShoushuCreateHeader.h"
#import "HPatientShoushuTableViewCell.h"
#import "HShoushuCreateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "SeletctListViewController.h"
#import "HPatientCreateShoushuLineContainerViewController.h"
#import "NSDate+Formatter.h"
#import "HPatientBinglikaViewController.h"

@interface HPatientShoushuListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)CDHBinglika* ka;
@property(nonatomic, strong)NSArray* shoushuArray;
@property(nonatomic, strong)CDHShoushu* shoushu;
@property(nonatomic, strong)HPatientShoushuCreateHeader* headerView;
@property(nonatomic, strong)HPatientBinglikaViewController* parentVc;

@end

@implementation HPatientShoushuListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNofitificationForMainThread:kHHuizhenCreateResponse];
    [self registerNofitificationForMainThread:kHShoushuLinesResponse];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
    self.ka = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
    //NSLog(@"%@",self.ka.shoushu[2].items.count);

}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHHuizhenCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [[BSCoreDataManager currentManager] save:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
        self.ka = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ka.shoushu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 660, 62)];
    UIView * upBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 660, 20)];
    upBackgroundView.backgroundColor = COLOR(96, 211, 212, 1);
    [upBackgroundView layer].cornerRadius = 6;
    UIView * downBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, 660, 30)];
    downBackgroundView.backgroundColor = COLOR(96, 211, 212, 1);
    [view addSubview:upBackgroundView];
    [view addSubview:downBackgroundView];
    
    UILabel *shoushuName = [[UILabel alloc] initWithFrame:CGRectMake(20, 34, 200, 16)];
    shoushuName.text = self.ka.shoushu[section].name;
    shoushuName.font = [UIFont systemFontOfSize:16];
    shoushuName.textColor = [UIColor whiteColor];
    shoushuName.textAlignment = NSTextAlignmentLeft;
    [view addSubview:shoushuName];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ka.shoushu[section].items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.shoushuArray = [self.ka.shoushu[indexPath.section].items sortedArrayUsingComparator:^NSComparisonResult(CDHShoushuLine*  _Nonnull obj1, CDHShoushuLine*  _Nonnull obj2) {
        return [obj1.operate_date compare:obj2.operate_date];
    }];
    CDHShoushuLine *shoushu = self.shoushuArray[indexPath.row];
    shoushu.sortIndex = @(indexPath.row + 1);
    
    return 40 + 90 + [self contentLinesHeight:shoushu.note] + [shoushu.review_date componentsSeparatedByString:@","].count * 17 - 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.shoushuArray = [self.ka.shoushu[indexPath.section].items sortedArrayUsingComparator:^NSComparisonResult(CDHShoushuLine*  _Nonnull obj1, CDHShoushuLine*  _Nonnull obj2) {
        return [obj1.operate_date compare:obj2.operate_date];
    }];
    CDHShoushuLine *shoushu = self.shoushuArray[indexPath.row];
    shoushu.sortIndex = @(indexPath.row + 1);

    UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 660, 80)];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView * upBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 660, 130)];
    upBackgroundView.backgroundColor = [UIColor whiteColor];
    UIView * downBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 660, [self contentLinesHeight:shoushu.note] + [shoushu.review_date componentsSeparatedByString:@","].count * 17.0 - 5)];
    downBackgroundView.backgroundColor = [UIColor whiteColor];
    if(indexPath.row == self.ka.shoushu[indexPath.section].items.count - 1) {
        [downBackgroundView layer].cornerRadius = 6;
    }
    else {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 90 + 8 + [self contentLinesHeight:shoushu.note] + 32, 660, 1)];
        bottomLine.backgroundColor = COLOR(224, 230, 230, 1);
        [cell addSubview:bottomLine];
    }
    [cell addSubview:upBackgroundView];
    [cell addSubview:downBackgroundView];
    
    UILabel * shoushuOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 150, 16)];
    NSString * shoushuOrderChineseString = [self chineseStringForNumber:indexPath.row + 1];
    shoushuOrderLabel.text = [NSString stringWithFormat:@"第%@次手术",shoushuOrderChineseString];
    shoushuOrderLabel.font = [UIFont systemFontOfSize:16];
    shoushuOrderLabel.textColor = COLOR(149, 171, 171, 1);
    shoushuOrderLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shoushuOrderLabel];
    
    UILabel * doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(660-200, 12, 180, 16)];
    doctorLabel.text = [NSString stringWithFormat:@"%@",shoushu.doctor_name];
    doctorLabel.font = [UIFont systemFontOfSize:16];
    doctorLabel.textColor = COLOR(112, 109, 110, 1);
    doctorLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:doctorLabel];
    
    UIView *devideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 660, 1)];
    devideLine.backgroundColor = COLOR(224, 230, 230, 1);
    [cell addSubview:devideLine];
    
    UILabel * shoushuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 61, 300, 16)];
    shoushuTitleLabel.text = [NSString stringWithFormat:@"%@",shoushu.name];
    shoushuTitleLabel.font = [UIFont systemFontOfSize:16];
    shoushuTitleLabel.textColor = COLOR(37, 37, 37, 1);
    shoushuTitleLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shoushuTitleLabel];
    
    UILabel * shoushuDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(660-300, 61, 280, 16)];
    shoushuDateLabel.text = [NSString stringWithFormat:@"手术时间：%@",[[NSDate dateFromString:shoushu.operate_date] dateStringWithFormatter:@"yyyy-MM-dd"]];
    shoushuDateLabel.font = [UIFont systemFontOfSize:14];
    shoushuDateLabel.textColor = COLOR(154, 156, 156, 1);
    shoushuDateLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:shoushuDateLabel];
    
    UILabel * shoushuDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 620, [self contentLinesHeight:shoushu.note])];
    shoushuDetailLabel.text = [NSString stringWithFormat:@"计划情况：%@",shoushu.note];
    shoushuDetailLabel.font = [UIFont systemFontOfSize:14];
    shoushuDetailLabel.textColor = COLOR(112, 109, 110, 1);
    shoushuDetailLabel.numberOfLines = 0;
    shoushuDetailLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shoushuDetailLabel];
    
    UILabel * shoushuCheckLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 90 + 8 + [self contentLinesHeight:shoushu.note], 620, 17 * [shoushu.review_date componentsSeparatedByString:@","].count)];
    NSString *dateString = [[NSString alloc] init];
    NSArray *elementArray = [shoushu.review_date componentsSeparatedByString:@","];
    for (int i = 0; i < elementArray.count; i++) {
        if (i > 0)
        {
            dateString = [NSString stringWithFormat:@"%@\n",dateString];
        }
        NSArray *datePartArray = [elementArray[i] componentsSeparatedByString:@"@"];
        if (datePartArray.count > 1){
            NSString *datePartString = datePartArray[1];
            dateString = [NSString stringWithFormat:@"%@%@",dateString,[[NSDate dateFromString:datePartString] dateStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
            //[dateString stringByAppendingString:[[NSDate dateFromString:datePartString] dateStringWithFormatter:@"yyyy-MM-dd HH:mm"]];
        }
    }
    UILabel *checkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90 + 8 + [self contentLinesHeight:shoushu.note], 100, 17)];
    checkTitleLabel.text = @"复查时间：";
    checkTitleLabel.font = [UIFont systemFontOfSize:14];
    checkTitleLabel.textColor = COLOR(153, 153, 153, 1);
    checkTitleLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:checkTitleLabel];
    shoushuCheckLabel.text = [NSString stringWithFormat:@"%@",dateString];
    shoushuCheckLabel.numberOfLines = [shoushu.review_date componentsSeparatedByString:@","].count;
    shoushuCheckLabel.font = [UIFont systemFontOfSize:14];
    shoushuCheckLabel.textColor = COLOR(153, 153, 153, 1);
    shoushuCheckLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shoushuCheckLabel];
    
    return cell;
}

- (NSString *)chineseStringForNumber:(NSInteger)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInteger:number]];
    return string;
}

- (NSInteger)contentLinesHeight:(NSString *)content
{
    CGSize size = CGSizeZero;
    NSInteger contentWidth = [content boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:nil context:nil].size.width * 14 / 12;
    NSInteger contentLines = contentWidth / 620 + 1;
    return contentLines * 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDHShoushu* shoushu = self.ka.shoushu[indexPath.section];
    if ([self.parentViewController isKindOfClass:[HPatientBinglikaViewController class]]) {
        self.parentVc = self.parentViewController;
        [self.parentVc shouShoushuView:indexPath.section];
//        self.parentVc.rightHuizhenView.hidden = YES;
//        self.parentVc.rightShoushuView.hidden = NO;
//        self.parentVc.rightShoushuChildVc.shoushuIndex = index;
//        self.parentVc.rightShoushuListView.hidden = YES;
//        self.parentVc.rightShoushuListChildVc.shoushuIndex = -1;
//        [self.parentVc.saveButton setTitle:@"保存" forState:UIControlStateNormal];
//        self.parentVc.saveButton.hidden = NO;
//        self.parentVc.rightBackButton.hidden = YES;
    }
}

@end
