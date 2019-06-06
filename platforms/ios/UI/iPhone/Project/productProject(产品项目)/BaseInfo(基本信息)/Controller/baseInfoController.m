//
//  baseInfoController.m
//  Boss
//
//  Created by jiangfei on 16/6/7.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "baseInfoController.h"
#import "productTableHeadView.h"
#import "producSectionView.h"
#import "productModel.h"
#import "productCell.h"
#import "productCategoryController.h"
#import "NumberInHandController.h"
#import <objc/message.h>
#import "BaseInfoEditModel.h"
#import "BSProjectTemplateCreateRequest.h"
#import "MBProgressHUD+MJ.h"
#import "BNScanCodeViewController.h"
#import "QRCodeView.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "SpecificationController.h"
#import "SpecificationBaseCell.h"
#import "UIView+Frame.h"
#import "BaseInfoTempModel.h"
@interface baseInfoController ()<UITableViewDelegate,UITableViewDataSource,productCellDelegate,productTableHeadViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BNScanCodeDelegate,QRCodeViewDelegate,specificationControllerDelegate>
/** tableView*/
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** tableView的头部控件*/
@property (nonatomic,strong)productTableHeadView *headView;
/** 显示在界面上的数据(折叠和展开)*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/** 折叠起来的数据*/
@property (nonatomic,strong)NSMutableArray *totalDataArray;
/** 判断当前是折叠还是展开的*/
@property (nonatomic,assign)BOOL isFold;
/** 折叠，展开View(这个View一开始没有被添加到父控件中用strong)*/
@property (nonatomic,strong)producSectionView *foldView;
/** alertController*/
@property (nonatomic,strong)UIAlertController *alertController;
/** 相册*/
@property (nonatomic,strong)UIImagePickerController *pick;
/** 记录用户输入的信息的model*/
@property (nonatomic,strong)BaseInfoEditModel *baseInfoEditModel;
/** hud*/
@property (nonatomic,strong)MBProgressHUD *hud;
/** starDict*/
@property (nonatomic,strong)NSMutableDictionary *starDict;
/** starArray->存放一开始的规格*/
@property (nonatomic,strong)NSMutableArray *starArray;
/** dict*/
@property (nonatomic,strong)NSMutableDictionary *lastDict;
/** tmpModel*/
@property (nonatomic,strong)BaseInfoTempModel *tempModel;
/** image*/
@property (nonatomic,strong)UIImage *pictureImage;
/** nsorderSet*/
@property (nonatomic,strong)NSOrderedSet *orderSet;
@end

@implementation baseInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VCBackgrodColor;
       //设置tabelView
    [self setUpTableView];
    NSLog(@"%@",self.baseProjectTemp);
    [self receivedNotification];
    [self showGoodsInfo];
    [self starDict];
    [self starArray];
}
#pragma mark 初始化开始的字典
-(NSMutableDictionary *)starDict
{
    if (!_starDict) {
        _starDict = [self returnParmaDictionary];
    }
    return _starDict;
}
#pragma mark 初始化开始的数组
-(NSMutableArray*)starArray
{
    if (!_starArray) {
        _starArray = [NSMutableArray array];
        [_starArray addObjectsFromArray:self.baseProjectTemp.attributeLines.array];
    }
    return _starArray;
}

#pragma mark 生成参数字典
/**返回参数字典 */
-(NSMutableDictionary*)returnParmaDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   
    
    //1.从产品分类->多少积分可兑换
    for (NSArray *arr in self.totalDataArray) {
        for (productModel *model in arr) {
            if (model.textContent.length>0) {
                dict[model.editModelProperty] = model.textContent;
            }else {
                dict[model.editModelProperty] = @(model.imageSeleted);
            }
        }

    }
    //2.名称->在手数量
    NSMutableDictionary *tmpModelDict= [self.tempModel mj_keyValuesWithIgnoredKeys:@[@"imageUrl"]];
    [dict addEntriesFromDictionary:tmpModelDict];
//    dict[@"templateName"] = self.baseProjectTemp.templateName;
//    dict[@"list_price"] = self.baseProjectTemp.list_price;
//    dict[@"standard_price"] = self.baseProjectTemp.standard_price;
//    dict[@"qty_available"] = self.baseProjectTemp.qty_available;
//    dict[@"time"] = self.baseProjectTemp.time;
    dict[@"image"] = @0;
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.baseProjectTemp.imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dict[@"image"] = image;
    }];
    //3.规格
    NSArray *lineArray = self.baseProjectTemp.attributeLines.array;
    
    if (lineArray.count>0) {
        NSMutableArray *lineSArray = [NSMutableArray array];
        for (CDProjectAttributeLine *line in lineArray) {//规格存才
            NSMutableArray *sigeLine = [NSMutableArray array];
            [sigeLine addObject:line.attributeLineID];
            NSMutableArray *sigeAttribut = [NSMutableArray array];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //dict[@"attribute_id"] = line.attributeID;
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:@[@6,@0]];
            NSMutableArray *valueArray = [NSMutableArray array];
            for (CDProjectAttributeValue *value in line.attributeValues.array) {
                [valueArray addObject:value.attributeValueID];
            }
            [arr addObject:valueArray];
            [sigeAttribut addObject:arr];
            if ([line.attributeLineID integerValue] == 0) {//新增的line
                dict[@"attribute_id"] = line.attributeID;
            }
            dict[@"value_ids"] = sigeAttribut;
            [sigeLine addObject:dict];
            [lineSArray addObject:sigeLine];
            
        }
        dict[@"attribute_line_ids"] = lineSArray;
    }
    //4.图片
    if (self.headView.image) {
        // 4.处理图片
        NSData *data = UIImageJPEGRepresentation(self.headView.image, 0.7);
        NSString *imagestr = [data base64Encoding];
        dict[@"image"] = imagestr;
    }
    return dict;
}
-(NSMutableDictionary *)lastDict
{
    if (!_lastDict) {
        _lastDict = [[NSMutableDictionary alloc]init];
    }
    return _lastDict;
}
#pragma mark - 设置tabelView
-(void)setUpTableView
{
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[productCell class] forCellReuseIdentifier:@"productCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecificationBaseCell" bundle:nil] forCellReuseIdentifier:@"SpecificationBaseCellId"];

}
#pragma mark 显示商品的基本信息
-(BaseInfoTempModel *)tempModel
{
    if (!_tempModel) {
        _tempModel = [[BaseInfoTempModel alloc]init];
    }
    return _tempModel;
}
-(void)showGoodsInfo
{

    for (int i=0; i<self.dataArray.count; i++) {
        NSMutableArray *arr = self.dataArray[i];
        for (int j=0; j<arr.count ;j++) {
            productModel *model = arr[j];
            if ([model.name containsString:@"产品分类"]) {
                model.textContent = [NSString stringWithFormat:@"%@",self.baseProjectTemp.categoryName];
            }else if ([model.name isEqualToString:@"内部货号"]) {
                model.textContent = self.baseProjectTemp.defaultCode;
            }else if ([model.name isEqualToString:@"条形码"]) {
                model.textContent = self.baseProjectTemp.barcode;
            }else if ([model.name containsString:@"在收银端销售"]) {
                model.imageSeleted = [self.baseProjectTemp.available_in_pos integerValue];
            }else if ([model.name containsString:@"可销售"]) {
                model.imageSeleted = [self.baseProjectTemp.sale_ok integerValue];
            }else if ([model.name containsString:@"可预约"]) {
                model.imageSeleted = [self.baseProjectTemp.book_ok integerValue];
            }else if ([model.name containsString:@"可采购"]) {
                model.imageSeleted = [self.baseProjectTemp.purchase_ok integerValue];
            }else if ([model.name containsString:@"在微信商城中展示"]) {
                model.imageSeleted = [self.baseProjectTemp.available_in_weixin integerValue];
            }else if ([model.name containsString:@"推荐商品"]) {
                model.imageSeleted = [self.baseProjectTemp.is_recommend integerValue];
            }else if ([model.name containsString:@"主打商品"]) {
                model.imageSeleted = [self.baseProjectTemp.is_main_product integerValue];
            }else if ([model.name containsString:@"参与微卡活动"]) {
                model.imageSeleted = [self.baseProjectTemp.is_spread integerValue];
            }else if ([model.name containsString:@"在微卡商城中展示"]) {
                model.imageSeleted = [self.baseProjectTemp.is_show_weika integerValue];
            }else if ([model.name containsString:@"多少积分可兑换"]) {
                model.textContent = [NSString stringWithFormat:@"%@",self.baseProjectTemp.exchange];
            }
        }
    }
    if (self.baseProjectTemp) {
        BaseInfoTempModel *tmpModel = [[BaseInfoTempModel alloc]init];
        self.tempModel = tmpModel;
        //名称
        tmpModel.name = self.baseProjectTemp.templateName;
         //售价
        tmpModel.list_price = self.baseProjectTemp.list_price.floatValue;
         //成本
        tmpModel.standard_price = self.baseProjectTemp.standard_price.floatValue;
        //在手数量
        tmpModel.qty_available = self.baseProjectTemp.qty_available.integerValue;
        //项目服务时间
        tmpModel.time = self.baseProjectTemp.time.integerValue;
        //图片
        tmpModel.imageUrl = self.baseProjectTemp.imageUrl;
    }
    self.headView.tempModel = self.tempModel;
    [self.tableView reloadData];
    
}

-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]init];
    }
    return _hud;
}
#pragma mark - 通知
-(void)receivedNotification
{
    //监听键盘弹起
    [myNotification addObserver:self selector:@selector(keyBoradFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //编辑headView，
    [myNotification addObserver:self selector:@selector(changeBsprojectItem:) name:baseInfoEdit object:nil];
    //上传结果通知
    [myNotification addObserver:self selector:@selector(receiveResultNotification:) name:kBSProjectTemplateCreateResponse object:nil];
    
    //接受父控制器的通知
   [myNotification addObserver:self selector:@selector(saveToServerceWith:) name:baseVCReceiveParentVCReceive object:nil];
    
    //接受在手数量改变
    [myNotification addObserver:self selector:@selector(numChange:) name:handNumVcChangeNum object:nil];
    //产品分类
    [myNotification addObserver:self selector:@selector(categorySelectedComperle:) name:productCategoryCompele object:nil];
}

#pragma mark - 通知事件
#pragma mark 选择产品分类
-(void)categorySelectedComperle:(NSNotification*)info
{
    NSInteger index = [info.userInfo[@"tage"] integerValue];
    CDProjectCategory *smallCategory = info.userInfo[@"smallCategory"];
    CDProjectCategory *bigCategory = info.userInfo[@"bigCategory"];
    if (index == self.baseTage) {
        if (smallCategory) {
            self.baseProjectTemp.category = smallCategory;
        }else if(bigCategory){
            self.baseProjectTemp.category = bigCategory;
        }
        for (NSArray *arr in self.dataArray) {
            for (productModel *model in arr) {
                if ([model.name isEqualToString:@"产品分类"]) {
                    if (smallCategory) {
                        model.textContent = [NSString stringWithFormat:@"%@/%@",bigCategory.categoryName,smallCategory.categoryName];
                        //上传的是categoryId(数字,界面上显示的是文字)
                        // self.baseInfoEditModel.pos_categ_id = smallCategory.categoryID;
                    }else{
                        model.textContent = [NSString stringWithFormat:@"%@",bigCategory.categoryName];
                        // self.baseInfoEditModel.pos_categ_id = bigCategory.categoryID;
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
}
#pragma mark 在手数量改变
-(void)numChange:(NSNotification*)info
{
    NSInteger index = [info.userInfo[@"tage"] integerValue];
    if (index == self.baseTage) {
        if(self.baseProjectTemp){
            self.baseProjectTemp.qty_available = @([info.userInfo[@"num"] integerValue]);
        }
        self.tempModel.qty_available = [info.userInfo[@"num"] integerValue];
        self.headView.tempModel = self.tempModel;
        [self showGoodsInfo];
    }
}
#pragma mark 键盘弹起
-(void)keyBoradFrameChange:(NSNotification*)info
{
    CGRect rect = [info.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat y = IC_SCREEN_HEIGHT - rect.origin.y;
    if (self.tableView.contentOffset.y>50 || y == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -y);
        }];
    }
    
    
}
#pragma mark 上传结果通知
-(void)receiveResultNotification:(NSNotification*)info
{
    if (info.userInfo[@"rm"]) {
        NSLog(@"保存失败");
//        if ([info.userInfo[@"isCreat"] boolValue]) {//新建
//            NSLog(@"网络繁忙新建失败...");
//            [MBProgressHUD showError:@"网络繁忙新建失败..."];
//        }else{
//            [MBProgressHUD showError:@"网络繁忙更新失败..."];
//        }
    }else{
        [[BSCoreDataManager currentManager]save:nil];
        NSLog(@"保存成功");
        
//        if ([info.userInfo[@"isCreat"] boolValue]) {
//            [MBProgressHUD showSuccess:@"新建成功"];
//        }else{
//            [MBProgressHUD showSuccess:@"更新成功"];
//        }
    }

    
    
    
}
-(BaseInfoEditModel *)baseInfoEditModel
{
    if (!_baseInfoEditModel) {
        NSDictionary *dict = self.baseProjectTemp.mj_keyValues;
        _baseInfoEditModel = [BaseInfoEditModel mj_objectWithKeyValues:dict];
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.baseProjectTemp.imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         _baseInfoEditModel.image = image;
        
           
        }];
    }
    return _baseInfoEditModel;
}
#pragma mark 编辑baseInfo通知
-(void)changeBsprojectItem:(NSNotification*)info
{
    
    if ([info.userInfo[@"tage"] integerValue] == 0 ) {//名称
        self.baseInfoEditModel.name = info.userInfo[@"text"];
    }else if ([info.userInfo[@"tage"] integerValue] == 1){//售价
        self.baseInfoEditModel.list_price = [info.userInfo[@"text"] floatValue];
    }else{
        self.baseInfoEditModel.standard_price = [info.userInfo[@"text"] floatValue];
    }
}

#pragma mark 移除通知监听器
-(void)dealloc
{
    [myNotification removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示商品的基本信息
   // [self showGoodsInfo];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
#pragma mark - 懒加载数据
#pragma mark 展开的数据
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        if (self.totalDataArray.count) {
            [_dataArray addObjectsFromArray:@[self.totalDataArray[0],self.totalDataArray[1]]];
        }
    }
    return _dataArray;
}
#pragma mark 折叠的数据
-(NSMutableArray *)totalDataArray
{
    if (!_totalDataArray) {
        _totalDataArray = [NSMutableArray array];
        NSMutableArray *countArray = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"productPlist" ofType:@"plist"];
        countArray = [[NSMutableArray array]initWithContentsOfFile:path];
        for (NSArray *arr in countArray) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (NSMutableDictionary *dict in arr) {
                productModel *model = [productModel productModelWithDict:dict];
                [tmpArray addObject:model];
            }
            [_totalDataArray addObject:tmpArray];
        }
    }
    return _totalDataArray;
}
#pragma mark - 懒加载控件
-(UIImagePickerController *)pick
{
    if (!_pick) {
        _pick = [[UIImagePickerController alloc]init];
        _pick.delegate = self;
        _pick.allowsEditing = YES;

    }
    return _pick;
}
#pragma mark 弹框控制器
-(UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
           self.pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.pick animated:YES completion:nil];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.pick animated:YES completion:nil];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.headView.image = nil;
            self.baseInfoEditModel.image = nil;
            self.baseProjectTemp.imageUrl = nil;
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertController addAction:action0];
        [_alertController addAction:action1];
        [_alertController addAction:action2];
        [_alertController addAction:action3];
    }
    return _alertController;
}
#pragma mark 相册中选完一张图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.headView.image = image;
    self.baseInfoEditModel.image = image;
    self.pictureImage = image;
    //self.
    [self.pick dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 折叠/展开View
-(producSectionView *)foldView
{
    if (!_foldView) {
        producSectionView *foldView = [[[NSBundle mainBundle]loadNibNamed:@"producSectionView" owner:nil options:nil] lastObject];
        foldView.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, 40);
        _foldView = foldView;
        __weak typeof(self) weakSelf = self;
        _foldView.selectedBlock = ^(BOOL selected){

            //清空数组.
            [weakSelf.dataArray removeAllObjects];
            if (selected) {//展开
            
                [weakSelf.dataArray addObjectsFromArray:weakSelf.totalDataArray];
                
            }else{//折叠
                weakSelf.dataArray = nil;
                [weakSelf dataArray];
            }
            [weakSelf showGoodsInfo];
        };
    }
    return _foldView;
}

#pragma mark 头部控件
-(productTableHeadView *)headView
{
    if (!_headView) {
        productTableHeadView *headView = [[[NSBundle mainBundle]loadNibNamed:@"productTableHeadView" owner:nil options:nil]lastObject];
        
        _headView = headView;
        self.tableView.tableHeaderView = _headView;
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.height.equalTo(@240);
            make.width.equalTo(self.view.mas_width);
            make.left.equalTo(self.view.mas_left);
        }];
        _headView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _headView.numBlock = ^{
            NumberInHandController *numController = [[NumberInHandController alloc]init];
            numController.num = [weakSelf.baseProjectTemp.qty_available integerValue];
            numController.productName = weakSelf.baseProjectTemp.templateName;
            numController.tage = weakSelf.baseTage;
            numController.projectTemp = weakSelf.baseProjectTemp;
            [weakSelf.navigationController pushViewController:numController animated:YES];
            [myNotification postNotificationName:projectSaveBtnHidden object:nil];
        };
    }
    return _headView;
}
#pragma mark - <productTableHeadViewDelegate>
#pragma mark 设置名称，售价。。。
-(void)productTableHeadViewChangeTextField:(BaseInfoTempModel *)temp andText:(NSString *)text
{
    self.tempModel = temp;
    if (self.baseProjectTemp) {
        self.baseProjectTemp.templateName = temp.name;
        self.baseProjectTemp.list_price = @(temp.list_price);
        self.baseProjectTemp.standard_price = @(temp.standard_price);
        self.baseProjectTemp.time = @(temp.time);
        self.baseProjectTemp.qty_available = @(temp.qty_available);
    }
    [self.tableView reloadData];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
}
#pragma mark 设置图片
-(void)productTableHeadViewImageBtnClick
{
    [self presentViewController:self.alertController animated:YES completion:nil];
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
    //弹出alertController
}
#pragma mark tableView dataSource/delegate method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self updateParamsDict];
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataArray[section];
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        SpecificationBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecificationBaseCellId"];
        if (self.baseProjectTemp) {
            cell.projectTemp = self.baseProjectTemp;
        }else if (self.orderSet){
            cell.orderSet = self.orderSet;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        productCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCellId"];
        productModel *model = self.dataArray[indexPath.section][indexPath.row];
        cell.cellModel = model;
        cell.delegate = self;
        if ([model.name isEqualToString:@"产品分类"] || [model.name isEqualToString:@"规格"]) {
            cell.isJump = YES;
        }else{
            cell.isJump = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = nil;
    if (self.baseProjectTemp) {
        arr = self.baseProjectTemp.attributeLines.array;
    }else if (self.orderSet){
        arr = self.orderSet.array;
    }
    
    CGFloat h=44.0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (arr.count > 0) {
            CGFloat totalH = h;
            totalH  = totalH + arr.count*20;
            CGFloat lineH = 0;
            for (CDProjectAttributeLine *line in arr) {
                NSArray *values = line.attributeValues.array;
                lineH = lineH + values.count/3*50;
                if (values.count%3) {
                    lineH = lineH + 50;
                }
            }
            totalH = totalH + lineH;
            h = totalH;
        }
    }
    return h;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IC_SCREEN_WIDTH, 20)];
    sHeadView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    return sHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 2)?0:20;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return (section==1)?self.foldView:nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 1)? 40:0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    productModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.name isEqualToString:@"产品分类"]) {//产品分类
        ProductCategoryController *category = [[ProductCategoryController alloc]init];
//        category.tage = self.baseTage;
//        category.baseProjectTemp = self.baseProjectTemp;
        [self.navigationController pushViewController:category animated:YES];
    }else if ([model.name isEqualToString:@"规格"]){
        SpecificationController *spec = [[SpecificationController alloc]init];
        spec.delegate = self;
        spec.baseProjectTemp = self.baseProjectTemp;
        [self.navigationController pushViewController:spec animated:YES];
    }
}
#pragma mark <SpecificationControllerDelegate>
-(void)specificationControllerUpdateProjectTempWith:(CDProjectTemplate *)temp withOrderSet:(NSOrderedSet *)orderSet
{
    self.dataArray = nil;
    self.totalDataArray = nil;
    if (self.baseProjectTemp) {
        self.baseProjectTemp = temp;
    }else{
        self.orderSet = orderSet;
    }
    
    [self showGoodsInfo];
}

#pragma mark <productCategoryControllerDelegate>
-(void)productCategoryControllerComplishBtnClickWithBigCategory:(CDProjectCategory *)bigCategory andSmallCategory:(CDProjectCategory *)smallCategory
{
    
    
}

#pragma mark <prodcutCellDelegate>
#pragma mark 编辑textField
-(void)productCellTextFieldEndEdit:(productCell *)cell withCellModel:(productModel *)cellModel
{
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
    for (NSArray *arr in self.dataArray){
        for (productModel *model in arr){
            if ([model.name isEqualToString:cellModel.name]){
                model.textContent = cellModel.textContent;
                [self updateBaseTempWith:cellModel];
                //1.刷新tableView
                [self.tableView reloadData];
            }
        }
    }
}
-(void)productCellClickBtnWith:(productModel *)proModel and:(BOOL)tage
{
    [myNotification postNotificationName:projectSaveBtnHidden object:nil];
    if (tage == 1) {//条形码
        if (IS_SDK7)
        {
            BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
            [self.navigationController pushViewController:viewController animated:NO];
        }
    }else{
        for (NSArray *arr in self.dataArray){
            for (productModel *model in arr){
                if ([model.name isEqualToString:proModel.name]){
                    model.imageSeleted = proModel.imageSeleted;
                    if (self.baseProjectTemp) {
                        [self updateBaseTempWith:proModel];
                    }
                    //1.刷新tableView
                    [self.tableView reloadData];
                }
            }
        }
    }
}
#pragma mark 更新temp
-(void)updateBaseTempWith:(productModel*)model
{
    if ([model.name containsString:@"内部货号"]) {
        self.baseProjectTemp.defaultCode = model.textContent;
    }else if ([model.name containsString:@"条形码"]){
        self.baseProjectTemp.barcode = model.textContent;
    }else if ([model.name containsString:@"多少积分可兑换"]){
        self.baseProjectTemp.exchange = @([model.textContent integerValue]);
    }else if ([model.name containsString:@"在收银端销售"]) {
        self.baseProjectTemp.available_in_pos = @(model.imageSeleted);
    }else if ([model.name containsString:@"可销售"]){
        self.baseProjectTemp.sale_ok = @(model.imageSeleted);
    }else if ([model.name containsString:@"可预约"]){
        self.baseProjectTemp.book_ok = @(model.imageSeleted);
    }else if ([model.name containsString:@"可采购"]){
        self.baseProjectTemp.purchase_ok = @(model.imageSeleted);
    }else if ([model.name containsString:@"在微信商城中展示"]){
        self.baseProjectTemp.available_in_weixin = @(model.imageSeleted);
    }else if ([model.name containsString:@"推荐商品"]){
        self.baseProjectTemp.is_recommend = @(model.imageSeleted);
    }else if ([model.name containsString:@"主打商品"]){
        self.baseProjectTemp.is_main_product = @(model.imageSeleted);
    }else if ([model.name containsString:@"参与微卡活动"]){
        self.baseProjectTemp.is_spread = @(model.imageSeleted);
    }else if ([model.name containsString:@"在微卡商城中展示"]){
        self.baseProjectTemp.is_show_weika = @(model.imageSeleted);
    }
}
#pragma mark BNScanCodeDelegate Methods
- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    if (result.length>0) {
        for (NSArray *arr in self.dataArray){
            for (productModel *model in arr){
                if ([model.name isEqualToString:@"条形码"]){
                    model.textContent = result;
                    //1.刷新tableView
                    [self.tableView reloadData];
                }
            }
        }
    }
    
}

#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark 更新bsprojectItem
-(void)upDateBsprojectItemWithProductModel:(productModel*)model andTage:(NSInteger)tag
{

//    if (tag == 0) {
//        if (![model.name isEqualToString:@"产品分类"]) {
//            //[self.baseInfoEditModel setValue:model.textContent forKey:model.editModelProperty];
//        }
//        
//    }else{
//        [self.baseInfoEditModel setValue:@(model.imageSeleted) forKeyPath:model.editModelProperty];
//    }

}
#pragma mark 处理规格属性
-(NSMutableDictionary*)updataSpecificationWithDict:(NSMutableDictionary*)dict
{
    /**
     "attribute_line_ids" = (
     (1,10,{"value_ids" = ((6,0,(8,14)));}),
     (4,11,0)
     );
     "born_category" = 1;
     "category_id" = 1;
     "attribute_line_ids" =     (
     (10,{"value_ids" = ((6,0,(14,22)));}),
     (11,{"value_ids" = ((6,0,(12,11)));})
     );
     "attribute_line_ids" =     (
     (1,10,{"value_ids" =((6,0,(14,22)));}),
     (4,11,0)
     );
     */
    NSArray *paramsArray = dict[@"attribute_line_ids"];
    NSMutableArray *totalArray = [NSMutableArray array];
    if (paramsArray.count>0) {
        NSArray *startArray = self.starDict[@"attribute_line_ids"];
        
        for (NSMutableArray *currentArray in paramsArray) {//遍历当前的规格
            NSMutableArray *attributeLineArray = [NSMutableArray array];
            if ([ startArray containsObject:currentArray]) {//不变的属性
                [attributeLineArray addObjectsFromArray:@[@4,[currentArray firstObject],@0]];
            }else{
                NSInteger attributeId = [[currentArray firstObject] integerValue];
                int i = 0;
                for (NSMutableArray *origneDict in startArray) {
                    if ([[origneDict firstObject] integerValue] == attributeId) {//改变的属性
                        i++;
                        [attributeLineArray addObject:@1];
                        [attributeLineArray addObjectsFromArray:currentArray];
                    }
                }
                if (i==0) {//添加的属性
                  
                    [attributeLineArray addObject:@0];
                    
                    [attributeLineArray addObjectsFromArray:currentArray];
                }
            }
            if (attributeLineArray.count>0) {
                [totalArray addObject:attributeLineArray];
            }
            
        }
        for (NSMutableArray *sta in startArray) {
            NSMutableArray *deleteArray = [NSMutableArray array];
            NSInteger attributeId = [[sta firstObject] integerValue];
            int i=0;
            for (NSMutableArray *currentArray in paramsArray) {
                if (attributeId == [[currentArray firstObject] integerValue]) {
                    i++;
                }
            }
            if (i==0) {//已经删除的
                [deleteArray addObjectsFromArray:@[@2,[sta firstObject],@0]];
            }
            if (deleteArray.count>0) {
                [totalArray addObject:deleteArray];
            }
        }
        
    }
    dict[@"attribute_line_ids"] = totalArray;
    return dict;
}
#pragma mark 更新ParmasDict
-(void)updateParamsDict
{
    if (self.baseProjectTemp) {
        return;
    }
    NSMutableDictionary *dict = [self returnParmaDictionary];
    if ([dict isEqualToDictionary:self.starDict]) {//属性没有改变
        return;
    }// 属性发生改变
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *arrayKey = [self.starDict allKeys];
    for (NSString *key in arrayKey) {
        NSString *starStr = [NSString stringWithFormat:@"%@",self.starDict[key]];
        NSString *dictStr = [NSString stringWithFormat:@"%@",dict[key]];
        if (![starStr isEqualToString:dictStr]) {//取出不相同的属性
            params[key] = dict[key];
        }
    }
    //处理规格
    if (params[@"attribute_line_ids"]) {
        params = [self updataSpecificationWithDict:params];
    }
    if (!self.baseProjectTemp) {//新建
        //更新parmas
        [self.parmasDict addEntriesFromDictionary:params];
        
    }
}
#pragma mark 父控制器接受到保存按钮被点击
#pragma mark 保存到服务器
-(void)saveToServerceWith:(NSNotification*)info
{
    // 1.过滤通知
    if ([info.userInfo[@"index"] integerValue] != self.baseTage) {//过滤一些通知(有3个控制器都会收到保存通知)
        return;
    }
    //5.处理"born_category"产品类别
    NSInteger categoryId = [info.userInfo[@"category_id"] integerValue];
    if (categoryId == 4) {
        categoryId ++;
    }
    if (!self.baseProjectTemp) {//新建
        if ([self.view isShowingOnKeyWindow]) {
            NSInteger categoryId = [info.userInfo[@"category_id"] integerValue];
            if (categoryId == 4) {
                categoryId ++;
            }
            
            self.parmasDict[@"born_category"] = @(categoryId +1);
            self.parmasDict[@"type"] = @"product";
            //3.判断关键属性是否有值
            if ([self.parmasDict[@"name"] length] == 0) {//1.商品名
                [MBProgressHUD showError:@"请输入商品名"];
                return;
            }else if ([self.parmasDict[@"list_price"] floatValue] <= 0){//2.商品价格
                [MBProgressHUD showError:@"请输入价格"];
                return;
            }else if (!self.parmasDict[@"pack_line_ids"] && categoryId >=2 ){
                [MBProgressHUD showError:@"组合套中请至少选择一件商品"];
                return;
            }
            BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithParams:self.parmasDict];
            [request execute];
             [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
    
        // 2.判断属性是否改变
        NSMutableDictionary *dict = [self returnParmaDictionary];
        if ([dict isEqualToDictionary:self.starDict] && self.baseProjectTemp) {//属性没有改变
            NSLog(@"属性没有发生改变");
            if ([self.view isShowingOnKeyWindow]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            return;
        }// 属性发生改变
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSArray *arrayKey = [self.starDict allKeys];
        NSArray *currentKey = [dict allKeys];
        for (NSString *key in arrayKey) {
            NSString *starStr = [NSString stringWithFormat:@"%@",self.starDict[key]];
            NSString *dictStr = [NSString stringWithFormat:@"%@",dict[key]];
            if (![starStr isEqualToString:dictStr]) {//取出不相同的属性
                params[key] = dict[key];
            }
        }
        for (NSString *key in currentKey) {
            NSString *starStr = [NSString stringWithFormat:@"%@",self.starDict[key]];
            NSString *dictStr = [NSString stringWithFormat:@"%@",dict[key]];
            if (![starStr isEqualToString:dictStr]) {//取出不相同的属性
                params[key] = dict[key];
            }
        }
        //处理规格
        if (params[@"attribute_line_ids"]) {
            params = [self updataSpecificationWithDict:params];
        }
        
        
        params[@"born_category"] = @(categoryId +1);
        //6.判断是修改还是新建
        if ([self.view isShowingOnKeyWindow]) {
            BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:self.baseProjectTemp.templateID params:params];
            [request execute];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
   
}
@end
