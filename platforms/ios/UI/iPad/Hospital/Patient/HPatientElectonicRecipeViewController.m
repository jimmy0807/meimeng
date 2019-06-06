//
//  HPatientElectonicRecipeViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/9/19.
//
//

#import "HPatientElectonicRecipeViewController.h"
#import "HPatientShoushuCreateHeader.h"
#import "HPatientShoushuTableViewCell.h"
#import "HShoushuCreateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "SeletctListViewController.h"
#import "HPatientCreateShoushuLineContainerViewController.h"
#import "NSDate+Formatter.h"
#import "HPatientBinglikaViewController.h"
#import "FetchHBinglikaDetailRequest.h"
#import "HPatientCreateRecipeViewController.h"

@interface HPatientElectonicRecipeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)CDHBinglika* ka;
@property(nonatomic, strong)NSArray* recipeArray;
//@property(nonatomic, weak)HPatientCreateRecipeViewController* createVC;

@end

@implementation HPatientElectonicRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNofitificationForMainThread:kHHuizhenLinesResponse];
    [self registerNofitificationForMainThread:kHHuizhenCreateResponse];
    [self registerNofitificationForMainThread:kHBinglikaResponse];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
    self.ka = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
    self.recipeArray = [[NSArray alloc] initWithObjects:@"1", @"2", nil];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recipeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recipeDetailString = @"处方：阿司匹林肠溶片 1盒 用法：一日3次，每次3片；玻尿酸 1支；美国进口疤克kelo-coto巴克硅胶软胶 2瓶 用法：一日2次，早中饭后30mL；";
    NSString * recipeNoteString = @"备注：它是只充气机器人,也是个医疗伴侣，能够快速扫描，检测出人体的不正常情绪或受伤，并对其治疗。大白呆萌可爱，作为机器人医生它很称职，也是小宏最好的朋友。";
    NSInteger detailHeight = [self contentLinesHeight:recipeDetailString];
    NSInteger noteHeight = [self contentLinesHeight:recipeNoteString];
    return 115 + detailHeight + noteHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recipeDetailString = @"处方：阿司匹林肠溶片 1盒 用法：一日3次，每次3片；玻尿酸 1支；美国进口疤克kelo-coto巴克硅胶软胶 2瓶 用法：一日2次，早中饭后30mL；";
    NSString * recipeNoteString = @"备注：它是只充气机器人,也是个医疗伴侣，能够快速扫描，检测出人体的不正常情绪或受伤，并对其治疗。大白呆萌可爱，作为机器人医生它很称职，也是小宏最好的朋友。";
    NSInteger detailHeight = [self contentLinesHeight:recipeDetailString];
    NSInteger noteHeight = [self contentLinesHeight:recipeNoteString];

    UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 660, 80)];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 660, 115 + detailHeight + noteHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView layer].cornerRadius = 6;
    [cell addSubview:backgroundView];
    
//    UILabel * recipeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 300, 16)];
//    recipeTitleLabel.text = [NSString stringWithFormat:@"临床诊断：感冒"];
//    recipeTitleLabel.font = [UIFont systemFontOfSize:16];
//    recipeTitleLabel.textColor = COLOR(149, 171, 171, 1);
//    recipeTitleLabel.textAlignment = NSTextAlignmentLeft;
//    [cell addSubview:recipeTitleLabel];
    
    UILabel * doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 300, 16)];
    doctorLabel.text = [NSString stringWithFormat:@"杨医生"];
    doctorLabel.font = [UIFont systemFontOfSize:16];
    doctorLabel.textColor = COLOR(149, 171, 171, 1);
    doctorLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:doctorLabel];
    
    UILabel * recipeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(660-200, 13, 180, 14)];
    recipeDateLabel.text = [NSString stringWithFormat:@"2017-04-22 12:23"];
    recipeDateLabel.font = [UIFont systemFontOfSize:13];
    recipeDateLabel.textColor = COLOR(155, 155, 155, 1);
    recipeDateLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:recipeDateLabel];
    
    UIView *devideLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 660, 1)];
    devideLine.backgroundColor = COLOR(224, 230, 230, 1);
    [cell addSubview:devideLine];
    
//    UILabel * recipeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(660-310, 63, 300, 14)];
//    recipeTypeLabel.text = [NSString stringWithFormat:@"处方类型：普通处方        科室：皮肤科"];
//    recipeTypeLabel.font = [UIFont systemFontOfSize:13];
//    recipeTypeLabel.textColor = COLOR(155, 155, 155, 1);
//    recipeTypeLabel.textAlignment = NSTextAlignmentRight;
//    [cell addSubview:recipeTypeLabel];
    
    UILabel * recipeDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 620, [self contentLinesHeight:recipeDetailString])];
    recipeDetailLabel.text = [NSString stringWithFormat:recipeDetailString];
    recipeDetailLabel.font = [UIFont systemFontOfSize:14];
    recipeDetailLabel.textColor = COLOR(112, 109, 110, 1);
    recipeDetailLabel.numberOfLines = 0;
    recipeDetailLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:recipeDetailLabel];
    
    UILabel * recipeNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65 + [self contentLinesHeight:recipeDetailString], 620, [self contentLinesHeight:recipeNoteString])];
    recipeNoteLabel.text = [NSString stringWithFormat:recipeNoteString];
    recipeNoteLabel.font = [UIFont systemFontOfSize:14];
    recipeNoteLabel.textColor = COLOR(112, 109, 110, 1);
    recipeNoteLabel.numberOfLines = 0;
    recipeNoteLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:recipeNoteLabel];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Delete row:%d", indexPath.row);
    }
}

- (void)didCreateRecipeButtonPressed
{
    self.createVC = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"createRecipe"];
//    self.createVC.huizhen = [[BSCoreDataManager currentManager] insertEntity:@"CDHHuizhen"];
//    self.createVC.huizhen.binglika = self.ka;
    [self.view addSubview:self.createVC.view];
}

- (void)didSaveRecipeButtonPressed
{
//    [self.createVC didSaveHuizhenButtonPressed];
}

- (void)didBackButtonPressed
{
//    if ( [self.createVC.huizhen.huizhen_id integerValue] == 0 )
//    {
//        [[BSCoreDataManager currentManager] deleteObject:self.createVC.huizhen];
//    }
}

- (void)popNavi
{
    //[self.createVC.navigationController popViewControllerAnimated:YES];
    if (self.createVC != nil)
    {
        [self.createVC.view removeFromSuperview];
    }
}

- (NSInteger)contentLinesHeight:(NSString *)content
{
    CGSize size = CGSizeZero;
    NSInteger contentWidth = [content boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:nil context:nil].size.width * 14 / 12;
    NSInteger contentLines = contentWidth / 620 + 1;
    return contentLines * 20;
}
@end
