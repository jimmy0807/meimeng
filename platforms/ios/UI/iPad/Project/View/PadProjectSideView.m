//
//  PadProjectSideView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectSideView.h"

typedef enum kPadProjectSideSectionType
{
    kPadProjectSideSectionBuy,
    kPadProjectSideSectionUse,
    kPadProjectSideSectionCheck,
    kPadProjectSideSectionCailiao,
    kPadProjectSideSectionCount
}kPadProjectSideSectionType;

@interface PadProjectSideView ()

@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) UITableView *cartTableView;

@property (nonatomic, strong) UIButton *settleButton;
@property (nonatomic, strong) UIButton *guadanButton;
@property (nonatomic, strong) UIButton *addItemButton;
@property (nonatomic, strong) NSMutableArray *buyProdArray;
@property (nonatomic, strong) NSMutableArray *checkItemArray;
@property (nonatomic, strong) NSMutableArray *consumeItemArray;

@end

@implementation PadProjectSideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat height = [self setYimeiHeader];
        
        self.cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, self.frame.size.width, self.frame.size.height - kPadConfirmButtonHeight - height) style:UITableViewStylePlain];
        self.cartTableView.backgroundColor = [UIColor whiteColor];
        self.cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.cartTableView.dataSource = self;
        self.cartTableView.delegate = self;
        self.cartTableView.showsVerticalScrollIndicator = NO;
        self.cartTableView.showsHorizontalScrollIndicator = NO;
        self.cartTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.cartTableView];
        
        if ([PersonalProfile currentProfile].is_post_checkout)
        {
            self.guadanButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - kPadConfirmButtonHeight, self.frame.size.width, kPadConfirmButtonHeight)];
            self.guadanButton.backgroundColor = [UIColor clearColor];
//            [self.guadanButton setBackgroundImage:[UIImage imageNamed:@"pad_guadan_button_n"] forState:UIControlStateNormal];
//            [self.guadanButton setBackgroundImage:[UIImage imageNamed:@"pad_guadan_button_n"] forState:UIControlStateHighlighted];
            [self.guadanButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
            [self.guadanButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateHighlighted];
            [self.guadanButton addTarget:self action:@selector(didGuadanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.guadanButton];
            
            //UILabel *guadanLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, (kPadConfirmButtonHeight - 20.0)/2.0, 64.0, 20.0)];
            UILabel *guadanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (kPadConfirmButtonHeight - 20.0)/2.0, self.frame.size.width, 20.0)];
            guadanLabel.backgroundColor = [UIColor clearColor];
            guadanLabel.textColor = [UIColor whiteColor];
            guadanLabel.textAlignment = NSTextAlignmentCenter;
            guadanLabel.font = [UIFont boldSystemFontOfSize:17.0];
            guadanLabel.text = @"挂单";
            guadanLabel.tag = 104;
            [self.guadanButton addSubview:guadanLabel];
        }
        
        //self.settleButton = [[UIButton alloc] initWithFrame:CGRectMake(70.0, self.frame.size.height - kPadConfirmButtonHeight, self.frame.size.width - 70, kPadConfirmButtonHeight)];
        if (![PersonalProfile currentProfile].is_post_checkout)
        {
            self.settleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - kPadConfirmButtonHeight, self.frame.size.width, kPadConfirmButtonHeight)];
            self.settleButton.backgroundColor = [UIColor clearColor];
            [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
            [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
            [self.settleButton addTarget:self action:@selector(didSettleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.settleButton];
        }
        
        
        UILabel *settleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, (kPadConfirmButtonHeight - 20.0)/2.0, 64.0, 20.0)];
        settleLabel.backgroundColor = [UIColor clearColor];
        settleLabel.textColor = [UIColor whiteColor];
        settleLabel.textAlignment = NSTextAlignmentLeft;
        settleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        settleLabel.text = LS(@"PadSettleTitle");
        settleLabel.tag = 101;
        [self.settleButton addSubview:settleLabel];
        
        UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 20.0)/2.0 + 2.0, 12.0, 12.0)];
        if ([PersonalProfile currentProfile].is_post_checkout)
        {
            symbolLabel.frame = CGRectMake(24.0 + 64.0  - 70.0, (kPadConfirmButtonHeight - 20.0)/2.0 + 2.0, 12.0, 12.0);
        }
        symbolLabel.backgroundColor = [UIColor clearColor];
        symbolLabel.textColor = [UIColor whiteColor];
        symbolLabel.textAlignment = NSTextAlignmentLeft;
        symbolLabel.font = [UIFont systemFontOfSize:14.0];
        symbolLabel.text = LS(@"PadMoneySymbol");
        symbolLabel.tag = 102;
        [self.settleButton addSubview:symbolLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 24.0)/2.0, self.frame.size.width - 2 * 24.0 - 64.0, 24.0)];
        if ([PersonalProfile currentProfile].is_post_checkout)
        {
            priceLabel.frame = CGRectMake(24.0 + 64.0 - 70.0, (kPadConfirmButtonHeight - 24.0)/2.0, self.frame.size.width - 2 * 24.0 - 64.0, 24.0);
        }
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont systemFontOfSize:20.0];
        priceLabel.tag = 103;
        [self.settleButton addSubview:priceLabel];
        self.checkItemArray = [[NSMutableArray alloc] init];
        self.consumeItemArray = [[NSMutableArray alloc] init];
        self.buyProdArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (CGFloat)setYimeiHeader
{
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        v.backgroundColor = COLOR(168, 228, 228, 1);
        [self addSubview:v];
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, self.frame.size.width / 2, v.frame.size.height);
        leftButton.backgroundColor = COLOR(96, 211, 212, 1);
        leftButton.adjustsImageWhenHighlighted = NO;
        [leftButton setTitle:@"新建项目" forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        [leftButton addTarget:self action:@selector(didLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"yimei_product_create_item"] forState:UIControlStateNormal];
        //[v addSubview:leftButton];
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0 , self.frame.size.width, v.frame.size.height);
        rightButton.backgroundColor = COLOR(96, 211, 212, 1);
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitle:@"选医生" forState:UIControlStateNormal];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        [rightButton addTarget:self action:@selector(didRightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"yimei_product_create_keshi"] forState:UIControlStateNormal];
        [v addSubview:rightButton];
        
        return 60;
    }
    else
    {
        return 0;
    }
}

- (void)didLeftButtonPressed:(id)sender
{
    [self.delegate didProjectSideYiMeiLeftButtonPressed];
}

- (void)didRightButtonPressed:(id)sender
{
    [self.delegate didProjectSideYiMeiRightButtonPressed];
}

#pragma mark -
#pragma mark public Methods


- (void)reloadProjectSideViewWithData:(PadProjectData *)data
{
    self.data = data;
    [self.buyProdArray removeAllObjects];
    [self.checkItemArray removeAllObjects];
    [self.consumeItemArray removeAllObjects];
    NSLog(@"%@",self.data.posOperate.products);
    for (CDPosProduct *product in self.data.posOperate.products)
    {
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
        
        if ([projectItem.is_check_service boolValue])
        {
            CDProjectCheck *check = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCheck" withValue:[NSNumber numberWithInt:[projectItem.itemID intValue]] forKey:@"productID"];
            product.qty = check.qty;
            [self.checkItemArray addObject:product];
        }
        else if ([projectItem.is_consumables boolValue])
        {
            CDProjectConsumable *consume = [[BSCoreDataManager currentManager] findEntity:@"CDProjectConsumable" withValue:[NSNumber numberWithInt:[projectItem.itemID intValue]] forKey:@"productID"];
            product.qty = consume.qty;
            [self.consumeItemArray addObject:product];
        }
        else
        {
            [self.buyProdArray addObject:product];
        }
        
        if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
        {
        }
        
    }
    NSLog(@"%@",self.data.posOperate.useItems);
    for (CDCurrentUseItem *item in self.data.posOperate.useItems) {
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:item.itemID forKey:@"itemID"];
        if ([projectItem.is_check_service boolValue]) {
            CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
            useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
            useItem.projectItem = projectItem;
            useItem.itemID = projectItem.itemID;
            useItem.itemName = projectItem.itemName;
            useItem.uomName = projectItem.uomName;
            useItem.defaultCode = projectItem.defaultCode;
            //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
            //useItem.useCount = [NSNumber numberWithInteger:1];
            CDProjectCheck *check = [[BSCoreDataManager currentManager] findEntity:@"CDProjectCheck" withValue:[NSNumber numberWithInt:[useItem.itemID intValue]] forKey:@"productID"];
            useItem.useCount = check.qty;
            [self.checkItemArray addObject:useItem];
        }
        if ([projectItem.is_consumables boolValue]) {
            CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
            useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
            useItem.projectItem = projectItem;
            useItem.itemID = projectItem.itemID;
            useItem.itemName = projectItem.itemName;
            useItem.uomName = projectItem.uomName;
            useItem.defaultCode = projectItem.defaultCode;
            //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
            CDProjectConsumable *consume = [[BSCoreDataManager currentManager] findEntity:@"CDProjectConsumable" withValue:[NSNumber numberWithInt:[useItem.itemID intValue]] forKey:@"productID"];
            useItem.useCount = consume.qty;
            [self.consumeItemArray addObject:useItem];
        }
        //        for (NSString *checkId in [item.check_ids componentsSeparatedByString:@","]) {
        //            CDProjectItem *checkItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:(int)checkId] forKey:@"itemID"];
        //            [self.checkItemArray addObject:checkItem];
        //        }
//        if ([projectItem.consumables_ids componentsSeparatedByString:@","].count > 0)
//        {
//            for (NSString *consumeId in [projectItem.consumables_ids componentsSeparatedByString:@","]) {
//                if ([consumeId length] == 0)
//                {
//                    break;
//                }
//                NSLog(@"%@",[NSNumber numberWithInt:[consumeId intValue]]);
//                CDProjectItem *consumeItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:[consumeId intValue]] forKey:@"itemID"];
//                CDCurrentUseItem *useItem = [[BSCoreDataManager currentManager] insertEntity:@"CDCurrentUseItem"];
//                useItem.type = [NSNumber numberWithInteger:kPadUseItemCurrentPurchase];
//                useItem.projectItem = consumeItem;
//                useItem.itemID = consumeItem.itemID;
//                useItem.itemName = consumeItem.itemName;
//                useItem.uomName = consumeItem.uomName;
//                useItem.defaultCode = consumeItem.defaultCode;
//                //useItem.totalCount = [NSNumber numberWithInteger:project.projectCount.integerValue];
//                useItem.useCount = [NSNumber numberWithInteger:1];
//                [self.consumeItemArray addObject:useItem];
//            }
//        }
    }
    
    /*

    for (CDPosProduct *product in self.data.posOperate.products)
    {
        
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
        if ([projectItem.is_check_service boolValue]) {
            [self.checkItemArray addObject:projectItem];
        }
        else if ([projectItem.is_consumables boolValue]) {
            [self.consumeItemArray addObject:projectItem];
        }
        else
        {
            [self.buyProdArray addObject:product];
        }
    }
    for (CDCurrentUseItem *item in self.data.posOperate.useItems) {
        CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:item.itemID forKey:@"itemID"];
//        for (NSString *checkId in [item.check_ids componentsSeparatedByString:@","]) {
//            CDProjectItem *checkItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:(int)checkId] forKey:@"itemID"];
//            [self.checkItemArray addObject:checkItem];
//        }
        if ([projectItem.consumables_ids componentsSeparatedByString:@","].count > 0)
        {
            for (NSString *consumeId in [projectItem.consumables_ids componentsSeparatedByString:@","]) {
                if ([consumeId length] == 0)
                {
                    break;
                }
                CDProjectItem *consumeItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[NSNumber numberWithInt:(int)consumeId] forKey:@"itemID"];
                [self.consumeItemArray addObject:consumeItem];
            }
        }
    }
    
    NSLog(@"%@",self.consumeItemArray);
     */
    [self.cartTableView reloadData];
    [self refreshSettleButton];
}

- (void)refreshSettleButton
{
    UILabel *settleLabel = (UILabel *)[self.settleButton viewWithTag:101];
    UILabel *symbolLabel = (UILabel *)[self.settleButton viewWithTag:102];
    UILabel *priceLabel = (UILabel *)[self.settleButton viewWithTag:103];
    UILabel *settleLabel2 = (UILabel *)[self.addItemButton viewWithTag:101];
    UILabel *symbolLabel2 = (UILabel *)[self.addItemButton viewWithTag:102];
    UILabel *priceLabel2 = (UILabel *)[self.addItemButton viewWithTag:103];
    if (self.data.posOperate.products.count == 0 && self.data.posOperate.useItems.count == 0)
    {
        settleLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        symbolLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        priceLabel.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
        [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
        [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateHighlighted];
        if (self.isAddItem) {
            settleLabel2.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
            symbolLabel2.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
            priceLabel2.textColor = COLOR(168.0, 205.0, 205.0, 1.0);
            [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateNormal];
            [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_disable_button_n"] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        settleLabel.textColor = [UIColor whiteColor];
        symbolLabel.textColor = [UIColor whiteColor];
        priceLabel.textColor = [UIColor whiteColor];
        [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.settleButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
        if (self.isAddItem) {
            settleLabel2.textColor = [UIColor whiteColor];
            symbolLabel2.textColor = [UIColor whiteColor];
            priceLabel2.textColor = [UIColor whiteColor];
            [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
            [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
        }
    }
    
    priceLabel.text = [NSString stringWithFormat:@"%.2f", self.data.posOperate.amount.doubleValue];;
    CGSize minSize = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(1024.0, priceLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    if ([PersonalProfile currentProfile].is_post_checkout)
    {
        symbolLabel.frame = CGRectMake(self.frame.size.width - 24.0 - minSize.width - 12.0 - 70.0, symbolLabel.frame.origin.y, symbolLabel.frame.size.width, symbolLabel.frame.size.height);
    }
    else
    {
        symbolLabel.frame = CGRectMake(self.frame.size.width - 24.0 - minSize.width - 12.0, symbolLabel.frame.origin.y, symbolLabel.frame.size.width, symbolLabel.frame.size.height);
    }
    if (self.isAddItem) {

        priceLabel2.text = [NSString stringWithFormat:@"%.2f", self.data.posOperate.amount.doubleValue];;
        CGSize minSize2 = [priceLabel2.text sizeWithFont:priceLabel2.font constrainedToSize:CGSizeMake(1024.0, priceLabel2.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
        symbolLabel2.frame = CGRectMake(self.frame.size.width - 24.0 - minSize2.width - 12.0 - 70.0, symbolLabel2.frame.origin.y, symbolLabel2.frame.size.width, symbolLabel2.frame.size.height);
    }

}

- (void)updateFrame
{
    if (self.isAddItem) {
        self.addItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - kPadConfirmButtonHeight, self.frame.size.width, kPadConfirmButtonHeight)];
        self.addItemButton.backgroundColor = [UIColor clearColor];
        [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
        [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
        [self.addItemButton addTarget:self action:@selector(didSettleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        self.settleButton.hidden = YES;
        self.guadanButton.hidden = YES;
        UILabel *settleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0, (kPadConfirmButtonHeight - 20.0)/2.0, 64.0, 20.0)];
        settleLabel.backgroundColor = [UIColor clearColor];
        settleLabel.textColor = [UIColor whiteColor];
        settleLabel.textAlignment = NSTextAlignmentLeft;
        settleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        settleLabel.text = @"添加";
        settleLabel.tag = 101;
        [self.addItemButton addSubview:settleLabel];
        
        UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 20.0)/2.0 + 2.0, 12.0, 12.0)];
        symbolLabel.backgroundColor = [UIColor clearColor];
        symbolLabel.textColor = [UIColor whiteColor];
        symbolLabel.textAlignment = NSTextAlignmentLeft;
        symbolLabel.font = [UIFont systemFontOfSize:14.0];
        symbolLabel.text = LS(@"PadMoneySymbol");
        symbolLabel.tag = 102;
        [self.addItemButton addSubview:symbolLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 64.0, (kPadConfirmButtonHeight - 24.0)/2.0, self.frame.size.width - 2 * 24.0 - 64.0, 24.0)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.font = [UIFont systemFontOfSize:20.0];
        priceLabel.tag = 103;
        [self.addItemButton addSubview:priceLabel];
        
        [self addSubview:self.addItemButton];
        [self refreshSettleButton];
    }
}

#pragma mark -
#pragma mark Required Methods

- (void)didSettleButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideSettleButtonClick:)])
    {
        if (self.isGuadanAddItem)
        {
            [self.delegate isGuadanActive:YES];
        }
        else
        {
            [self.delegate isGuadanActive:NO];
        }
        [self.delegate didProjectSideSettleButtonClick:self.data.posOperate];
    }
}

- (void)didGuadanButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideSettleButtonClick:)])
    {
        //[self.delegate didProjectSideSettleButtonClick:self.data.posOperate];
        UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"是否确认要挂单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL isContainingUse = NO;
            for (CDPosProduct *product in self.data.posOperate.products)
            {
                CDProjectItem *projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:product.product_id forKey:@"itemID"];
                if (projectItem.bornCategory.integerValue == kPadBornCategoryProject)
                {
                    isContainingUse = YES;
                }
            }
            if (self.data.posOperate.useItems.count == 0 && !isContainingUse)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该产品不能挂单" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [self.delegate isGuadanActive:YES];
            [self.delegate didProjectSideSettleButtonClick:self.data.posOperate];
        }];
        [alertControll addAction:cancel];
        [alertControll addAction:save];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
        
        NSLog(@"%@",self.data.posOperate);
        
    }
}

- (void)didAddItemButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideSettleButtonClick:)])
    {
        [self.delegate isAddItemActive:YES];
        [self.delegate didProjectSideSettleButtonClick:self.data.posOperate];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPadProjectSideSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kPadProjectSideSectionBuy)
    {
        //return self.data.posOperate.products.count;
        return self.buyProdArray.count;
        
    }
    else if (section == kPadProjectSideSectionUse)
    {
        NSLog(@"%@",self.data.posOperate);
        NSLog(@"%@",self.data.posOperate.useItems);
        return self.data.posOperate.useItems.count;
    }
    else if (section == kPadProjectSideSectionCheck)
    {
        return self.checkItemArray.count;
    }
    else if (section == kPadProjectSideSectionCailiao)
    {
        return self.consumeItemArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPadProjectSideSectionBuy)
    {
        CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:indexPath.row];
        if ( product.yimei_buwei.count == 0 )
        {
            return kPadProjectSideCellHeight;
        }
        else
        {
            return kPadProjectSideCellHeight + 30;
        }
    }
    else if (indexPath.section == kPadProjectSideSectionUse)
    {
        CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:indexPath.row];
        if ( useItem.yimei_buwei.count == 0 )
        {
            return kPadProjectSideCellHeight;
        }
        else
        {
            return kPadProjectSideCellHeight + 30;
        }
    }
    
    return kPadProjectSideCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kPadProjectSideSectionUse)
    {
        if (self.data.posOperate.useItems.count == 0)
        {
            return 0.0;
        }
        else
        {
            return 32.0;
        }
    }
    else if (section == kPadProjectSideSectionCheck)
    {
        if (self.checkItemArray.count == 0)
        {
            return 0.0;
        }
        else
        {
            return 32.0;
        }
    }
    else if (section == kPadProjectSideSectionCailiao)
    {
        if (self.consumeItemArray.count == 0)
        {
            return 0.0;
        }
        else
        {
            return 32.0;
        }
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0, self.frame.size.width, 33.0)];
    headerView.backgroundColor = COLOR(169.0, 205.0, 205.0, 1.0);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 1.0, kPadProjectSideCellWidth - 2 * 24.0, 32.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    if (section == kPadProjectSideSectionUse)
    {
        titleLabel.text = @"卡扣项目";
    }
    else if (section == kPadProjectSideSectionCheck)
    {
        titleLabel.text = @"检查";
    }
    else
    {
        titleLabel.text = @"材料";
    }
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadProjectSideCellIdentifier";
    PadProjectSideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadProjectSideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.symbolLabel.hidden = NO;
    cell.priceLabel.hidden = NO;
    if (indexPath.section == kPadProjectSideSectionBuy)
    {
        CDPosProduct *product = (CDPosProduct *)[self.buyProdArray objectAtIndex:indexPath.row];
        //CDPosProduct *product = (CDPosProduct *)[self.data.posOperate.products objectAtIndex:indexPath.row];
        if (product.defaultCode.length != 0 && ![product.defaultCode isEqualToString:@"0"])
        {
            cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), product.defaultCode, product.product.itemName];
        }
        else
        {
            cell.titleLabel.text = product.product.itemName;
        }
        
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), product.product_qty.integerValue];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", product.product_price.floatValue * product.product_qty.integerValue - product.point_deduction.floatValue - product.coupon_deduction.floatValue];
        if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
        {
            cell.useLabel.text = @"本次使用";
        }
        else
        {
            cell.useLabel.text = @"";
        }
        
        if ( product.yimei_buwei.count == 0 )
        {
            cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
            cell.buweiLabel.text = @"";
        }
        else
        {
            cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
            
            NSMutableString* title = [NSMutableString string];
            //cell.buwei = buwei;
            for ( CDYimeiBuwei* buwei in product.yimei_buwei )
            {
                [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
            }
            cell.buweiLabel.text = title;
        }
        
    }
    else if (indexPath.section == kPadProjectSideSectionUse)
    {
        cell.symbolLabel.hidden = YES;
        cell.priceLabel.hidden = YES;
        CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:indexPath.row];
        if (useItem.defaultCode.length != 0 && ![useItem.defaultCode isEqualToString:@"0"])
        {
            cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), useItem.defaultCode, useItem.projectItem.itemName];
        }
        else
        {
            cell.titleLabel.text = useItem.projectItem.itemName;
        }
        cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), useItem.useCount.integerValue];
        cell.useLabel.text = @"本次使用";
        
        if ( useItem.yimei_buwei.count == 0 )
        {
            cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
            cell.buweiLabel.text = @"";
        }
        else
        {
            cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
            
            NSMutableString* title = [NSMutableString string];

            for ( CDYimeiBuwei* buwei in useItem.yimei_buwei )
            {
                [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
            }
            cell.buweiLabel.text = title;
        }
        
        //cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", useItem.projectItem.totalPrice.floatValue * useItem.useCount.integerValue];
    }
    else if (indexPath.section == kPadProjectSideSectionCheck)
    {
        cell.symbolLabel.hidden = YES;
        //cell.priceLabel.hidden = YES;
        if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
        {
            CDPosProduct *product = (CDPosProduct *)[self.checkItemArray objectAtIndex:indexPath.row];
            if (product.defaultCode.length != 0 && ![product.defaultCode isEqualToString:@"0"])
            {
                cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), product.defaultCode, product.product.itemName];
            }
            else
            {
                cell.titleLabel.text = product.product.itemName;
            }
            
            cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), product.product_qty.integerValue];
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", product.product_price.floatValue * product.product_qty.integerValue - product.point_deduction.floatValue - product.coupon_deduction.floatValue];
            if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
            {
                cell.useLabel.text = @"本次使用";
            }
            else
            {
                cell.useLabel.text = @"";
            }
            
            if ( product.yimei_buwei.count == 0 )
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
                cell.buweiLabel.text = @"";
            }
            else
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
                
                NSMutableString* title = [NSMutableString string];
                //cell.buwei = buwei;
                for ( CDYimeiBuwei* buwei in product.yimei_buwei )
                {
                    [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
                }
                cell.buweiLabel.text = title;
            }
        }
        else if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
        {
            cell.symbolLabel.hidden = YES;
            cell.priceLabel.hidden = YES;
            CDCurrentUseItem *useItem = [self.checkItemArray objectAtIndex:indexPath.row];
            if (useItem.defaultCode.length != 0 && ![useItem.defaultCode isEqualToString:@"0"])
            {
                cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), useItem.defaultCode, useItem.projectItem.itemName];
            }
            else
            {
                cell.titleLabel.text = useItem.projectItem.itemName;
            }
            cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), useItem.useCount.integerValue];
            cell.useLabel.text = @"本次使用";
            
            if ( useItem.yimei_buwei.count == 0 )
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
                cell.buweiLabel.text = @"";
            }
            else
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
                
                NSMutableString* title = [NSMutableString string];
                
                for ( CDYimeiBuwei* buwei in useItem.yimei_buwei )
                {
                    [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
                }
                cell.buweiLabel.text = title;
            }
        }
    }
    else if (indexPath.section == kPadProjectSideSectionCailiao)
    {
        if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
        {
            CDPosProduct *product = (CDPosProduct *)[self.consumeItemArray objectAtIndex:indexPath.row];

            if (product.defaultCode.length != 0 && ![product.defaultCode isEqualToString:@"0"])
            {
                cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), product.defaultCode, product.product.itemName];
            }
            else
            {
                cell.titleLabel.text = product.product.itemName;
            }
            
            cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), product.product_qty.integerValue];
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", product.product_price.floatValue * product.product_qty.integerValue - product.point_deduction.floatValue - product.coupon_deduction.floatValue];
            if ( product.product.bornCategory.integerValue == kPadBornCategoryProject )
            {
                cell.useLabel.text = @"本次使用";
            }
            else
            {
                cell.useLabel.text = @"";
            }
            
            if ( product.yimei_buwei.count == 0 )
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
                cell.buweiLabel.text = @"";
            }
            else
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
                
                NSMutableString* title = [NSMutableString string];
                //cell.buwei = buwei;
                for ( CDYimeiBuwei* buwei in product.yimei_buwei )
                {
                    [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
                }
                cell.buweiLabel.text = title;
            }
        }
        else if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
        {
            cell.symbolLabel.hidden = YES;
            cell.priceLabel.hidden = YES;
            CDCurrentUseItem *useItem = [self.consumeItemArray objectAtIndex:indexPath.row];
            if (useItem.defaultCode.length != 0 && ![useItem.defaultCode isEqualToString:@"0"])
            {
                cell.titleLabel.text = [NSString stringWithFormat:LS(@"PadItemInternalAndName"), useItem.defaultCode, useItem.projectItem.itemName];
            }
            else
            {
                cell.titleLabel.text = useItem.projectItem.itemName;
            }
            cell.numberLabel.text = [NSString stringWithFormat:LS(@"PadPosProductNum"), useItem.useCount.integerValue];
            cell.useLabel.text = @"本次使用";
            
            if ( useItem.yimei_buwei.count == 0 )
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0, kPadProjectSideCellWidth, 1.0);
                cell.buweiLabel.text = @"";
            }
            else
            {
                cell.lineImageView.frame = CGRectMake(0.0, kPadProjectSideCellHeight - 1.0 + 30, kPadProjectSideCellWidth, 1.0);
                
                NSMutableString* title = [NSMutableString string];
                
                for ( CDYimeiBuwei* buwei in useItem.yimei_buwei )
                {
                    [title appendFormat:@"%@[%@]  ",buwei.name, buwei.count];
                }
                cell.buweiLabel.text = title;
            }
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == kPadProjectSideSectionBuy)
        {
            CDPosProduct *product = (CDPosProduct *)[self.buyProdArray objectAtIndex:indexPath.row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideCellDelete:)])
            {
                [self.delegate didProjectSideCellDelete:product];
            }
        }
        else if (indexPath.section == kPadProjectSideSectionUse)
        {
            CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:indexPath.row];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemDelete:)])
            {
                [self.delegate didProjectSideUseItemDelete:useItem];
            }
        }
        else if (indexPath.section == kPadProjectSideSectionCheck)
        {
            if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
            {
                CDPosProduct *product = (CDPosProduct *)[self.checkItemArray objectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideCellDelete:)])
                {
                    [self.delegate didProjectSideCellDelete:product];
                }
            }
            else if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
            {
                CDCurrentUseItem *useItem = [self.checkItemArray objectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemDelete:)])
                {
                    [self.delegate didProjectSideUseItemDelete:useItem];
                }
            }
        }
        else if (indexPath.section == kPadProjectSideSectionCailiao)
        {
            if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
            {
                CDPosProduct *product = (CDPosProduct *)[self.consumeItemArray objectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideCellDelete:)])
                {
                    [self.delegate didProjectSideCellDelete:product];
                }
            }
            else if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
            {
                CDCurrentUseItem *useItem = [self.consumeItemArray objectAtIndex:indexPath.row];
                if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemDelete:)])
                {
                    [self.delegate didProjectSideUseItemDelete:useItem];
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kPadProjectSideSectionBuy && self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideCellClick:)])
    {
        CDPosProduct *product = (CDPosProduct *)[self.buyProdArray objectAtIndex:indexPath.row];
        [self.delegate didProjectSideCellClick:product];
    }
    else if (indexPath.section == kPadProjectSideSectionUse && self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemClick:)])
    {
        CDCurrentUseItem *useItem = [self.data.posOperate.useItems objectAtIndex:indexPath.row];
        [self.delegate didProjectSideUseItemClick:useItem];
    }
    else if (indexPath.section == kPadProjectSideSectionCheck && self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemClick:)])
    {
        if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
        {
            CDPosProduct *product = (CDPosProduct *)[self.checkItemArray objectAtIndex:indexPath.row];
            [self.delegate didProjectSideCellClick:product];
        }
        else if ([[self.checkItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
        {
            CDCurrentUseItem *useItem = [self.checkItemArray objectAtIndex:indexPath.row];
            [self.delegate didProjectSideUseItemClick:useItem];
        }
    }
    else if (indexPath.section == kPadProjectSideSectionCailiao && self.delegate && [self.delegate respondsToSelector:@selector(didProjectSideUseItemClick:)] && [self.delegate respondsToSelector:@selector(didProjectSideCellClick:)])
    {
        if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDPosProduct class]])
        {
            CDPosProduct *product = (CDPosProduct *)[self.consumeItemArray objectAtIndex:indexPath.row];
            [self.delegate didProjectSideCellClick:product];
        }
        else if ([[self.consumeItemArray objectAtIndex:indexPath.row] isKindOfClass:[CDCurrentUseItem class]])
        {
            CDCurrentUseItem *useItem = [self.consumeItemArray objectAtIndex:indexPath.row];
            [self.delegate didProjectSideUseItemClick:useItem];
        }
    }
}

@end
