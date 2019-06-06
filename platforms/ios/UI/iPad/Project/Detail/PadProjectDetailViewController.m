//
//  PadProjectDetailViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/11/4.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectDetailViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "BSFetchStaffRequest.h"
#import "BSHandleBookRequest.h"
#import "PadProjectYimeiBuweiTableViewCell.h"
#import "PadProjectYimeiBuweiPhotoViewController.h"
#import "UIViewController+MMDrawerController.h"

typedef enum kProjectDetailSectionType
{
    kProjectDetailSectionItem           = 0,
    kProjectDetailSectionAmount         = 1,
    kProjectDetailNOReserveCount        = 2,
    kProjectDetailPointDiscount        = 3,
    kProjectDetailcouponDiscount        = 4,

    kProjectSubRelatedItems             = 2,
    kProjectSubRelatedCount             = 5,
    
    kProjectDetailSectionTechnician     = 2,
    kProjectDetailSectionAppointment    = 3,
    kProjectDetailSectionCount          = 4,
    
    kProjectYimeiSectionBuwei          = 4,
    kProjectYimeiSectionCount          = 4,
    
    kProjectYimeiPointDiscount         = 2,
    kProjectYimeicouponDiscount        = 3
    
}kProjectDetailSectionType;

@interface PadProjectDetailViewController ()<PadProjectYimeiBuweiTableViewCellDelegate,PadProjectYimeiBuweiPhotoViewControllerDelegate>
{
    BOOL isAnimation;
    BOOL isTechnician;
    BOOL isAppointment;
}

@property (nonatomic, strong) CDPosProduct *product;
@property (nonatomic, strong) CDCurrentUseItem *useItem;
@property (nonatomic, strong) CDProjectItem *projectItem;
@property (nonatomic, assign) kPadProjectDetailType type;
@property (nonatomic, strong) NSArray *technicians;
@property (nonatomic, strong) NSString *contentstr;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) CGFloat discount;
@property (nonatomic, strong) CDStaff *technician;
@property (nonatomic, strong) NSDate *appointment;

@property (nonatomic, assign) CGFloat returnAmount;
@property (nonatomic, strong) BSReturnItem *returnItem;

@property (nonatomic, strong) UILabel *naviLabel;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UITextView* remarkTextField;

@property (nonatomic, assign) CGFloat pointDiscount;
@property (nonatomic, assign) CGFloat point2Money;
@property (nonatomic, assign) CGFloat couponDiscount;
@property (nonatomic, assign) NSInteger *couponID;

@end

@implementation PadProjectDetailViewController

- (id)initWithUseItem:(CDCurrentUseItem *)useItem
{
    self = [super initWithNibName:@"PadProjectDetailViewController" bundle:nil];
    if (self)
    {
        self.type = kPadProjectDetailUseItem;
        self.useItem = useItem;
        self.projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.useItem.itemID forKey:@"itemID"];
        self.quantity = self.useItem.useCount.integerValue;
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if (self.useItem.book.technician_id.integerValue != 0)
            {
                self.technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.useItem.book.technician_id forKey:@"staffID"];
                if (self.technician)
                {
                    self.technician = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
                    self.technician.staffID = self.useItem.book.technician_id;
                    self.technician.name = self.useItem.book.technician_name;
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.appointment = [dateFormatter dateFromString:self.product.book.start_date];
        }
    }
    
    return self;
}

- (id)initWithProjectItem:(CDProjectItem *)item quantity:(NSInteger)quantity
{
    self = [super initWithNibName:@"PadProjectDetailViewController" bundle:nil];
    if (self)
    {
        self.type = kPadProjectDetailProjectItem;
        self.projectItem = item;
        self.quantity = quantity;
        self.discount = 10.0;
        self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity;
    }
    
    return self;
}

- (id)initWithPosProduct:(CDPosProduct *)product detailType:(kPadProjectDetailType)type
{
    self = [super initWithNibName:@"PadProjectDetailViewController" bundle:nil];
    if (self)
    {
        self.type = type;
        self.product = product;
        //self.couponCard = product.operate.couponCard;
        self.quantity = self.product.product_qty.integerValue;
        self.totalPrice = self.product.product_price.floatValue * self.quantity;
        self.discount = (self.product.product_discount == nil || product.product_discount.floatValue == 0) ? 10.0 : product.product_discount.floatValue;
        self.projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:self.product.product_id forKey:@"itemID"];
        self.memberCard = product.operate.memberCard;
        if (self.memberCard != nil)
        {
            self.point2Money = self.memberCard.priceList.points2Money.floatValue;
            if(self.point2Money == 0 || isnan(self.point2Money) || isinf(self.point2Money))
            {
                self.pointDiscount = 0.0;
            }
        }
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if (self.product.book.technician_id.integerValue != 0)
            {
                self.technician = [[BSCoreDataManager currentManager] findEntity:@"CDStaff" withValue:self.product.book.technician_id forKey:@"staffID"];
                if (self.technician)
                {
                    self.technician = [[BSCoreDataManager currentManager] insertEntity:@"CDStaff"];
                    self.technician.staffID = self.product.book.technician_id;
                    self.technician.name = self.product.book.technician_name;
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.appointment = [dateFormatter dateFromString:self.product.book.start_date];
        }
    }
    
    return self;
}

- (id)initWithReturnItem:(BSReturnItem *)returnItem
{
    self = [super initWithNibName:@"PadProjectDetailViewController" bundle:nil];
    if (self)
    {
        self.type = kPadProjectDetailReturnItem;
        self.returnItem = returnItem;
        self.quantity = self.returnItem.returnCount;
        self.returnAmount = self.returnItem.returnAmount;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSCreateBookResponse];
    [self registerNofitificationForMainThread:kBSEditBookResponse];
    [self registerNofitificationForMainThread:kBSDeleteBookResponse];
    [self registerNofitificationForMainThread:kPadSelectMemberAndCardFinish];
    
    self.technicians = [[BSCoreDataManager currentManager] fetchBookStaffs];
    //BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
    //[request execute];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0) style:UITableViewStylePlain];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.backgroundColor = [UIColor clearColor];
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.showsHorizontalScrollIndicator = NO;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 28.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.detailTableView.tableFooterView = footerView;
    [self.view addSubview:self.detailTableView];
    
    CGFloat originY = self.view.frame.size.height - 32.0 - 60.0 - 32.0;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, self.view.frame.size.width, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.view addSubview:lineImageView];
    originY += 32.0;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor clearColor];
    deleteButton.frame = CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0);
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [deleteButton setTitle:LS(@"PadDeleteButton") forState:UIControlStateNormal];
    [deleteButton setTitleColor:COLOR(96.0, 211.0, 212.0, 1.0) forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_item_delete_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"pad_item_delete_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    [self initNaviBar];
    
    [self setFooter];
    
    [self.detailTableView registerNib:[UINib nibWithNibName:@"PadProjectYimeiBuweiTableViewCell" bundle:nil] forCellReuseIdentifier:@"PadProjectYimeiBuweiTableViewCell"];
    if (self.product.coupon_id.integerValue != 0 && self.couponCard == nil)
    {
        self.couponCard = [[BSCoreDataManager currentManager] fetchCouponCardWithIds:@[self.product.coupon_id]][0];
    }
    self.couponDiscount = self.product.coupon_deduction.floatValue;
    if (self.point2Money > 0)
    {
        self.pointDiscount = self.product.point_deduction.floatValue/self.point2Money;
    }
    if(isnan(self.pointDiscount)||isinf(self.pointDiscount))
    {
        self.pointDiscount = 0.0;
    }
    self.needRefreshCoupon = YES;
}

- (void)setFooter
{
    return;
    
    if ( ![[PersonalProfile currentProfile].isYiMei boolValue] )
        return;
    
    if ( [self.projectItem.bornCategory integerValue] != kPadBornCategoryProject )
        return;
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 250)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 30, 100, 20)];
    label.text = @"自定义部位";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 60, kPadMaskViewContentWidth, 180)];
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 2;
    textField.layer.masksToBounds = TRUE;
    [bgView addSubview:textField];
    self.remarkTextField = textField;
    
    self.detailTableView.tableFooterView = bgView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.detailTableView reloadData];
}

- (void)initNaviBar
{
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_back_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    self.naviLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    self.naviLabel.backgroundColor = [UIColor clearColor];
    self.naviLabel.textAlignment = NSTextAlignmentCenter;
    self.naviLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.naviLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [navi addSubview:self.naviLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(self.view.frame.size.width - 90.0, 0.0, 90.0, kPadNaviHeight);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadConfirmButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:confirmButton];
    
    [self reloadNaviTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchStaffResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.technicians = [[BSCoreDataManager currentManager] fetchBookStaffs];
            if (isTechnician)
            {
                [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectDetailSectionTechnician] withRowAnimation:UITableViewRowAnimationNone];
            }
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
    else if ([notification.name isEqualToString:kBSCreateBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            CDBook *book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:notification.object forKey:@"book_id"];
            book.isUsed = [NSNumber numberWithBool:YES];
            //
            //            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
            //            request.type = HandleBookType_billed;
            //            [request execute];
            
            if (self.type == kPadProjectDetailUseItem)
            {
                self.useItem.book = book;
            }
            else if (self.type == kPadProjectDetailCurrentCashier)
            {
                self.product.book = book;
            }
            [self didPadProjectDetailEditFinish];
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
    else if ([notification.name isEqualToString:kBSEditBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            if (self.type == kPadProjectDetailUseItem)
            {
                self.useItem.book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:self.useItem.book.book_id forKey:@"book_id"];
                self.useItem.book.isUsed = [NSNumber numberWithBool:YES];
                
                //                BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:self.useItem.book];
                //                request.type = HandleBookType_billed;
                //                [request execute];
            }
            else if (self.type == kPadProjectDetailCurrentCashier)
            {
                self.product.book = [[BSCoreDataManager currentManager] findEntity:@"CDBook" withValue:self.product.book.book_id forKey:@"book_id"];
                self.product.book.isUsed = [NSNumber numberWithBool:YES];
                
                //                BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:self.product.book];
                //                request.type = HandleBookType_billed;
                //                [request execute];
            }
            [self didPadProjectDetailEditFinish];
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
    else if ([notification.name isEqualToString:kBSDeleteBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            if (self.type == kPadProjectDetailUseItem)
            {
                self.useItem.book = nil;
            }
            else if (self.type == kPadProjectDetailCurrentCashier)
            {
                self.product.book = nil;
            }
            [self didPadProjectDetailEditFinish];
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
    else if ([notification.name isEqualToString:kPadSelectMemberAndCardFinish])
    {
        CDMember *member = (CDMember *)[notification.userInfo objectForKey:@"member"];
        CDMemberCard *memberCard = (CDMemberCard *)[notification.userInfo objectForKey:@"card"];
        CDCouponCard *couponCard = (CDCouponCard *)[notification.userInfo objectForKey:@"coupon"];
        self.member = member;
        self.memberCard = memberCard;
        if (couponCard != nil)
        {
            self.couponID = couponCard.cardID.integerValue;
            self.couponCard = [[BSCoreDataManager currentManager] fetchCouponCardWithIds:@[[NSNumber numberWithInteger:self.couponID]]][0];
        }
        //self.couponDiscount = couponCard.remainAmount.floatValue;
        [self.detailTableView reloadData];
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)refreshProductPrice
{
    //    self.unitPrice = self.product.product_price.floatValue;
    if ( self.product )
    {
        self.quantity = self.product.product_qty.integerValue;
        self.totalPrice = self.product.product_price.floatValue * self.product.product_qty.integerValue;
        self.discount = (self.product.product_discount == nil || self.product.product_discount.floatValue == 0) ? 10.0 : self.product.product_discount.floatValue;
        [self.detailTableView reloadData];
        [self reloadNaviTitle];
    }
}

- (void)reloadNaviTitle
{
    if (self.type == kPadProjectDetailReturnItem)
    {
        self.naviLabel.text = [NSString stringWithFormat:LS(@"PadReturnItemAmount"), self.returnAmount];
    }
    else if (self.type == kPadProjectDetailUseItem)
    {
        if (self.useItem.defaultCode.length != 0 && ![self.useItem.defaultCode isEqualToString:@"0"])
        {
            self.naviLabel.text = [NSString stringWithFormat:LS(@"PadProjectUsingTitle"), self.useItem.defaultCode, self.useItem.itemName, self.quantity, self.useItem.uomName];
        }
        else
        {
            self.naviLabel.text = [NSString stringWithFormat:@"%@ %d%@", self.useItem.itemName, self.quantity, self.useItem.uomName];
        }
    }
    else
    {
        if (self.projectItem.defaultCode.length != 0 && ![self.projectItem.defaultCode isEqualToString:@"0"])
        {
            self.naviLabel.text = [NSString stringWithFormat:LS(@"PadProjectDetailTitle"), self.projectItem.defaultCode, self.projectItem.itemName, self.projectItem.totalPrice.floatValue];
        }
        else
        {   ///调整卡项修改
            //老代码
            //self.naviLabel.text = [NSString stringWithFormat:LS(@"PadProjectNoDefaultCodeTitle"), self.projectItem.itemName, self.projectItem.totalPrice.floatValue];
            
            //新代码
            ///购买&卡内项目都会走这里设置title 从调整卡项进来因为想隐藏购买界面的标题栏价格
            if (self.hiddenProductPrice)
            {
                self.naviLabel.text = [NSString stringWithFormat:@"%@", self.projectItem.itemName];
            }
            else
            {
                self.naviLabel.text = [NSString stringWithFormat:LS(@"PadProjectNoDefaultCodeTitle"), self.projectItem.itemName, self.projectItem.totalPrice.floatValue];
            }
        }
    }
}

- (void)didBackButtonClick:(id)sender
{
    [self removeNotificationOnMainThread:kBSCreateBookResponse];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailProjectItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if ( self.maskView )
        {
            self.couponCard.remainAmount = [NSNumber numberWithFloat:self.couponCard.remainAmount.floatValue + self.couponDiscount];
            self.couponDiscount = self.product.coupon_deduction.floatValue;
            self.couponCard.remainAmount = [NSNumber numberWithFloat:self.couponCard.remainAmount.floatValue - self.couponDiscount];
            self.memberCard.points = [NSString stringWithFormat:@"%.0f",self.memberCard.points.floatValue + self.pointDiscount];
            if (self.point2Money > 0)
            {
                self.pointDiscount = self.product.point_deduction.floatValue/self.point2Money;
            }
            else
            {
                self.pointDiscount = 0;
            }
            self.memberCard.points = [NSString stringWithFormat:@"%.0f",self.memberCard.points.floatValue - self.pointDiscount];
            [self.maskView hidden];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.type == kPadProjectDetailReturnItem || self.type == kPadProjectDetailFreeCombination)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
#if 0
    if ( self.product.yimei_buwei.count > 0 )
    {
        CGFloat totalCount = 0;
        for (CDYimeiBuwei* buwei in self.product.yimei_buwei )
        {
            totalCount = totalCount + buwei.count.floatValue;
        }
        
        if ( totalCount > self.quantity )
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"部位使用的产品数量大于了购买数量，请增加产品的购买数量"
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
#endif
    if ( self.remarkTextField.text.length > 0 )
    {
        CDYimeiBuwei* buwei = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiBuwei"];
        buwei.name = self.remarkTextField.text;
        buwei.count = @(1);
        
        if ( self.product )
        {
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
            [orderedSet addObject:buwei];
            self.product.yimei_buwei = orderedSet;
        }
        else
        {
            NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.useItem.yimei_buwei];
            [orderedSet addObject:buwei];
            self.useItem.yimei_buwei = orderedSet;
        }
    }
    
    if (self.member == nil)
    {
        [self didPadProjectDetailEditFinish];
        return;
    }
    
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            CDBook *book;
            HandleBookType type;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSInteger projectTime = 0;
            if (self.type == kPadProjectDetailUseItem)
            {
                book = self.useItem.book;
                projectTime = self.useItem.projectItem.time.integerValue;
            }
            else
            {
                book = self.product.book;
                projectTime = self.product.product.time.integerValue;
            }
            
            if (book)
            {
                if (self.technician == nil || self.appointment == nil)
                {
                    type = HandleBookType_delete;
                }
                else
                {
                    type = HandleBookType_edit;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    params[@"start_date"] = [dateFormatter stringFromDate:self.appointment];
                    NSTimeInterval startInterval = [self.appointment timeIntervalSince1970];
                    NSTimeInterval endInterval = startInterval + ((projectTime != 0) ? (projectTime * 60) : (60.0 * 60.0));
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
                    params[@"end_date"] = [dateFormatter stringFromDate:endDate];
                    params[@"technician_id"] = self.technician.staffID;
                }
            }
            else
            {
                if (self.technician == nil || self.appointment == nil)
                {
                    [self didPadProjectDetailEditFinish];
                    return;
                }
                
                book = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
                type = HandleBookType_create;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                params[@"start_date"] = [dateFormatter stringFromDate:self.appointment];
                NSTimeInterval startInterval = [self.appointment timeIntervalSince1970];
                NSTimeInterval endInterval = startInterval + ((projectTime != 0) ? (projectTime * 60) : (60.0 * 60.0));
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];
                params[@"end_date"] = [dateFormatter stringFromDate:endDate];
                params[@"telephone"] = self.member.mobile;
                params[@"member_name"] = self.member.memberName;
                params[@"technician_id"] = self.technician.staffID;
                params[@"product_ids"] = @[@[@(kBSDataExist), @(NO), @[self.projectItem.itemID]]];
                params[@"active"] = [NSNumber numberWithBool:YES];
                params[@"state"] = @"approved";
                [params setObject:@(YES) forKey:@"is_reservation_bill"];
            }
            
            BSHandleBookRequest *request = [[BSHandleBookRequest alloc] initWithCDBook:book];
            request.type = type;
            request.params = params;
            [request execute];
            return ;
        }
    }
    
    [self didPadProjectDetailEditFinish];
}

- (void)didPadProjectDetailEditFinish
{
    if (self.type == kPadProjectDetailUseItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUseItemEditConfirm:)])
        {
            self.useItem.useCount = [NSNumber numberWithInteger:self.quantity];
            if (self.technician)
            {
                self.useItem.book.technician_id = self.technician.staffID;
                self.useItem.book.technician_name = self.technician.name;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.useItem.book.start_date = [dateFormatter stringFromDate:self.appointment];
            }
            [self.delegate didUseItemEditConfirm:self.useItem];
        }
    }
    else if (self.type == kPadProjectDetailProjectItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadProjectItemConfirm:quantity:)])
        {
            self.product.product_qty = [NSNumber numberWithInteger:self.quantity];
            self.product.product_discount = [NSNumber numberWithFloat:self.discount];
            self.product.product_price = [NSNumber numberWithFloat:self.totalPrice/self.quantity];
            [self.delegate didPadProjectItemConfirm:self.projectItem quantity:self.quantity];
        }
    }
    else if (self.type == kPadProjectDetailReturnItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadReturnItemEditConfirm:)])
        {
            self.returnItem.returnCount = self.quantity;
            self.returnItem.returnAmount = self.returnAmount;
            [self.delegate didPadReturnItemEditConfirm:self.returnItem];
        }
    }
    else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPosProductConfirm:)])
        {
            self.product.product_qty = [NSNumber numberWithInteger:self.quantity];
            self.product.product_discount = [NSNumber numberWithFloat:self.discount];
            self.product.product_price = [NSNumber numberWithFloat:self.totalPrice/self.quantity];
            self.product.coupon_id = [NSNumber numberWithInteger:self.couponID];
            self.product.coupon_deduction = [NSNumber numberWithFloat:self.couponDiscount];
            self.product.point_deduction = [NSNumber numberWithFloat:self.pointDiscount*self.point2Money];
            if (self.technician)
            {
                self.product.book.technician_id = self.technician.staffID;
                self.product.book.technician_name = self.technician.name;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.product.book.start_date = [dateFormatter stringFromDate:self.appointment];
            }
            [self.delegate didPadPosProductConfirm:self.product];
        }
    }
    
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailProjectItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if ( self.maskView )
        {
            [self.maskView hidden];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.type == kPadProjectDetailReturnItem || self.type == kPadProjectDetailFreeCombination)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didDeleteButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.type == kPadProjectDetailUseItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUseItemDelete:)])
        {
            [self.delegate didUseItemDelete:self.useItem];
        }
    }
    else if (self.type == kPadProjectDetailProjectItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadProjectItemDelete:)])
        {
            [self.delegate didPadProjectItemDelete:self.projectItem];
        }
    }
    else if (self.type == kPadProjectDetailReturnItem)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadReturnItemDelete:)])
        {
            [self.delegate didPadReturnItemDelete:self.returnItem];
        }
    }
    else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadPosProductDelete:)])
        {
            [self.delegate didPadPosProductDelete:self.product];
        }
    }
    
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailProjectItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if ( self.maskView )
        {
            [self.maskView hidden];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.type == kPadProjectDetailReturnItem || self.type == kPadProjectDetailFreeCombination)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    if (self.hiddenProductPrice) {
    //        return 1;
    //    }else{
    //
    //    }
    if (self.type == kPadProjectDetailReturnItem)
    {
        return kProjectDetailNOReserveCount;
    }
    else if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
            {
                if (self.hiddenProductPrice)
                {
                    return 1;
                }
                if ([self.viewFrom isEqualToString:@"Wenzhen"])
                {
                    return 2;
                }
                return kProjectYimeiSectionCount;
            }
            
            if ( self.noTechnician )
            {
                return kProjectDetailNOReserveCount;
            }
            
            return kProjectDetailSectionCount;
        }
    }
    
    if (self.projectItem != nil && self.projectItem.subRelateds.count != 0)
    {
        return kProjectSubRelatedCount;
    }
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if (self.isFromGift) {
                return kProjectYimeiPointDiscount;
            }
            return kProjectYimeiSectionCount;
        }
        else
        {
            if (self.projectItem != nil && self.projectItem.subRelateds.count != 0)
            {
                return kProjectYimeiSectionCount;
            }
            else
            {
                return 2;
            }
        }
    }
    
    return kProjectDetailNOReserveCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if ( section == kProjectYimeiSectionBuwei && [[PersonalProfile currentProfile].isYiMei boolValue] )
            {
                //return self.product.yimei_buwei.count + 1;
                return 1;
            }
            
            if (section == kProjectDetailSectionTechnician)
            {
                if (isTechnician)
                {
                    return 2;
                }
                
                return 1;
            }
            else if (section == kProjectDetailSectionAppointment)
            {
                if (isAppointment)
                {
                    return 2;
                }
                
                return 1;
            }
        }
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kProjectDetailSectionItem)
    {
        return kPadProjectDetailItemCellHeight;
    }
    else if (indexPath.section == kProjectDetailSectionAmount)
    {
        return 108.0;
    }
    else if (indexPath.section == kProjectDetailPointDiscount)
    {
        return 108.0;
    }
    else if (indexPath.section == kProjectDetailcouponDiscount)
    {
        return 108.0;
    }
    
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if ( [PersonalProfile currentProfile].isYiMei.boolValue && indexPath.section == kProjectYimeiSectionBuwei )
            {
                return 57;
            }
            
            if (indexPath.section == kProjectDetailSectionTechnician || indexPath.section == kProjectDetailSectionAppointment)
            {
                if (indexPath.row == 0)
                {
                    if (indexPath.section == kProjectDetailSectionTechnician)
                    {
                        return kPadDetailInputCellHeight;
                    }
                    else if (indexPath.section == kProjectDetailSectionAppointment)
                    {
                        return kPadProjectDetailAppointmentCellHeight;
                    }
                }
                
                return kPadPickerViewCellHeight;
            }
        }
    }
    
    if (self.projectItem != nil && self.projectItem.subRelateds.count != 0)
    {
        if (indexPath.section == kProjectSubRelatedItems)
        {
            self.contentstr = @"";
            for (CDProjectRelated *related in self.projectItem.subRelateds)
            {
                CDProjectItem *subItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
                if (self.contentstr.length == 0)
                {
                    if ( [self.product.change_qty integerValue] > 0 )
                    {
                        self.contentstr = [NSString stringWithFormat:@"%@    x%d", subItem.itemName, self.product.change_qty.integerValue];
                    }
                    else
                    {
                        self.contentstr = [NSString stringWithFormat:@"%@    x%d", subItem.itemName, related.quantity.integerValue];
                    }
                }
                else
                {
                    self.contentstr = [NSString stringWithFormat:@"%@\n%@    x%d", self.contentstr, subItem.itemName, related.quantity.integerValue];
                }
            }
            
            CGSize minSize = [self.contentstr sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(kPadDetailContentLabelWidth, 1024.0) lineBreakMode:NSLineBreakByWordWrapping];
            self.contentHeight = minSize.height;
            
            return (minSize.height + 2 * 20.0 + 28.0 + 20.0 + 12.0);
        }
    }
    
    if ( [PersonalProfile currentProfile].isYiMei.boolValue && indexPath.section == kProjectYimeiSectionBuwei )
    {
        return 57;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"self.hiddenProductPrice = %d",self.hiddenProductPrice);
    //新代码
    ///调整卡项修改
    ///这个条件是为了隐藏 PadProjectDetailItemCell加的
    if (self.hiddenProductPrice)
    {///从会员中心调整卡项进入项目详细
        
        //hiddenProductPrice=YES这个条件表示隐藏navi价格 也代表从调整卡项进来 这时隐藏 PadProjectDetailItemCell
        if (indexPath.section == kProjectDetailSectionItem)
        {
            static NSString *CellIdentifier = @"PadProjectDetailAmountCellIdentifier";
            PadProjectDetailAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadProjectDetailAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
                cell.discountTextField.tag = 2001;
            }
            
            cell.quantityLabel.text = LS(@"PadItemDetailQuantity");
            //cell.discountLabel.text = LS(@"PadItemDetailDiscount");
            cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
            cell.discountLabel.hidden = YES;
            cell.discountTextField.superview.hidden = YES;
            if (self.type != kPadProjectDetailUseItem && self.type != kPadProjectDetailReturnItem)
            {
                if (self.projectItem.itemID.integerValue != 1)
                {
                    cell.discountLabel.hidden = NO;
                    cell.discountTextField.superview.hidden = NO;
                    cell.discountTextField.delegate = self;
                    if (fabs(self.discount - (int)roundf(self.discount)) < 0.01)
                    {
                        cell.discountTextField.text = [NSString stringWithFormat:@"%d", (int)roundf(self.discount)];
                    }
                    else
                    {
                        cell.discountTextField.text = [NSString stringWithFormat:@"%.1f", self.discount];
                    }
                }
            }
            else if (self.type == kPadProjectDetailReturnItem)
            {
                cell.discountLabel.text = LS(@"PadReturnItemReturnAmount");
                cell.discountLabel.hidden = NO;
                cell.discountTextField.superview.hidden = NO;
                cell.discountTextField.delegate = self;
                cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
            }
            //cell.contentView.backgroundColor = [UIColor orangeColor];
            cell.discountTextField.hidden = YES;
            cell.discountTextField.superview.hidden = YES;
            return cell;
        }
        else if (indexPath.section == kProjectDetailSectionAmount){
            static NSString *CellIdentifier = @"ProjectDetailItemCellIdentifier";
            PadProjectDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                ///如果点击调整卡项项目 这里设置cell
                cell = [[PadProjectDetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.priceTextField.tag = 1001;
                cell.priceTextField.delegate = self;
            }
            
            if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailReturnItem)
            {
                cell.titleLabel.text = LS(@"PadItemUsingItem");
            }
            else
            {
                ///如果点击调整卡项项目 “总价”
                cell.titleLabel.text = LS(@"PadItemDetailTotalPrice");
                //cell.contentView.backgroundColor = [UIColor redColor];
            }
            
            if (self.type == kPadProjectDetailReturnItem)//3
            {
                cell.detailLabel.text = self.returnItem.cardProject.projectName;
                cell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.returnItem.cardProject.projectPriceUnit.doubleValue];
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = NO;
                cell.priceTextField.delegate = nil;
                return cell;
            }
            
            if (self.projectItem.defaultCode.length != 0 && ![self.projectItem.defaultCode isEqualToString:@"0"])
            {
                //"[%@]%@"
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), self.projectItem.defaultCode, self.projectItem.itemName];
            }
            else
            {
                ///如果点击调整卡项项目 进来
                cell.detailLabel.text = self.projectItem.itemName;
            }
            ///如果点击调整卡项项目 进来
            cell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
            
            if (self.type == kPadProjectDetailUseItem)
            {
                cell.priceTextField.hidden = YES;
            }
            if (self.type == kPadProjectDetailProjectItem)
            {
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = NO;
                cell.priceTextField.delegate = nil;
            }
            else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
            {
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = YES;
                cell.priceTextField.delegate = self;
            }
            
            //cell.contentView.backgroundColor = [UIColor redColor];
            cell.hidden = YES;
            return cell;
        }
        
    }
    else
    {///从其他页面进入项目详细
        //老代码
        if (indexPath.section == kProjectDetailSectionItem)//0
        {
            static NSString *CellIdentifier = @"ProjectDetailItemCellIdentifier";
            PadProjectDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                ///如果点击调整卡项项目 这里设置cell
                cell = [[PadProjectDetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.priceTextField.tag = 1001;
                cell.priceTextField.delegate = self;
            }
            
            if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailReturnItem)
            {
                cell.titleLabel.text = LS(@"PadItemUsingItem");
            }
            else
            {
                ///如果点击调整卡项项目 “总价”
                cell.titleLabel.text = LS(@"PadItemDetailTotalPrice");
                //cell.contentView.backgroundColor = [UIColor redColor];
            }
            
            if (self.type == kPadProjectDetailReturnItem)//3
            {
                cell.detailLabel.text = self.returnItem.cardProject.projectName;
                cell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.returnItem.cardProject.projectPriceUnit.doubleValue];
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = NO;
                cell.priceTextField.delegate = nil;
                return cell;
            }
            
            if (self.projectItem.defaultCode.length != 0 && ![self.projectItem.defaultCode isEqualToString:@"0"])
            {
                //"[%@]%@"
                cell.detailLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), self.projectItem.defaultCode, self.projectItem.itemName];
            }
            else
            {
                ///如果点击调整卡项项目 进来
                cell.detailLabel.text = self.projectItem.itemName;
            }
            ///如果点击调整卡项项目 进来
            cell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice-self.pointDiscount-self.couponDiscount];
            
            if (self.type == kPadProjectDetailUseItem)
            {
                cell.priceTextField.hidden = YES;
            }
            if (self.type == kPadProjectDetailProjectItem)
            {
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = NO;
                cell.priceTextField.delegate = nil;
            }
            else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
            {
                cell.priceTextField.hidden = NO;
                cell.priceTextField.enabled = YES;
                cell.priceTextField.delegate = self;
            }
            //cell.hidden = YES;
            return cell;
        }
        else if (indexPath.section == kProjectDetailSectionAmount)//1
        {
            static NSString *CellIdentifier = @"PadProjectDetailAmountCellIdentifier";
            PadProjectDetailAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadProjectDetailAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.delegate = self;
                cell.discountTextField.tag = 2001;
            }
            // 数量和折扣cell
            //cell.contentView.backgroundColor = [UIColor orangeColor];
            cell.quantityLabel.text = LS(@"PadItemDetailQuantity");
            cell.discountLabel.text = LS(@"PadItemDetailDiscount");
            cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
            cell.discountLabel.hidden = YES;
            cell.discountTextField.superview.hidden = YES;
            if (self.type != kPadProjectDetailUseItem && self.type != kPadProjectDetailReturnItem)
            {
                if (self.projectItem.itemID.integerValue != 1)
                {
                    cell.discountLabel.hidden = NO;
                    cell.discountTextField.superview.hidden = NO;
                    cell.discountTextField.delegate = self;
                    if (fabs(self.discount - (int)roundf(self.discount)) < 0.01)
                    {
                        cell.discountTextField.text = [NSString stringWithFormat:@"%d", (int)roundf(self.discount)];
                    }
                    else
                    {
                        cell.discountTextField.text = [NSString stringWithFormat:@"%.1f", self.discount];
                    }
                }
            }
            else if (self.type == kPadProjectDetailReturnItem)
            {
                cell.discountLabel.text = LS(@"PadReturnItemReturnAmount");
                cell.discountLabel.hidden = NO;
                cell.discountTextField.superview.hidden = NO;
                cell.discountTextField.delegate = self;
                cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
            }
            
            return cell;
        }
        else if (indexPath.section == kProjectDetailPointDiscount && self.projectItem.bornCategory.integerValue != kPadBornCategoryProject)//2
        {
            static NSString *CellIdentifier = @"PadProjectDetailDiscountCellIdentifier";
            PadProjectDetailDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadProjectDetailDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.titleLabel.text = LS(@"PadItemDetailPointDiscount");
                cell.discountTextField.tag = 3001;
                cell.discountTextField.delegate = self;
                cell.symbolLabel.hidden = YES;
            }
            cell.maxDiscountPoint = self.memberCard.points.floatValue + self.pointDiscount;
            self.point2Money = self.memberCard.priceList.points2Money.floatValue;
            cell.pointsChangeMoney = self.memberCard.priceList.points2Money.floatValue;
            float useAmount = 0.0;
//            if (self.product.point_deduction.floatValue != 0)
//            {
//                if (self.point2Money > 0)
//                {
//                    useAmount = self.product.point_deduction.floatValue/self.point2Money;
//                }
//                else
//                {
//                    useAmount = 0.0;
//                }
//            }
//            if (self.pointDiscount == 0)
//            {
                useAmount = self.pointDiscount;
//            }
            cell.discountTextField.text = [NSString stringWithFormat:@"%.0f", useAmount];
            cell.detailLabel.text = [NSString stringWithFormat:@"可用%.0f", self.memberCard.points.floatValue + self.pointDiscount];
            [cell reloadView];
            return cell;
        }
        else if (indexPath.section == kProjectDetailcouponDiscount && self.projectItem.bornCategory.integerValue != kPadBornCategoryProject)//3
        {
            static NSString *CellIdentifier = @"PadProjectDetailcouponDiscountCellIdentifier";
            PadProjectDetailCashDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadProjectDetailCashDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.titleLabel.text = LS(@"PadItemDetailCashDiscount");
                cell.discountTextField.tag = 4001;
                cell.discountTextField.delegate = self;
                //cell.detailLabel.text = self.member
            }
            if (!self.needRefreshCoupon)
            {
                self.needRefreshCoupon = YES;
                return cell;
            }
            cell.shouldShowMember = self.isFromProject;
            if (self.couponCard != nil)
            {
                cell.isChosen = YES;
                float useAmount = 0.0;
                cell.maxDiscountPoint = self.couponCard.remainAmount.floatValue + self.couponDiscount;
                if (self.product.coupon_deduction.floatValue != 0)
                {
                    useAmount = self.product.coupon_deduction.floatValue;
                }
                if (self.couponDiscount != 0)
                {
                    useAmount = self.couponDiscount;
                }
//                else
//                {
//                    useAmount = 0.0;
//                    self.couponCard.remainAmount = [NSNumber numberWithFloat:self.couponCard.remainAmount.floatValue - useAmount];
//                    self.couponDiscount = useAmount;
//                    [[BSCoreDataManager currentManager] save:nil];
//                }
                cell.detailLabel.text = [NSString stringWithFormat:@"%@(可用%.0f)",self.couponCard.cardName,self.couponCard.remainAmount.floatValue + self.couponDiscount];
                cell.discountTextField.text = [NSString stringWithFormat:@"%.2f",useAmount];
                [cell.discountTextField endEditing:YES];
                self.couponID  = self.couponCard.cardID.integerValue;
                
            }
            [cell reloadView];
            return cell;
        }
    }

    ///TODO：调整卡项进来 和下面的if条件无关
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if (indexPath.section == kProjectYimeiSectionBuwei && self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            PadProjectYimeiBuweiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadProjectYimeiBuweiTableViewCell"];
            cell.delegate = self;
            
            CDYimeiBuwei* buwei = nil;
            
            if ( indexPath.row == 0 )
            {
                cell.bgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                
                if ( self.product.yimei_buwei.count == 0 )
                {
                    
                }
                //                        else
                //                        {
                //                            cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                //                        }
            }
            else if ( indexPath.row == self.product.yimei_buwei.count )
            {
                buwei = self.product.yimei_buwei[indexPath.row - 1];
                cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
            }
            else
            {
                buwei = self.product.yimei_buwei[indexPath.row - 1];
                cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
            }
            
            NSMutableString* title = [NSMutableString string];
            //cell.buwei = buwei;
            if ( self.product )
            {
                for ( CDYimeiBuwei* buwei in self.product.yimei_buwei )
                {
                    //[title appendFormat:@"%@X%@%@  ",buwei.name, buwei.count, self.projectItem.uomName];
                    [title appendFormat:@"%@  ",buwei.name];
                }
            }
            else
            {
                for ( CDYimeiBuwei* buwei in self.useItem.yimei_buwei )
                {
                    [title appendFormat:@"%@  ",buwei.name];
                    //[title appendFormat:@"%@X%@%@  ",buwei.name, buwei.count, self.projectItem.uomName];
                }
            }
            
            [cell setBuweiTitle:title];
            
            return cell;
        }
    }
    
    if (self.type == kPadProjectDetailUseItem || self.type == kPadProjectDetailCurrentCashier)
    {
        if (self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
        {
            if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
            {
                if (indexPath.section == kProjectYimeiPointDiscount)//2
                {
                    static NSString *CellIdentifier = @"PadProjectDetailDiscountCellIdentifier";
                    PadProjectDetailDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadProjectDetailDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.titleLabel.text = LS(@"PadItemDetailPointDiscount");
                        cell.discountTextField.tag = 3001;
                        cell.discountTextField.delegate = self;
                        cell.symbolLabel.hidden = YES;
                    }
                    cell.maxDiscountPoint = self.memberCard.points.floatValue + self.pointDiscount;
                    self.point2Money = self.memberCard.priceList.points2Money.floatValue;
                    cell.pointsChangeMoney = self.memberCard.priceList.points2Money.floatValue;
                    float useAmount = 0.0;
//                    if (self.product.point_deduction.floatValue != 0)
//                    {
//                        if (self.point2Money > 0)
//                        {
//                            useAmount = self.product.point_deduction.floatValue/self.point2Money;
//                        }
//                        else
//                        {
//                            useAmount = 0.0;
//                        }
//                    }
//                    if (self.pointDiscount == 0)
//                    {
                        useAmount = self.pointDiscount;
//                    }
                    cell.discountTextField.text = [NSString stringWithFormat:@"%.0f", useAmount];
                    cell.detailLabel.text = [NSString stringWithFormat:@"可用%.0f", self.memberCard.points.floatValue + self.pointDiscount];
                    [cell reloadView];
                    return cell;
                }
                else if (indexPath.section == kProjectYimeicouponDiscount)//3
                {
                    static NSString *CellIdentifier = @"PadProjectDetailcouponDiscountCellIdentifier";
                    PadProjectDetailCashDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadProjectDetailCashDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.titleLabel.text = LS(@"PadItemDetailCashDiscount");
                        cell.discountTextField.tag = 4001;
                        cell.discountTextField.delegate = self;
                        //cell.detailLabel.text = self.member
                    }
                    if (!self.needRefreshCoupon)
                    {
                        self.needRefreshCoupon = YES;
                        return cell;
                    }
                    cell.shouldShowMember = self.isFromProject;
                    if (self.couponCard != nil)
                    {
                        cell.isChosen = YES;
                        float useAmount = 0.0;
                        cell.maxDiscountPoint = self.couponCard.remainAmount.floatValue + self.couponDiscount;
                        if (self.product.coupon_deduction.floatValue != 0)
                        {
                            useAmount = self.product.coupon_deduction.floatValue;
                        }
                        if (self.couponDiscount != 0)
                        {
                            useAmount = self.couponDiscount;
                        }
                        //                else
                        //                {
                        //                    useAmount = 0.0;
                        //                    self.couponCard.remainAmount = [NSNumber numberWithFloat:self.couponCard.remainAmount.floatValue - useAmount];
                        //                    self.couponDiscount = useAmount;
                        //                    [[BSCoreDataManager currentManager] save:nil];
                        //                }
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@(可用%.0f)",self.couponCard.cardName,self.couponCard.remainAmount.floatValue + self.couponDiscount];
                        cell.discountTextField.text = [NSString stringWithFormat:@"%.2f",useAmount];
                        [cell.discountTextField endEditing:YES];
                        self.couponID  = self.couponCard.cardID.integerValue;
                        
                    }
                    [cell reloadView];
                    return cell;
                }
                else if (indexPath.section == kProjectYimeiSectionBuwei)
                {
                    PadProjectYimeiBuweiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PadProjectYimeiBuweiTableViewCell"];
                    cell.delegate = self;
                    
                    CDYimeiBuwei* buwei = nil;
                    
                    if ( indexPath.row == 0 )
                    {
                        cell.bgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                        
                        if ( self.product.yimei_buwei.count == 0 )
                        {
                            
                        }
                        //                        else
                        //                        {
                        //                            cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                        //                        }
                    }
                    else if ( indexPath.row == self.product.yimei_buwei.count )
                    {
                        buwei = self.product.yimei_buwei[indexPath.row - 1];
                        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                    }
                    else
                    {
                        buwei = self.product.yimei_buwei[indexPath.row - 1];
                        cell.bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
                    }
                    
                    NSMutableString* title = [NSMutableString string];
                    //cell.buwei = buwei;
                    for ( CDYimeiBuwei* buwei in self.product.yimei_buwei )
                    {
                        [title appendFormat:@"%@X%@%@  ",buwei.name, buwei.count,self.projectItem.uomName];
                    }
                    
                    [cell setBuweiTitle:title];
                    
                    return cell;
                }
            }
            
            if (indexPath.section == kProjectDetailSectionTechnician)
            {
                if (indexPath.row == 0)
                {
                    static NSString *CellIdentifier = @"PadDetailInputCellIdentifier";
                    PadDetailInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadDetailInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.delegate = self;
                    }
                    
                    cell.confirmButton.alpha = 0.0;
                    if (isTechnician)
                    {
                        cell.confirmButton.alpha = 1.0;
                        cell.background.image = [[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
                    }
                    else
                    {
                        cell.background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
                    }
                    
                    if (self.technician)
                    {
                        cell.inputTextField.text = self.technician.name;
                    }
                    else
                    {
                        cell.inputTextField.text = @"";
                    }
                    
                    return cell;
                }
                else
                {
                    static NSString *CellIdentifier = @"PadPickerViewCellIdentifier";
                    PadPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.delegate = self;
                    }
                    
                    [cell reloadPickerViewWithTechnicians:self.technicians];
                    
                    if (self.technician)
                    {
                        for (int i = 0; i < self.technicians.count; i++)
                        {
                            CDStaff *staff = [self.technicians objectAtIndex:i];
                            if (self.technician.staffID.integerValue == staff.staffID.integerValue)
                            {
                                [cell.pickerView selectRow:i inComponent:0 animated:NO];
                                break;
                            }
                        }
                    }
                    else if (self.technicians.count != 0)
                    {
                        [cell.pickerView selectRow:0 inComponent:0 animated:NO];
                    }
                    
                    return cell;
                }
            }
            else if (indexPath.section == kProjectDetailSectionAppointment)
            {
                if (indexPath.row == 0)
                {
                    static NSString *CellIdentifier = @"PadProjectDetailAppointmentCellIdentifier";
                    PadProjectDetailAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadProjectDetailAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.delegate = self;
                    }
                    
                    cell.confirmButton.alpha = 0.0;
                    if (isAppointment)
                    {
                        cell.confirmButton.alpha = 1.0;
                        cell.background.image = [[UIImage imageNamed:@"pad_top_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
                    }
                    else
                    {
                        cell.background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
                    }
                    
                    if (self.appointment)
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy年 MM月 dd日 HH:mm";
                        cell.timeTextField.text = [dateFormatter stringFromDate:self.appointment];
                    }
                    
                    return cell;
                }
                else
                {
                    static NSString *CellIdentifier = @"PadPickerViewCellIdentifier";
                    PadPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (cell == nil)
                    {
                        cell = [[PadPickerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.delegate = self;
                    }
                    
                    NSDate *date = [NSDate date];
                    if (self.appointment)
                    {
                        date = self.appointment;
                    }
                    [cell reloadPickerViewWithDateAndTime:date];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSString *datestr = [dateFormatter stringFromDate:date];
                    NSString *hourstr = [datestr substringWithRange:NSMakeRange(11, 2)];
                    NSString *minutestr = [datestr substringWithRange:NSMakeRange(14, 2)];
                    [cell.pickerView selectRow:hourstr.integerValue inComponent:0 animated:NO];
                    [cell.pickerView selectRow:minutestr.integerValue inComponent:1 animated:NO];
                    
                    return cell;
                }
            }
        }
    }
    
    if (self.projectItem != nil && self.projectItem.subRelateds.count != 0)
    {
        if (indexPath.section == kProjectSubRelatedItems)
        {
            static NSString *CellIdentifier = @"PadProjectDetailSubRelatedCellIdentifier";
            PadProjectDetailSubRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[PadProjectDetailSubRelatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            self.contentstr = @"";
            for (CDProjectRelated *related in self.projectItem.subRelateds)
            {
                CDProjectItem *subItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
                if (self.contentstr.length == 0)
                {
                    if ( [self.product.change_qty integerValue] > 0 )
                    {
                        self.contentstr = [NSString stringWithFormat:@"%@    x%d", subItem.itemName, self.product.change_qty.integerValue];
                    }
                    else
                    {
                        self.contentstr = [NSString stringWithFormat:@"%@    x%d", subItem.itemName, related.quantity.integerValue];
                    }
                }
                else
                {
                    self.contentstr = [NSString stringWithFormat:@"%@\n%@    x%d", self.contentstr, subItem.itemName, related.quantity.integerValue];
                }
            }
            
            CGSize minSize = [self.contentstr sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(kPadDetailContentLabelWidth, 1024.0) lineBreakMode:NSLineBreakByWordWrapping];
            self.contentHeight = minSize.height;
            
            cell.titleLabel.text = LS(@"PadItemDetailSubItems");
            cell.detailLabel.text = self.contentstr;
            cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width, self.contentHeight);
            cell.detailView.frame = CGRectMake(cell.detailView.frame.origin.x, cell.detailView.frame.origin.y, cell.detailView.frame.size.width, self.contentHeight + 2 * 20.0);
            
            cell.changeCountTextField.hidden = YES;
            cell.changeCountTextField.tag = 3231;
            cell.changeCountTextField.delegate = self;
            if ( self.projectItem.subRelateds.count == 1 )
            {
                if ( self.projectItem.bornCategory.integerValue == kPadBornCategoryCourses )
                {
                    cell.changeCountTextField.hidden = NO;
                }
            }
            
            return cell;
        }
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] && section == kProjectYimeiSectionBuwei && self.projectItem.bornCategory.integerValue == kPadBornCategoryProject)
    {
        UIView* v = [[UIView alloc] init];
        v.backgroundColor = [UIColor clearColor];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, 0, kPadMaskViewContentWidth, 20.0)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        if ( self.product.yimei_buwei.count > 0 )
        {
            CGFloat totalCount = 0;
            for (CDYimeiBuwei* buwei in self.product.yimei_buwei )
            {
                totalCount = totalCount + buwei.count.floatValue;
            }
            
            titleLabel.text = [NSString stringWithFormat:@"已添加部位总数为%.02f%@",totalCount,self.projectItem.uomName];
        }
        else
        {
            titleLabel.text = @"部位";
        }
        
        [v addSubview:titleLabel];
        
        return v;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] && section == kProjectYimeiSectionBuwei && self.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
    {
        return 40;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] && indexPath.section == kProjectYimeiSectionBuwei && self.projectItem.bornCategory.integerValue == kPadBornCategoryProject )
    {
        CDYimeiBuwei* buwei = nil;
        if ( indexPath.row != 0 )
        {
            buwei = self.product.yimei_buwei[indexPath.row - 1];
        }
        
        PadProjectYimeiBuweiPhotoViewController* vc = [[PadProjectYimeiBuweiPhotoViewController alloc] initWithNibName:@"PadProjectYimeiBuweiPhotoViewController" bundle:nil];
        vc.delegate = self;
        vc.product = self.product;
        vc.item = self.useItem;
        //vc.totalCount = self.quantity;
        [(UINavigationController*)((MMDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController).centerViewController pushViewController:vc animated:YES];
        //[((UIViewController*)self.delegate).navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark PadProjectDetailAmountCellDelegate Methods

- (void)didQuantityMinus
{
    //新代码
    if (self.hiddenProductPrice){
        if (self.quantity > 1)
        {
            PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
            //PadProjectDetailItemCell *priceCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
            
            self.quantity --;
            cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
            
            if (self.type == kPadProjectDetailProjectItem)
            {
                self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
                //priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
            }
            else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
            {
                self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
                //priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
            }
            else if (self.type == kPadProjectDetailReturnItem)
            {
                self.returnAmount = self.returnItem.cardProject.projectPriceUnit.doubleValue * self.quantity;
                //cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
            }
        }
        
        //[self reloadNaviTitle];
    }
    else{
        //老代码
        if (self.quantity > 1)
        {
            PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAmount]];
            PadProjectDetailItemCell *priceCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
            
            [self clearPointsAndCouponCard];
            self.quantity --;
            cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
            
            if (self.type == kPadProjectDetailProjectItem)
            {
                self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
                priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
            }
            else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
            {
                self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0 - self.product.coupon_deduction.floatValue - self.product.point_deduction.floatValue;
                priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
            }
            else if (self.type == kPadProjectDetailReturnItem)
            {
                self.returnAmount = self.returnItem.cardProject.projectPriceUnit.doubleValue * self.quantity;
                cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
            }
        }
        
        [self reloadNaviTitle];
    }
}

- (void)didQuantityPlus
{
    if (self.type == kPadProjectDetailUseItem)
    {
        if (self.quantity >= self.useItem.totalCount.integerValue)
        {
            NSString *message = @"";
            if (self.useItem.type.integerValue == kPadUseItemPurchasing)
            {
                message = LS(@"PadPurchaseUseItemCountLimit");
            }
            else if (self.useItem.type.integerValue == kPadUseItemMemberCardProject || self.useItem.type.integerValue == kPadUseItemCouponCardProject)
            {
                message = LS(@"PadCardUseItemCountLimit");
            }
            else
            {
                message = @"超过可使用的数量";
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    else if (self.type == kPadProjectDetailReturnItem)
    {
        if (self.quantity >= self.returnItem.cardProject.remainQty.integerValue)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:LS(@"PadCardReturnItemCountLimit")
                                                               delegate:nil
                                                      cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    //   老代码
    //    PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAmount]];//1
    //    PadProjectDetailItemCell *priceCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];//0
    //
    //    self.quantity ++;
    //    cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
    //    if (self.type == kPadProjectDetailProjectItem)
    //    {
    //        self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
    //        priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
    //    }
    //    else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
    //    {
    //        self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
    //        priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
    //    }
    //    else if (self.type == kPadProjectDetailReturnItem)
    //    {
    //        self.returnAmount = self.returnItem.cardProject.projectPriceUnit.doubleValue * self.quantity;
    //        cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
    //    }
    //
    //    [self reloadNaviTitle];
    
    // 新代码 用hiddenProductPrice区分是从调整卡项进去的 if - else
    if (self.hiddenProductPrice) {
        //PadProjectDetailAmountCell kProjectDetailSectionItem
        //PadProjectDetailItemCell
        PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
        //PadProjectDetailItemCell *priceCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
        
        self.quantity ++;
        cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
        if (self.type == kPadProjectDetailProjectItem)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
            //priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
        }
        else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
            //priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
        }
        else if (self.type == kPadProjectDetailReturnItem)
        {
            self.returnAmount = self.returnItem.cardProject.projectPriceUnit.doubleValue * self.quantity;
            cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
        }
        
        [self reloadNaviTitle];
    }
    else{
        PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAmount]];//1
        PadProjectDetailItemCell *priceCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];//0
        
        self.quantity ++;
        cell.quantityTextField.text = [NSString stringWithFormat:@"%d", self.quantity];
        if (self.type == kPadProjectDetailProjectItem)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
            priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
        }
        else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0 - self.product.coupon_deduction.floatValue - self.product.point_deduction.floatValue;
            priceCell.priceTextField.text = [NSString stringWithFormat:LS(@"%.2f"), self.totalPrice];
        }
        else if (self.type == kPadProjectDetailReturnItem)
        {
            self.returnAmount = self.returnItem.cardProject.projectPriceUnit.doubleValue * self.quantity;
            cell.discountTextField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
        }
        
        [self reloadNaviTitle];
    }
    
}


#pragma mark -
#pragma mark UITextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1001)
    {
        self.totalPrice = textField.text.floatValue;
        if (self.type == kPadProjectDetailProjectItem)
        {
            //self.discount = textField.text.floatValue/(self.projectItem.totalPrice.floatValue * self.quantity) * 10.0;
        }
        else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
        {
            //self.discount = textField.text.floatValue/(self.product.product_price.floatValue * self.quantity) * 10.0;
        }
        
        PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAmount]];
        if (fabs(self.discount - (int)roundf(self.discount)) < 0.01)
        {
            cell.discountTextField.text = [NSString stringWithFormat:@"%d", (int)roundf(self.discount)];
        }
        else
        {
            cell.discountTextField.text = [NSString stringWithFormat:@"%.1f", self.discount];
        }
        
        [self clearPointsAndCouponCard];
//        self.couponCard.remainAmount = [NSNumber numberWithFloat:(self.couponCard.remainAmount.floatValue + self.couponDiscount)];
//        self.couponDiscount = 0.0;
//        self.memberCard.points = [NSString stringWithFormat:@"%.0f",(self.memberCard.points.floatValue + self.pointDiscount)];
//        self.pointDiscount = 0.0;
//        [[BSCoreDataManager currentManager] save:nil];
//        PadProjectDetailCashDiscountCell *couponCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailcouponDiscount]];
//        couponCell.discountTextField.text = [NSString stringWithFormat:@"%.0f", self.couponDiscount];
//        [couponCell reloadView];
//        [self.detailTableView reloadData];
        [self reloadNaviTitle];
    }
    else if (textField.tag == 2001)
    {
        if (self.type == kPadProjectDetailReturnItem)
        {
            self.returnAmount = textField.text.floatValue;
            textField.text = [NSString stringWithFormat:@"%.2f", self.returnAmount];
            [self reloadNaviTitle];
            return;
        }
        
        self.discount = textField.text.floatValue;
        if (self.discount > 10.0)
        {
            self.discount = 10.0;
        }
        
        if (fabs(self.discount - (int)roundf(self.discount)) < 0.01)
        {
            textField.text = [NSString stringWithFormat:@"%d", (int)roundf(self.discount)];
        }
        else
        {
            textField.text = [NSString stringWithFormat:@"%.1f", self.discount];
        }
        
        if (self.type == kPadProjectDetailProjectItem)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
        }
        else if (self.type == kPadProjectDetailCurrentCashier || self.type == kPadProjectDetailFreeCombination)
        {
            self.totalPrice = self.projectItem.totalPrice.floatValue * self.quantity * self.discount/10.0;
        }
        
        if (self.hiddenProductPrice) {
            //新代码
            PadProjectDetailAmountCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
            //cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.totalPrice];
            [self reloadNaviTitle];
        }else{
            //老代码
            PadProjectDetailItemCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
            cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.totalPrice];
            [self reloadNaviTitle];
            //[self.detailTableView reloadData];
        }
       
    }
    else if (textField.tag == 3001)
    {
        self.memberCard.points = [NSString stringWithFormat:@"%.0f",(self.memberCard.points.floatValue + self.pointDiscount)];
        self.pointDiscount = textField.text.floatValue < self.memberCard.points.floatValue ? textField.text.floatValue : self.memberCard.points.floatValue;
        NSLog(@"%@",textField.text);
        self.pointDiscount = self.pointDiscount < self.totalPrice - self.couponDiscount ? self.pointDiscount : floorf(self.totalPrice - self.couponDiscount);
        textField.text = [NSString stringWithFormat:@"%.0f", self.pointDiscount];
        self.pointDiscount = textField.text.floatValue;
        self.memberCard.points = [NSString stringWithFormat:@"%.0f",(self.memberCard.points.floatValue - self.pointDiscount)];
        [[BSCoreDataManager currentManager] save:nil];
        PadProjectDetailItemCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
        cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.totalPrice-self.pointDiscount-self.couponDiscount];
        [self.detailTableView reloadData];
        [self reloadNaviTitle];
    }
    else if (textField.tag == 4001)
    {
        self.couponCard.remainAmount = [NSNumber numberWithFloat:(self.couponCard.remainAmount.floatValue + self.couponDiscount)];
        NSLog(@"%f",textField.text.floatValue);
        self.couponDiscount = textField.text.floatValue < self.couponCard.remainAmount.floatValue ? textField.text.floatValue : self.couponCard.remainAmount.floatValue;
        self.couponDiscount = self.couponDiscount < self.totalPrice - self.pointDiscount? self.couponDiscount : self.totalPrice - self.pointDiscount;
        textField.text = [NSString stringWithFormat:@"%.0f", self.couponDiscount];
        self.couponCard.remainAmount = [NSNumber numberWithFloat:(self.couponCard.remainAmount.floatValue - self.couponDiscount)];
        [[BSCoreDataManager currentManager] save:nil];
        PadProjectDetailItemCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionItem]];
        cell.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.totalPrice-self.pointDiscount-self.couponDiscount];
        [self.detailTableView reloadData];
        [self reloadNaviTitle];
    }
    else if (textField.tag > 10000 && textField.tag < 20000)
    {
        NSInteger index = textField.tag - 10000;
        CDYimeiBuwei* buwei = self.product.yimei_buwei[index];
        buwei.name = textField.text;
    }
    else if (textField.tag > 20000 && textField.tag < 30000)
    {
        NSInteger index = textField.tag - 10000;
        CDYimeiBuwei* buwei = self.product.yimei_buwei[index];
        buwei.count = @([textField.text integerValue]);
    }
    else if (textField.tag == 3231)
    {
        PadProjectDetailSubRelatedCell *cell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectSubRelatedItems]];
        //        for (CDProjectRelated *related in self.projectItem.subRelateds)
        //        {
        //            CDProjectItem *subItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
        //            if (self.contentstr.length == 0)
        //            {
        //                self.contentstr = [NSString stringWithFormat:@"[%@]%@    x%d", subItem.defaultCode, subItem.itemName, related.quantity.integerValue];
        //            }
        //            else
        //            {
        //                self.contentstr = [NSString stringWithFormat:@"%@\n[%@]%@    x%d", self.contentstr, subItem.defaultCode, subItem.itemName, textField.text.integerValue];
        //            }
        //        }
        //        cell.detailLabel.text = self.contentstr;
        if ( [textField.text integerValue] > 0 )
        {
            self.product.change_qty = @([textField.text integerValue]);
            cell.changeCountTextField.text = @"";
            [self.detailTableView reloadData];
        }
    }
}


#pragma mark -
#pragma mark PadDetailInputCellDelegate Methods

- (void)didShowAndHidePickerView:(PadDetailInputCell *)cell
{
    isTechnician = !isTechnician;
    if (isTechnician)
    {
        if (self.technician == nil && self.technicians.count != 0)
        {
            self.technician = [self.technicians objectAtIndex:0];
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            cell.confirmButton.alpha = 1.0;
            [self.detailTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kProjectDetailSectionTechnician]] withRowAnimation:UITableViewRowAnimationBottom];
        } completion:^(BOOL finished) {
            [self.detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAppointment] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    }
    else
    {
        cell.confirmButton.alpha = 0.0;
        [self.detailTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kProjectDetailSectionTechnician]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectDetailSectionTechnician] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
#pragma mark PadProjectDetailAppointmentCellDelegate Methods

- (void)didShowAndHideAppointmentPickerView:(PadProjectDetailAppointmentCell *)cell
{
    isAppointment = !isAppointment;
    if (isAppointment)
    {
        if (self.appointment == nil)
        {
            self.appointment = [NSDate date];
        }
        [UIView animateWithDuration:0.1 animations:^{
            cell.confirmButton.alpha = 1.0;
            [self.detailTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kProjectDetailSectionAppointment]] withRowAnimation:UITableViewRowAnimationBottom];
        } completion:^(BOOL finished) {
            [self.detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:kProjectDetailSectionAppointment] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
    }
    else
    {
        cell.confirmButton.alpha = 0.0;
        [self.detailTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:kProjectDetailSectionAppointment]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:kProjectDetailSectionAppointment] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
#pragma mark PadPickerViewCellDelegate Methods

- (void)pickerView:(PadPickerViewCell *)cell selectedTechnician:(CDStaff *)technician
{
    self.technician = technician;
    PadDetailInputCell *inputCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionTechnician]];
    inputCell.inputTextField.text = self.technician.name;
}

- (void)pickerView:(PadPickerViewCell *)cell selectedDateAndTime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年 MM月 dd日 HH:mm";
    self.appointment = date;
    
    PadProjectDetailAppointmentCell *detailCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kProjectDetailSectionAppointment]];
    detailCell.timeTextField.text = [dateFormatter stringFromDate:self.appointment];
}

- (void)didPadProjectYimeiBuweiTableViewDeleteButtonPressed:(PadProjectYimeiBuweiTableViewCell*)cell
{
    NSInteger index = [self.detailTableView indexPathForCell:cell].row;
    if ( index == 0 )
    {
        PadProjectYimeiBuweiPhotoViewController* vc = [[PadProjectYimeiBuweiPhotoViewController alloc] initWithNibName:@"PadProjectYimeiBuweiPhotoViewController" bundle:nil];
        vc.delegate = self;
        vc.product = self.product;
        vc.item = self.useItem;
        [((UIViewController*)self.delegate).navigationController pushViewController:vc animated:YES];
    }
    else
    {
        CDYimeiBuwei* buwei = self.product.yimei_buwei[index - 1];
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
        [orderedSet removeObject:buwei];
        self.product.yimei_buwei = orderedSet;
        [self.detailTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:kProjectYimeiSectionBuwei]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didBuweiEditFinished:(CDYimeiBuwei*)buwei
{
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
    [orderedSet addObject:buwei];
    self.product.yimei_buwei = orderedSet;
    [self.detailTableView reloadData];
    //[self.detailTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.product.yimei_buwei.count inSection:kProjectYimeiSectionBuwei]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)clearPointsAndCouponCard
{
    self.couponCard.remainAmount = [NSNumber numberWithFloat:(self.couponCard.remainAmount.floatValue + self.couponDiscount)];
    self.couponDiscount = 0.0;
    self.product.coupon_deduction = [NSNumber numberWithFloat:0.0];
    self.memberCard.points = [NSString stringWithFormat:@"%.0f",(self.memberCard.points.floatValue + self.pointDiscount)];
    self.pointDiscount = 0.0;
    self.product.point_deduction = [NSNumber numberWithFloat:0.0];
    [[BSCoreDataManager currentManager] save:nil];
    [self.detailTableView reloadData];
}
@end

