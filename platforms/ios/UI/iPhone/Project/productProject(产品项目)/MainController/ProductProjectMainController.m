//
//  productProjectMainController.m
//  Boss
//
//  Created by jiangfei on 16/5/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductProjectMainController.h"
#import "UIBarButtonItem+JFExtension.h"
#import "ProductTypeTitleView.h"
#import "ProductTypeColletionCell.h"
#import "BSCoreDataManager.h"
#import "CDProjectTemplate+CoreDataClass.h"
#import "MJRefresh.h"
#import "BSProjectRequest.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "ProductCategoryLeftController.h"
#import "ProductCategoryRightController.h"
#import "ProductTypeNavigationView.h"
#import "ProductTypeOneColumnCollectionCell.h"
#import "ProductTypeFlowLayout.h"
#import "ProductTypeCollectionHeadView.h"
#import "PadProjectData.h"
#import "productTypeNaviSearch.h"
#import "TemplateDetailViewController.h"
#import "BottomBtnView.h"
#import "CDProjectItem+CoreDataClass.h"
#import "BottomPayView.h"
#import "UIView+SnapShot.h"
#import "CDProjectItem+CoreDataClass.h"
#import "CDMemberCard.h"
#import "CDMemberCardProject.h"
#import "CDCouponCardProduct+CoreDataClass.h"
#import "NaviAddPopView.h"
#import "FastSaleController.h"
#import "ScanCodeSaleController.h"
#import "PadProjectData.h"
#import "PadProjectCart.h"
#import "BSProjectItemPriceRequest.h"
#import "OperateManager.h"
#import "MemberCardShopCartViewController.h"
#import "BSProjectTemplateCreateRequest.h"
#import "MemberViewController.h"
#import "CBRotateNavigationController.h"
#import "UINavigationBar+Background.h"
#import "BNScanCodeViewController.h"
#import "QRCodeView.h"
#import "MemberCardPayModeViewController.h"
#import "MemberSalePayViewController.h"
#import "MemberSaleSelectedCardViewController.h"
#import "FilterItemView.h"
#import "BSPopupArrowView.h"
#import "BSImageButton.h"

#import "ProductCategoryLeftController.h"
#import "ProductCategoryRightController.h"

#import "ProductTemplateDetailViewController.h"
#import "BSConsumable.h"
#import "BSSubItem.h"
#import "GuadanViewController.h"

#import "BSEditView.h"
#import "BSDatePickerView.h"
#import "ImportEditViewDataSource.h"
#import "BSCardItem.h"



@interface ProductProjectMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,ProductTypeNavigationViewDelegate,UIScrollViewDelegate,BottomPayViewDelegate,ProductTypeCollectionHeadViewDelegate,BNScanCodeDelegate,QRCodeViewDelegate,UIAlertViewDelegate,ProductTypeTitleViewDelegate,ProductCategoryViewDelegate,BottomBtnViewDelegate,BSEditViewDelegate>
{
    BSImageButton *titleBtn;
    BOOL cardItemSelected;
}

/** title按钮数组*/
@property (nonatomic,strong)ProductTypeTitleView *typeTitleView;

/** 左边的控制器*/
@property (nonatomic,strong)ProductCategoryLeftController *leftController;

/** layout*/
@property (nonatomic,strong)ProductTypeFlowLayout *layout;

/** leftArray*/
@property (nonatomic,strong)NSMutableArray *leftArray;
/** 右边的控制器*/
@property (nonatomic,strong)ProductCategoryRightController *rightController;
/** rightNavi*/
@property (nonatomic,strong)UINavigationController *rightNavi;
/** collectionView*/
//@property (nonatomic,weak)UICollectionView *collectionView;
/** collectionView头部控件*/
@property (nonatomic,weak)ProductTypeCollectionHeadView *collctionHeadView;
/** layout数组*/
@property (nonatomic,strong)NSMutableArray *layoutArray;
/** collectionView所有的数据*/
@property (nonatomic,strong)NSMutableArray *collectionArray;
/** collectionView当前显示在界面上的数据*/

/** 标题按钮名字数组*/
@property (nonatomic,strong)NSMutableArray *titleBtnNameArray;
/** 存放colletionView的Cell重复使用标识付*/
@property (nonatomic,strong)NSMutableArray *reuseIdArray;
/** 分类菜单view(两个tabelView)*/

/** 弹出两个tableView时的蒙版*/
@property (nonatomic,weak)UIButton *coverView;
/** 刷新控件HUD*/
@property (nonatomic,strong)MBProgressHUD *hud;
/** 商品类型*/
@property (nonatomic,strong)NSMutableArray *typeArray;
/** 记录collectionView 上一次滚动的点*/
@property (nonatomic,assign)CGPoint prePoint;
/** 记录collectionView停止拖拽时候的点*/
@property (nonatomic,assign)CGPoint stopPoint;
/** 判断当前滚动的方向*/
@property (nonatomic,assign)BOOL scrollUp;

/**  productVC要滚动的距离*/
@property (nonatomic,assign)NSInteger tagePVC;
/** alertController*/
@property (nonatomic,strong)UIAlertController *alertController;
/** 底部的结算按钮*/

/** 购物车中的商品*/
@property (nonatomic,strong)NSMutableArray *goodsArray;
/** addPopView*/
@property (nonatomic,weak)NaviAddPopView *addPopView;
/** addPopView 弹出时的蒙版*/
@property (nonatomic,weak)UIButton *coverPopView;
/** naviTitleView*/
@property (nonatomic,weak)ProductTypeNavigationView *navigationView;

@property (nonatomic, strong) NSMutableArray *cardItems;

/** 添加消耗品的Template*/
@property (nonatomic,strong)CDProjectTemplate *projectTemplate;

@property (nonatomic, assign) NSInteger topBtnIdx; //当前选中的顶部btn的索引

@property (nonatomic, assign) BOOL isPresent;
/**  searchH*/
@property (nonatomic,assign)NSUInteger searchH;

/**  contentOffset*/
@property (nonatomic,assign)CGPoint offSet;


@property (nonatomic, strong) BSPopupArrowView *popupArrowView;
@property (nonatomic, assign) BOOL isOneColumn;

@property (nonatomic, strong) NSArray *currentArray;

@property (nonatomic, strong)ProductTypeTitleView *titleView;
@property (nonatomic, strong)ProductCategoryView *productCategoryView;
@property (nonatomic, strong) BottomPayView *bottomPayView;
@property (nonatomic, strong) BottomBtnView *bottomBtnView;


@property (nonatomic, strong) NSString *filterString;

@property (nonatomic, assign) kProjectItemType projectItemType;

/** producVc*/
@property (nonatomic,strong)TemplateDetailViewController *productVc;

@property (nonatomic, strong) NSArray *bornCategoryCodes;
@property (nonatomic, strong) NSArray *catetoryIds;
@property (nonatomic, strong) CDBornCategory *bornCategory;

@property (nonatomic, strong) BSEditView *editView;
@property (nonatomic, strong) ImportEditViewDataSource *editViewDataSource;


@end



@implementation ProductProjectMainController
{
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationView];
    
    [self initView];
    
    [self registerNotification];
//    [self sendReqeust];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bottomPayView.operate = [OperateManager shareManager].posOperate;
    
}


#pragma mark - navigation bar
- (void)initNavigationView
{
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_add_n.png"] highlightedImage:[UIImage imageNamed:@"navi_add_h.png"]];
    rightButtonItem.delegate = self;
    
    if (self.controllerType == ProductControllerType_Template || self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Buy) {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }

    if (self.controllerType == ProductControllerType_Template) {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"商品" normalImageName:nil highlightImageName:nil];
    }
    else if (self.controllerType == ProductControllerType_Consume)
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"添加消耗品" normalImageName:nil highlightImageName:nil];
    }
    else if (self.controllerType == ProductControllerType_SubItem)
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"组合套" normalImageName:nil highlightImageName:nil];
    }
    else if (self.controllerType == ProductControllerType_SameItem)
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"替换项目" normalImageName:nil highlightImageName:nil];
    }
    else if (self.controllerType == ProductControllerType_Import)
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"选择项目" normalImageName:nil highlightImageName:nil];
    }
    else if (self.controllerType == ProductControllerType_Point)
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"选择商品" normalImageName:nil highlightImageName:nil];
    }
    else
    {
        titleBtn = [[BSImageButton alloc] initWithTitle:@"商品" normalImageName:@"sale_selected_member_arrow.png" highlightImageName:@"sale_selected_member_arrow.png"];
        
        titleBtn.imageStyle = ImageStyle_Right;
        [titleBtn addTarget:self action:@selector(navigationTitlePressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0, 0, 100, 44);
    self.navigationItem.titleView = titleBtn;
    
    [self reloadNavigationTitle];
}

- (void)reloadNavigationTitle
{
    if (self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Buy) {
        if ([OperateManager shareManager].posOperate.member == NULL) {
            [titleBtn setTitle:@"散客" forState:UIControlStateNormal];
        }
        else
        {
            [titleBtn setTitle:[OperateManager shareManager].posOperate.member.memberName forState:UIControlStateNormal];
        }
    }
}

#pragma mark - initView
- (void)initView
{
    //初始化collectionView
    [self initCollectionView];
    
    //arrowView
    [self initPopupArrowView];
    
    //顶部按钮view
    [self initTitleBtnView];
    
    //初始化选择subcategoryView
    [self initSubCategoryView];
    
    
    //初始化底部购物车view
    [self initBottomView];
    
    
    //初始化弹出的EidtView
    if (self.controllerType == ProductControllerType_Import) {
        [self initEidtView];
    }
}


- (void)initPopupArrowView
{
    self.popupArrowView = [BSPopupArrowView createView];
    self.popupArrowView.delegate = self;
    NSMutableArray *items = [NSMutableArray array];

    if (self.controllerType == ProductControllerType_Template) {
        
        for (CDBornCategory *category in [self bornCategorys]) {
           
            PopupItem *item = [[PopupItem alloc] init];
            item.title = category.bornCategoryName;
            [items addObject:item];
        }
    }
    else
    {
        PopupItem *item = [[PopupItem alloc] init];
        item.title = @"定制价格";
        item.imageName = @"sale_fast.png";
        [items addObject:item];
        
        item = [[PopupItem alloc] init];
        item.title = @"扫码销售";
        item.imageName = @"sale_code.png";
        [items addObject:item];
    }
    self.popupArrowView.items = items;
}


- (void)initTitleBtnView
{
    if (self.controllerType == ProductControllerType_Consume) {
        self.topViewHeightConstraint.constant = 0;
//        return;
    }
    
    if (self.controllerType == ProductControllerType_Import) {
        self.topViewHeightConstraint.constant = 0;
//        return;
    }
    
    if (self.controllerType == ProductControllerType_SubItem) {
        if (self.templateBornCategory.code.integerValue == kPadBornCategoryCourses) {
            self.topViewHeightConstraint.constant = 0;
//            return;
        }
        else if (self.templateBornCategory.code.integerValue == kPadBornCategoryPackageKit)
        {
            self.topViewHeightConstraint.constant = 0;
//            return;
        }
    }
    
    self.titleView = [[ProductTypeTitleView alloc] initWithCategorys:nil];
    self.titleView.delegate = self;
 
    [self.topView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self reloadTitleBtnView];
    self.titleView.selectedIdx = 0;
    if (self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Buy) {
        if ([OperateManager shareManager].posOperate.member) {
            self.titleView.selectedIdx = 1;
        }
    }
   
}

- (void)reloadTitleBtnView
{
    NSMutableArray *categorys = [NSMutableArray array];
    for (CDBornCategory *category in [self bornCategorys]) {
        [categorys addObject:category];
    }
    if (categorys.count == 0) {
        
    }
    else
    {
        if (self.controllerType == ProductControllerType_Buy || self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Template) {
            [categorys insertObject:@"全部" atIndex:0];
        }
        
        if ((self.controllerType == ProductControllerType_Sale||self.controllerType == ProductControllerType_Buy) && [OperateManager shareManager].posOperate.member) {
            [categorys insertObject:@"卡内项目" atIndex:1];
        }
    }
    [self.titleView reloadWithCategorys:categorys];
}


- (NSArray *)bornCategorys
{
    NSArray *categorys = [[BSCoreDataManager currentManager] fetchAllBornCategory];
    NSMutableArray *bornCategorys = [NSMutableArray array];
    for (CDBornCategory *category in categorys) {
        
        if (category.code.integerValue == kPadBornFreeCombination) {
            continue;
        }
        if (self.controllerType == ProductControllerType_Consume) {
            if (category.code.integerValue == kPadBornCategoryProduct) {
                [bornCategorys addObject:category];
            }
        }
        else if (self.controllerType == ProductControllerType_SubItem)
        {
            if (self.templateBornCategory.code.integerValue == kPadBornCategoryCourses)
            {
                if (category.code.integerValue == kPadBornCategoryProject) {
                    [bornCategorys addObject:category];
                }
            }
           
            else if (self.templateBornCategory.code.integerValue == kPadBornCategoryPackage)
            {
                if (category.code.integerValue == kPadBornCategoryProduct || category.code.integerValue == kPadBornCategoryProject) {
                    [bornCategorys addObject:category];
                }
            }
            else if (self.templateBornCategory.code.integerValue == kPadBornCategoryPackageKit)
            {
                if (category.code.integerValue == kPadBornCategoryProject) {
                    [bornCategorys addObject:category];
                }
            }
        }
        else if (self.controllerType == ProductControllerType_SameItem)
        {
            if (category.code.integerValue == kPadBornCategoryProject) {
                [bornCategorys addObject:category];
            }
        }
        else if (self.controllerType == ProductControllerType_Import)
        {
            if (category.code.integerValue == kPadBornCategoryProject) {
                [bornCategorys addObject:category];
            }
        }
        else
        {
          [bornCategorys addObject:category];
        }
    }
    return bornCategorys;
}


- (void)initSubCategoryView
{
    self.productCategoryView = [ProductCategoryView createView];
    self.productCategoryView.delegate = self;
    [self.containView addSubview:self.productCategoryView];
    [self.productCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}


- (void)initCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //注册正方形的cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductTypeColletionCell" bundle:nil] forCellWithReuseIdentifier:@"ProductTypeColletionCell"];
    
    //注册长方形的cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductTypeOneColumnCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ProductTypeOneColumnCollectionCell"];
    
    //注册headView
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProductTypeCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductTypeCollectionHeadView"];

//    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0];
    
    [self reloadData];
    
    //头部刷新控件
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendReqeust)];
    refreshHeader.lastUpdatedTimeLabel.hidden = true;
    refreshHeader.stateLabel.textColor = COLOR(136.0, 132.0, 124.0, 1.0);
    refreshHeader.arrowView.image = [UIImage imageNamed:@"arrow_refresh.png"];
    [refreshHeader setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"数据刷新中..." forState:MJRefreshStateRefreshing];
    
    
    self.collectionView.mj_header = refreshHeader;
    
    if (self.currentArray.count<1) {
        self.hud = [MBProgressHUD showMessage:@"正在加载..."];
        
        [self.collectionView.mj_header beginRefreshing];
    }
//     self.hud = [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)hideSearchBar
{
    self.collectionView.contentOffset = CGPointMake(0, 44);
}

- (void)initBottomView
{
    if (self.controllerType == ProductControllerType_Template || self.controllerType == ProductControllerType_Import || self.controllerType == ProductControllerType_Point) {
        self.bottomViewHeightConstraint.constant = 0;
        self.bottomView.hidden = true;
    }
    else
    {
        self.bottomViewHeightConstraint.constant = 52;
        self.bottomView.hidden = false;
        if (self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Buy) {
            self.bottomPayView  = [BottomPayView createView];
            self.bottomPayView.delegate = self;
            
            [self.bottomView addSubview:self.bottomPayView];
            [self.bottomPayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsZero);
            }];
        }
        else
        {
            self.bottomBtnView = [BottomBtnView createView];
            self.bottomBtnView.delegate = self;
            [self.bottomView addSubview:self.bottomBtnView];
            [self.bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsZero);
            }];
            
            if (self.controllerType == ProductControllerType_Consume) {
                NSInteger count = 0;
                for (BSConsumable *consume in self.consumeArray) {
                    count += consume.count;
                }
                
                self.bottomBtnView.count = count;
            }
        }
    }
}

- (void)initEidtView
{
    self.editViewDataSource = [[ImportEditViewDataSource alloc] init];
    self.editView = [BSEditView createViewWithDataSource:self.editViewDataSource addToView:self.view];
    self.editView.delegate = self;
}

#pragma mark - init & reload Data
- (void)setControllerType:(ProductControllerType)controllerType
{
    _controllerType = controllerType;
    if (controllerType == ProductControllerType_Sale || controllerType == ProductControllerType_Buy|| controllerType == ProductControllerType_Point) {
        self.projectItemType = kProjectItemDefault;
    }
    else if (controllerType == ProductControllerType_Consume)
    {
        self.projectItemType = kProjectItemConsumable;
    }
    else if (controllerType == ProductControllerType_SubItem)
    {
        self.projectItemType = kProjectItemSubItem;
    }
    else if (controllerType == ProductControllerType_SameItem)
    {
        self.projectItemType = kProjectItemSameItem;
    }
    else if (controllerType == ProductControllerType_Import)
    {
        self.projectItemType = kProjectItemCardItem;
    }
}


- (void)reloadData
{
    if (self.controllerType == ProductControllerType_Template) {
        self.currentArray = [[BSCoreDataManager currentManager] fetchProjectTemplatesWithBornCategorys:self.bornCategoryCodes categoryIds:self.catetoryIds keyword:self.filterString priceAscending:YES];
    }
    else
    {
        self.currentArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:self.projectItemType bornCategorys:self.bornCategoryCodes categoryIds:self.catetoryIds existItemIds:self.existsItemIds keyword:self.filterString priceAscending:YES];
    }
    
    [self.collectionView reloadData];
}


- (void)setSameItems:(NSMutableArray *)sameItems
{
    _sameItems = sameItems;
    self.sameSelectedItemDict = [NSMutableDictionary dictionary];
    for (CDProjectItem *item in self.sameItems) {
        [self.sameSelectedItemDict setObject:@(YES) forKey:item.itemID];
    }
}

#pragma mark - request & notification

- (void)sendReqeust
{
    BSProjectRequest *projectRequest = [BSProjectRequest sharedInstance];
    [projectRequest startProjectRequest];
}


- (void)registerNotification
{
    //注册通知
    [self registerNofitificationForMainThread:kBSProjectItemPriceResponse];
    [self registerNofitificationForMainThread:kChangeMemberAndCard];
    
    [self registerNofitificationForMainThread:kBSProjectRequestSuccess];
    [self registerNofitificationForMainThread:kBSProjectTemplateResponse];
    [self registerNofitificationForMainThread:kBSProjectRequestFailed];

    [self registerNofitificationForMainThread:kBSProjectTemplateCreateResponse];
    
    [self registerNofitificationForMainThread:kBSProjectTemplateEditFinish];
}



- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSProjectItemPriceResponse]) {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            NSDictionary *params = notification.userInfo;
            for (CDPosProduct *product in [OperateManager shareManager].posOperate.products)
            {
                NSNumber *price = [params objectForKey:product.product_id];
                if (price != nil)
                {
                    product.product_price = price;
                    CGFloat discount = product.product_price.floatValue/product.product.totalPrice.floatValue * 10.0;
                    product.product_discount = [NSNumber numberWithFloat:discount];
                }
            }
            
            CGFloat totalAmount = 0.0;
            for (CDPosProduct *product in [OperateManager shareManager].posOperate.products)
            {
                totalAmount += product.product_price.floatValue * product.product_qty.integerValue;
            }
            [OperateManager shareManager].posOperate.amount = [NSNumber numberWithFloat:totalAmount];
            [[BSCoreDataManager currentManager] save:nil];
            
            //            [self.projectView reloadProjectViewWithData:self.data];
            //            [self.sideView reloadProjectSideViewWithData:self.data];
            self.bottomPayView.operate = [OperateManager shareManager].posOperate;
        }
    }
    else if ([notification.name isEqualToString:kChangeMemberAndCard])
    {
        [self reloadTitleBtnView];
        [self reloadNavigationTitle];
        self.titleView.selectedIdx = 1;
        if (cardItemSelected) {
            self.currentArray = [OperateManager shareManager].cardItems;
            [self.collectionView reloadData];
        }
    }
    else if ([notification.name isEqualToString:kBSProjectRequestSuccess])
    {
        [self reloadTitleBtnView];
        [self requestScucess];
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateResponse])
    {
        
    }
    else if ([notification.name isEqualToString:kBSProjectRequestFailed])
    {
        [self requestFailed];
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateCreateResponse])
    {
        
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateEditFinish])
    {
        [self.collectionView.mj_header beginRefreshing];
    }
    
}

- (void)requestScucess
{
    [self.hud hideAnimated:YES];
    [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
        [self reloadData];
        
    }];
    
    
}

-(void)requestFailed
{
    [self.hud hideAnimated:YES];
    [self.collectionView.mj_header
     endRefreshingWithCompletionBlock:^{

     }];
    
}

#pragma mark - View Delgate

#pragma mark - 导航栏按钮事件

-(void)didItemBackButtonPressed:(UIButton*)sender
{
    if (self.controllerType == ProductControllerType_Buy || self.controllerType == ProductControllerType_Sale) {
        
        if (self.bottomPayView.gudanBtn.isEnabled) {
            if ([OperateManager shareManager].posOperate.isLocal.boolValue) {
                [[OperateManager shareManager] guaDan];
                [self pop];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"挂单请输入手牌号(可不填写)" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView show];
            }
           
        }
        else
        {
            [OperateManager shareManager].posOperate = nil;
            [self pop];
        }
    }
    else
    {
        [self pop];
    }
}

- (void)didRightBarButtonItemClick:(id)sender
{
    [self.popupArrowView showArrowView:sender];
}



- (void)navigationTitlePressed
{
    CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[PersonalProfile currentProfile].homeSelectedShopID forKey:@"storeID"];
    MemberViewController *memberVC = [[MemberViewController alloc] initWithStore:store];
    memberVC.isCashier = true;
    CBRotateNavigationController *navigationVC = [[CBRotateNavigationController alloc] initWithRootViewController:memberVC];
    [navigationVC.navigationBar setCustomizedNaviBar:true];
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
    
    if ([OperateManager shareManager].posOperate.member) {
        MemberSaleSelectedCardViewController *saleSelectdCardVC = [[MemberSaleSelectedCardViewController alloc] init];
        saleSelectdCardVC.isPopDismiss = true;
        saleSelectdCardVC.member = [OperateManager shareManager].posOperate.member;
        [navigationVC pushViewController:saleSelectdCardVC animated:NO];
    }
}

- (void)pop
{
    if (self.isFromSuccessView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - BSPopupArrowViewDelegate
- (void)didSelectedItem:(BSPopupArrowView *)popupView atIndexPath:(NSIndexPath *)indexPath
{
    if (self.controllerType == ProductControllerType_Template) {
        CDBornCategory *bornCategory = [[self bornCategorys] objectAtIndex:indexPath.row];
        
        ProductTemplateDetailViewController *templateDetailVC = [[ProductTemplateDetailViewController alloc]init];
        templateDetailVC.bornCategory = bornCategory;
        
        [self.navigationController pushViewController:templateDetailVC animated:YES];
    }
    else if (self.controllerType == ProductControllerType_Sale)
    {
        if (indexPath.row == 0) {
            NSLog(@"快速销售");
            FastSaleController *fast = [[FastSaleController alloc]init];
            [self.navigationController pushViewController:fast animated:YES];
        }
        else if (indexPath.row == 1)
        {
            NSLog(@"扫码销售");
            ScanCodeSaleController *scanCodeVC = [[ScanCodeSaleController alloc]init];
            [self.navigationController pushViewController:scanCodeVC animated:YES];
        }
    }
}

#pragma mark - ProductTypeTitleViewDelegate
- (void)didSelectedBornCategory:(CDBornCategory *)bornCategory
{
    cardItemSelected = false;
    if (bornCategory) {
        self.bornCategoryCodes = @[bornCategory.code];
        self.productCategoryView.bornCategory = bornCategory;
        [self.productCategoryView show];
    }
    else
    {
        [self.productCategoryView hide];
        self.bornCategoryCodes = nil;
    }
    self.catetoryIds = nil;
    [self reloadData];
}

- (void)didSelectedCardItem
{
    NSLog(@"卡内项目");
    cardItemSelected = true;
    self.currentArray = [OperateManager shareManager].cardItems;
    [self.collectionView reloadData];
}

#pragma mark - ProductCategoryViewDelegate

- (void)didSelectedCategoryWithCategoryIds:(NSArray *)categoryIds
{
    self.catetoryIds = categoryIds;
    [self reloadData];
}



#pragma mark - scrollView的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    NSLog(@"offset: %@",NSStringFromCGPoint(scrollView.contentOffset));
    
//    if ([scrollView isKindOfClass:[ProductTypeTitleView class]]) { //title的scrollView滚动
//       
//    }
//    else
//    {
//        CGPoint currentPoint = scrollView.contentOffset;
//        //判断是否往上面滚。
//        self.scrollUp = (self.prePoint.y < currentPoint.y);
//        self.prePoint = currentPoint;
//        
//    
//    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"%s",__FUNCTION__);
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y >0 ) {
//        offset.y = 0;
//    }
//
//    
//    [scrollView setContentOffset:offset animated:YES];
    
//    if ([scrollView isKindOfClass:[ProductTypeTitleView class]]){
//        int count = 6;
//        CGFloat width = 375.0/count;
//        int x = (int)scrollView.contentOffset.x /width;
//        CGFloat w = scrollView.contentOffset.x - width*x;
//        CGFloat maxX = self.titleBtnNameArray.count - count;
//        if (x>maxX){
//            x = self.titleBtnNameArray.count - count;
//        }
//        if (w>(width/3*1.5)){
//            x = x + 1;
//        if (x>maxX){
//            x = self.titleBtnNameArray.count - count;
//        }
//    }
//        [scrollView setContentOffset:CGPointMake(x*width, 0) animated:YES];
//        return;
//    }
//    
//    self.stopPoint = scrollView.contentOffset;
//    CGFloat y = self.searchH;
//    CGPoint zeroPoint = CGPointMake(0, 0);
//    CGPoint maxPoint = CGPointMake(0, y);
//    if (scrollView.contentOffset.y <y && scrollView.contentOffset.y >-10){
//    
//        if (self.scrollUp>0) {//往上滚
//            if (scrollView.contentOffset.y > 10) {
//                [self.collectionView setContentOffset:maxPoint animated:YES];
//            }else{
//                [self.collectionView setContentOffset:zeroPoint animated:YES];
//            }
//            
//        }else{//往下滚
//            if (scrollView.contentOffset.y >-10) {
//                NSLog(@"------");
//                [self.collectionView setContentOffset:maxPoint animated:YES];
//                
//            }else{
//                NSLog(@"+++++");
//                [self.collectionView setContentOffset:zeroPoint animated:YES];
//            }
//            
//        }
//    
//    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__FUNCTION__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOneColumn) {
        ProductTypeOneColumnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeOneColumnCollectionCell" forIndexPath:indexPath];
        cell.object = self.currentArray[indexPath.row];
        
        if (self.controllerType == ProductControllerType_SameItem) {
            CDProjectItem *item = self.currentArray[indexPath.row];
            NSNumber *selected = [self.sameSelectedItemDict objectForKey:item.itemID];
            cell.selectedLabel.hidden = !selected.boolValue;
        }
        
        return cell;
    }
    else
    {
        ProductTypeColletionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductTypeColletionCell" forIndexPath:indexPath];
        cell.object = self.currentArray[indexPath.row];
        
        if (self.controllerType == ProductControllerType_SameItem) {
            CDProjectItem *item = self.currentArray[indexPath.row];
            NSNumber *selected = [self.sameSelectedItemDict objectForKey:item.itemID];
            cell.selectedLabel.hidden = !selected.boolValue;
        }
        
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isKindOfClass:[UICollectionElementKindSectionHeader class]])
    {
        ProductTypeCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductTypeCollectionHeadView" forIndexPath:indexPath];
        headView.backgroundColor = COLOR(245, 245, 245, 1);
        headView.placeholder = @"请输入名字/内部编号";
        headView.delegate = self;

        return headView;
    }
    else
    {
        UICollectionReusableView *footView = (UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footView" forIndexPath:indexPath];
        footView.backgroundColor = [UIColor whiteColor];
        return footView;
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOneColumn) {
        return CGSizeMake(collectionView.frame.size.width, 100);
    }
    else
    {
        float width = (IC_SCREEN_WIDTH - 3*15)/2.0;
        return CGSizeMake(width, 3*width/4.0 + 28);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.isOneColumn)
    {
        return UIEdgeInsetsZero;
    }
    else
    {
        return UIEdgeInsetsMake(15, 15,15, 15);
//        return UIEdgeInsetsZero;
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){collectionView.frame.size.width,44};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    return (CGSize){ScreenWidth,22};
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSObject *object = self.currentArray[indexPath.row];
    if (self.controllerType == ProductControllerType_Template)
    {
        //正常显示
        CDProjectTemplate *template = (CDProjectTemplate *)object;
        
        ProductTemplateDetailViewController *templateDetailVC = [[ProductTemplateDetailViewController alloc] init];
        templateDetailVC.projectTemplate = template;
        [self.navigationController pushViewController:templateDetailVC animated:YES];
        
        //以前
        
//        NSInteger i = [template.bornCategory integerValue];
//        
//        if (i==6) {//套盒返回的bornCategory是6;对应数组titleBtnNameArray的最后一个元素.
//            i=5;
//        }
//        [self jumpToProductVCWithTitleName:self.titleBtnNameArray[i] offSiezX:i-1 isScrollView:NO titleArray:nil template:template];
    }
    else if (self.controllerType == ProductControllerType_Consume)
    {
        //添加消耗品
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *item = (CDProjectItem *)object;
            
            if (item.bornCategory.integerValue != kPadBornCategoryProduct) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"项目消耗品只能为产品" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            
            BOOL isExsist = false;;
            for (BSConsumable *consume in self.consumeArray) {
                if (consume.productID.integerValue == item.itemID.integerValue) {
                    consume.count++;
                    isExsist = true;
                    break;
                }
            }
            
            if (!isExsist) {
                BSConsumable *consume = [[BSConsumable alloc] init];
                consume.productID = item.itemID;
                consume.productName = item.itemName;
                consume.projectItem = item;
                
                consume.uomID = item.uomID;
                consume.uomName = item.uomName;
                
                consume.amount = item.totalPrice.floatValue;
                consume.count = 1;
                
                [self.consumeArray addObject:consume];
            }
            [self screenCartView:cell toRect:CGRectMake(20, self.view.frame.size.height - 20, 20.0, 20.0)];
            
            NSInteger count = 0;
            for (BSConsumable *consume in self.consumeArray) {
                count += consume.count;
            }
            
            self.bottomBtnView.count = count;
        }
        else
        {
            
        }
        NSLog(@"添加消耗品");
    }
    else if (self.controllerType == ProductControllerType_SubItem)
    {
        //添加组合套
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *item = (CDProjectItem *)object;
            
            if (self.templateBornCategory.code.integerValue == kPadBornCategoryCourses) {
                if (item.bornCategory.integerValue != kPadBornCategoryProduct && item.bornCategory.integerValue != kPadBornCategoryProject) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"疗程组合套里只能为项目" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            else if (self.templateBornCategory.code.integerValue == kPadBornCategoryPackage)
            {
                if (item.bornCategory.integerValue != kPadBornCategoryProduct && item.bornCategory.integerValue != kPadBornCategoryProject && item.bornCategory.integerValue != kPadBornCategoryCourses) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"套餐和套盒的组合套里只能为产品、项目" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            else if (self.templateBornCategory.code.integerValue == kPadBornCategoryPackageKit)
            {
                if (item.bornCategory.integerValue != kPadBornCategoryProduct && item.bornCategory.integerValue != kPadBornCategoryProject && item.bornCategory.integerValue != kPadBornCategoryCourses) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"套餐和套盒的组合套里只能为项目" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            
            BOOL isExsist = false;
            for (BSSubItem *subItem in self.subItems) {
                if (subItem.itemID.integerValue == item.itemID.integerValue) {
                    subItem.count++;
                    isExsist = true;
                    break;
                }
            }
            if (!isExsist) {
                BSSubItem *subItem = [[BSSubItem alloc] init];
                subItem.itemID = item.itemID;
                subItem.itemName = item.itemName;
                subItem.projectItem = item;
                subItem.itemPrice = item.totalPrice.floatValue;
                subItem.itemSetPrice = item.totalPrice.floatValue;
                subItem.projectType = item.projectTemplate.bornCategory.integerValue;
                subItem.count = 1;
                subItem.sameItems = [NSMutableArray array];
                [self.subItems addObject:subItem];
            }
            [self screenCartView:cell toRect:CGRectMake(20, self.view.frame.size.height - 20, 20.0, 20.0)];
            
            NSInteger count = 0;
            for (BSSubItem *subItem in self.subItems) {
                count += subItem.count;
            }
            
            self.bottomBtnView.count = count;
        }
        else
        {
            
        }
        NSLog(@"添加组合套");
    }
    else if (self.controllerType == ProductControllerType_SameItem)
    {
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *item = (CDProjectItem *)object;
            NSNumber* selected = [self.sameSelectedItemDict objectForKey:item.itemID];
            if (selected.boolValue) {
                [self.sameSelectedItemDict removeObjectForKey:item.itemID];
                [self.sameItems removeObject:item];
            }
            else
            {
                [self.sameSelectedItemDict setObject:@(YES) forKey:item.itemID];
                [self.sameItems addObject:item];
            }
            self.bottomBtnView.count = self.sameItems.count;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
       
    }
    else if (self.controllerType == ProductControllerType_Import)
    {
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *item = (CDProjectItem *)object;
            BSCardItem *cardItem = [[BSCardItem alloc] init];
            cardItem.productID = item.itemID;
            cardItem.productName = item.itemName;
            cardItem.productPrice = item.totalPrice.floatValue;
            cardItem.unitPrice = item.totalPrice.floatValue;
            
            self.editView.editObject = cardItem;
            [self.editView show];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardItemSelectFinish object:item];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else if (self.controllerType == ProductControllerType_Point)
    {
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *item = (CDProjectItem *)object;
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSPointItemSelectFinish object:item];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.controllerType == ProductControllerType_Buy || self.controllerType == ProductControllerType_Sale)
    {
        //购买
        if ([object isKindOfClass:[CDProjectItem class]] )
        {
            CDProjectItem *product = (CDProjectItem *)object;
            if (product.bornCategory.integerValue == kPadBornCategoryCourses || product.bornCategory.integerValue == kPadBornCategoryPackage || product.bornCategory.integerValue == kPadBornCategoryPackageKit) {
                if ([OperateManager shareManager].posOperate.member == nil || [OperateManager shareManager].posOperate.member.isDefaultCustomer.boolValue)
                {
                    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"散客无法购买疗程和套餐，请点击顶部选择一位会员" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                    return;
                }
                else
                {
                    if ([OperateManager shareManager].posOperate.memberCard == nil) {
                        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"购买疗程和套餐需要会员的一张会员卡，请点击顶部选择会员卡" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                        return;
                    }
                }
                
            }
        }
        
        [self screenCartView:cell toRect:CGRectMake(20, self.view.frame.size.height - 20, 20.0, 20.0)];
        //加入购物车
        [self addObjectToCart:object];
        //选择卡内项目时刷新界面（数量）re
        if (cardItemSelected) {
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }

    
}


- (void)screenCartView:(UIView*)shotView toRect:(CGRect)toRect
{
    CGRect rect = [self.view convertRect:shotView.bounds fromView:shotView];
    UIView *snapshot = [shotView snapshot];
    snapshot.alpha = 1.0;
    snapshot.layer.shadowRadius = 4.0;
    snapshot.layer.shadowOpacity = 0.0;
    snapshot.layer.shadowOffset = CGSizeZero;
    snapshot.layer.shadowPath = [[UIBezierPath bezierPathWithRect:snapshot.layer.bounds] CGPath];
    snapshot.frame = rect;
    [self.view insertSubview:snapshot belowSubview:self.self.bottomView];
    [UIView animateWithDuration:0.4 animations:^{
        snapshot.frame = toRect;
    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
    }];
}


#pragma mark - ProductTypeCollectionHeadViewDelegate
- (void)didSearchWithString:(NSString *)string
{
    if (cardItemSelected) {
        self.currentArray = [OperateManager shareManager].cardItems;
        if (string.length > 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i=0; i<self.currentArray.count; i++) {
                
                CDProjectTemplate *template = self.currentArray[i];
                if ([template.templateName containsString:string]) {
                    [tempArray addObject:template];
                }
            }
            self.currentArray = tempArray;
            [self.collectionView reloadData];
        }
    }
    else
    {
        self.filterString = string;
        [self reloadData];
    }
   
   

    
}

- (void)didChangeBtnPressed:(BOOL)isOneColumn
{
    self.isOneColumn = isOneColumn;
    [self.collectionView reloadData];
}

- (void)didScanBtnPressed
{
    BNScanCodeViewController *viewController = [[BNScanCodeViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark BNScanCodeDelegate Methods
- (void)scanCodeViewController:(BNScanCodeViewController *)viewController didScanSuccess:(NSString *)result
{
    NSLog(@"----%@",result);
    self.filterString = result;
    [self reloadData];
}

#pragma mark QRCodeViewDelegate Methods

- (void)didQRBackButtonClick:(QRCodeView *)qrCodeView
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}



- (void)setUpNavi
{
    self.navigationView.imageHide = (self.controllerType == ProductControllerType_Sale || self.controllerType == ProductControllerType_Buy)? NO:YES;
    [self.view addSubview:self.navigationView];
    
    [self reloadNavigationTitle];
}

#pragma mark - BSEditViewDelegate
- (void)didRightBtnPressed:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSCardItemSelectFinish object:object];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BottomBtnViewDelegate
- (void)didSureBtnPressed
{
    if (self.controllerType == ProductControllerType_Consume) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAddConsumeProductDone" object:nil];
    }
    else if (self.controllerType == ProductControllerType_SubItem)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAddSubItemDone" object:nil];
    }
    else if (self.controllerType == ProductControllerType_SameItem)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAddSameItemDone" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 结算 & 挂单 代理 bottomPayViewDelegate
- (void)didGuaDanOperate:(CDPosOperate *)operate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入手牌号(可不填写)" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)didPayOperate:(CDPosOperate *)operate
{
    NSLog(@"结算");
    
    
    MemberSalePayViewController *memberSalePayVC = [[MemberSalePayViewController alloc] init];
    memberSalePayVC.operateManager = [OperateManager shareManager];
    [self.navigationController pushViewController:memberSalePayVC animated:YES];
}

- (void)didShopCartOperate:(CDPosOperate *)operate
{
    NSLog(@"购物车");
    [self pushToShopCartViewController];
}

- (void)pushToShopCartViewController
{
    MemberCardShopCartViewController *shopCartVC = [[MemberCardShopCartViewController alloc] init];
    shopCartVC.operateManager = [OperateManager shareManager];
    [self.navigationController pushViewController:shopCartVC animated:YES];
}

#pragma mark - 往购物车加东西
- (void)addObjectToCart:(NSObject *)object
{
    CDProjectItem *item;
    if ([object isKindOfClass:[CDProjectItem class]])
    {
        item = (CDProjectItem *)object;
    }
    else if ([object isKindOfClass:[PadProjectCart class]])
    {
        PadProjectCart *cart = (PadProjectCart *)object;
        item = cart.item;
    }
    else if ([object isKindOfClass:[CDMemberCardProject class]])
    {
        CDMemberCardProject *cardProject = (CDMemberCardProject *)object;
        item = cardProject.item;
    }
    else if ([object isKindOfClass:[CDCouponCardProduct class]])
    {
        CDCouponCardProduct *coupon = (CDCouponCardProduct *)object;
        item = coupon.item;
    }
    
    [[OperateManager shareManager] addObject:object];
    
    if (![OperateManager shareManager].posOperate.member.isDefaultCustomer.boolValue && [OperateManager shareManager].posOperate.memberCard.priceList.priceID.integerValue != 0)
    {
        BSProjectItemPriceRequest *request = [[BSProjectItemPriceRequest alloc] initWithProjectIds:@[item.itemID] priceListId:[OperateManager shareManager].posOperate.memberCard.priceList.priceID];
        [request execute];
    }
    
    self.bottomPayView.operate = [OperateManager shareManager].posOperate;
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        return;
    }
    else
    {
        [OperateManager shareManager].posOperate.handno = [alertView textFieldAtIndex:0].text;
    }
//    NSLog(@"text: %@ - idx: %d",[alertView textFieldAtIndex:0].text,buttonIndex);
    
    
    NSLog(@"挂单");
    [[OperateManager shareManager] guaDan];
    [self pop];
    
    
//    [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:[[UIViewController alloc]init] animated:NO];
}

@end
