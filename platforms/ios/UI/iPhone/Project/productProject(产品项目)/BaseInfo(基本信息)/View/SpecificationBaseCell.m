//
//  SpecificationBaseCell.m
//  Boss
//
//  Created by jiangfei on 16/7/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationBaseCell.h"
#import "SpecificationBaseAttributeValueCell.h"
@interface SpecificationBaseCell ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** array*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@end;
@implementation SpecificationBaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    [self.tableView registerClass:[SpecificationBaseAttributeValueCell class] forCellReuseIdentifier:@"cellId"];

}

-(void)setProjectTemp:(CDProjectTemplate *)projectTemp
{
    _projectTemp = projectTemp;
    self.dataArray = nil;
     [self dataArray];
    [self.tableView reloadData];
}
-(void)setOrderSet:(NSOrderedSet *)orderSet
{
    _orderSet = orderSet;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:orderSet.array];
    [self.tableView reloadData];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        if (self.projectTemp.attributeLines.count) {
            [_dataArray addObjectsFromArray:self.projectTemp.attributeLines.array];
        }else if (self.orderSet.array.count){
            [_dataArray addObjectsFromArray:self.orderSet.array];
        }
        
    }
    return _dataArray;
}

#pragma mark UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificationBaseAttributeValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.line = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDProjectAttributeLine *line = self.dataArray[indexPath.section];
    CGFloat cellH = line.attributeValues.array.count/3*50;
    if (line.attributeValues.array.count%3) {
        cellH = cellH + 50;
    }
    return cellH;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, 20);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    CDProjectAttributeLine *line = self.dataArray[section];
    [btn setTitle:[NSString stringWithFormat:@"%@:",line.attributeName] forState:UIControlStateNormal];
    [btn setTitleColor:projectTextFieldColor forState:UIControlStateNormal];
    btn.titleLabel.font = projectSmallFont;
    return btn;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
@end
