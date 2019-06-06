//
//  SpecificationListController.m
//  Boss
//
//  Created by jiangfei on 16/8/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationListController.h"
#import "SpecificationAddPropertyBoomView.h"
#import "BSAttributeCreateRequest.h"
#import "MBProgressHUD+MJ.h"
@interface SpecificationListController ()<UITableViewDelegate,UITableViewDataSource,SpecificationAddPropertyBoomViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *boomView;
/** dataArray*/
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SpecificationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    //监听键盘弹起
    [myNotification addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [myNotification addObserver:self selector:@selector(newCreatAttribut:) name:kBSAttributeCreateResponse object:nil];
     [self setUpBoomView];
}
#pragma mark 新建属性
-(void)newCreatAttribut:(NSNotification*)info
{
    if (info.userInfo[@"object"]) {
        CDProjectAttribute *attribute = info.userInfo[@"object"];
        [self.dataArray insertObject:attribute atIndex:0];
        [self.tableView reloadData];
        if ([_delegate respondsToSelector:@selector(specificationListDidseletedCellWith:)]) {
            [_delegate specificationListDidseletedCellWith:attribute];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"网路繁忙请稍后再试..."];
    }
    
}
#pragma mark 监听键盘弹起
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
#pragma mark 初始化数据
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
       [array addObjectsFromArray:[[BSCoreDataManager currentManager]fetchAllProjectAttribute]];
        
        if (self.attributeIdArray.count) {
            NSMutableArray *deleteArray = [NSMutableArray array];
                for (CDProjectAttribute *attribute in array) {
                    if ([self.attributeIdArray containsObject:attribute.attributeID]) {
                        [deleteArray addObject:attribute];
                    }
                }
            [array removeObjectsInArray:deleteArray];
            }
        
        [_dataArray addObjectsFromArray:array];
    }
    return _dataArray;
}
#pragma mark - boomView
#pragma mark - boomView
-(void)setUpBoomView
{
   
    SpecificationAddPropertyBoomView *boomView_add = [SpecificationAddPropertyBoomView specificationBoomView];
    boomView_add.delegate = self;
    boomView_add.placeHold = @"新建属性";
    boomView_add.frame = self.boomView.bounds;
    [self.boomView addSubview:boomView_add];
}
-(void)specificationAddPropertyBoomViewCompletionWithText:(NSString *)text
{
    if (text.length) {
        BSAttributeCreateRequest *request = [[BSAttributeCreateRequest alloc] initWithAttributeName:text];
        [request execute];
    }
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark - UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    CDProjectAttribute *attribute = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = attribute.attributeName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(specificationListDidseletedCellWith:)]) {
        [_delegate specificationListDidseletedCellWith:self.dataArray[indexPath.row]];
    }
    [self backBtnClick:nil];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
