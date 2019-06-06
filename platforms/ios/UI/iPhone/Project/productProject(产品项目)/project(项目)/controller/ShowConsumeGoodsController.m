//
//  ShowConsumeGoodsController.m
//  Boss
//
//  Created by jiangfei on 16/7/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ShowConsumeGoodsController.h"
#import "ProductTypeFlowLayout.h"
#import "ProductTypeOneColumnCollectionCell.h"
#import "BSProjectTemplateCreateRequest.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+SnapShot.h"
@interface ShowConsumeGoodsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *seletedBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLableView;
@property (weak, nonatomic) IBOutlet UIView *boomView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** dataArray*/
@property (nonatomic,strong)NSMutableArray *consumArray;
/** 选中的array*/
@property (nonatomic,strong)NSMutableArray *selArray;
@end

@implementation ShowConsumeGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    self.boomView.backgroundColor = VCBackgrodColor;
    [self.seletedBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [self setUpCollectionView];
    [self receiveNotification];
}
#pragma mark  接收通知
-(void)receiveNotification
{
    [myNotification addObserver:self selector:@selector(addResult:) name:kBSProjectTemplateCreateResponse object:nil];
    
}
#pragma mark 网络请求结果
-(void)addResult:(NSNotification*)info
{
    if (!info.userInfo[@"rm"]) {
        [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
        
    }else{
         [MBProgressHUD showSuccess:@"添加失败" toView:self.view];
    }
}
#pragma mark - seletedArray
-(NSMutableArray *)selArray
{
    if (!_selArray) {
        _selArray = [NSMutableArray array];
    }
    return _selArray;
}
#pragma mark 初始化设置collectionView
-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(IC_SCREEN_WIDTH, 100);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductTypeOneColumnCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"otherColletiionCell"];
}
-(NSMutableArray *)consumArray
{
    if (!_consumArray) {
        _consumArray = [NSMutableArray array];
        [_consumArray addObjectsFromArray:[[BSCoreDataManager currentManager]fetchProjectTemplatesWithBornCategorys:@[@1] categoryIds:nil keyword:nil priceAscending:nil]];
    }
    return _consumArray;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return  self.consumArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTypeOneColumnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otherColletiionCell" forIndexPath:indexPath];
    cell.object = self.consumArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self.view screenCartView:cell rect:CGRectMake(IC_SCREEN_WIDTH*0.5, IC_SCREEN_HEIGHT-25, 20, 20)];
    [self.selArray addObject:self.consumArray[indexPath.row]];
    [self.seletedBtn setTitle:[NSString stringWithFormat:@"已选择%d",self.selArray.count] forState:UIControlStateNormal];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)seletedBtnClick:(UIButton *)sender {
    [self postNotificationDidSeletedArray];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)postNotificationDidSeletedArray
{
    NSMutableDictionary *seletedDict = [NSMutableDictionary dictionary];
    seletedDict[@"selete"] = self.selArray;
    [myNotification postNotificationName:consumeGoodsSeletedArray object:nil userInfo:seletedDict];
}
@end
