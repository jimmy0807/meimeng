//
//  moreSetUpController.m
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "moreSetUpController.h"
#import "moreSetupCell.h"
#import "moreSetupModel.h"
#import "canReplaceProjectController.h"
@interface moreSetUpController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** dataArray*/
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation moreSetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
#pragma mark 初始化tableView
-(void)setUpTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"moreSetupCell" bundle:nil] forCellReuseIdentifier:@"moreCellId"];
   self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark 懒加载(数据)
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *tmpArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"moreSetUpController" ofType:@"plist"];
        tmpArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        for (int i=0; i<tmpArray.count; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in tmpArray[i]) {
                moreSetupModel *model = [moreSetupModel moreSetupModelWithDict:(NSMutableDictionary*)dict];
                [arr addObject:model];
            }
            [_dataArray addObject:arr];
        }
    }
    return _dataArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    moreSetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellId"];
    cell.setUpModel = self.dataArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    moreSetupModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.placeHold isEqualToString:@"请选择"]) {
        canReplaceProjectController *pc = [[canReplaceProjectController alloc]init];
        [self.navigationController pushViewController:pc animated:YES];
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
