//
//  prodcutViewController.m
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "TemplateDetailViewController.h"
#import "productCell.h"
#import "productModel.h"
#import "BSEditCell.h"
#import "productTitleBtn.h"
#import "producSectionView.h"
#import "productTableHeadView.h"
#import "productPopView.h"
#import "NumberInHandController.h"
#import "productCategoryController.h"
#import "projectController.h"
#import "baseInfoController.h"
#import "courseBaseController.h"
#import "productProjectMainController.h"
#import "ProductVC.h"
#import "ShowConsumeGoodsController.h"
#import "PackageServiceController.h"
#import "PackageBookController.h"
#import "MJExtension.h"
#import "ProductProjectBaseController.h"
#import "PadNumberKeyboard.h"

@interface TemplateDetailViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *subControllerView;
@property (weak, nonatomic) IBOutlet UIButton *naviTitleBtn;
@property (weak, nonatomic) IBOutlet UIView *naviTitleView;
@property (weak, nonatomic) IBOutlet UIButton *naviBackBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *naviSaveBtn;


/** tableView*/
@property (nonatomic,weak)UITableView *tableView;
/** 显示在界面上的数据(折叠和展开)*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/** 折叠起来的数据*/
@property (nonatomic,strong)NSMutableArray *totalDataArray;
/** popView*/
@property (nonatomic,weak)productPopView *popView;
/** coverBtn*/
@property (nonatomic,weak)UIButton *coverBtn;
/** 产品*/
@property (nonatomic,strong)ProductVC *productVc;
/** 项目控制器*/
@property (nonatomic,strong)projectController *projectVC;
/** 疗程控制器*/
@property (nonatomic,strong)courseBaseController *courseVc;
/** 套餐*/
@property (nonatomic,strong)PackageServiceController *taocanVc;
/** 套盒*/
@property (nonatomic,strong)PackageBookController *taoheVc;
/** 上次显示的ViewController*/
@property (nonatomic,strong)UIViewController *lastViewController;
/** popView要显示的数组(项目，产品...)*/
@property (nonatomic,strong)NSMutableArray *popTitleArray;
/** startTemp*/
@property (nonatomic,strong)NSMutableDictionary *startDict;
/** paramsDict*/
@property (nonatomic,strong)NSMutableDictionary *parmasDict;
@end

@implementation TemplateDetailViewController

- (void)viewDidLoad {
   // sale_selected_member_arrow.png
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(245, 245, 245, 1);;
    
    
    self.subControllerView.backgroundColor = self.view.backgroundColor;
    [self.view insertSubview:self.subControllerView atIndex:0];
    
    [self startDict];
    //projectTemplate=0x7fa1944bbf40
    //添加子控制器
    [self addSubController];
    //显示title
    self.titleNameLabel.text = self.titleName;
    //通知，添加监听器
    [self addObserverNotification];
    self.naviSaveBtn.hidden = YES;
    [self setUpSubChildControllWith:self.titleTag];
    
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"新建";
    
}
-(NSMutableDictionary *)parmasDict
{
    if (!_parmasDict) {
        _parmasDict = [[NSMutableDictionary alloc]init];
    }
    return _parmasDict;
}
-(NSMutableDictionary *)startDict
{
    if (!_startDict) {
        _startDict = [self dictWithTemp:self.projectTemplate];
    }
    return _startDict;
}
#pragma mark titleNameArray
-(NSMutableArray *)popTitleArray
{
    if (!_popTitleArray) {
        _popTitleArray = [[NSMutableArray alloc]init];
        [_popTitleArray addObjectsFromArray:@[@"产品",@"项目",@"疗程",@"套餐",@"套盒",]];
    }
    return _popTitleArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
   
}
-(UIViewController *)lastViewController
{
    if (!_lastViewController) {
        _lastViewController = [[UIViewController alloc]init];
    }
    return _lastViewController;
}
#pragma mark 给子控制器附上temp
-(void)setUpSubChildControllWith:(NSInteger)tag
{
    [self.lastViewController.view removeFromSuperview];
    self.lastViewController = self.childViewControllers[tag];
    ProductProjectBaseController *subViewControl = self.childViewControllers[tag];
   
    if (self.projectTemplate) {//有temp
         subViewControl.baseProjectTemp = self.projectTemplate;
    }else{//新建商品
        subViewControl.parmasDict = self.parmasDict;
    }
    
    subViewControl.view.frame = self.subControllerView.bounds;
    [self.subControllerView addSubview:subViewControl.view];
}
#pragma mark 添加子控制器
-(void)addSubController
{
    //产品控制器(基本信息控制器)
    self.productVc = [[ProductVC alloc]init];
    [self addChildViewController:self.productVc];
    //项目控制器(项目控制器)
    self.projectVC = [[projectController alloc]init];
    [self addChildViewController:self.projectVC];
    //疗程控制器
    self.courseVc = [[courseBaseController alloc]init];
    [self addChildViewController:self.courseVc];
    //套餐，
    self.taocanVc = [[PackageServiceController alloc]init];
    [self addChildViewController:self.taocanVc];
    //套盒
    self.taoheVc = [[PackageBookController alloc]init];
    [self addChildViewController:self.taoheVc];
}

#pragma mark - 通知
-(void)addObserverNotification
{
    [myNotification addObserver:self selector:@selector(addBtnClickNotification:) name:projectAddBtnClick object:nil];
    [myNotification addObserver:self selector:@selector(showSaveBtn) name:projectSaveBtnHidden object:nil];
}
-(void)showSaveBtn
{
    self.naviSaveBtn.hidden = NO;
}

#pragma mark - 移除通知
-(void)dealloc
{
    [myNotification removeObserver:self];
}

#pragma mark  - 通知事件
#pragma mark 项目菜单里的添加按钮事件
-(void)addBtnClickNotification:(NSNotification*)info
{
    ShowConsumeGoodsController *consumGoodsController = [[ShowConsumeGoodsController alloc]init];
    consumGoodsController.baseProjectTemp = self.projectTemplate;
    [self.navigationController pushViewController:consumGoodsController animated:YES];
}

#pragma mark - 懒加载控件
#pragma mark coverBtn
-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0;
        _coverBtn = btn;
        btn.frame = self.view.bounds;
        [btn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_coverBtn];
    }
    return _coverBtn;
}

#pragma mark popView
-(productPopView *)popView
{
    if (!_popView) {
        productPopView *popView =[productPopView productPopView];
        _popView = popView;
         _popView.alpha = 0;
        _popView.titleNameArray = self.popTitleArray;
        [self.view addSubview:_popView];
       [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self.view.mas_centerX);
           make.top.equalTo(@57);
           make.width.equalTo(@(175));
           make.height.equalTo(@(257));
       }];
#pragma mark 监听titleBtn点击
        __weak typeof(self) weakSelf = self;
        _popView.popBlock = ^(NSString *selText,NSInteger tag){
        
            weakSelf.titleNameLabel.text = selText;
            [weakSelf setUpSubChildControllWith:tag];
            [weakSelf hiddenPopView];
        };
        
    }
    return _popView;
}
-(void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    //改变title文字
//    [self.naviTitleBtn setTitle:titleName forState:UIControlStateNormal];
    self.titleNameLabel.text = titleName;
}

#pragma mark - 点击事件
#pragma mark 保存按钮点击
- (IBAction)saveBtnClick:(UIButton *)sender {
    NSLog(@"保存");
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"category_id"] = @(self.titleTag);
    NSInteger index = [self.popTitleArray indexOfObject:self.titleNameLabel.text];
    dict[@"index"] = @(index);
    [myNotification postNotificationName:productSaveBtnClick object:nil userInfo:dict];
    
    
}
#pragma mark projectTemplate ->生成属性字典
-(NSMutableDictionary*)dictWithTemp:(CDProjectTemplate*)temp
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [temp mj_keyValuesWithIgnoredKeys:@[@"attributeLines",@"consumables",@"projectItems",@"category"]];
    NSMutableArray *attributeLinesArray = [NSMutableArray array];
    if (temp.attributeLines.array.count) {//规格
        for (CDProjectAttributeLine *line in temp.attributeLines.array) {
            
            NSMutableDictionary *lineDict = [line mj_keyValuesWithIgnoredKeys:@[@"attribute",@"attributeValues",@"projectItems"]];
            NSMutableArray *attributArray = [NSMutableArray array];
            NSArray *valueArray = line.attributeValues.array;
            for (CDProjectAttributeValue *value in valueArray) {
                NSMutableDictionary *attributDict = [value mj_keyValuesWithIgnoredKeys:@[@"attribute",@"attributeLines",@"attributePrices",@"projectItems"]];
                [attributArray addObject:attributDict];
            }
            lineDict[@"attributArray"] = attributArray;
            [attributeLinesArray addObject:lineDict];
        }
    }
    NSMutableArray *consumArray = [NSMutableArray array];
    if (temp.consumables.array.count) {//消耗品
        for (CDProjectConsumable *consum in temp.consumables.array) {
            /*
             @property (nullable, nonatomic, retain) NSSet<CDProjectTemplate *> *projectItems;
             */
            NSMutableDictionary *dict = [consum mj_keyValuesWithIgnoredKeys:@[@"projectItems"]];
            [consumArray addObject:dict];
            
        }
    }
    NSMutableArray *combinArray = [NSMutableArray array];
    NSArray *itemIgnorArray = @[@"attributeValues",@"couponCardProject",@"memberCardProject",@"orderline",@"panDianItem",@"parentItems",@"posProducts",@"sameRelateds",@"subItems",@"subRelateds",@"useItem",@"projectTemplate",@"moveItem",@"category"];
    if (temp.projectItems.array.count) {
        for (CDProjectItem *item in temp.projectItems.array) {
            if (item) {
                NSMutableDictionary *dict = [item mj_keyValuesWithIgnoredKeys:itemIgnorArray];
                NSMutableArray *subRelatedArray = [NSMutableArray array];
                for (CDProjectRelated *related in [item.subRelateds allObjects]) {
                    NSMutableDictionary *relatedDict = [related mj_keyValuesWithIgnoredKeys:@[@"sameItems",@"item"]];
                    [subRelatedArray addObject:relatedDict];
                }
                dict[@"subRelateds"] = subRelatedArray;
                [combinArray addObject:dict];
            }
           
        }
    }
    dict[@"attributeLines"] = attributeLinesArray;
    dict[@"consumables"] = consumArray;
    dict[@"projectItems"] = combinArray;
    return dict;
}
#pragma mark 返回按钮点击
- (IBAction)backBtnclick:(UIButton *)sender {
    
    NSMutableDictionary *dict = [self dictWithTemp:self.projectTemplate];
    if ([dict isEqualToDictionary:self.startDict] && self.naviSaveBtn.hidden == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        //consumables(消耗品) attributeLines(规格)
        NSLog(@"不同");
        UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"产品信息已修改,是否保存?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"保存");
            [self saveBtnClick:nil];
        }];
        UIAlertAction *notSave = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"不保存");
            [[BSCoreDataManager currentManager]rollback];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *edit = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"继续编辑");
        }];
        [alertControll addAction:save];
        [alertControll addAction:notSave];
        [alertControll addAction:edit];
        [self presentViewController:alertControll animated:YES completion:nil];
    }
    
    

}
#pragma mark 标题按钮被点击
- (IBAction)naviTitleBtnClick:(UIButton *)sender {
   
    [self  showPopView];
}
#pragma mark coverBtn被点击
-(void)coverBtnClick:(UIButton*)btn
{
    [self hiddenPopView];
}
#pragma mark - 其他方法
#pragma mark 弹出popView
-(void)showPopView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.coverBtn.alpha = 0.5;
        self.popView.alpha = 1.0;
        self.popView.titleNameArray = self.popTitleArray;
        self.popView.seletedName = self.titleNameLabel.text;
         self.titleImageView.transform = CGAffineTransformRotate(self.titleImageView.transform, M_PI);
    }];
}
#pragma mark 隐藏popView
-(void)hiddenPopView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.coverBtn.alpha = 0.0;
        self.popView.alpha = 0.0;
        self.titleImageView.transform = CGAffineTransformRotate(self.titleImageView.transform, M_PI);
    }];
}
@end
