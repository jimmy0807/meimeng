//
//  prodcutPopView.m
//  Boss
//
//  Created by jiangfei on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "productPopView.h"
#define  selColor [UIColor colorWithRed:41/255.0 green:104/255.0 blue:254/255.0 alpha:1]
@interface productPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *popImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** cell*/
@property (nonatomic,strong)UITableViewCell *seletedCell;
@end
@implementation productPopView
static NSString *cellId = @"cellId";
+(instancetype)productPopView
{
    productPopView *popView = [[[NSBundle mainBundle]loadNibNamed:@"productPopView" owner:nil options:nil]lastObject];
    return popView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.popImageView.layer.cornerRadius = 4;
    self.popImageView.clipsToBounds = YES;
    self.tableView.layer.cornerRadius = 4;
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 50;
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)setSeletedName:(NSString *)seletedName
{
    _seletedName = seletedName;
    for (int i=0; i<self.titleNameArray.count; i++) {
        if ([seletedName isEqualToString:self.titleNameArray[i]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            self.seletedCell.textLabel.textColor = cell.textLabel.textColor;
            self.seletedCell.accessoryView = nil;
            cell.textLabel.textColor = selColor;
            UIImageView *iView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"productCheck"]];
            cell.accessoryView = iView;
            self.seletedCell = cell;
            
        }
    }
}
-(void)setTitleNameArray:(NSMutableArray *)titleNameArray
{
    _titleNameArray = titleNameArray;
    [self.tableView reloadData];
}
#pragma mark 加载selCell
-(UITableViewCell *)seletedCell
{
    if (!_seletedCell) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        _seletedCell = cell;
    }
    return _seletedCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.titleNameArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0  blue:244/255.0  alpha:1.0];
    }
    
    cell.textLabel.text = self.titleNameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.seletedCell.textLabel.textColor = cell.textLabel.textColor;
    self.seletedCell.accessoryView = nil;
    cell.textLabel.textColor = selColor;
    UIImageView *iView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"productCheck"]];
    cell.accessoryView = iView;
    if (_popBlock) {
        _popBlock(cell.textLabel.text,indexPath.row);
    }
    self.seletedCell = cell;
}

@end
