//
//  ProdcutAttributValueController.m
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProdcutAttributValueController.h"
#import "ProductAttributeCollectionCell.h"
#import "SpecificationAddPropertyBoomView.h"
#import "BSAttributeValueCreateRequest.h"
#import "SpecificationEditModel.h"
#import "MBProgressHUD+MJ.h"
@interface ProdcutAttributValueController ()<UICollectionViewDelegate,UICollectionViewDataSource,ProductAttributeCollectionCellDelegate,SpecificationAddPropertyBoomViewDelegate>
@property (weak, nonatomic)UICollectionView *collectionView;
/** nsarray*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/**  collectionH*/
@property (nonatomic,assign)CGFloat collectionH;
/** layout*/
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
/** boomView*/
@property (weak, nonatomic) IBOutlet UIImageView *emptyPlaceHoldImage;
@property (weak, nonatomic) IBOutlet UILabel *placeHoldLabel;
@property (nonatomic,weak)SpecificationAddPropertyBoomView *boomView;
@end

@implementation ProdcutAttributValueController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    //初始化collectionView
    [self setUpCollectionView];
    //初始化boomView
    [self setUpBoomView];
    //添加通知
    [self receiveNotification];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 添加通知监听器
-(void)receiveNotification
{
    //监听键盘弹起
    [myNotification addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [myNotification addObserver:self selector:@selector(addNotificationFinish:) name:kBSAttributeValueCreateResponse object:nil];
}
-(void)addNotificationFinish:(NSNotification*)info
{
    NSLog(@"%@",info.userInfo);
    if (info.userInfo[@"object"]) {
        CDProjectAttributeValue *attributeValue = (CDProjectAttributeValue *)[info.userInfo objectForKey:@"object"];
//        CDProjectAttributeValue *value = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectAttributeValue"];
//        attributeValue = value;
//        value.isSeleted = @1;
//        value.attributeValueName = text;
//        value.attributeID = self.attributeLine.attributeID;
      //  [self.dataArray addObject:value];
        attributeValue.isSeleted = @1;
        [self.dataArray addObject:attributeValue];
        self.collectionView.frame = [self upDateCollectionViewFrame];
        [self.collectionView reloadData];
//        for (CDProjectAttributeValue *value in self.dataArray) {
//            if ([value.attributeValueName isEqualToString:attributeValue.attributeValueName]) {
//                value.attributeValueID = attributeValue.attributeValueID;
//                value.attribute = attributeValue.attribute;
//            }
//        }
       // [self.collectionView reloadData];
    }else{
        [MBProgressHUD showError:@"网络繁忙请稍后再试..."];
    }
    
}
#pragma mark 键盘弹起
-(void)keyboardFrameChange:(NSNotification*)info
{
    CGFloat beginH = [info.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
    CGFloat endH = [info.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    CGFloat transH = endH - beginH;
    CGFloat during = [info.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:during animations:^{
        self.boomView.transform = CGAffineTransformTranslate(self.boomView.transform, 0, transH);
    }];
}
#pragma mark 移除通知
-(void)dealloc
{
    [myNotification removeObserver:self];
}

#pragma mark 数组排序
-(void)arrPaixu
{
    for (int i=0; i<_dataArray.count; i++) {
        CDProjectAttributeValue *value = _dataArray[i];
        value.isSeleted = @0;
        for (CDProjectAttributeValue *tempValue in self.editModel.attributeLine.attributeValues.array) {
            if ([value.attributeValueID isEqualToNumber:tempValue.attributeValueID]) {
                value.isSeleted = @1;
                [_dataArray removeObject:value];
                [_dataArray insertObject:value atIndex:0];
                
            }
        }
    }
}
#pragma mark 初始化数组
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        NSNumber *numId = @0;
        if (self.editModel.attribute) {
            numId = self.editModel.attribute.attributeID;
        }else if (self.editModel.attributeLine){
            numId = self.editModel.attributeLine.attributeID;
        }
       CDProjectAttribute *attribute  = [[BSCoreDataManager currentManager]findEntity:@"CDProjectAttribute" withValue:numId forKey:@"attributeID"];
        for (CDProjectAttributeValue *value in attribute.attributeValues.array) {
            
            [_dataArray addObject:value];
        }
        [self arrPaixu];
    }
    return _dataArray;
}
#pragma mark 初始化layout
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat cellW = 70;
        CGFloat cellH = 30;
        CGFloat topBottom = 20;
        CGFloat leftRigth = 15;
        layout.itemSize = CGSizeMake(cellW, cellH);
        layout.sectionInset = UIEdgeInsetsMake(topBottom, leftRigth, topBottom, leftRigth);
        layout.minimumLineSpacing = 0;
        layout.minimumLineSpacing = 20;
        _layout = layout;
    }
    return _layout;
}
#pragma mark 计算collectionView的frame
-(CGRect)upDateCollectionViewFrame
{

    CGFloat cellH = 30;
    CGFloat topBottom = 20;
    CGFloat hang = 0;
    NSInteger maxCount = 0;
    NSInteger count = self.dataArray.count;
    if (self.dataArray.count == 0) {
        return CGRectMake(0, 0, 0, 0);
    }
    if (IC_SCREEN_WIDTH>320) {//4
        maxCount = 4;
        hang = count/maxCount;
    }else{//3
        maxCount = 3;
        hang = count/maxCount;
    }
    if (count % maxCount) {
        hang++;
    }
    CGFloat collectionH = cellH * hang + topBottom * (hang+1);
    self.collectionH = collectionH;
    if (collectionH >= IC_SCREEN_HEIGHT - 168) {
        collectionH = IC_SCREEN_HEIGHT - 168;
    }
   return  CGRectMake(0, 124, IC_SCREEN_WIDTH, collectionH);
}
#pragma mark 初始化boomView
-(void)setUpBoomView
{
    SpecificationAddPropertyBoomView *boomView = [SpecificationAddPropertyBoomView specificationBoomView];
    boomView.placeHold = @"新建属性值";
    boomView.delegate = self;
    self.boomView = boomView;
    [self.view addSubview:self.boomView];
    [self.boomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@44);
    }];
}
#pragma mark <SpecificationAddPropertyBoomViewDelegate>
-(void)specificationAddPropertyBoomViewCompletionWithText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
//    CDProjectAttributeValue *value = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectAttributeValue"];
//    value.isSeleted = @1;
//    value.attributeValueName = text;
//    value.attributeID = self.attributeLine.attributeID;
//    [self.dataArray addObject:value];
//    self.collectionView.frame = [self upDateCollectionViewFrame];
//    [self.collectionView reloadData];
    //添加CDProjectAttributeValue
    BSAttributeValueCreateRequest *request = [[BSAttributeValueCreateRequest alloc] initWithAttribute:self.editModel.attribute attributeValueName:text];
    
    [request execute];
    
}
#pragma mark 初始化collectionView
-(void)setUpCollectionView
{

    BOOL isCanScroll = NO;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[self upDateCollectionViewFrame] collectionViewLayout:self.layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    if (collectionView.frame.size.height >= IC_SCREEN_HEIGHT - 168) {
        isCanScroll = YES;
    }else{
        isCanScroll = NO;
    }
    collectionView.scrollEnabled = isCanScroll;
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductAttributeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ProductAttributeCollectionCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark collectionViewDelegate/datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.placeHoldLabel.hidden = self.dataArray.count ? NO:YES;
    self.emptyPlaceHoldImage.hidden = !self.placeHoldLabel.hidden;
   self.collectionView.frame = [self upDateCollectionViewFrame];
    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductAttributeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductAttributeCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    
   CDProjectAttributeValue *attribute = self.dataArray[indexPath.item];
    cell.projectAttributeValue = attribute;
    return cell;
}

#pragma mark <ProductAttributeCollectionCellDelegate>
-(void)productAttributeChangeStatues:(CDProjectAttributeValue *)attributeValue
{
   
    for (CDProjectAttributeValue *value in self.dataArray) {
        if ([attributeValue.attributeValueID isEqualToNumber:value.attributeValueID]) {
            value.isSeleted = attributeValue.isSeleted;
        }
    }
    [self.collectionView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark 长按删除
-(void)productAttributeLongPressCellWithAttributeValue:(CDProjectAttributeValue *)attributeValue
{
    NSUInteger row = [self.dataArray indexOfObject:attributeValue];
    [self.dataArray removeObjectAtIndex:row];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.frame = [self upDateCollectionViewFrame];
    }];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
    
}
- (IBAction)backViewClick:(UIButton *)sender {
//    if ([_delegate respondsToSelector:@selector(prodcutAttributValueControllerWith:)]) {
//        if (self.dataArray.count==0) {
//        [self.navigationController popViewControllerAnimated:YES];
//            [self.editModel.attributeValueArray removeAllObjects];
//            [_delegate prodcutAttributValueControllerWith:self.editModel];
//            return;
//        }
//        NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
//        for (CDProjectAttributeValue *value in self.dataArray) {
//            if ([value.isSeleted boolValue]) {
//                [orderSet addObject:value];
//            }
//        }
//        if (![self.editModel.attributeValueArray isEqualToArray:orderSet.array]) {
//            self.editModel.attributeValueArray = [NSMutableArray array];
//            [self.editModel.attributeValueArray addObjectsFromArray:orderSet.array];
//            [_delegate prodcutAttributValueControllerWith:self.editModel];
//        }
//        
//    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)completionClick:(UIButton *)sender {
    NSLog(@"完成");
    if ([_delegate respondsToSelector:@selector(prodcutAttributValueControllerWith:)]) {
        if (self.dataArray.count==0) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.editModel.attributeValueArray removeAllObjects];
            [_delegate prodcutAttributValueControllerWith:self.editModel];
            return;
        }
        NSMutableOrderedSet *orderSet = [NSMutableOrderedSet orderedSet];
        for (CDProjectAttributeValue *value in self.dataArray) {
            if ([value.isSeleted boolValue]) {
                [orderSet addObject:value];
            }
        }
        if (![self.editModel.attributeValueArray isEqualToArray:orderSet.array]) {
            self.editModel.attributeValueArray = [NSMutableArray array];
            [self.editModel.attributeValueArray addObjectsFromArray:orderSet.array];
            [_delegate prodcutAttributValueControllerWith:self.editModel];
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}


@end
