//
//  ProductCategorySubRightController.m
//  Boss
//
//  Created by jiangfei on 16/5/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductCategorySubRightController.h"
#import "UIBarButtonItem+JFExtension.h"
#import "subRightNaviTitleView.h"
#import "rightSubCell.h"
/**
 *  产品分类左边的控制器tableView被点击
 *
 */
#define productProjectLeftTableViewClickNotification @"productProjectLeftTableViewClickNotification"
/**
 *  产品分类左边tableView被点击的
 */
#define productProjectLeftTalbeViewClickWithCategory @"productProjectLeftTalbeViewClickWithCategory"
@interface ProductCategorySubRightController ()<UITableViewDelegate,UITableViewDataSource>
/** naviView*/
@property (nonatomic,weak)subRightNaviTitleView *naviView;
/** tableView*/
@property (nonatomic,weak)UITableView *tableView;
/** subCategory*/
@property (nonatomic,strong)NSMutableArray *subCategory;
@end

@implementation ProductCategorySubRightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加naviView控件
    [self naviView];
    //添加tableView
    [self tableView];
    
    [self addNotification];
}

#pragma mark 添加通知监听器
-(void)addNotification
{
    [myNotification addObserver:self selector:@selector(tableViewReload:) name:productProjectLeftTableViewClickNotification object:nil];
}
#pragma mark 通知事件
-(void)tableViewReload:(NSNotification*)info
{
    NSLog(@"返回上一级");
    NSLog(@"childViewControllers==%d",self.navigationController.childViewControllers.count);
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -category的set方法
-(void)setCategory:(CDProjectCategory *)category
{
    _category = category;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemCount != %@", [NSNumber numberWithInteger:0]];
    self.subCategory = nil;
    //通过leftController传过来的category获取子菜单数组
    [self.subCategory addObjectsFromArray:[category.subCategory.array filteredArrayUsingPredicate:predicate]];
    //刷新tableView
    [self.tableView reloadData];
}
#pragma mark - 懒加载 (初始化数据)
-(NSMutableArray *)subCategory
{
    if (!_subCategory) {
        _subCategory = [NSMutableArray array];
    }
    return _subCategory;
}
#pragma mark - 懒加载 (初始化View)
-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"rightSubCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
        [self.view addSubview:_tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@44);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    return _tableView;
}
#pragma mark 初始化naviView
-(subRightNaviTitleView*)naviView
{
    if (!_naviView) {
        subRightNaviTitleView *navi = [subRightNaviTitleView buttonWithType:UIButtonTypeCustom];
        _naviView = navi;
        [self.view addSubview:_naviView];
        _naviView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH/2, 44);
        [_naviView addTarget:self action:@selector(naviViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviView;
}
#pragma mark 导航控制器事件(pop)
-(void)naviViewClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rightSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
    CDProjectCategory *category = self.subCategory[indexPath.row];
    cell.cellModel = category;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
}
@end
