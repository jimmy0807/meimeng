//
//  naviAddPopView.m
//  Boss
//
//  Created by jiangfei on 16/7/4.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "NaviAddPopView.h"
#import "AddPopModel.h"
@interface NaviAddPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** tableView数组*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
@implementation NaviAddPopView

static  NSString *cellId = @"cellId";
+(instancetype)naviAddPopView
{
    NaviAddPopView *popView = [[[NSBundle mainBundle]loadNibNamed:@"NaviAddPopView" owner:nil options:nil]lastObject];
    return popView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化，添加子控件等
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //初始化，添加子控件等
    [self setUp];
}
#pragma mark - 初始化，添加子控件等
-(void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 2;
    self.tableView.rowHeight = 50.0;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        AddPopModel *model1 = [AddPopModel addPopModelWith:@"sale_fast" andTitleName:@"快速销售"];
        AddPopModel *model2 = [AddPopModel addPopModelWith:@"sale_code" andTitleName:@"扫码销售"];
        [_dataArray addObjectsFromArray:@[model1,model2]];
    }
    return _dataArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.backgroundColor = [UIColor clearColor];
    AddPopModel *popModel = self.dataArray[indexPath.row];
    cell.imageView.image = popModel.image;
    cell.textLabel.text = popModel.titleName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_popBlock) {
        _popBlock(indexPath.row);
    }
}
@end
