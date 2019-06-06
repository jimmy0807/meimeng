//
//  FastSaleController.m
//  Boss
//
//  Created by jiangfei on 16/7/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FastSaleController.h"
#import "FastSaleCell.h"
#import "BottomPayView.h"
#import "OperateManager.h"
#import "MemberCardShopCartViewController.h"
#import "MemberCardPayModeViewController.h"
#import "MemberSalePayViewController.h"

@interface FastSaleController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,FastSaleCellDelegate,BottomPayViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *priceBtnTailConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) BottomPayView *bottomPayView;

@property (strong, nonatomic) OperateManager *operateManager;

/** dataArray*/
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation FastSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = @"快速销售";
    
    self.dataArray = @[@"7",@"8",@"9",@"4",@"5",@"6",@"1",@"2",@"3",@"0",@".",@"加入"];
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"FastSaleCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    self.bottomPayView = [[[NSBundle mainBundle] loadNibNamed:@"BottomPayView" owner:self options:nil] lastObject];
    self.bottomPayView.gudanBtn.hidden = true;
    self.bottomPayView.delegate = self;
    self.bottomPayView.operate = self.operateManager.posOperate;
    [self.bottomView addSubview:self.bottomPayView];
    [self.bottomPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    
    self.operateManager = [[OperateManager alloc] init];
    
    self.operateManager.couponCard = [OperateManager shareManager].couponCard;
    self.operateManager.memberCard = [OperateManager shareManager].memberCard;
    
//    [self.priceView removeConstraint:self.priceBtnTailConstraint];
}



#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FastSaleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.titleName = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1) {
        cell.titleColor = COLOR(0, 165, 254, 1);
    }
    else
    {
        cell.titleColor = COLOR(72, 72, 72, 1);
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width)/3.0, (collectionView.frame.size.height)/4.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}




#pragma mark - FastSaleCellDelegate
-(void)fastSaleCellDidSelectedWithBtnTitle:(NSString *)titleName
{
    NSMutableString *priceString = [NSMutableString stringWithString:[self.priceBtn.currentTitle substringFromIndex:1]];
    
    if ([titleName isEqualToString:@"加入"]) {
        NSLog(@"加入");
        PersonalProfile *profile = [PersonalProfile currentProfile];
        CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:profile.defaultProductId forKey:@"itemID"];
//        [self.operateManager addObject:item];
        [self addProjectItem:item withAmount:priceString.floatValue];
        self.bottomPayView.operate = self.operateManager.posOperate;
        
        [self.priceBtn setTitle:[NSString stringWithFormat:@"￥%@",@0] forState:UIControlStateNormal];
        return;
    }
    else if ([titleName isEqualToString:@"."])
    {
        if ([priceString containsString:@"."]) {
            return;
        }
        else
        {
            [priceString appendString:titleName];
        }
    }
    else
    {
        //数字
        if ([priceString isEqualToString:@"0"]) {
            priceString = [NSMutableString stringWithFormat:@"%@",titleName];
        }
        else
        {
            [priceString appendString:titleName];
        }
    }
    
    [self.priceBtn setTitle:[NSString stringWithFormat:@"￥%@",priceString] forState:UIControlStateNormal];
    [self checkShowOrHideDeleteBtn];
    
}


#pragma mark - Button Action
- (IBAction)deleteBtnPressed:(id)sender {
    NSString *priceString = [self.priceBtn.currentTitle substringFromIndex:1];
    if (priceString.length == 1) {
        priceString = @"0";
    }
    else
    {
        priceString = [priceString substringToIndex:priceString.length - 1];
    }
    [self.priceBtn setTitle:[NSString stringWithFormat:@"￥%@",priceString] forState:UIControlStateNormal];
    [self checkShowOrHideDeleteBtn];
}


- (void)checkShowOrHideDeleteBtn
{
    NSString *priceString = [self.priceBtn.currentTitle substringFromIndex:1];
    if ([priceString isEqualToString:@"0"]) {
        [self.priceView addConstraint:self.priceBtnTailConstraint];
    }
    else
    {
        [self.priceView removeConstraint:self.priceBtnTailConstraint];
    }
    
}


- (void)addProjectItem:(CDProjectItem *)item withAmount:(CGFloat)amount
{
    BOOL isExist = NO;
//    for (CDPosProduct *product in self.operateManager.posOperate.products)
//    {
//        if (product.product_id.integerValue == item.itemID.integerValue)
//        {
//            isExist = YES;
//            amount += product.product_price.floatValue;
//            product.product_name = item.itemName;
//            product.product_price = [NSNumber numberWithFloat:amount];
//            product.product_discount = [NSNumber numberWithFloat:10.0];
//            product.money_total = [NSNumber numberWithFloat:amount];
//            break;
//        }
//    }
    
    if (!isExist)
    {
        CDPosProduct *product = [[BSCoreDataManager currentManager] insertEntity:@"CDPosProduct"];
        product.product = item;
        product.product_id = item.itemID;
        product.product_name = item.itemName;
        product.defaultCode = item.defaultCode;
        product.product_price = [NSNumber numberWithFloat:amount];
        product.product_qty = [NSNumber numberWithInteger:1];
        product.product_discount = [NSNumber numberWithFloat:10.0];
        product.money_total = [NSNumber numberWithFloat:amount];
        product.imageUrl = item.imageUrl;
        product.imageSmallUrl = item.imageSmallUrl;
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.operateManager.posOperate.products];
        [orderedSet addObject:product];
        self.operateManager.posOperate.products = orderedSet;
    }
    
    CGFloat totalAmount = 0.0;
    for (CDPosProduct *product in self.operateManager.posOperate.products)
    {
        totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
    }
    self.operateManager.posOperate.amount = [NSNumber numberWithDouble:totalAmount];
    
//    [[BSCoreDataManager currentManager] save:nil];
    
}


#pragma mark - BottomPayViewDelegate
- (void)didPayOperate:(CDPosOperate *)operate
{
    MemberSalePayViewController *memberSalePayVC = [[MemberSalePayViewController alloc] init];
    memberSalePayVC.operateManager = self.operateManager;
    [self.navigationController pushViewController:memberSalePayVC animated:YES];
}

- (void)didShopCartOperate:(CDPosOperate *)operate
{
    MemberCardShopCartViewController *shopCartVC = [[MemberCardShopCartViewController alloc] init];
    shopCartVC.operateManager = self.operateManager;
    [self.navigationController pushViewController:shopCartVC animated:YES];
}


@end
