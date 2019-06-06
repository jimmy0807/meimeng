//
//  consumeGoodsController.m
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "consumeGoodsController.h"
#import "ConsumeEditCell.h"
#import "goodsCell.h"
#import "goodsBoomView.h"
#import "goodsCompleteBoomView.h"
#import "BSCoreDataManager+Customized.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "ConsumeGoodModel.h"
#import "BSProjectTemplateCreateRequest.h"
#import "UIView+Frame.h"
#import "MBProgressHUD+MJ.h"
@interface consumeGoodsController ()<UITableViewDelegate,UITableViewDataSource,ConsumeEditCellDelegate,goodsBoomViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *boomView;
/** 消耗品数组*/
@property (nonatomic,strong)NSMutableArray *consumArray;
/** deleteIndexPath*/
@property (nonatomic,strong)NSMutableArray *deleteIndexpath;
/** 删除的消耗品*/
@property (nonatomic,strong)NSMutableArray *deleteModel;
/** 数量改变的消耗品*/
@property (nonatomic,strong)NSMutableArray *changeModel;
/** 添加的消耗品*/
@property (nonatomic,strong)NSMutableArray *addModel;
/** stareModel*/
@property (nonatomic,strong)NSMutableArray *stareModel;
/** boomViewCompelet*/
@property (nonatomic,weak)goodsCompleteBoomView *boomComple;
/** boomViewEdit*/
@property (nonatomic,weak)goodsBoomView *boomEdti;
@property (weak, nonatomic) IBOutlet UIView *editView;
@end

@implementation consumeGoodsController
static NSString* reuseId = @"cellId";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    //设置tableView
    [self setUpTableView];
   
    [self receiveNotifcation];
    [self stareModel];
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [self boomViewAddSubView];
}

#pragma mark 通知
-(void)receiveNotifcation
{
    //点击保存按钮
   [myNotification addObserver:self selector:@selector(saveEditStatue:) name:productSaveBtnClick object:nil];
    //选择完消耗品
    [myNotification addObserver:self selector:@selector(completeSeletedConsumGoods:) name:consumeGoodsSeletedArray object:nil];
  
}
#pragma mark <ShowConsumeGoodsController>选择完消耗品
-(void)completeSeletedConsumGoods:(NSNotification*)info
{
    NSArray * array = info.userInfo[@"selete"];
    if (array.count<1) {
        return;
    }
    NSMutableArray *tempConsumArray = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        CDProjectTemplate *temp = array[i];
        ConsumeGoodModel *goodModel = [ConsumeGoodModel consumGoodModelWithTemp:temp];
        [self.consumArray addObject:goodModel];
       [self.addModel addObject:temp];
        if (self.baseProjectTemp) {
            CDProjectConsumable *consum = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectConsumable"];
            consum.productName = temp.templateName;
            consum.qty = temp.qty_available;
            consum.uomID = temp.uomID;
            consum.uomName = temp.uomName;
            consum.projectItems = [NSSet setWithObject:self.baseProjectTemp];
            [tempConsumArray addObject:consum];
        }
    }
    
    if (self.baseProjectTemp) {
        [tempConsumArray addObjectsFromArray:self.baseProjectTemp.consumables.array];
        self.baseProjectTemp.consumables = [NSOrderedSet orderedSetWithArray:tempConsumArray];
    }

    [self.tableView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark - 通知时间
#pragma mark 保存按钮被点击
-(void)saveEditStatue:(NSNotification*)info
{
    if ([info.userInfo[@"index"] integerValue] == 1) {
         [self requestToNet];
    }
   
}
-(void)deleteConsumModelWith:(NSMutableArray*)array
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"born_category"] = @2;
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ConsumeGoodModel *deleteModel in self.deleteModel) {//删除的数据
        NSMutableArray *arr = [NSMutableArray array ];
        [arr addObjectsFromArray:@[@2,@(deleteModel.modelId),@0]];
        [tmpArray addObject:arr];
    }
    parmas[@"consumables_ids"] = tmpArray;
}

-(NSMutableArray *)deleteModel
{
    if (!_deleteModel) {
        _deleteModel = [NSMutableArray array];
    }
    return _deleteModel;
}
-(NSMutableArray *)deleteIndexpath
{
    if (!_deleteIndexpath) {
        _deleteIndexpath = [NSMutableArray array];
    }
    return _deleteIndexpath;
}
-(NSMutableArray *)stareModel
{
    if (!_stareModel) {
        _stareModel = [NSMutableArray array];
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:self.baseProjectTemp.consumables.array];
        for (CDProjectConsumable *consum in tempArray) {
            ConsumeGoodModel *goodModel = [ConsumeGoodModel consumGoodModelWithConsum:consum];
            [_stareModel addObject:goodModel];
        }
    }
    return _stareModel;
}
-(NSMutableArray *)addModel
{
    if (!_addModel) {
        _addModel = [NSMutableArray array];
    }
    return _addModel;
}
#pragma mark - 懒加载数组(消耗品)
-(NSMutableArray *)consumArray
{
    if (!_consumArray) {
        _consumArray = [NSMutableArray  array];
        NSMutableArray *tempArray = [NSMutableArray array];
       [tempArray addObjectsFromArray:self.baseProjectTemp.consumables.array];
        for (CDProjectConsumable *consum in tempArray) {
            ConsumeGoodModel *goodModel = [ConsumeGoodModel consumGoodModelWithConsum:consum];
            [_consumArray addObject:goodModel];
        }
        
    }
    return _consumArray;
}
#pragma mark - 改变商品的数量的数组
-(NSMutableArray *)changeModel
{
    if (!_changeModel) {
        _changeModel = [NSMutableArray array];
    }
    return _changeModel;
}
#pragma mark - 初始化boomView

-(void)boomViewAddSubView
{
    [self.boomComple removeFromSuperview];
    [self.boomEdti removeFromSuperview];
    //完成状态
    goodsCompleteBoomView *boomViewComplete = [[[NSBundle mainBundle]loadNibNamed:@"goodsCompleteBoomView" owner:nil options:nil]firstObject];
    self.boomComple = boomViewComplete;
    boomViewComplete.frame = self.boomView.bounds;
    __weak typeof(self) weakSelf = self;
    boomViewComplete.completeBoomBlock = ^(UIButton *btn){
        if (btn.tag == 0) {//全选
            for (ConsumeGoodModel *consumGood in weakSelf.consumArray) {
                consumGood.isChoice = btn.selected;
            }
           [weakSelf.tableView reloadData];
        }else{//删除
            int count = weakSelf.consumArray.count;
            //[self.deleteModel removeAllObjects];
            [weakSelf.deleteIndexpath removeAllObjects];
            for (int i=0; i<count; i++) {
                ConsumeGoodModel *consum = [[ConsumeGoodModel alloc]init];
                consum = weakSelf.consumArray[i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (consum.isChoice) {
                    [weakSelf.deleteModel addObject:consum];
                    [weakSelf.deleteIndexpath addObject:indexPath];
                }
            }
            
             [weakSelf.consumArray removeObjectsInArray:weakSelf.deleteModel];
             [weakSelf.tableView deleteRowsAtIndexPaths:weakSelf.deleteIndexpath withRowAnimation:UITableViewRowAnimationRight];
            [weakSelf.tableView reloadData];
            [weakSelf boomViewAddSubView];
        }
       
    };

    //编辑状态
    goodsBoomView *boomViewEdit = [[[NSBundle mainBundle]loadNibNamed:@"goodsBoomView" owner:nil options:nil]lastObject];
    boomViewEdit.delegate = self;
    boomViewEdit.frame = self.boomView.bounds;
    self.boomEdti = boomViewEdit;
    if ([self.editBtn.currentTitle isEqualToString:@"编辑"] || self.consumArray.count == 0) {
        [self.boomView addSubview:boomViewEdit];
    }else{
        [self.boomView addSubview:boomViewComplete];

    }
    
}
#pragma mark - <goodsBoomViewDelegate>
-(void)goodsBoomViewAddBtnClick
{
    //1. 通知productViewController跳转界面
    //2. 通知主控制器显示boomView;
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"projecTemplate"] = self.baseProjectTemp;
    [myNotification postNotificationName:projectAddBtnClick object:nil userInfo:dict];
}
#pragma mark - 设置tableView
-(void)setUpTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"goodsCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConsumeEditCell" bundle:nil] forCellReuseIdentifier:@"editCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateParamsDict];
    self.editView.hidden = !self.consumArray.count;
    [self judgementCellState];
    return self.consumArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ConsumeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//    cell.consumModel = self.consumArray[indexPath.row];
//    if ([cell isKindOfClass:[ConsumeEditCell class]]) {
//         cell.delegate = self;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow-----%d",indexPath.row);
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ConsumeGoodModel *model = self.consumArray[indexPath.row];
    if ([self.addModel containsObject:model]) {
        [self.addModel removeObject:model];
    }else{
        [self.deleteModel addObject:model];
    }
    NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
    if (self.baseProjectTemp) {
        for (CDProjectConsumable *consum in self.baseProjectTemp.consumables.array) {
            ConsumeGoodModel *goodModel = self.consumArray[indexPath.row];
            if (consum.consumableID.integerValue != goodModel.modelId){
                [orderSet addObject:consum];
            }
        }
        self.baseProjectTemp.consumables = orderSet;
    }
    //1.移除数组中对应的model
    [self.consumArray removeObjectAtIndex:indexPath.row];
    //2.移除tableView对应的cell
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark <ConsumeEditCellDelegate>
-(void)ConsumeEditCellChangeGoodsNum:(ConsumeEditCell *)goodsCell WithConsumeGoodModel:(ConsumeGoodModel *)consumModel
{
    for (int i=0; i<self.consumArray.count; i++) {
        ConsumeGoodModel *model = self.consumArray[i];
        if (consumModel.modelId == model.modelId) {
            model = consumModel;
        }
    }
    if (self.baseProjectTemp) {
        NSArray *array = self.baseProjectTemp.consumables.array;
        for (CDProjectConsumable *consum in array) {
            if (consumModel.modelId == consum.consumableID.integerValue) {
                consum.qty = @(consumModel.num);
            }
            
        }
    }
  [self.tableView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark 判断当前显示的Cell类型
-(void)judgementCellState
{
    if ([self.editBtn.currentTitle isEqualToString:@"编辑"]){
         reuseId = @"cellId";
    }else{
        reuseId = @"editCell";
    }
}
#pragma mark 点击编辑按钮
- (IBAction)editBtnClick:(UIButton *)sender {
    
    //切换cell
    if ([self.editBtn.currentTitle isEqualToString:@"编辑"]){
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
    }
    //切换boomView的显示页面
    [self boomViewAddSubView];
    //刷新tableView
    [self.tableView reloadData];
}
#pragma mark 获取添加Model
-(NSMutableArray*)getUpAddConsumGoodModel
{
    NSMutableArray *parmasArray = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.addModel.count; i++) {
        CDProjectTemplate *temp = self.addModel[i];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        //是否直接出库
        tempDict[@"is_stock"] = @0;
        tempDict[@"product_id"] = temp.templateID;
        tempDict[@"qty"] = temp.qty_available;
        tempDict[@"uom_id"] = temp.uomID;
        CDProjectConsumable *consum = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectConsumable"];
        consum.consumableID = temp.templateID;
        consum.productName = temp.templateName;
        consum.qty = temp.qty_available;
        consum.uomID = temp.uomID;
        consum.uomName = temp.uomName;
        [array addObject:consum];
        [parmasArray addObject:@[@0,@0,tempDict]];
    }
    return parmasArray;
}
#pragma mark 获取已经改变了数量的Model
-(NSMutableArray*)getUpChangeNumConsumeGoodModel
{
    
    NSMutableArray *array = [NSMutableArray array];
    [self.changeModel removeAllObjects];
    for (ConsumeGoodModel *changeModel in self.changeModel) {//修改数量
        NSMutableArray * arr = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"qty"] = @(changeModel.num);
        [arr addObjectsFromArray:@[@1,@(changeModel.modelId),dict]];
        [array addObject:arr];
    }
    return array;
}
#pragma mark 获取删除已经删除了的model
-(NSMutableArray*)getUpDeleteConsumeGoodModel
{
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (ConsumeGoodModel *deleteModel in self.deleteModel) {//删除的数据
        NSMutableArray *arr = [NSMutableArray array ];
        if (deleteModel.modelId) {
             [arr addObjectsFromArray:@[@2,@(deleteModel.modelId),@0]];
        }
       
        [deleteArr addObject:arr];
    }
    NSMutableArray *orderSetArray = [NSMutableArray array];
    for (CDProjectConsumable *consum in self.baseProjectTemp.consumables.array) {
        for (ConsumeGoodModel *goodModel in self.deleteModel) {
            if (goodModel.modelId == consum.consumableID.integerValue) {
                [orderSetArray addObject:consum];
            }
        }
    }
    return deleteArr;
}
#pragma mark 更新ParmasDict
-(void)updateParamsDict
{
    if (self.baseProjectTemp) {
        return;
    }
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    //要添加的
    if ([[self getUpAddConsumGoodModel] count]) {
    
        parmas[@"consumables_ids"] = [self getUpAddConsumGoodModel];
    }
    
    if (!self.baseProjectTemp) {//新建
        [self.parmasDict addEntriesFromDictionary:parmas];
    }
}
#pragma mark - 点击完成发送网络请求
-(void)requestToNet
{
    if (!self.baseProjectTemp) {//新建
        if ([self.view isShowingOnKeyWindow]) {
            
            self.parmasDict[@"born_category"] = @2;
            self.parmasDict[@"type"] = @"product";
            //3.判断关键属性是否有值
            if ([self.parmasDict[@"name"] length] == 0) {//1.商品名
                [MBProgressHUD showError:@"请输入商品名"];
                
                return;
            }else if ([self.parmasDict[@"list_price"] floatValue] <= 0){//2.商品价格
                [MBProgressHUD showError:@"请输入价格"];
                return;
            }
            BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithParams:self.parmasDict];
            [request execute];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        parmas[@"born_category"] = @2;
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if ([[self getUpDeleteConsumeGoodModel] count] >0){//删除
            
            [tmpArray addObjectsFromArray:[self getUpDeleteConsumeGoodModel]];
        }
        if ([[self getUpChangeNumConsumeGoodModel] count] >0 ) {//改变
            [tmpArray addObjectsFromArray:[self getUpChangeNumConsumeGoodModel]];
        }
        if ([[self getUpAddConsumGoodModel] count] >0 ) {//添加
            [tmpArray addObjectsFromArray:[self getUpAddConsumGoodModel]];
        }
        parmas[@"consumables_ids"] = tmpArray;
        if ([self.view isShowingOnKeyWindow]) {
            BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc]initWithProjectTemplateID:self.baseProjectTemp.templateID params:parmas];
            [request execute];
            
         
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
@end
