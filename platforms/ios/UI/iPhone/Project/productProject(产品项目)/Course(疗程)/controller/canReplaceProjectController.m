//
//  canReplaceProjectController.m
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "canReplaceProjectController.h"
#import "replaceProjectCell.h"
@interface canReplaceProjectController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation canReplaceProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableView
    [self setUpTableView];
}
#pragma mark - 初始化tableView
-(void)setUpTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"replaceProjectCell" bundle:nil] forCellReuseIdentifier:@"replaceCellId"];
    self.tableView.rowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replaceCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addBtnClick:(UIButton *)sender {
   // NSLog(@"添加");
}

@end
