//
//  ProductBaseInfoView.m
//  ds
//
//  Created by lining on 2016/10/27.
//
//

#import "ProductBaseInfoView.h"
#import "UIView+Frame.h"
#import "ProductPicCell.h"
#import "TextFieldCell.h"
#import "MemberCheckboxCell.h"
#import "ItemArrowCell.h"  
#import "ScanInputCell.h"
#import "UILabel+ColorFont.h"
#import "ProductCategoryController.h"
#import "BSImagePickerManager.h"
#import "AlbumViewController.h"
#import "UIImage+Orientation.h"
#import "ProductAttributeLineController.h"
#import "AttributeLineViewCell.h"
#import "AttributePriceViewController.h"
#import "BSAttributePriceCreateRequest.h"
#import "AttributeProductViewController.h"
#import "OnHandViewController.h"
#import "BNScanCodeViewController.h"
#import "AttributeControllerViewController.h"
#import "MemberSalePayViewController.h"
#import "BSProjectTemplateCreateRequest.h"

#define ValueColor COLOR(177,177,177,1)

typedef enum kInfoSection
{
    kInfoSectionOne,
    kInfoSectionTwo,
    kInfoSectionThree,
    kInfoSectionFour,
    kInfoSectionFive,
    kInfoSectionSix,
    kInfoSectionNum
}kInfoSection;

typedef enum InfoSectionOneRow
{
    InfoSectionRow_pic,
    InfoSectionRow_category,
    InfoSectionRow_fuwuDate,
    InfoSectionOneRow_num
}InfoSectionOneRow;


typedef enum InfoSectionTwoRow
{
    InfoSectionRow_attribute,
    InfoSectionRow_attributeLine,
    InfoSectionRow_attributePrice,
    InfoSectionRow_attributeProductItem
    
}InfoSectionTwoRow;

//typedef enum InfoSectionThreeRow
//{
//    InfoSectionRow_cost,
//    InfoSectionRow_onHand,
//    InfoSectionRow_innerCode,
//    InfoSectionRow_barcode,
//    InfoSectionThreeRow_num,
//}InfoSectionThreeRow;


typedef enum InfoSectionFourRow
{
    InfoSectionRow_canSale,
    InfoSectionRow_canBook,
    InfoSectionRow_canPurchase,
    InfoSectionFourRow_num
}InfoSectionFourRow;


typedef enum InfoSectionFiveRow
{
    InfoSectionRow_onCashierSale,
    InfoSectionRow_onWeixinShow,
    InfoSectionRow_isTuijian,
    InfoSectionRow_isMain,
    InfoSectionFiveRow_num
}InfoSectionFiveRow;


typedef enum InfoSectionSixRow
{
    InfoSectionRow_weikaHuodong,
    InfoSectionRow_onWeikaShow,
    InfoSectionRow_point,
    InfoSectionSixRow_num
}InfoSectionSixRow;

@interface ProductBaseInfoView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ScanInputCellDelegate,ProductPicCellDelegate,CheckBoxCellDelegate,ProductCategoryControllerDelegate,UIActionSheetDelegate,BSImagePickerManagerDelegate,AlbumViewControllerDelegate,ProductAttributeLineControllerDelegate,BNScanCodeDelegate>
{
    bool expand;
    bool isHaveImage;
    
    bool canSale,canBook,canPurchase,isSaleOnCashier;
   
    
    NSInteger attributeSectionRowNum;
    
    int InfoSectionRow_cost,
    InfoSectionRow_vipPrice,
    InfoSectionRow_onHand,
    InfoSectionRow_innerCode,
    InfoSectionRow_barcode,
    InfoSectionThreeRow_num;
}
@property (nonatomic, assign) ProductTmplateType type;
@property (nonatomic, strong) NSIndexPath *scanIndexPath;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation ProductBaseInfoView

+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory
{
    ProductBaseInfoView *infoView = [self loadFromNib];
    infoView.backgroundColor = COLOR(245, 245, 245, 1);
    infoView.type = type;
    infoView.bornCategory = bornCategory;
    
    infoView.tableView.dataSource = infoView;
    infoView.tableView.delegate = infoView;

    [infoView.tableView registerNib:[UINib nibWithNibName:@"ProductPicCell" bundle:nil] forCellReuseIdentifier:@"ProductPicCell"];
    [infoView.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [infoView.tableView registerNib:[UINib nibWithNibName:@"MemberCheckboxCell" bundle:nil] forCellReuseIdentifier:@"MemberCheckboxCell"];
    [infoView.tableView registerNib:[UINib nibWithNibName:@"ScanInputCell" bundle:nil] forCellReuseIdentifier:@"ScanInputCell"];
    [infoView.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [infoView.tableView registerNib:[UINib nibWithNibName:@"AttributeLineViewCell" bundle:nil] forCellReuseIdentifier:@"AttributeLineViewCell"];
    
    infoView.deleteBtn.layer.cornerRadius = 4;
    infoView.deleteBtn.layer.masksToBounds = true;
    
    return infoView;
}

- (void)setProjectTemplate:(CDProjectTemplate *)projectTemplate
{
    _projectTemplate = projectTemplate;
    
    self.bsItem = [[BSProjectItem alloc] init];
    
    
    self.bsItem.projectImage = nil;
    if (self.projectTemplate.imageUrl != nil)
    {
        [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:self.projectTemplate.imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             isHaveImage = true;
             self.bsItem.projectImage = image;
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSectionRow_pic];
             ProductPicCell *cell = (ProductPicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
             cell.picImageView.image = self.bsItem.projectImage;
         }];
    }
    else
    {
        self.bsItem.projectImage = nil;
    }

    
    self.bsItem.projectName = self.projectTemplate.templateName;
    self.bsItem.projectPrice = self.projectTemplate.listPrice.floatValue;
    self.bsItem.standardPrice = self.projectTemplate.standard_price.floatValue;
    self.bsItem.memberPrice = self.projectTemplate.memberPrice.floatValue;
    
    if (self.projectTemplate) {
        self.bsItem.projectType = self.projectTemplate.type;
    }
    else
    {
        if (self.bornCategory.code.integerValue == kPadBornCategoryProduct) {
            self.bsItem.projectType = @"product";
        }
        else
        {
            self.bsItem.projectType = @"service";
        }
    }
    self.bsItem.posCategory = self.projectTemplate.category;
    self.bsItem.barcode = self.projectTemplate.barcode;
    self.bsItem.defaultCode = self.projectTemplate.defaultCode;
    self.bsItem.isActive = self.projectTemplate.isActive.boolValue;
    if (self.projectTemplate) {
        self.bsItem.canSale = self.projectTemplate.canSale.boolValue;
    }
    else
    {
        self.bsItem.canSale = true;
    }
    canSale = self.bsItem.canSale;
    
    if (self.projectTemplate) {
        self.bsItem.canPurchase = self.projectTemplate.canPurchase.boolValue;
    }
    else
    {
        self.bsItem.canPurchase = true;
    }
    canPurchase = self.bsItem.canPurchase;
    
    if (self.projectTemplate) {
        self.bsItem.canBook = self.projectTemplate.canBook.boolValue;
    }
    else
    {
        if (self.bornCategory.code.integerValue == kPadBornCategoryProject) {
            self.bsItem.canBook = true;
        }
        else
        {
            self.bsItem.canBook = false;
        }
    }
    canBook = self.bsItem.canBook;
    
    if (self.projectTemplate) {
        self.bsItem.isSaleOnCashier = self.projectTemplate.available_in_pos.boolValue;
    }
    else
    {
        self.bsItem.isSaleOnCashier = true;
    }
    isSaleOnCashier = self.bsItem.isSaleOnCashier;
    
    
    self.bsItem.fuwuTime = self.projectTemplate.time.integerValue;
    self.bsItem.isShowOnWeixin = self.projectTemplate.available_in_weixin.boolValue;
    self.bsItem.isTuijian = self.projectTemplate.is_recommend.boolValue;
    self.bsItem.isMain = self.projectTemplate.is_main_product.boolValue;
    self.bsItem.isInWeikaActive = self.projectTemplate.is_spread.boolValue;
    self.bsItem.isShowOnWeika = self.projectTemplate.is_show_weika.boolValue;
    
    self.bsItem.exchangePoint = self.projectTemplate.exchange.floatValue;
    
    [self initAttributeLines];
    
    [self initThreeSection];
    [self resetAttributeSectionRowNum];
}


- (void)initAttributeLines
{
    self.bsItem.attributeLines = [NSMutableArray array];
    for (int i = 0; i < self.projectTemplate.attributeLines.count; i++)
    {
        CDProjectAttributeLine *attributeLine = [self.projectTemplate.attributeLines objectAtIndex:i];
        BSAttributeLine *bsAttributeLine = [[BSAttributeLine alloc] init];
        bsAttributeLine.attributeLineID = attributeLine.attributeLineID;
        bsAttributeLine.attributeLineName = attributeLine.attributeLineName;
        bsAttributeLine.templateID = attributeLine.templateID;
        bsAttributeLine.templateName = attributeLine.templateName;
        bsAttributeLine.attributeID = attributeLine.attributeID;
        bsAttributeLine.attributeName = attributeLine.attributeName;
        
        bsAttributeLine.attributeValues = [[NSMutableArray alloc] init];
        for (int j = 0; j < attributeLine.attributeValues.count; j++)
        {
            CDProjectAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:j];
            BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
            bsAttributeValue.editType = kBSDataNone;
            bsAttributeValue.attributeLine = bsAttributeLine;
            bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
            bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
            CDProjectAttributePrice *attributePrice = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributePrice" withValue:attributeValue.attributeValueID forKey:[NSString stringWithFormat:@"templateID == %@ && attributeValueID", attributeLine.templateID]];
            bsAttributeValue.attributePrice = attributePrice;
            bsAttributeValue.attributeValueExtraPrice = 0.0;
            if (attributePrice != nil)
            {
                bsAttributeValue.attributeValueExtraPrice = attributePrice.extraPrice.floatValue;
            }
            
            [bsAttributeLine.attributeValues insertObject:bsAttributeValue atIndex:bsAttributeLine.attributeValues.count];
        }
        [self.bsItem.attributeLines insertObject:bsAttributeLine atIndex:self.bsItem.attributeLines.count];
    }
}

#pragma mark - init Section & Row

- (void)initThreeSection
{

    int startRow = 0;
    if (self.bornCategory.code.integerValue == kPadBornCategoryCourses || self.bornCategory.code.integerValue == kPadBornCategoryPackage || self.bornCategory.code.integerValue == kPadBornCategoryPackageKit) {
        startRow = -1;
    }
    
    if (self.type == ProductTmplateType_Edit && [self.projectTemplate.type isEqualToString:@"product"]) {
        InfoSectionRow_cost = startRow++;
        InfoSectionRow_vipPrice = startRow++;
        InfoSectionRow_onHand = startRow++;
        InfoSectionRow_innerCode= startRow++;
        InfoSectionRow_barcode = startRow++;
        InfoSectionThreeRow_num = startRow++;
    }
    else
    {
        InfoSectionRow_onHand = -1;
        InfoSectionRow_cost = startRow++;
        InfoSectionRow_vipPrice = startRow++;
        InfoSectionRow_innerCode= startRow++;
        InfoSectionRow_barcode = startRow++;
        InfoSectionThreeRow_num = startRow++;
    }
    
}

#pragma mark - 规格section row的数量
- (void)resetAttributeSectionRowNum
{
    if (self.bornCategory.code.integerValue != kPadBornCategoryProduct) {
        attributeSectionRowNum = 0;
        return;
    }
    
    if (self.bsItem.attributeLines.count == 0) {
        attributeSectionRowNum = InfoSectionRow_attribute + 1;
    }
    else
    {
        attributeSectionRowNum = InfoSectionRow_attributeLine + 1;
        for (BSAttributeLine *attributeLine in self.bsItem.attributeLines) {
            if (attributeLine.attributeValues.count > 0) {
                
                attributeSectionRowNum = InfoSectionRow_attributeProductItem + 1;
                break;
            }
        }
    }
}






#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (expand) {
        return kInfoSectionNum;
    }
    else
    {
        return kInfoSectionFour;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kInfoSectionOne) {
        if (self.bornCategory.code.integerValue == kPadBornCategoryProject) {
            return InfoSectionOneRow_num;
        }
        else
        {
            return InfoSectionRow_fuwuDate;
        }
        
    }
    else if (section == kInfoSectionTwo)
    {
        return attributeSectionRowNum;
    }
    else if (section == kInfoSectionThree)
    {
        return InfoSectionThreeRow_num;
    }
    else if (section == kInfoSectionFour)
    {
        return InfoSectionFourRow_num;
    }
    else if (section == kInfoSectionFive)
    {
        return InfoSectionFiveRow_num;
    }
    else if (section == kInfoSectionSix)
    {
        return InfoSectionSixRow_num;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kInfoSectionOne) {
        if (row == InfoSectionRow_pic) {
            ProductPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"ProductPicCell"];
            picCell.delegate = self;
            picCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [picCell.nameLabel setAttributeString:@"名称*" colorString:@"*" color:[UIColor redColor] font:nil];
            [picCell.priceLabel setAttributeString:@"售价*" colorString:@"*" color:[UIColor redColor] font:nil];
            
            picCell.nameTextField.delegate = self;
            picCell.priceTextField.delegate = self;
            
            picCell.nameTextField.textColor = ValueColor;
            picCell.priceTextField.textColor = ValueColor;
            
            picCell.nameTextField.tag = 101;
            picCell.priceTextField.tag = 102;
            
            picCell.nameTextField.text = self.bsItem.projectName;
            picCell.priceTextField.text = [NSString stringWithFormat:@"¥%.2f",self.bsItem.projectPrice];
            
            picCell.nameTextField.clearsOnBeginEditing = true;
            picCell.priceTextField.clearsOnBeginEditing = true;
            
            if (self.bsItem.projectImage) {
                picCell.picImageView.image = self.bsItem.projectImage;
            }
            else
            {
                picCell.picImageView.image = [UIImage imageNamed:@"BornCategoryPleceHoledImage.png"];
            }
            return picCell;
        }
        else if (row == InfoSectionRow_category)
        {
            ItemArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            arrowCell.nameLabel.text = @"产品分类";
            arrowCell.nameLabel.font = [UIFont systemFontOfSize:16];
            
            arrowCell.valueLabel.textColor = ValueColor;
            if (self.bornCategory.code.integerValue == kPadBornCategoryProject) {
                arrowCell.lineImgView.hidden = false;
            }
            else
            {
                arrowCell.lineImgView.hidden = true;
            }
            
            NSString *categoryString;
            CDProjectCategory *category = self.bsItem.posCategory;
            while (category) {
                if (categoryString == nil) {
                    categoryString = category.categoryName;
                }
                else
                {
                    categoryString = [NSString stringWithFormat:@"%@/%@",category.categoryName,categoryString];
                }
                
                category = category.parent;
            }
            
            arrowCell.valueLabel.text = categoryString;
            
            
            return arrowCell;
        }
        else if (row == InfoSectionRow_fuwuDate)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            [cell.titleLabel setAttributeString:@"服务时间*" colorString:@"*" color:[UIColor redColor] font:nil];
            cell.valueTextFiled.text = [NSString stringWithFormat:@"%d",self.bsItem.fuwuTime];
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.tag = 1000*section + row;
            cell.valueTextFiled.textColor = ValueColor;
            cell.lineImgView.hidden = true;
            return cell;
        }
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSectionRow_attributeLine) {
        
            AttributeLineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeLineViewCell"];
            cell.attributeLines = self.bsItem.attributeLines;
            if (row == attributeSectionRowNum - 1) {
                cell.lineImgView.hidden = true;
            }
            else
            {
                cell.lineImgView.hidden = false;
            }
            return cell;
        }
        else
        {
            ItemArrowCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            arrowCell.lineTailingConstant = 0;
            arrowCell.nameLabel.font = [UIFont systemFontOfSize:16];
            arrowCell.valueLabel.hidden = true;
            
            arrowCell.valueLabel.textColor = ValueColor;
            
            if (row == InfoSectionRow_attribute) {
                arrowCell.nameLabel.text = @"规格";
            }
            else if (row == InfoSectionRow_attributePrice)
            {
                arrowCell.nameLabel.text = @"规格附加价格";
            }
            else if (row == InfoSectionRow_attributeProductItem)
            {
                arrowCell.nameLabel.text = @"规格详情";
            }
            
            if (row == attributeSectionRowNum - 1) {
                arrowCell.lineImgView.hidden = true;
            }
            else
            {
                arrowCell.lineImgView.hidden = false;
            }
            
            return arrowCell;
        }
    }
    else if (section == kInfoSectionThree)
    {
        if (row == InfoSectionRow_cost) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.text = @"成本";
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.lineTailingConstant = 0;
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.lineImgView.hidden = false;
            cell.valueTextFiled.placeholder = @"请输入";
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.textColor = ValueColor;
            
            cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",self.bsItem.standardPrice];
            
            cell.valueTextFiled.tag = 1000*section + row;
            
            return cell;
        }
        else if (row == InfoSectionRow_vipPrice)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.text = @"会员价";
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.lineTailingConstant = 0;
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.lineImgView.hidden = false;
            cell.valueTextFiled.placeholder = @"请输入";
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.textColor = ValueColor;
            
            cell.valueTextFiled.text = [NSString stringWithFormat:@"¥%.2f",self.bsItem.memberPrice];
            
            cell.valueTextFiled.tag = 1000*section + row;
            
            return cell;
        }
        else if (row == InfoSectionRow_onHand)
        {
            ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
            cell.nameLabel.text = @"在手数量";
            cell.nameLabel.font = [UIFont systemFontOfSize:16];
            cell.lineImgView.hidden = false;
            cell.lineTailingConstant = 0;
            cell.valueLabel.textColor = ValueColor;
            return cell;
        }
        else if (row == InfoSectionRow_innerCode)
        {
            ScanInputCell *scanCell = [tableView dequeueReusableCellWithIdentifier:@"ScanInputCell"];
            scanCell.selectionStyle = UITableViewCellSelectionStyleNone;
            scanCell.delegate = self;
            scanCell.titleLabel.text = @"内部货号";
            scanCell.valueTextField.delegate = self;
            scanCell.lineImgView.hidden = false;
            scanCell.valueTextField.textColor = ValueColor;
           
            scanCell.valueTextField.text = self.bsItem.defaultCode;
            scanCell.valueTextField.tag = 1000*section + row;
            
            return scanCell;
        }
        else if (row == InfoSectionRow_barcode)
        {
            ScanInputCell *scanCell = [tableView dequeueReusableCellWithIdentifier:@"ScanInputCell"];
            scanCell.selectionStyle = UITableViewCellSelectionStyleNone;
            scanCell.lineImgView.hidden = true;
            scanCell.delegate = self;
            scanCell.titleLabel.text = @"条形码";
            scanCell.valueTextField.delegate = self;
            scanCell.valueTextField.textColor = ValueColor;
            scanCell.valueTextField.text = self.bsItem.barcode;
            scanCell.valueTextField.tag = 1000*section + row;
            return scanCell;
        }
    }
    else if (section == kInfoSectionFour)
    {
        MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineImgView.hidden = false;
        if (row == InfoSectionRow_canSale) {
            cell.titleLabel.text = @"可销售";
            cell.checkBoxImg.highlighted = self.bsItem.canSale;
        }
        else if (row == InfoSectionRow_canBook)
        {
            cell.titleLabel.text = @"可预约";
            cell.checkBoxImg.highlighted = self.bsItem.canBook;
        }
        else if (row == InfoSectionRow_canPurchase)
        {
            cell.titleLabel.text = @"可采购";
            cell.lineImgView.hidden = true;
            cell.checkBoxImg.highlighted = self.bsItem.canPurchase;
        }
        
        return cell;
    }
    else if (section == kInfoSectionFive)
    {
        MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineImgView.hidden = false;
        
        if (row == InfoSectionRow_onCashierSale) {
            cell.titleLabel.text = @"在收银端销售";
            cell.checkBoxImg.highlighted = self.bsItem.isSaleOnCashier;
        }
        else if (row == InfoSectionRow_onWeixinShow)
        {
            cell.titleLabel.text = @"在微信商城中展示";
            cell.checkBoxImg.highlighted = self.bsItem.isShowOnWeixin;
            
        }
        else if (row == InfoSectionRow_isTuijian)
        {
            cell.titleLabel.text = @"推荐商品";
            cell.checkBoxImg.highlighted = self.bsItem.isTuijian;
        }
        else if (row == InfoSectionRow_isMain)
        {
            cell.titleLabel.text = @"主打商品";
            cell.lineImgView.hidden = true;
            cell.checkBoxImg.highlighted = self.bsItem.isMain;
        }
        return cell;
    }
    else if (section == kInfoSectionSix)
    {
        if (row == InfoSectionRow_weikaHuodong) {
            MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.titleLabel.text = @"参与微卡活动";
            cell.checkBoxImg.highlighted = self.bsItem.isInWeikaActive;
            return cell;
        }
        else if (row == InfoSectionRow_onWeikaShow)
        {
            MemberCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCheckboxCell"];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.titleLabel.text = @"在微卡商城中展示";
            cell.checkBoxImg.highlighted = self.bsItem.isShowOnWeika;
            return cell;
        }
        else if (row == InfoSectionRow_point)
        {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lineTailingConstant = 0;
            cell.lineImgView.hidden = true;
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.text = @"多少积分可兑换";
            cell.valueTextFiled.delegate = self;
            cell.valueTextFiled.textColor = ValueColor;
            cell.valueTextFiled.text = [NSString stringWithFormat:@"%.2f",self.bsItem.exchangePoint];
            cell.valueTextFiled.tag = 1000*section + row;
            
            return cell;
        }
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionOne) {
        if (row == InfoSectionRow_pic) {
            return 90;
        }
        else if (row == InfoSectionRow_category)
        {
            return 50;
        }
        else if (row == InfoSectionRow_fuwuDate)
        {
            return 50;
        }
        
       
    }
    else if (section == kInfoSectionTwo)
    {
        
        if (row == InfoSectionRow_attributeLine) {
            CGFloat totalHeight = 0;
            if (self.bsItem.attributeLines.count > 0) {
                totalHeight  = totalHeight + self.bsItem.attributeLines.count*36 + 10;
                for (BSAttributeLine *attributeLine in self.bsItem.attributeLines) {
                    
                    totalHeight += ceilf(attributeLine.attributeValues.count/4.0)*40;
                    
                }
            }
            return totalHeight;
        }
        else
        {
           
            return 50;
        }
        
    }
    else if (section == kInfoSectionThree)
    {
        return 50;
    }
    else if (section == kInfoSectionFour)
    {
        return 50;
    }
    else if (section == kInfoSectionFive)
    {
        return 50;
    }
    else if (section == kInfoSectionSix)
    {
        return 50;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == kInfoSectionTwo)
    {
         if (self.bornCategory.code.integerValue != kPadBornCategoryProduct)
         {
             return 0.1;
         }
    }
    else if (section == kInfoSectionThree) {
        return 30;
    }
  
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kInfoSectionOne) {
        return 20;
    }
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    if (section == kInfoSectionThree) {
        UIImage *arrow = [UIImage imageNamed:@"member_triangle_left.png"];
        UIImage *arrow_h = [UIImage imageNamed:@"member_triangle_up.png"];
        UIImageView *arrowView;
        if (!expand) {
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (30 - arrow.size.height)/2.0, arrow.size.width, arrow.size.height)];
        }
        else
        {
            arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (30 - arrow.size.height)/2.0, arrow_h.size.width, arrow_h.size.height)];
        }
        arrowView.image = arrow;
        arrowView.highlightedImage = arrow_h;
        [view addSubview:arrowView];
        
        UILabel *arrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrowView.right + 10, (30-20)/2.0, 100, 20)];
        arrowLabel.backgroundColor = [UIColor clearColor];
        arrowLabel.textColor = COLOR(12, 169, 250,1);
        arrowLabel.textAlignment = NSTextAlignmentLeft;
        arrowLabel.text = @"更多信息";
        arrowLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:arrowLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(arrowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, IC_SCREEN_WIDTH, 30);
        [view addSubview:btn];
        
        arrowView.highlighted = expand;
        if (!expand) {
            arrowLabel.text = @"更多信息";
        }
        else
        {
            arrowLabel.text = @"收起";
        }
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionOne) {
        if (row != InfoSectionRow_category) {
            return;
        }
        
        ProductCategoryController *categoryController = [[ProductCategoryController alloc] init];
        categoryController.delegate = self;
        if (self.bsItem.posCategory) {
            CDProjectCategory *subCategory = self.bsItem.posCategory;
            if (subCategory.parent == nil) {
                categoryController.subCategory = nil;
                categoryController.topCategory = subCategory;
            }
            else
            {
                while (subCategory.parent.parent) {
                    subCategory = subCategory.parent;
                }
                
                categoryController.subCategory = subCategory;
                categoryController.topCategory = subCategory.parent;
            }
           
        }
        
        [self.viewController.navigationController pushViewController:categoryController animated:YES];
        
//        ProductAttributeLineController *attributeLineController = [[ProductAttributeLineController alloc] init];
//        attributeLineController.attributeLines = self.bsItem.attributeLines;
//        attributeLineController.delegate = self;
//        [self.viewController.navigationController pushViewController:attributeLineController animated:YES];
        
//        MemberSalePayViewController *salePayVC = [[MemberSalePayViewController alloc] init];
//        [self.viewController.navigationController pushViewController:salePayVC animated:YES]
    }
    else if (section == kInfoSectionTwo)
    {
        if (row == InfoSectionRow_attribute) {
            ProductAttributeLineController *attributeLineController = [[ProductAttributeLineController alloc] init];
            attributeLineController.attributeLines = self.bsItem.attributeLines;
            attributeLineController.delegate = self;
            [self.viewController.navigationController pushViewController:attributeLineController animated:YES];
        }
        else if (row == InfoSectionRow_attributePrice)
        {
            AttributePriceViewController *attributePriceVC = [[AttributePriceViewController alloc] init];
            attributePriceVC.attributeLines = self.bsItem.attributeLines;
            [self.viewController.navigationController pushViewController:attributePriceVC animated:YES];
        }
        else if (row == InfoSectionRow_attributeProductItem)
        {
            AttributeProductViewController *attributProductVC = [[AttributeProductViewController alloc] init];
            attributProductVC.projectTemplate = self.projectTemplate;
            [self.viewController.navigationController pushViewController:attributProductVC animated:YES];
        }
        return;
    }
    else if (section == kInfoSectionThree)
    {
        if (row != InfoSectionRow_onHand) {
            return;
        }
        
        OnHandViewController *onHandVC = [[OnHandViewController alloc] init];
        onHandVC.projectTemplate = self.projectTemplate;
        [self.viewController.navigationController pushViewController:onHandVC animated:YES  ];
        
    }
    else if (section == kInfoSectionFour)
    {
        return;
    }
    else if (section == kInfoSectionFive)
    {
        return;
    }
    else if (section == kInfoSectionSix)
    {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(didItemSelectedAtIndexPath:)]) {
        [self.delegate didItemSelectedAtIndexPath:indexPath];
    }
    
}

#pragma mark - arrow btn pressed
- (void)arrowBtnPressed:(UIButton *)btn
{
    expand = !expand;
    [self.tableView reloadData];
    if (expand) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:kInfoSectionFour];
        [indexSet addIndex:kInfoSectionFive];
        [indexSet addIndex:kInfoSectionSix];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - ProductPicCellDelegate
- (void)didSelectedPicBtnPressed
{
    UIActionSheet *actionSheet;
    if(!isHaveImage)
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选择", nil];
        [actionSheet showInView:self];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选择",@"删除", nil];
        [actionSheet showInView:self];
    }
}

#pragma mark - ProductAttributeLineControllerDelegate
- (void)didSelectedAttributeLines:(NSMutableArray *)attributeLines
{
    self.bsItem.attributeLines = attributeLines;
    [self resetAttributeSectionRowNum];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kInfoSectionTwo] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        if (isHaveImage)
        {
            self.bsItem.isImageEdit = YES;
            self.bsItem.projectImage = nil;

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSectionRow_pic];
            ProductPicCell *cell = (ProductPicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.picImageView.image = self.bsItem.projectImage;
    
        }
        return;
    }
    
    if (buttonIndex == 3)
    {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0)
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [[BSImagePickerManager shareManager] startImagePickerWithType:sourceType delegate:self allowEdit:false];
}




#pragma mark - BSImagePickerManagerDelegate
-(void)didSelectedImage:(UIImage *)image
{
    AlbumViewController *viewController = [[AlbumViewController alloc] initWithAlbumImage:[image orientation] delegate:self];
    [self.viewController.navigationController pushViewController:viewController animated:NO];
}


#pragma mark AlbumViewControllerDelegate Methods
- (void)didAlbumImageEditFinished:(UIImage *)image
{
    self.bsItem.isImageEdit = YES;
    self.bsItem.projectImage = image;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kInfoSectionOne inSection:InfoSectionRow_pic];
    ProductPicCell *cell = (ProductPicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.picImageView.image = self.bsItem.projectImage;
}


#pragma mark - ProductCategoryControllerDelegate
- (void)didSelectedCategory:(CDProjectCategory *)category
{
    self.bsItem.posCategory = category;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:InfoSectionRow_category inSection:kInfoSectionOne]] withRowAnimation:UITableViewRowAnimationFade];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section;
    NSInteger row;
    if (textField.tag == 101 || textField.tag == 102) {
        section = kInfoSectionOne;
        row = InfoSectionRow_pic;
        if (textField.tag == 101) {
            self.bsItem.projectName = textField.text;
        }
        else
        {
            CGFloat price = [textField.text floatValue];
            
            self.bsItem.projectPrice = price;
            textField.text = [NSString stringWithFormat:@"¥%.2f",price];
        }
    }
    else
    {
        section = textField.tag / 1000;
        row = textField.tag % 1000;
        if (section == kInfoSectionOne) {
            if (row == InfoSectionRow_fuwuDate) {
                NSInteger time = textField.text.integerValue;
                self.bsItem.fuwuTime = time;
            }
        }
        else if (section == kInfoSectionThree) {
            if (row == InfoSectionRow_cost) {
                CGFloat price = [textField.text floatValue];
                
                self.bsItem.standardPrice = price;
                
                textField.text = [NSString stringWithFormat:@"¥%.2f",price];
            }
            else if (row == InfoSectionRow_vipPrice)
            {
                CGFloat price = [textField.text floatValue];
                self.bsItem.memberPrice = price;
                textField.text = [NSString stringWithFormat:@"¥%.2f",price];
            }
            else if (row == InfoSectionRow_innerCode)
            {
                self.bsItem.defaultCode = textField.text;
            }
            else if (row == InfoSectionRow_barcode)
            {
                self.bsItem.barcode = textField.text;
            }
        }
        else if (section == kInfoSectionSix)
        {
            if (row == InfoSectionRow_point) {
                CGFloat point = [textField.text floatValue];
                self.bsItem.exchangePoint = point;
                textField.text = [NSString stringWithFormat:@"%.2f",point];
            }
        }
    }


    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    if ([self.delegate respondsToSelector:@selector(didEditTextField:atIndexPath:)]) {
        [self.delegate didEditTextField:textField atIndexPath:indexPath];
    }
}



#pragma mark - CheckBoxCellDelegate
- (void)didCheckboxSelected:(bool)selected indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == kInfoSectionFour)
    {
        if (row == InfoSectionRow_canSale) {
            self.bsItem.canSale = selected;
        }
        else if (row == InfoSectionRow_canBook)
        {
            self.bsItem.canBook = selected;
        }
        else if (row == InfoSectionRow_canPurchase)
        {
            self.bsItem.canPurchase = selected;
        }
    }
    else if (section == kInfoSectionFive)
    {
        if (row == InfoSectionRow_onCashierSale) {
            self.bsItem.isSaleOnCashier = selected;
        }
        else if (row == InfoSectionRow_onWeixinShow)
        {
            self.bsItem.isShowOnWeixin = selected;
            
        }
        else if (row == InfoSectionRow_isTuijian)
        {
            self.bsItem.isTuijian = selected;
        }
        else if (row == InfoSectionRow_isMain)
        {
            self.bsItem.isMain = selected;
        }
    }
    else if (section == kInfoSectionSix)
    {
        if (row == InfoSectionRow_weikaHuodong) {
            self.bsItem.isInWeikaActive = selected;
        }
        else if (row == InfoSectionRow_onWeikaShow)
        {
            self.bsItem.isShowOnWeika = selected;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didCheckBoxSelcted:atIndexPath:)]) {
        [self .delegate didCheckBoxSelcted:selected atIndexPath:indexPath];
    }
}

#pragma mark - ScanInputCellDelegate
- (void)didScanBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
    self.scanIndexPath = indexPath;
    
    BNScanCodeViewController *scanCodeVC = [[BNScanCodeViewController alloc] init];
    [self.viewController.navigationController pushViewController:scanCodeVC animated:YES];

}

#pragma mark - BNScanCodeDelegate
- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    if (self.scanIndexPath.section == kInfoSectionThree) {
        if (self.scanIndexPath.row == InfoSectionRow_innerCode) {
            self.bsItem.defaultCode = result;
        }
        else if (self.scanIndexPath.row == InfoSectionRow_barcode)
        {
            self.bsItem.barcode = result;
        }
        [self.tableView reloadRowsAtIndexPaths:@[self.scanIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (NSMutableDictionary *)baseInfoParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.bsItem.projectName.length == 0) {

        return nil;

    }
    
    if (self.bsItem.isImageEdit)
    {
        if (self.bsItem.projectImage != nil)
        {
            NSData *data = UIImageJPEGRepresentation(self.bsItem.projectImage, 0.2);
            NSString *imagestr = [data base64Encoding];
            [params setObject:imagestr forKey:@"image"];
        }
        else
        {
            [params setObject:[NSNumber numberWithBool:false] forKey:@"image"];
        }
    }
    
    if (self.bsItem.projectName.length > 0 && ![self.bsItem.projectName isEqualToString:self.projectTemplate.templateName])
    {
        [params setObject:self.bsItem.projectName forKey:@"name"];
    }
    
    if (fabs(self.bsItem.projectPrice - self.projectTemplate.listPrice.floatValue) > 0.001)
    {
        [params setObject:[NSNumber numberWithFloat:self.bsItem.projectPrice] forKey:@"list_price"];
    }
    
    if (self.bsItem.fuwuTime - self.projectTemplate.time.integerValue != 0) {
        [params setObject:[NSNumber numberWithInt:self.bsItem.fuwuTime] forKey:@"time"];
    }
    
    
    if (self.bsItem.posCategory.categoryID != nil && self.bsItem.posCategory.categoryID.integerValue != self.projectTemplate.category.categoryID.integerValue)
    {
        [params setObject:self.bsItem.posCategory.categoryID forKey:@"pos_categ_id"];
    }
    if (self.bsItem.projectType.length != 0 && ![self.bsItem.projectType isEqualToString:self.projectTemplate.type])
    {
        [params setObject:self.bsItem.projectType forKey:@"type"];
    }
    
    if (fabs(self.bsItem.standardPrice - self.projectTemplate.standard_price.floatValue) > 0.001) {
        [params setObject:@(self.bsItem.standardPrice) forKey:@"standard_price"];
    }
    
    if (fabs(self.bsItem.memberPrice - self.projectTemplate.memberPrice.floatValue) > 0.001) {
        [params setObject:@(self.bsItem.memberPrice) forKey:@"member_price"];
    }
    
    if (self.bsItem.barcode.length > 0 && ![self.bsItem.barcode isEqualToString:@"0"] && ![self.bsItem.barcode isEqualToString:self.projectTemplate.barcode])
    {
        [params setObject:self.bsItem.barcode forKey:@"barcode"];
    }
    if (self.bsItem.defaultCode.length > 0 && ![self.bsItem.defaultCode isEqualToString:@"0"] && ![self.bsItem.defaultCode isEqualToString:self.projectTemplate.defaultCode])
    {
        [params setObject:self.bsItem.defaultCode forKey:@"default_code"];
    }
    if (self.bsItem.isActive != self.projectTemplate.isActive.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isActive] forKey:@"active"];
    }
    if (self.bsItem.canSale != canSale)//self.projectTemplate.canSale.boolValue
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.canSale] forKey:@"sale_ok"];
    }
    if (self.bsItem.canBook != canBook)//self.projectTemplate.canBook.boolValue
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.canBook] forKey:@"book_ok"];
    }
    
    if (self.bsItem.canPurchase != canPurchase)//self.projectTemplate.canPurchase.boolValue
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.canPurchase] forKey:@"purchase_ok"];
    }
    
    if (self.bsItem.isSaleOnCashier != isSaleOnCashier)//self.projectTemplate.available_in_pos.boolValue
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isSaleOnCashier] forKey:@"available_in_pos"];
    }
    
    if (self.bsItem.isShowOnWeixin != self.projectTemplate.available_in_weixin.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isShowOnWeixin] forKey:@"available_in_weixin"];
    }
    
    if (self.bsItem.isTuijian != self.projectTemplate.is_recommend.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isTuijian] forKey:@"is_recommend"];
    }
    
    if (self.bsItem.isMain != self.projectTemplate.is_main_product.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isMain] forKey:@"is_main_product"];
    }
    
    if (self.bsItem.isInWeikaActive != self.projectTemplate.is_spread.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isInWeikaActive] forKey:@"is_spread"];
    }
    
    if (self.bsItem.isShowOnWeika != self.projectTemplate.is_show_weika.boolValue)
    {
        [params setObject:[NSNumber numberWithBool:self.bsItem.isShowOnWeika] forKey:@"is_show_weika"];
    }
    
    if (fabs(self.bsItem.exchangePoint - self.projectTemplate.exchange.floatValue) > 0.001)
    {
        [params setObject:[NSNumber numberWithFloat:self.bsItem.exchangePoint] forKey:@"exchange"];
    }
    
    
    NSArray *attributeLines = [self attributeLinePrams];
    if (attributeLines.count != 0) {
        [params setObject:attributeLines forKey:@"attribute_line_ids"];
    }
    
    return params;
}


- (NSMutableArray *)attributeLinePrams
{
    NSMutableArray *params = [NSMutableArray array];
    NSMutableArray *bsAttributeLines = [NSMutableArray arrayWithArray:self.bsItem.attributeLines];
    BOOL isTotalEdited = NO;
    if (self.type == ProductTmplateType_Edit)
    {
        for (int i = 0; i < self.projectTemplate.attributeLines.count; i++)
        {
            CDProjectAttributeLine *attributeLine = [self.projectTemplate.attributeLines objectAtIndex:i];
            BOOL isDelete = YES;
            for (int j = 0; j < bsAttributeLines.count; j++)
            {
                BSAttributeLine *bsAttributeLine = [bsAttributeLines objectAtIndex:j];
                if (bsAttributeLine.attributeLineID.integerValue != 0 && bsAttributeLine.attributeLineID.integerValue == attributeLine.attributeLineID.integerValue)
                {
                    isDelete = NO;
                    BOOL isEdited = NO;
                    if (bsAttributeLine.attributeID.integerValue != attributeLine.attributeID.integerValue || bsAttributeLine.attributeValues.count != attributeLine.attributeValues.count)
                    {
                        isEdited = YES;
                        isTotalEdited = YES;
                    }
                    else
                    {
                        for (int k = 0; k < bsAttributeLine.attributeValues.count; k++)
                        {
                            BSAttributeValue *bsAttributeValue = [bsAttributeLine.attributeValues objectAtIndex:k];
                            CDProjectAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:k];
                            if (bsAttributeValue.attributeValueID.integerValue != attributeValue.attributeValueID.integerValue)
                            {
                                isEdited = YES;
                                isTotalEdited = YES;
                            }
                        }
                    }
                    
                    if (!isEdited)
                    {
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataLinked], attributeLine.attributeLineID, [NSNumber numberWithBool:NO]]];
                    }
                    else
                    {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        if (bsAttributeLine.attributeID.integerValue != attributeLine.attributeID.integerValue)
                        {
                            [dict setObject:bsAttributeLine.attributeID forKey:@"attribute_id"];
                        }
                        
                        NSMutableArray *values = [NSMutableArray array];
                        for (int k = 0; k < bsAttributeLine.attributeValues.count; k++)
                        {
                            BSAttributeValue *attributeValue = [bsAttributeLine.attributeValues objectAtIndex:k];
                            [values addObject:attributeValue.attributeValueID];
                        }
                        NSArray *valueIds = @[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], values]];
                        [dict setObject:valueIds forKey:@"value_ids"];
                        [params addObject:@[[NSNumber numberWithInteger:kBSDataUpdate], bsAttributeLine.attributeLineID, dict]];
                    }
                    
                    [bsAttributeLines removeObject:bsAttributeLine];
                    j--;
                    
                    break;
                }
            }
            
            if (isDelete)
            {
                isTotalEdited = YES;
                [params addObject:@[[NSNumber numberWithInteger:kBSDataDelete], attributeLine.attributeLineID, [NSNumber numberWithBool:NO]]];
            }
        }
    }
    
    if (!isTotalEdited && bsAttributeLines.count == 0)
    {
        return nil;
    }
    
    for (int i = 0; i < bsAttributeLines.count; i++)
    {
        BSAttributeLine *attributeLine = [bsAttributeLines objectAtIndex:i];
        NSMutableArray *values = [NSMutableArray array];
        for (int j = 0; j < attributeLine.attributeValues.count; j++)
        {
            BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:j];
            [values addObject:attributeValue.attributeValueID];
        }
        
        NSArray *valueIds = @[@[[NSNumber numberWithInteger:kBSDataExist], [NSNumber numberWithBool:NO], values]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              attributeLine.attributeID, @"attribute_id",
                              valueIds, @"value_ids", nil];
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;
}



- (NSArray *)needSendAttributePriceRequestsTemplateID:(NSNumber *)templateID
{
    NSMutableArray *requests = [NSMutableArray array];
    for (BSAttributeLine *attributeLine in self.bsItem.attributeLines) {
        for (BSAttributeValue *attributeValue in attributeLine.attributeValues)
        {
            if (attributeValue.attributeValueExtraPrice - attributeValue.attributePrice.extraPrice.floatValue > 0.001) {
                //附加价格有更改
                BSAttributePriceCreateRequest *request = [[BSAttributePriceCreateRequest alloc] initWithTemplateID:templateID attributeValueID:attributeValue.attributeValueID extraPrice:attributeValue.attributeValueExtraPrice];
                [requests addObject:request];
            }
        }
    }
    
    return requests;
}

- (IBAction)didDeleteButtonPressed:(id)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:self.bornCategory.code forKey:@"born_category"];
    
    params[@"active"] = @(FALSE);
    BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:self.projectTemplate.templateID params:params];
    request.projectTemplate = self.projectTemplate;
    [request execute];
}

@end
