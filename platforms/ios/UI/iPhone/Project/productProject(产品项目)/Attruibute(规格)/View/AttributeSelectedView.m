//
//  AttributeSelectedView.m
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import "AttributeSelectedView.h"
#import "AttributeBtnCell.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "BSAttributeValue.h"
#import "BSAttributeCreateRequest.h"
#import "BSAttributeValueCreateRequest.h"

@interface AttributeSelectedView ()<UICollectionViewDataSource,UICollectionViewDelegate,AttributeBtnCellDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *attributes;
@property (strong, nonatomic) NSMutableArray *selectedAttributes;
@property (strong, nonatomic) NSMutableArray *selectedAttributeValues;
@property (strong, nonatomic) NSMutableDictionary *selectedDict;
@property (assign, nonatomic) AttributeStyle style;
@property (strong, nonatomic) CDProjectAttribute *attribute;
@property (strong, nonatomic) NSArray *attributeValues;
@end

@implementation AttributeSelectedView

+ (instancetype)createView
{
    AttributeSelectedView *selectedView = [self loadFromNib];
    [[UIApplication sharedApplication].keyWindow addSubview:selectedView];
    [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    return selectedView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = true;
    
    self.hidden = true;
    self.bgBtn.alpha = 0.0;
    self.containerView.alpha = 0.0;
    
    
    self.valueTextField.returnKeyType = UIReturnKeyDone;
    self.valueTextField.delegate = self;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AttributeBtnCell" bundle:nil] forCellWithReuseIdentifier:@"AttributeBtnCell"];
    
    
    self.tipLabel.text = @"单击选中或取消";
    
    
    [self registerNofitificationForMainThread:kBSAttributeCreateResponse];
    [self registerNofitificationForMainThread:kBSAttributeValueCreateResponse];
}

- (void)setNotShowAttributeIDs:(NSArray *)notShowAttributeIDs
{
    _notShowAttributeIDs = notShowAttributeIDs;
    
    self.style = AttributeStyle_attribute;
    self.selectedAttributes = [NSMutableArray array];
    self.selectedDict = [NSMutableDictionary dictionary];
    [self reloadData];
    [self.collectionView reloadData];
}


- (void)setAttributeLine:(BSAttributeLine *)attributeLine
{
    _attributeLine = attributeLine;
    self.selectedAttributeValues = [NSMutableArray array];
    self.selectedDict = [NSMutableDictionary dictionary];
    self.style = AttributeStyle_attributeValue;
    [self reloadData];
    [self.collectionView reloadData];
}

- (void)reloadData
{
    if (self.style == AttributeStyle_attribute) {
        self.titleLabel.text = @"属性";
        self.valueTextField.placeholder = @"请输入属性";
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchAllProjectAttribute]];
        for (int i = 0; i < self.notShowAttributeIDs.count; i++) {
            NSNumber *attributeId = [self.notShowAttributeIDs objectAtIndex:i];
            CDProjectAttribute *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:attributeId forKey:@"attributeID"];
            [mutableArray removeObject:attribute];
        }
        self.attributes = mutableArray;
    }
    else if (self.style == AttributeStyle_attributeValue)
    {

        NSNumber *attributeId = self.attributeLine.attributeID;
        self.attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:attributeId forKey:@"attributeID"];
        
        self.titleLabel.text = self.attribute.attributeName;
        self.valueTextField.placeholder = [NSString stringWithFormat:@"请输入属性值"];
        NSMutableArray *values = [NSMutableArray arrayWithArray:self.attribute.attributeValues.array];
        for (int i = 0; i < self.attributeLine.attributeValues.count; i++)
        {
            BSAttributeValue *attributeValue = [self.attributeLine.attributeValues objectAtIndex:i];
            CDProjectAttributeValue *value = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttributeValue" withValue:attributeValue.attributeValueID forKey:@"attributeValueID"];
            [values removeObject:value];
        }
        
        self.attributeValues = values;

    }
}

#pragma mark - show & hide
- (void)show
{
    self.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 0.6;
        self.containerView.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 0.0;
        self.containerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = true;
    }];
    
    [self.valueTextField resignFirstResponder];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.style == AttributeStyle_attribute) {
        return self.attributes.count;
    }
    else
    {
        return self.attributeValues.count;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttributeBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeBtnCell" forIndexPath:indexPath];
    cell.normalImageName = @"attribute_rect_gray.png";
    cell.selectedImageName = @"attribute_solid_blue.png";
    cell.normalColor = COLOR(150, 150, 150, 1);
    cell.selectedColor = COLOR(255, 255, 255, 1);
    cell.longPressedDelete = false;
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.deleteBtnShow = false;
    if (self.style == AttributeStyle_attribute) {
        CDProjectAttribute *attribute = [self.attributes objectAtIndex:indexPath.row];
        cell.title = attribute.attributeName;
        cell.object = attribute;
        NSNumber *selected = [self.selectedDict objectForKey:attribute.attributeID];
        cell.btnSelected = selected.boolValue;
    }
    else if (self.style == AttributeStyle_attributeValue)
    {
        CDProjectAttributeValue *attributeValue = [self.attributeValues objectAtIndex:indexPath.row];
        cell.title = attributeValue.attributeValueName;
        cell.object = attributeValue;
        NSNumber *selected = [self.selectedDict objectForKey:attributeValue.attributeValueID];
        cell.btnSelected = selected.boolValue;
    }
    
    
   
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.containerView.frame.size.width - 20)/3, 45);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10,5,10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){collectionView.frame.size.width,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //    return (CGSize){ScreenWidth,22};
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadData];
    [self.collectionView reloadData];
}


#pragma mark - AttributeBtnCellDelegate
- (void)didBtnSelected:(BOOL)selected object:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.style == AttributeStyle_attribute) {
        CDProjectAttribute *attribute = (CDProjectAttribute *)object;
        [self.selectedDict setObject:@(selected) forKey:attribute.attributeID];
        if (selected) {
            [self.selectedAttributes addObject:attribute];
        }
        else
        {
            [self.selectedAttributes removeObject:attribute];
        }
    }
    else if (self.style == AttributeStyle_attributeValue)
    {
        CDProjectAttributeValue *attributeValue = (CDProjectAttributeValue *)object;
        [self.selectedDict setObject:@(selected) forKey:attributeValue.attributeValueID];
        if (selected) {
            [self.selectedAttributeValues addObject:attributeValue];
        }
        else
        {
            [self.selectedAttributeValues removeObject:attributeValue];
        }
    }
    
}

- (void)didLongPressedObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didDeleteBtnPressedObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.style == AttributeStyle_attribute) {
//        CDProjectAttribute *attribute = (CDProjectAttribute *)object;
        
    }
    else if (self.style == AttributeStyle_attributeValue)
    {
//        CDProjectAttributeValue *attributeValue = (CDProjectAttributeValue *)object;
    }
    

}

#pragma mark - btn action
- (IBAction)addBtnPressed:(id)sender {
    [self.valueTextField resignFirstResponder];
    if (self.style == AttributeStyle_attribute) {
        [self sendCreateAttributeRequest];
    }
    else if (self.style == AttributeStyle_attributeValue)
    {
        [self sendCreateAttributeValueRequest];
    }
}

- (IBAction)sureBtnPressed:(id)sender {
    [self hide];
    if (self.style == AttributeStyle_attribute) {
        if ([self.delegate respondsToSelector:@selector(didSureBtnPressedWithAttributes:)]) {
            [self.delegate didSureBtnPressedWithAttributes:self.selectedAttributes];
        }
    }
    else if (self.style == AttributeStyle_attributeValue)
    {
        for (CDProjectAttributeValue *attributeValue in self.selectedAttributeValues) {
            BSAttributeValue *bsAttributeValue = [[BSAttributeValue alloc] init];
            bsAttributeValue.attributeValueID = attributeValue.attributeValueID;
            bsAttributeValue.attributeValueName = attributeValue.attributeValueName;
            bsAttributeValue.attributeLine = self.attributeLine;
            [self.attributeLine.attributeValues addObject:bsAttributeValue];
        }
        if ([self.delegate respondsToSelector:@selector(didSureBtnPressedWithAttributeValues:)]) {
            [self.delegate didSureBtnPressedWithAttributeValues:self.selectedAttributeValues];
        }
    }
}
- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - sendRequest
- (void)sendCreateAttributeRequest
{
    if (self.valueTextField.text.length == 0)
    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
        //                                                            message:LS(@"AttributeNameCanNotBeNULL")
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
        //                                                  otherButtonTitles:nil, nil];
        //        [alertView show];
        [[[CBMessageView alloc] initWithTitle:@"属性不能为空"] show];
        return;
    }
    
    CDProjectAttribute *attribute = [[BSCoreDataManager currentManager] findEntity:@"CDProjectAttribute" withValue:self.valueTextField.text forKey:@"attributeName"];
    if (attribute)
    {
        NSString *message = [NSString stringWithFormat:@"属性%@已经存在",self.valueTextField.text];
        [[[CBMessageView alloc] initWithTitle:message] show];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
        //                                                            message:@"属性已存在"
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
        //                                                  otherButtonTitles:nil, nil];
        //        [alertView show];
        return;
    }
    
    BSAttributeCreateRequest *request = [[BSAttributeCreateRequest alloc] initWithAttributeName:self.valueTextField.text];
    [request execute];
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)sendCreateAttributeValueRequest
{
    if (self.valueTextField.text.length == 0)
    {
         [[[CBMessageView alloc] initWithTitle:@"属性不能为空"] show];
        
        return;
    }
    
    [[CBLoadingView shareLoadingView] show];
    BSAttributeValueCreateRequest *request = [[BSAttributeValueCreateRequest alloc] initWithAttribute:self.attribute attributeValueName:self.valueTextField.text];
    [request execute];

}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [[CBLoadingView shareLoadingView] hide];
    if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
    {
        self.valueTextField.text = @"";
        [self reloadData];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    else
    {
        NSString *message = [notification.userInfo stringValueForKey:@"rm"];
        if(message.length != 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }

    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
