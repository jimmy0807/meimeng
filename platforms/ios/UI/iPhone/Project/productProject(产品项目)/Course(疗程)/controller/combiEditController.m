//
//  combiEditController.m
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "combiEditController.h"
#import "moreSetUpController.h"
#import "CombinMoreSetFootView.h"
#import "moreSetupModel.h"
#import "moreSetupCell.h"
#import "BSProjectTemplateCreateRequest.h"
#import "CombiNetRequestModel.h"
#import "MJExtension.h"
@interface combiEditController ()<UITableViewDelegate,UITableViewDataSource,moreSetupCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *compleBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** cell的标题数组*/
@property (nonatomic,strong)NSMutableArray *titleNameArray;
/** cell子标题数组*/
@property (nonatomic,strong)NSMutableArray *subTitleNameArray;
/** 当前显示的数据*/
@property (nonatomic,strong)NSMutableArray *currentArray;
/** 影藏的数据*/
@property (nonatomic,strong)NSMutableArray *hiddenArray;
/** footView*/
@property (nonatomic,weak)CombinMoreSetFootView *footView;
/**  数量*/
@property (nonatomic,assign)NSInteger num;
/**  单价*/
@property (nonatomic,assign)CGFloat singePrice;
/** combinRequsetModel*/
@property (nonatomic,strong)CombiNetRequestModel *requstModel;
/** startDict*/
@property (nonatomic,strong)NSMutableDictionary *startDict;
/**  isShow*/
@property (nonatomic,assign)BOOL isShow;
@end

@implementation combiEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startDict];
    [self.tableView registerNib:[UINib nibWithNibName:@"moreSetupCell" bundle:nil] forCellReuseIdentifier:@"moreCellId"];
    self.tableView.frame = CGRectMake(0,20, IC_SCREEN_WIDTH, 172.0);
    self.tableView.contentOffset = CGPointMake(0, IC_SCREEN_HEIGHT*2);
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
   [self.tableView registerNib:[UINib nibWithNibName:@"moreSetupCell" bundle:nil] forCellReuseIdentifier:@"moreCellId"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUpData];
    
}
-(void)setUpData
{
    NSMutableArray *arr = [NSMutableArray array];
    moreSetupModel *model0 = [[moreSetupModel alloc]init];
    model0.name = @"产品";
    model0.norImageName = @"bs_common_arrow";
    model0.selImageName = @"bs_common_arrow";
    
    moreSetupModel *model1 = [[moreSetupModel alloc]init];
    model1.name = @"数量";
    
    moreSetupModel *model2 = [[moreSetupModel alloc]init];
    model2.name = @"价格";
    
   
    if (self.related) {
        model0.textContent = self.related.productName;
        model1.textContent = [NSString stringWithFormat:@"%@",self.related.quantity];
        self.num = [self.related.quantity integerValue];
        model2.textContent = [NSString stringWithFormat:@"%@",self.related.item.totalPrice];
        self.singePrice = [self.related.item.totalPrice floatValue]/self.num;
    }else if (self.baseProjectTemp){
        model0.textContent = self.baseProjectTemp.templateName;
        model1.textContent = [NSString stringWithFormat:@"%@",self.baseProjectTemp.qty_available];
        self.num = [self.baseProjectTemp.qty_available integerValue];
        model2.textContent = [NSString stringWithFormat:@"%@",self.baseProjectTemp.listPrice];
        self.singePrice = [self.baseProjectTemp.list_price floatValue]/self.num;
    }
    [arr addObject:@[model0,model1,model2]];
    self.currentArray = arr;
    
}
-(NSMutableDictionary *)startDict
{
    if (!_startDict) {
        _startDict = [[NSMutableDictionary alloc]init];
        _startDict = [self.related mj_keyValuesWithIgnoredKeys:@[@"item",@"sameItems"]];
        
    }
    return _startDict;
}
-(CombiNetRequestModel *)requstModel
{
    if (!_requstModel) {
        _requstModel = [[CombiNetRequestModel alloc]init];
    }
    return _requstModel;
}
-(NSMutableArray *)currentArray
{
    if (!_currentArray) {
        _currentArray = [NSMutableArray array];
    }
    return _currentArray;
}
#pragma mark 懒加载(数据)
-(NSMutableArray *)hiddenArray
{
    if (!_hiddenArray) {
        _hiddenArray = [NSMutableArray array];
        NSMutableArray *tmpArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"moreSetUpController" ofType:@"plist"];
        tmpArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        for (int i=0; i<tmpArray.count; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in tmpArray[i]) {
                moreSetupModel *model = [moreSetupModel moreSetupModelWithDict:(NSMutableDictionary*)dict];
                if ([model.name containsString:@"不限次数"]) {
                    model.imageSeleted = [self.related.limited_qty boolValue];
                }else if ([model.name containsString:@"有效期限(天)"]){
                    model.textContent = [NSString stringWithFormat:@"%@",self.related.limited_date] ;
                }else if ([model.name containsString:@"可以等价替换消耗"]){
                    model.imageSeleted = [self.related.same_price_replace boolValue];
                }else if ([model.name containsString:@"项目最高价"]){
                    model.textContent = [NSString stringWithFormat:@"%0.2f",[self.related.same_price_replace_max floatValue]];
                }else if ([model.name containsString:@"项目最低价"]){
                    model.textContent = [NSString stringWithFormat:@"%0.2f",[self.related.same_price_replace_min floatValue]];
                }
                
                [arr addObject:model];
            }
            [_hiddenArray addObject:arr];
        }
    }
    return _hiddenArray;
}

#pragma mark tableView delegate和dataSource 方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    self.compleBtn.hidden = [self.startDict isEqualToDictionary:[self.related mj_keyValuesWithIgnoredKeys:@[@"item",@"sameItems"]]];
    if ([self judgementIsEdit]) {
        self.compleBtn.hidden = NO;
    }else{
        self.compleBtn.hidden = YES;
    }
   return  self.currentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.currentArray[section];
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    moreSetupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.setUpModel = self.currentArray[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
}
-(BOOL)judgementIsEdit
{
  NSMutableDictionary *dict = [self.related mj_keyValuesWithIgnoredKeys:@[@"item",@"sameItems"]];
    if ([self.startDict isEqualToDictionary:dict]) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark <moreSetupCellDelegate>
#pragma mark 编辑btn
-(void)moreSetupCellEditImageBtnSeletedStatus:(BOOL)seleted andModel:(moreSetupModel *)updateModel
{
    if ([updateModel.name containsString:@"有效期限内不限次数使用"]) {
        self.requstModel.limited_qty = seleted;
        self.related.limited_qty = @(seleted);
    }else if ([updateModel.name containsString:@"可以等价替换消耗"]){
        self.requstModel.same_price_replace = seleted;
        self.related.same_price_replace = @(seleted);
    }
    for (NSArray *array in self.currentArray) {
        for (moreSetupModel *model in array) {
            if ([model.name isEqualToString:updateModel.name]) {
                model.imageSeleted = seleted;
            }
        }
        
    }
    [self.tableView reloadData];
}
#pragma mark 编辑textField
-(void)moreSetupCellDelegateWith:(NSString *)text andModel:(moreSetupModel *)updateModel
{
    if ([updateModel.name containsString:@"数量"]) {
        self.requstModel.quantity = [text integerValue];
        self.num = [text integerValue];
        if (self.related){
            self.related.quantity = @(self.num);
        }else if (self.baseProjectTemp) {
            self.baseProjectTemp.qty_available = @(self.num);
        }
    }else if ([updateModel.name containsString:@"有效期限"]){
        self.requstModel.limited_date = [text integerValue];
        if (self.related) {
            self.related.limited_date = @([text integerValue]);
        }
    }else if ([updateModel.name containsString:@"最高价"]){
        self.requstModel.same_price_replace_max = [text floatValue];
        self.related.same_price_replace_max = @([text floatValue]);
    }else if ([updateModel.name containsString:@"最低价"]){
        self.requstModel.same_price_replace_min = [text floatValue];
        self.related.same_price_replace_min = @([text floatValue]);
    }
    
    [self.tableView reloadData];
    
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CombinMoreSetFootView *footView = [CombinMoreSetFootView combinFootView];
        footView.isShow = self.isShow;
        __weak typeof(self) weakSelf = self;
        footView.footBlock = ^(BOOL isShow){
            weakSelf.isShow = isShow;
            if (weakSelf.currentArray.count<2) {
                [weakSelf.currentArray addObjectsFromArray:weakSelf.hiddenArray];
            }else{
                [weakSelf.currentArray removeAllObjects];
                [weakSelf setUpData];
            }
            [weakSelf.tableView reloadData];
        };
        footView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, 40);
        return footView;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else if (section == 1){
        return 20;
    }else{
        return 0;
        }
    
}

- (IBAction)completeBtnClick:(UIButton *)sender {
    
  
   //NSMutableDictionary *dict = [self.requstModel mj_keyValues];
    NSMutableDictionary *dict = [self.related mj_keyValuesWithIgnoredKeys:@[@"item",@"sameItems"]];
    if ([dict isEqualToDictionary:self.startDict]) {
        return;
    }
    NSArray *allKey = [dict allKeys];
    NSMutableDictionary *dictLine = [NSMutableDictionary dictionary];
    for (NSString *keyStr in allKey) {
        if (![dict[keyStr] isEqual:self.startDict[keyStr]]) {
            dictLine[keyStr] = dict[keyStr];
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger relatedId = 0;
    if (self.related) {
      relatedId  = [self.related.relatedID integerValue];
    }else if (self.baseProjectTemp){
        relatedId = [self.baseProjectTemp.templateID integerValue];
    }
    
    
    [arr addObject:@[@1,@(relatedId),dictLine]];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"pack_line_ids"] = arr;
  
//    parmas[@"list_price"] = @(self.num *self.singePrice);
    parmas[@"born_category"] = @(self.combiTage);
    BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:self.baseProjectTemp.templateID params:parmas];
    [request execute];
    /*
     params==={
     pack_line_ids = [
     [1,691,{
     is_show_more = 1,
     quantity = 21
     }]
     ],
     list_price = 3535.014,
     born_category = 3
     }
     */
   // self.projectTemp.templateName =
    if ([_delegate respondsToSelector:@selector(combiEditControllerNumChang:andRelated:andTemp:)]) {
        [_delegate combiEditControllerNumChang:self.num andRelated:self.related andTemp:self.baseProjectTemp];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [[BSCoreDataManager currentManager]rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
