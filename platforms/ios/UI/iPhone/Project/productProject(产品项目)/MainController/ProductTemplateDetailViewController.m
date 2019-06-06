//
//  ProductTemplateDetailViewController.m
//  ds
//
//  Created by lining on 2016/10/27.
//
//

#import "ProductTemplateDetailViewController.h"
#import "IndicatorCollectionTableView.h"
#import "BSProjectTemplateCreateRequest.h"
#import "CBLoadingView.h"
#import "BSAttributePriceCreateRequest.h"
#import "ProductBaseInfoView.h"
#import "ProductCombineView.h"
#import "ProductConsumeView.h"
#import "CBMessageView.h"
#import "BNActionSheet.h"

@interface ProductTemplateDetailViewController ()<IndicatorCollectionViewDelegate,BNRightButtonItemDelegate,BNActionSheetDelegate>
@property (nonatomic, assign) ProductTmplateType type;
@property (nonatomic, strong) ProductBaseInfoView *infoView;
@property (nonatomic, strong) ProductConsumeView *consumeView;
@property (nonatomic, strong) ProductCombineView *combineView;

@property (nonatomic, strong) IndicatorCollectionTableView *indicatorCollectView;

@property (nonatomic, assign) NSInteger attributePriceReqeustCount;
@end

@implementation ProductTemplateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    BNRightButtonItem *rightBtnItem = [[BNRightButtonItem alloc] initWithTitle:@"完成"];
    rightBtnItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.navigationItem.title = self.bornCategory.bornCategoryName;
    
    if (self.projectTemplate == nil) {
        self.type = ProductTmplateType_Create;
    }
    else
    {
        self.type = ProductTmplateType_Edit;
        self.navigationItem.title = self.projectTemplate.templateName;
        CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:self.projectTemplate.bornCategory forKey:@"code"];
        self.bornCategory = bornCategory;
    }
    
    [self initView];
    
    [self registerNofitificationForMainThread:kBSProjectTemplateCreateResponse];
    [self registerNofitificationForMainThread:kBSAttributePriceCreateResponse];
    
    
}

//kPadBornCategoryAll         = 0,
//kPadBornCategoryProduct     = 1,    // 产品
//kPadBornCategoryProject     = 2,    // 项目
//kPadBornCategoryCourses     = 3,    // 疗程
//kPadBornCategoryPackage     = 4,    // 套餐
//kPadBornFreeCombination     = 5,    // 定制组合
//kPadBornCategoryPackageKit  = 6,    // 套盒
//kPadBornCategoryCustomPrice = 999,   // 定制价格
//kPadBornCategoryCardItem     = 9999  // 卡内项目

#pragma mark - initView
- (void)initView
{
    self.infoView = [ProductBaseInfoView createViewWithType:self.type bornCategory:self.bornCategory];
    
    self.infoView.projectTemplate = self.projectTemplate;
    self.infoView.viewController = self;
    
    NSInteger bornCategoryCode = self.bornCategory.code.integerValue;
    if (bornCategoryCode == kPadBornCategoryProduct)
    {
       //产品
        [self.view addSubview:self.infoView];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
    else
    {
        NSArray *titles;
        NSArray *views;
        if (bornCategoryCode == kPadBornCategoryProject)
        {
            //项目
            titles = @[@"基本信息",@"消耗品"];
            self.consumeView = [ProductConsumeView createViewWithType:self.type bornCategory:self.bornCategory];
            self.consumeView.viewController = self;
            self.consumeView.projectTemplate = self.projectTemplate;
            views = @[self.infoView,self.consumeView];
        }
        else
        {
            titles = @[@"基本信息",@"组合套"];
            self.combineView = [ProductCombineView createViewWithType:self.type bornCategory:self.bornCategory];
            self.combineView.viewController = self;
            self.combineView.projectTemplate = self.projectTemplate;
            views = @[self.infoView, self.combineView];
        }
        
        self.indicatorCollectView = [[IndicatorCollectionTableView alloc] initWithTitles:titles];
        self.indicatorCollectView.collectionView.scrollEnabled = false;
        self.indicatorCollectView.indicatorViews = views;
         self.indicatorCollectView.topStartOffset = 53;
        self.indicatorCollectView.scrollView.backgroundColor = AppThemeColor;
        [self.indicatorCollectView reloadSubViews];
        [self.view addSubview:self.indicatorCollectView];
        self.indicatorCollectView.delegate = self;
        [self.indicatorCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
}


#pragma mark - initData
- (void) initData
{
    
}

#pragma mark - receivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSProjectTemplateCreateResponse]) {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            
            NSNumber *templateID;
            if (self.type == ProductTmplateType_Edit)
            {
                templateID = self.projectTemplate.templateID;
            }
            else if (self.type == ProductTmplateType_Create)
            {
                templateID = [notification.userInfo numberValueForKey:@"TemplateID"];
            }
            
            NSArray *needSendAttributePriceRequests = [self.infoView needSendAttributePriceRequestsTemplateID:templateID];
            if (needSendAttributePriceRequests.count == 0) {
                [[CBLoadingView shareLoadingView] hide];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateEditFinish object:nil userInfo:nil];
            }
            else
            {
                self.attributePriceReqeustCount = needSendAttributePriceRequests.count;
                for (BSAttributePriceCreateRequest *reqeust in needSendAttributePriceRequests) {
                    [reqeust execute];
                }
            }
        }
        else
        {
            [[CBLoadingView shareLoadingView] hide];
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
    else if ([notification.name isEqualToString:kBSAttributePriceCreateResponse])
    {
        self.attributePriceReqeustCount --;
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            
        }
        else
        {
            NSLog(@"!!!!!!!!!!!!!!!!!!!规格附加价值修改不成功!!!!!!!!!!!!!!!!!");
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
        
        if (self.attributePriceReqeustCount == 0)
        {
            [[CBLoadingView shareLoadingView] hide];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectTemplateEditFinish object:nil userInfo:nil];
        }
    }
}

#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
  
    if ([self infoIsChanged]) {
        BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithTitle:@"信息已修改，是否保存" items:[NSArray arrayWithObjects:@"保存", @"不保存", nil] cancelTitle:LS(@"继续编辑") delegate:self];
        
        [actionSheet show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    if (![self infoIsChanged]) {
        return;
    }
    NSMutableDictionary *baseParams = [self.infoView baseInfoParams];
    if (self.infoView.bsItem.projectName.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"名称不能为空"]
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [self.indicatorCollectView indicateViewToIndex:0];
        return;
    }
//    if (baseParams == nil) {
//        
//        [self.indicatorCollectView indicateViewToIndex:0];
//        return;
//    }
    [baseParams setObject:self.bornCategory.code forKey:@"born_category"];
    
    if (self.bornCategory.code.integerValue == kPadBornCategoryProject) {
        NSArray *consumParams = [self.consumeView consumableParams];
        if (consumParams.count > 0) {
            [baseParams setObject:consumParams forKey:@"consumables_ids"];
        }
        else
        {
            if (self.consumeView.consumeArray.count == 0) {
                
            }
//            [[[CBMessageView alloc] initWithTitle:@"消耗品不能为空"] show];
//            [self.indicatorCollectView indicateViewToIndex:1];
//            return;
        }
    }
    else if (self.bornCategory.code.integerValue == kPadBornCategoryPackage || self.bornCategory.code.integerValue == kPadBornCategoryCourses || self.bornCategory.code.integerValue == kPadBornCategoryPackageKit)
    {
        NSArray *subItems = [self.combineView subItemsParams];
        if (subItems != nil && subItems.count != 0)
        {
            [baseParams setObject:subItems forKey:@"pack_line_ids"];
        }
        else
        {
            if (self.combineView.subItems.count == 0) {
                [[[CBMessageView alloc] initWithTitle:@"组合套不能为空"] show];
                [self.indicatorCollectView indicateViewToIndex:1];
                return;
            }
        }
    }
    
    if (self.type == ProductTmplateType_Create) {
        BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithParams:baseParams];
        
        [request execute];
    }
    else
    {
        BSProjectTemplateCreateRequest *request = [[BSProjectTemplateCreateRequest alloc] initWithProjectTemplateID:self.projectTemplate.templateID params:baseParams];
        
        [request execute];
    }
    [[CBLoadingView shareLoadingView] show];
}


- (BOOL)infoIsChanged
{
    NSMutableDictionary *baseParams = [self.infoView baseInfoParams];
    NSArray *consumParams = [self.consumeView consumableParams];
    NSArray *subItems = [self.combineView subItemsParams];
    if (baseParams.allKeys.count > 0 || consumParams.count > 0 || subItems.count > 0) {
        return true;
    }
    else
    {
        return false;
    }

}

#pragma mark - IndicatorCollectionViewDelegate
- (void)didSelectedIndicatorView:(IndicatorCollectionTableView *)indicatorView atIndex:(NSInteger)index
{
    NSLog(@"---");
}


#pragma mark - BNActionSheetDelegate
- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self didRightBarButtonItemClick:nil];
        }
            break;
            
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
