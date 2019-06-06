//
//  SpecificationController.m
//  Boss
//
//  Created by jiangfei on 16/7/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationController.h"
#import "SpecificationAddPropertyBoomView.h"
#import "SpecificationSectionHeadView.h"
#import "CDProjectAttributeLine.h"
#import "CDProjectAttributeValue.h"
#import "SpecificationAttributeValueCell.h"
#import "ProdcutAttributValueController.h"
#import "SpecificationEditHeadView.h"
#import "SpecificationAttributeEditCell.h"
#import "SpecificationEditBoomView.h"
#import "SpecificationEditModel.h"
#import "BSAttributeCreateRequest.h"
#import "SpecificationListController.h"
@interface SpecificationController ()<UITableViewDelegate,UITableViewDataSource,SpecificationSectionHeadViewDelegate,SpecificationAttributeEditCellDelegate,SpecificationEditHeadCellDelegate,ProdcutAttributValueControllerDelegate,SpecificationListControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** boomView*/
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
/** boomView */
@property (weak, nonatomic) IBOutlet UIView *boomView;
/** deleteBoomView*/
@property (nonatomic,weak)SpecificationEditBoomView *boomView_delete;
/** dataArray*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/** deleteArray*/
@property (nonatomic,strong)NSMutableArray *deleteArray;
/**  isTransform*/
@property (nonatomic,assign)BOOL isTransform;
/** imageView*/
@property (nonatomic,weak)UIImageView *emptyImageView;
@end

@implementation SpecificationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
   
  //  NSArray *arr = self.projectTemp.attributeLines.array;
//    for (CDProjectAttributeLine *line in arr) {
//        NSArray *values = line.attributeValues.array;
//        for (CDProjectAttributeValue *vlaue in values) {
//            NSLog(@"%@,%@",vlaue.attributeValueName,vlaue.attributeName);
//        }
//    }
    // 初始化tableView
    [self setUptableView];
    //添加boomView
    [self setUpBoomView];
    //添加通知监听器
    [self receiveNotification];
    //添加imageView(没有数据的时候显示)
    [self setUpEmptyImageView];
}
-(void)attributeNotification:(NSNotification*)noti
{
    NSLog(@"%@",noti);
}
#pragma mark - 添加imageView
-(void)setUpEmptyImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    
    self.emptyImageView = imageView;
    self.emptyImageView.image = [UIImage imageNamed:@"specificationEmpty"];
    [self.view addSubview:imageView];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@133);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-80);
        
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:btn];
    imageView.userInteractionEnabled = YES;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.bottom.equalTo(imageView.mas_bottom);
        make.width.equalTo(imageView.mas_width);
        make.height.height.equalTo(@30);
    }];
    [btn addTarget:self action:@selector(newCreatSpecification:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 调到新建页面
-(void)newCreatSpecification:(UIButton*)btn
{
    [self addBtnClick:btn];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *arr = self.baseProjectTemp.attributeLines.array;
        for (CDProjectAttributeLine *line in arr) {
            SpecificationEditModel *editModel = [[SpecificationEditModel alloc]init];
            editModel.attributeLine = line;
            editModel.attributeValueArray = [NSMutableArray array];
            [editModel.attributeValueArray addObjectsFromArray:line.attributeValues.array];
        [_dataArray addObject:editModel];
        }
//         NSArray *lineAllArray = [[BSCoreDataManager currentManager]fetchAllProjectAttribute];
//            for (CDProjectAttribute *attribute in lineAllArray) {
//                int i=0;
//                for (CDProjectAttributeLine *tmpLine in arr) {
//                    if ([attribute.attributeID isEqualToNumber:tmpLine.attributeID]) {
//                        i++;
//                    }
//                }
//                if (i==0) {
//                    SpecificationEditModel *editModel = [[SpecificationEditModel alloc]init];
//                    editModel.attribute = attribute;
//                    [_dataArray addObject:editModel];
//                }
//            }
    }
    return _dataArray;
}
-(NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [[NSMutableArray alloc]init];
    }
    return _deleteArray;
}
#pragma mark 初始化tableView
-(void)setUptableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecificationAttributeValueCell" bundle:nil] forCellReuseIdentifier:@"SpecificationAttributeValueCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecificationAttributeEditCell" bundle:nil] forCellReuseIdentifier:@"SpecificationAttributeEditCell"];
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, 200, 20);
    self.tableView.tableHeaderView = headView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doneKeyBord:)];
    [self.tableView addGestureRecognizer:tap];
}
-(void)doneKeyBord:(UITapGestureRecognizer*)pan
{
    [self.view endEditing:YES];
}
#pragma mark - tableView_DataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    self.boomView.hidden = YES;
    if (self.dataArray.count) {
        self.editBtn.hidden = NO;
        self.emptyImageView.hidden = YES;
        if (self.editBtn.selected) {
            self.boomView.hidden = NO;
            //判断属性的选中状态
            [self judgementIsSeletedHeadViewAndAllBnt];
        }
    }else{
        self.editBtn.hidden = YES;
        self.emptyImageView.hidden = NO;
    }
      return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    SpecificationEditModel *editModel = self.dataArray[section];
    return editModel.attributeValueArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SpecificationEditModel *editModel = self.dataArray[indexPath.section];
    if (!self.editBtn.selected) {
        SpecificationAttributeValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecificationAttributeValueCell"];
        CDProjectAttributeLine *line = editModel.attributeLine;
        cell.attributeLine = line;
        
        cell.attributeValue = editModel.attributeValueArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
      SpecificationAttributeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecificationAttributeEditCell"];
        cell.delegate = self;
        cell.attributeValue = editModel.attributeValueArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}


#pragma mark - tableView_cellDelegate
-(void)specificationAttributeEditCellWith:(CDProjectAttributeValue *)attributeValue
{
    for (SpecificationEditModel *editModel in self.dataArray) {
        for (CDProjectAttributeValue *value in editModel.attributeValueArray) {
            if ([attributeValue.attributeValueID isEqualToNumber:value.attributeValueID]) {
                value.isSeleted = attributeValue.isSeleted;
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark - tableView_HeadView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SpecificationEditModel *editModel = self.dataArray[section];
    if (!self.editBtn.selected) {//编辑
        SpecificationSectionHeadView *headView = [SpecificationSectionHeadView specificationHeadView];
        headView.attributeLine = editModel.attributeLine;
        headView.attribute = editModel.attribute;
        headView.delegate = self;
        headView.editModel = editModel;
        return headView;
    }else{
        SpecificationEditHeadView *editCell = [SpecificationEditHeadView specificationEditHeadView];
        editCell.delegate = self;
        editCell.attributeLine = editModel.attributeLine;
        editCell.attribute = editModel.attribute;
        return editCell;
    }
    
}

#pragma mark - <SpecificationEditHeadViewDelegate>
-(void)specificationEditHeadCellImageBtnClickWithLine:(CDProjectAttributeLine *)line
{
    for (SpecificationEditModel *editModel in self.dataArray) {
        if ([line.attributeLineID isEqualToNumber:editModel.attributeLine.attributeLineID]) {
            editModel.attributeLine.isSelected = line.isSelected;
            for (CDProjectAttributeValue *valu in editModel.attributeValueArray) {
                valu.isSeleted = line.isSelected;
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark - <SpecificationSectionHeadViewDelegate>
-(void)specificationSectionHeadViewAddBtnClickWithLine:(SpecificationEditModel *)model
{
    ProdcutAttributValueController *avVC = [[ProdcutAttributValueController alloc]init];
    avVC.editModel = model;
    avVC.delegate = self;
    [self.view endEditing:YES];
    [self.navigationController pushViewController:avVC animated:YES];
}
#pragma mark <ProdcutAttributValueControllerDelegate>
-(void)prodcutAttributValueControllerWith:(SpecificationEditModel *)model
{
    for (SpecificationEditModel *editModel in self.dataArray) {
        if ([model.numId isEqualToNumber:editModel.numId]) {
            editModel.attributeValueArray = model.attributeValueArray;
            if (editModel.attributeLine) {
                editModel.attributeLine.attributeValues = [NSOrderedSet orderedSetWithArray:model.attributeValueArray];
            }else{
                CDProjectAttributeLine *line = [[BSCoreDataManager currentManager]insertEntity:@"CDProjectAttributeLine"];
                line.attributeID = model.numId;
                line.attributeName = model.attributeName;
                line.attributeValues = [NSOrderedSet orderedSetWithArray:model.attributeValueArray];
                editModel.attributeLine = line;
            }
            
        }
    }
   
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
#pragma mark - boomView
-(void)setUpBoomView
{
    
    SpecificationEditBoomView *boomView_delete = [SpecificationEditBoomView specificationEditBoomView];
    [self.boomView addSubview:boomView_delete];
    self.boomView_delete = boomView_delete;
    self.boomView.hidden = YES;
    boomView_delete.frame = self.boomView.bounds;
    __weak SpecificationController *sep = self;
    boomView_delete.allSeletedBlock = ^(BOOL isAllSeleted){
        for (SpecificationEditModel *tmpModel in sep.dataArray) {
            tmpModel.attribute.isSeleted = @(isAllSeleted);
            tmpModel.attributeLine.isSelected = @(isAllSeleted);
            for (CDProjectAttributeValue *valus in tmpModel.attributeValueArray) {
                valus.isSeleted = @(isAllSeleted);
            }
        }
        [sep.tableView reloadData];
    };
    boomView_delete.deleteBlock = ^{//删除
        NSMutableArray *deletearray = [NSMutableArray array];
        for (int i=0; i<self.dataArray.count; i++) {
            SpecificationEditModel *editModel = self.dataArray[i];
            if ([editModel.attribute.isSeleted boolValue]) {
                [deletearray addObject:editModel];
            }else if ([editModel.attributeLine.isSelected boolValue]) {
                [deletearray addObject:editModel];
            }else{
                for (int j=0; j<editModel.attributeValueArray.count; j++) {
                    CDProjectAttributeValue *value = editModel.attributeValueArray[j];
                    if ([value.isSeleted boolValue]) {
                       [deletearray addObject:editModel];
                    }
                }
            }
        }
        [self.dataArray removeObjectsInArray:deletearray];
        
        [self.tableView reloadData];
        
    };
    
}
#pragma mark - 添加通知监听器
-(void)receiveNotification
{
    //监听键盘弹起
    [myNotification addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark 键盘弹起
-(void)keyboardFrameChange:(NSNotification*)info
{
    if (!self.isTransform) {
        return;
    }
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
#pragma mark 返回按钮点击
- (IBAction)backBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(specificationControllerUpdateProjectTempWith:withOrderSet:)]) {
        NSMutableOrderedSet *lineOrderSet = [NSMutableOrderedSet orderedSet];
        for (SpecificationEditModel *editModel in self.dataArray) {
            
            if (editModel.attributeValueArray.count) {
                if (editModel.attributeLine.attributeName.length == 0) {
                    editModel.attributeLine.attributeName = editModel.attributeName;
                }
                [lineOrderSet addObject:editModel.attributeLine];
            }
     
            
        }
        if (self.baseProjectTemp) {
            self.baseProjectTemp.attributeLines = lineOrderSet;
        }
        [_delegate specificationControllerUpdateProjectTempWith:self.baseProjectTemp withOrderSet:lineOrderSet];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 编辑按钮点击
- (IBAction)editBtnClick:(UIButton *)sender {
    self.editBtn.selected = !self.editBtn.selected;
    [self.tableView reloadData];
}
#pragma mark other
#pragma mark 判断headView和全选按钮的选中状态
-(void)judgementIsSeletedHeadViewAndAllBnt
{
    SpecificationEditModel *editModel = [self.dataArray firstObject];
    CDProjectAttributeLine *firstLine = editModel.attributeLine;
    int j = 0;
    for (SpecificationEditModel *editModel in self.dataArray) {
        if (editModel.attributeLine.attributeValues.count == 0) {
            return;
        }
        CDProjectAttributeValue *firstValue = [editModel.attributeValueArray firstObject];
        int i=0;
        for (CDProjectAttributeValue *value in editModel.attributeValueArray) {
            if (![value.isSeleted isEqualToNumber:firstValue.isSeleted]) {//属性(红色，蓝色)的选中状态不相同
                i++;
                continue;
            }
        }
        if (i==0) {//所有的子属性选中状态相同
            editModel.attributeLine.isSelected = firstValue.isSeleted;
        }else{
            editModel.attributeLine.isSelected = @0;
        }
        if (![editModel.attributeLine.isSelected isEqualToNumber:firstLine.isSelected]) {//类别(颜色,Q)的选中状态不同
            j++;
            continue;
        }
        
    }
    if (j==0) {//所有的类别选中状态相同
        self.boomView_delete.isAllSeleted = [firstLine.isSelected boolValue];
    }else{
        self.boomView_delete.isAllSeleted = NO;
    }
}
#pragma mark 新建btn点击
- (IBAction)addBtnClick:(UIButton *)sender {
    NSLog(@"添加");
    SpecificationListController *listController = [[SpecificationListController alloc]init];
    listController.attributeIdArray = [NSMutableArray array];
    for (SpecificationEditModel *editModel in self.dataArray) {
        [listController.attributeIdArray addObject:editModel.numId];
    }
    listController.delegate = self;
    [self.navigationController pushViewController:listController animated:YES];
}
#pragma mark <SpecificationListControllerDelegate>
-(void)specificationListDidseletedCellWith:(CDProjectAttribute *)attribute
{
    if (attribute) {
        SpecificationEditModel *editModel = [[SpecificationEditModel alloc]init];
        attribute.isSeleted = @0;
        editModel.attribute = attribute;
        [self.dataArray addObject:editModel];
        [self.tableView reloadData];
    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.editBtn.selected = NO;
    [self.tableView reloadData];
    [super viewDidDisappear:animated];
    
}
@end
