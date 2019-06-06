//
//  CombiPackageController.m
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "CombiPackageController.h"
#import "combiCell.h"
#import "ShowCombinationController.h"
#import "combiEditController.h"
#import "CombiModel.h"
#import "combiEditController.h"
#import "BSProjectTemplateCreateRequest.h"
#import "UIView+Frame.h"
#import "MBProgressHUD+MJ.h"
@interface CombiPackageController ()<UITableViewDelegate,UITableViewDataSource,combiEditControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** dataArray*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/** addArra*/
@property (nonatomic,strong)NSMutableArray *addArray;
/** deleteArray*/
@property (nonatomic,strong)NSMutableArray *deletedArray;
@property (weak, nonatomic) IBOutlet UIView *boomView;
@end

@implementation CombiPackageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    self.boomView.backgroundColor = VCBackgrodColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"combiCell" bundle:nil] forCellReuseIdentifier:@"combiCellId"];
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self receiveNotification];
}

#pragma mark - 接收通知
-(void)receiveNotification
{
    //添加组合套完成，刷新界面
    [myNotification addObserver:self selector:@selector(addServiceCompReloadData:) name:packageSeletedCompleted object:nil];
    //保存按钮被点击
    [ myNotification addObserver:self selector:@selector(categoryMainVCSaveBtnClick:) name:productSaveBtnClick object:nil];
}
-(void)addServiceCompReloadData:(NSNotification*)info
{
    if ([info.userInfo[@"tage"] integerValue] != 4) {
        return;
    }
    self.addArray = info.userInfo[@"array"];
    for (CDProjectTemplate *tmp in self.addArray) {
        CombiModel *comModel = [CombiModel combiModelWithTemplate:tmp];
        [self.dataArray addObject:comModel];
        CDProjectRelated *related = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectRelated"];
        related.productName = tmp.templateName;
        related.price = tmp.list_price;
        related.quantity = tmp.qty_available;
        
    }
    
    [self.tableView reloadData];
}
-(NSMutableArray*)getWillAddCombi
{
    NSMutableArray *addArray = [NSMutableArray array];
    CGFloat price = 0;
    if (self.addArray.count>0) {
        for (int i=0; i<self.addArray.count; i++) {
            CDProjectTemplate *temp = self.addArray[i];
            price = [temp.listPrice floatValue];
            NSMutableDictionary *dictAdd = [NSMutableDictionary dictionary];
            dictAdd[@"lst_price"] = @(price);
            dictAdd[@"limited_qty"] = temp.qty_available;
            dictAdd[@"quantity"] = @1;
            dictAdd[@"product_id"] = temp.templateID;
            [addArray addObject:@[@0,@0,dictAdd]];
        }
        
    }
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
    return addArray;
}
#pragma mark 更新ParmasDict
-(void)updateParamsDict
{
    if (self.baseProjectTemp) {
        return;
    }
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    //要添加的
    parmas[@"pack_line_ids"] = [self getWillAddCombi];
    if (!self.baseProjectTemp) {//新建
        [self.parmasDict addEntriesFromDictionary:parmas];
    }
}
#pragma mark 保存按钮被点击
-(void)categoryMainVCSaveBtnClick:(NSNotification*)info
{
    if ([info.userInfo[@"category_id"] integerValue] !=3) {
        return;
    }
    if (!self.baseProjectTemp) {
        if ([self.view isShowingOnKeyWindow]) {
            
            self.parmasDict[@"born_category"] = @4;
            self.parmasDict[@"type"] = @"product";
            //3.判断关键属性是否有值
            if ([self.parmasDict[@"name"] length] == 0) {//1.商品名
                [MBProgressHUD showError:@"请输入商品名"];
                
                return;
            }else if ([self.parmasDict[@"list_price"] floatValue] <= 0){//2.商品价格
                [MBProgressHUD showError:@"请输入价格"];
                return;
            }else if (!self.parmasDict[@"pack_line_ids"]){
                [MBProgressHUD showError:@"组合套中请至少选择一件商品"];
                return;
            }
            BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithParams:self.parmasDict];
            [request execute];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
    
        NSMutableArray *arr = [NSMutableArray array];
        CGFloat price = 0;
        //要添加的
        if ([[self getWillAddCombi] count]) {
            [arr addObject:[self getWillAddCombi]];
        }
        
        //要删除的
        if (self.deletedArray.count>0) {
            for (int i=0; i<self.deletedArray.count; i++) {
                CombiModel *model = self.deletedArray[i];
                [arr addObject:@[@2,model.related.relatedID,@0]];
            }
        }
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        parmas[@"pack_line_ids"] = arr;
        parmas[@"born_category"] = @4;
        parmas[@"list_price"] = @(price);
        if ([self.view isShowingOnKeyWindow]) {
            if (self.addArray.count != 0 || self.deletedArray.count != 0) {
                BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:self.baseProjectTemp.templateID params:parmas];
                [request execute];
            }
            [self.navigationController  popViewControllerAnimated:YES];
        }
        
    }
    
    /*
     kBSDataNone     = -1,
     kBSDataAdded    = 0,
     kBSDataUpdate   = 1,
     kBSDataDelete   = 2,
     kBSDataDeleteN  = 3,
     kBSDataLinked   = 4,
     kBSDataExist    = 6
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
}
-(NSMutableArray *)deletedArray
{
    if (!_deletedArray) {
        _deletedArray = [NSMutableArray array];
    }
    return _deletedArray;
}
-(NSMutableArray *)addArray
{
    if (!_addArray) {
        _addArray = [[NSMutableArray alloc]init];
    }
    return _addArray;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        CDProjectItem *projectItem = [self.baseProjectTemp.projectItems.array firstObject];
        NSArray *arr = [projectItem.subRelateds allObjects];
        
        for (CDProjectRelated *related in arr) {
            CombiModel *model = [CombiModel combiModelWith:related];
            [self.dataArray addObject:model];
        }
    }
    return _dataArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateParamsDict];
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    combiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"combiCellId"];
    cell.combiModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    combiEditController *edit = [[combiEditController alloc]init];
    CombiModel *model = self.dataArray[indexPath.row];
    edit.related = model.related;
    edit.delegate = self;
    edit.baseProjectTemp = self.baseProjectTemp;
    edit.combiTage = 4;
    [self.navigationController pushViewController:edit animated:YES];
}
-(void)combiEditControllerNumChang:(NSInteger)num andRelated:(CDProjectRelated *)related andTemp:(CDProjectTemplate *)temp
{
    for (CombiModel *model in self.dataArray) {
        if ([related.productName isEqualToString:model.name]) {
            model.num = num;
        }
    }
    
    [self.tableView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.deletedArray addObject:self.deletedArray[indexPath.row]];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
-(void)combiEditControllerNumChang:(NSInteger)num andRelated:(CDProjectRelated *)related
{
    for (CombiModel *model in self.dataArray) {
        if ([related.productName isEqualToString:model.name]) {
            model.num = num;
        }
    }
    [self.tableView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}

- (IBAction)packAddBtnClick:(UIButton *)sender {
    NSLog(@"添加...");
    ShowCombinationController *show = [[ShowCombinationController alloc]init];
    show.baseProjectTemp = self.baseProjectTemp;
    show.combinTage = 4;
    [self.navigationController pushViewController:show animated:YES];
}


@end
