//
//  ShowCombinationController.m
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ShowCombinationController.h"
#import "ProductTypeOneColumnCollectionCell.h"
#import "UIView+SnapShot.h"
#import "BSProjectTemplateCreateRequest.h"
#import "MBProgressHUD+MJ.h"
@interface ShowCombinationController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *seletedBtn;
@property (weak, nonatomic) IBOutlet UIView *boomView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** combiArray*/
@property (nonatomic,strong)NSMutableArray *combiArray;
/** seletedArray*/
@property (nonatomic,strong)NSMutableArray *seletedArray;
@end

@implementation ShowCombinationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    self.boomView.backgroundColor = VCBackgrodColor;
    //初始化collectionView
    [self setUpCollectionView];
}
-(NSMutableArray *)seletedArray
{
    if (!_seletedArray) {
        _seletedArray = [[NSMutableArray alloc]init];
    }
    return _seletedArray;
}
#pragma mark 初始化collectionView
-(void)setUpCollectionView
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(IC_SCREEN_WIDTH, 100);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductTypeOneColumnCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"otherColletiionCell"];
}
-(NSMutableArray *)combiArray
{
    if (!_combiArray) {
        _combiArray = [NSMutableArray array];
        [_combiArray addObjectsFromArray:[[BSCoreDataManager currentManager]fetchProjectTemplatesWithBornCategorys:@[@1,@2] categoryIds:nil keyword:nil priceAscending:nil]];
    }
    return _combiArray;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.combiArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTypeOneColumnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otherColletiionCell" forIndexPath:indexPath];
    cell.object = self.combiArray[indexPath.row];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.combinTage != 4 && self.seletedArray.count>0) {
        [MBProgressHUD showError:@"只能添加一种类型的商品"];
        return;
    }
    ProductTypeOneColumnCollectionCell *cell = (ProductTypeOneColumnCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self.view screenCartView:cell rect:CGRectMake(IC_SCREEN_WIDTH*0.5, IC_SCREEN_HEIGHT-25, 20, 20)];
    CDProjectTemplate *temp = self.combiArray[indexPath.row];
    [self.seletedArray addObject:temp];
    [self.seletedBtn setTitle:[NSString stringWithFormat:@"已选择%zd",self.seletedArray.count] forState:UIControlStateNormal];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    NSLog(@"返回...");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seletedBtnClick:(UIButton *)sender {
    NSLog(@"已选择:%d",self.seletedArray.count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"array"] = self.seletedArray;
    dict[@"tage"] = @(self.combinTage);
    [myNotification postNotificationName:packageSeletedCompleted object:nil userInfo:dict];
   // [self requsetToNet];
    [self.navigationController popViewControllerAnimated:YES];
    /*
     {
     pack_line_ids = [
     [4,687,0],
     [0,0,{
     quantity = 1,
     product_id = 2905,
     lst_price = 33,
     limited_qty = 0
     }],
     ],
     list_price = 1033,
     born_category = 3
     }
     kBSDataAdded    = 0,
     kBSDataUpdate   = 1,
     kBSDataDelete   = 2,
     kBSDataDeleteN  = 3,
     kBSDataLinked   = 4,
     kBSDataExist    = 6
     
     */
}
-(void)requsetToNet
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"born_category"] = @3;
    dict[@"list_price"] = @([self.baseProjectTemp.list_price floatValue]);
    NSMutableArray *array = [NSMutableArray array];

    [array addObject:@[@4,self.baseProjectTemp.templateID,@0]];
    for (CDProjectTemplate *temp in self.seletedArray) {
        [array addObject:@[@0,@0,@{
                               @"quantity":@1,
                               @"product_id":temp.templateID,
                               @"lst_price":temp.list_price,
                               @"limited_qty":@0
                                    }]];
    }
    BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc]initWithProjectTemplateID:self.baseProjectTemp.templateID params:dict];
    [request execute];
}

@end
