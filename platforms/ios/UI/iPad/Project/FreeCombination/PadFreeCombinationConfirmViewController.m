//
//  PadFreeCombinationConfirmViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/10/28.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadFreeCombinationConfirmViewController.h"
#import "PadProjectConstant.h"
#import "UIImage+Resizable.h"
#import "BSProjectItemCreateRequest.h"
#import "PadOperateSuccessViewController.h"

#define kPadMaskViewHalfContentWidth    (kPadMaskViewContentWidth - 32.0)/2.0

@interface PadFreeCombinationConfirmViewController ()

@property (nonatomic, strong) NSOrderedSet *products;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) UITextField *customName;
@property (nonatomic, strong) UITextField *cardDeduct;
@property (nonatomic, strong) UITextField *fixedCardDeduct;
@property (nonatomic, strong) UITextField *notCardDeduct;
@property (nonatomic, strong) UITextField *notFixedCardDeduct;

@end


@implementation PadFreeCombinationConfirmViewController

- (id)initWithProducts:(NSOrderedSet *)products totalPrice:(CGFloat)totalPrice
{
    self = [super initWithNibName:@"PadFreeCombinationConfirmViewController" bundle:nil];
    if (self)
    {
        self.products = products;
        self.totalPrice = totalPrice;
        self.projectName = @"[PX000119] 养肝护胆疗法";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
    
    [self initDetailScrollView];
    [self initNaviBar];
}


#pragma mark-
#pragma mark Required Methods

- (void)initDetailScrollView
{
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight - 32.0 - 60.0 - 32.0)];
    self.detailScrollView.backgroundColor = [UIColor clearColor];
    self.detailScrollView.scrollEnabled = YES;
    self.detailScrollView.showsVerticalScrollIndicator = NO;
    self.detailScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.detailScrollView];
    
    CGFloat originY = 28.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadCreateItemCustomName");
    [self.detailScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.detailScrollView addSubview:background];
    
    self.customName = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, background.frame.size.width - 2 * 20.0, background.frame.size.height)];;
    self.customName.backgroundColor = [UIColor clearColor];
    self.customName.font = [UIFont systemFontOfSize:16.0];
    self.customName.textAlignment = NSTextAlignmentCenter;
    self.customName.placeholder = LS(@"PadCreateItemCustomName");
    self.customName.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.customName.delegate = self;
    [background addSubview:self.customName];
    originY += 60.0 + 28.0;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [self.detailScrollView addSubview:lineImageView];
    originY += 28.0;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewHalfContentWidth, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = COLOR(149.0, 171.0, 171.0, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = LS(@"PadCommissionPercentage");
    [self.detailScrollView addSubview:titleLabel];
    originY += 20.0 + 12.0;
    
    background = [[UIImageView alloc] initWithFrame:CGRectMake(kPadMaskLeftRightMarginWidth, originY, kPadMaskViewContentWidth, 60.0 * 4)];
    background.backgroundColor = [UIColor clearColor];
    background.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    background.userInteractionEnabled = YES;
    [self.detailScrollView addSubview:background];
    
    originY = 0.0;
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadMaskViewHalfContentWidth + 120.0 - 8.0, 60.0)];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.textAlignment = NSTextAlignmentLeft;
    itemLabel.font = [UIFont systemFontOfSize:16.0];
    itemLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    itemLabel.text = LS(@"PadCardDeduct");
    [background addSubview:itemLabel];
    
    self.cardDeduct = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, originY, kPadMaskViewHalfContentWidth - 120.0, 60.0)];
    self.cardDeduct.backgroundColor = [UIColor clearColor];
    self.cardDeduct.font = [UIFont systemFontOfSize:16.0];
    self.cardDeduct.textAlignment = NSTextAlignmentRight;
    self.cardDeduct.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.cardDeduct.delegate = self;
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, 60.0 - 2.0)];
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.textAlignment = NSTextAlignmentRight;
    percentLabel.font = [UIFont systemFontOfSize:16.0];
    percentLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    percentLabel.text = @"%";
    self.cardDeduct.rightView = percentLabel;
    self.cardDeduct.rightViewMode = UITextFieldViewModeAlways;
    self.cardDeduct.text = [NSString stringWithFormat:@"%.2f", 0.0];
    [background addSubview:self.cardDeduct];
    originY += 60.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, kPadMaskViewContentWidth, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [background addSubview:lineImageView];
    
    itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadMaskViewHalfContentWidth + 120.0 - 8.0, 60.0)];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.textAlignment = NSTextAlignmentLeft;
    itemLabel.font = [UIFont systemFontOfSize:16.0];
    itemLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    itemLabel.text = LS(@"PadFixedCardDeduct");
    [background addSubview:itemLabel];
    
    self.fixedCardDeduct = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, originY, kPadMaskViewHalfContentWidth - 120.0, 60.0)];
    self.fixedCardDeduct.backgroundColor = [UIColor clearColor];
    self.fixedCardDeduct.font = [UIFont systemFontOfSize:16.0];
    self.fixedCardDeduct.textAlignment = NSTextAlignmentRight;
    self.fixedCardDeduct.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.fixedCardDeduct.delegate = self;
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 12.0, 60.0 - 2.0)];
    symbolLabel.backgroundColor = [UIColor clearColor];
    symbolLabel.textAlignment = NSTextAlignmentLeft;
    symbolLabel.font = [UIFont systemFontOfSize:16.0];
    symbolLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    symbolLabel.text = LS(@"PadMoneySymbol");
    self.fixedCardDeduct.leftView = symbolLabel;
    self.fixedCardDeduct.leftViewMode = UITextFieldViewModeAlways;
    self.fixedCardDeduct.text = [NSString stringWithFormat:@"%.2f", 0.0];
    [background addSubview:self.fixedCardDeduct];
    originY += 60.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, kPadMaskViewContentWidth, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [background addSubview:lineImageView];
    
    itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadMaskViewHalfContentWidth + 120.0 - 8.0, 60.0)];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.textAlignment = NSTextAlignmentLeft;
    itemLabel.font = [UIFont systemFontOfSize:16.0];
    itemLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    itemLabel.text = LS(@"PadNotCardDeduct");
    [background addSubview:itemLabel];
    
    self.notCardDeduct = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, originY, kPadMaskViewHalfContentWidth - 120.0, 60.0)];
    self.notCardDeduct.backgroundColor = [UIColor clearColor];
    self.notCardDeduct.font = [UIFont systemFontOfSize:16.0];
    self.notCardDeduct.textAlignment = NSTextAlignmentRight;
    self.notCardDeduct.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.notCardDeduct.delegate = self;
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, 60.0 - 2.0)];
    percentLabel.backgroundColor = [UIColor clearColor];
    percentLabel.textAlignment = NSTextAlignmentRight;
    percentLabel.font = [UIFont systemFontOfSize:16.0];
    percentLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    percentLabel.text = @"%";
    self.notCardDeduct.rightView = percentLabel;
    self.notCardDeduct.rightViewMode = UITextFieldViewModeAlways;
    self.notCardDeduct.text = [NSString stringWithFormat:@"%.2f", 0.0];
    [background addSubview:self.notCardDeduct];
    originY += 60.0;
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY - 0.5, kPadMaskViewContentWidth, 0.5)];
    lineImageView.backgroundColor = COLOR(220.0, 230.0, 230.0, 1.0);
    [background addSubview:lineImageView];
    
    itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, originY, kPadMaskViewHalfContentWidth + 120.0 - 8.0, 60.0)];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.textAlignment = NSTextAlignmentLeft;
    itemLabel.font = [UIFont systemFontOfSize:16.0];
    itemLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    itemLabel.text = LS(@"PadNotFixedCardDeduct");
    [background addSubview:itemLabel];
    
    self.notFixedCardDeduct = [[UITextField alloc] initWithFrame:CGRectMake(background.frame.size.width - 20.0 - kPadMaskViewHalfContentWidth + 120.0, originY, kPadMaskViewHalfContentWidth - 120.0, 60.0)];
    self.notFixedCardDeduct.backgroundColor = [UIColor clearColor];
    self.notFixedCardDeduct.font = [UIFont systemFontOfSize:16.0];
    self.notFixedCardDeduct.textAlignment = NSTextAlignmentRight;
    self.notFixedCardDeduct.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.notFixedCardDeduct.delegate = self;
    symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 12.0, 60.0 - 2.0)];
    symbolLabel.backgroundColor = [UIColor clearColor];
    symbolLabel.textAlignment = NSTextAlignmentLeft;
    symbolLabel.font = [UIFont systemFontOfSize:16.0];
    symbolLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    symbolLabel.text = LS(@"PadMoneySymbol");
    self.notFixedCardDeduct.leftView = symbolLabel;
    self.notFixedCardDeduct.leftViewMode = UITextFieldViewModeAlways;
    self.notFixedCardDeduct.text = [NSString stringWithFormat:@"%.2f", 0.0];
    [background addSubview:self.notFixedCardDeduct];
    if (background.frame.origin.y + background.frame.size.height + 32.0 > self.detailScrollView.frame.size.height)
    {
        self.detailScrollView.contentSize = CGSizeMake(self.detailScrollView.frame.size.width, background.frame.origin.y + background.frame.size.height + 32.0);
    }
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
    closeButton.backgroundColor = [UIColor clearColor];
    closeButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(didCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:closeButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, (kPadNaviHeight - 24.0)/2.0, self.view.frame.size.width - kPadNaviHeight - 90.0, 24.0)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCreateConfirmTitle"), self.totalPrice, 3];
    [navi addSubview:self.titleLabel];
    
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
    
    [self refreshNaviTitle];
}


#pragma mark -
#pragma mark Required Methods

- (void)refreshNaviTitle
{
    self.titleLabel.text = [NSString stringWithFormat:LS(@"PadCreateConfirmTitle"), self.totalPrice, self.products.count];
}

- (void)didCloseButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.customName.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"名称不能为空")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.customName.text forKey:@"name"];
    [params setObject:[NSNumber numberWithInteger:kPadBornFreeCombination] forKey:@"born_category"];
    CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:[NSNumber numberWithInteger:kPadBornFreeCombination] forKey:@"code"];
    [params setObject:bornCategory.bornCategoryID forKey:@"category_id"];
    [params setObject:bornCategory.type forKey:@"born_category_type"];
    [params setObject:[NSNumber numberWithFloat:self.totalPrice] forKey:@"list_price"];
    [params setObject:@"product" forKey:@"type"];
    NSArray *subItems = [self subItemsParams];
    if (subItems.count != 0)
    {
        [params setObject:subItems forKey:@"pack_line_ids"];
    }
    
    BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithParams:params];
    request.useTemplate = TRUE;
    [request execute];
}

- (NSArray *)subItemsParams
{
    NSMutableArray *params = [NSMutableArray array];
    for (int i = 0; i < self.products.count; i++)
    {
        CDPosProduct *product = [self.products objectAtIndex:i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     product.product_id, @"product_id",
                                     [NSNumber numberWithFloat:product.product_price.floatValue], @"lst_price",
                                     [NSNumber numberWithInteger:product.product_qty.integerValue], @"quantity", nil];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"limited_qty"];
        [params addObject:@[[NSNumber numberWithInteger:kBSDataAdded], [NSNumber numberWithBool:NO], dict]];
    }
    
    return params;
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSProjectItemCreateResponse])
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self.maskView hidden];
//            [self.navigationController.view removeFromSuperview];
//            PadOperateSuccessViewController *viewController = [[PadOperateSuccessViewController alloc] initWithOperateType:kPadFreeCombinationCreateSuccess detail:self.projectName amount:self.totalPrice];
//            viewController.maskView = self.maskView;
//            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
//            self.maskView.navi.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
//            [self.maskView addSubview:self.maskView.navi.view];
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
}

@end
