//
//  YimeiSignBeforeTitleTableViewCell.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "YimeiSignBeforeTitleTableViewCell.h"
#import "BSFetchPosProductRequest.h"

@interface YimeiSignBeforeTitleTableViewCell()
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* genderLabel;
@property(nonatomic, weak)IBOutlet UILabel* ageLabel;
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;
@property(nonatomic, weak)IBOutlet UITextView* contentTextView;
@property(nonatomic, weak)IBOutlet UIScrollView* itemScrollView;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property(nonatomic, strong) NSMutableArray *posProducts;
@property(nonatomic, strong) NSMutableArray *titleLabels;
@property(nonatomic, weak)IBOutlet UITextView* buyTextView;
@property(nonatomic, weak)IBOutlet UITextView* remarkTextView;
@property(nonatomic, weak)IBOutlet UILabel* priceLabel;
@property(nonatomic, strong) NSMutableAttributedString *buyString;
@property(nonatomic, strong) NSMutableAttributedString *useString;
@property(nonatomic, strong) NSMutableArray *useItems;
@property(nonatomic) int buyCount;
@property(nonatomic) int useCount;
@property(nonatomic, weak)IBOutlet UILabel* useTitle;

@end

@implementation YimeiSignBeforeTitleTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabels = [NSMutableArray array];
}

- (void)reloadItems
{
    for ( UILabel* label in self.titleLabels )
    {
        [label removeFromSuperview];
    }
    
    __block CGFloat totalLength = 0;
    
    [self.posProducts enumerateObjectsUsingBlock:^(CDPosBaseProduct*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.textColor = COLOR(106, 106, 106, 1);
        title.font = [UIFont systemFontOfSize:13];
        
        NSMutableString* buweiString = [[NSMutableString alloc] init];
        NSNumber* itemID = nil;
        if ( [obj isKindOfClass:[CDCurrentUseItem class]] )
        {
            itemID = ((CDCurrentUseItem*)obj).itemID;
        }
        else
        {
            itemID = obj.product_id;
        }
        
        CDProjectItem* projectItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:itemID forKey:@"itemID"];
        
        if ( [obj isKindOfClass:[CDCurrentUseItem class]] )
        {
            for ( CDYimeiBuwei* buwei in ((CDCurrentUseItem*)obj).yimei_buwei )
            {
                [buweiString appendFormat:@"%@ ",buwei.name];
                //[buweiString appendFormat:@"%@X%@%@ ",buwei.name, buwei.count, projectItem.uomName];
            }
            if ( buweiString.length > 0 )
            {
                title.text = [NSString stringWithFormat:@"%@(%@)",((CDCurrentUseItem*)obj).itemName,buweiString];
            }
            else
            {
                title.text = ((CDCurrentUseItem*)obj).itemName;
            }
        }
        else
        {
            for ( CDYimeiBuwei* buwei in obj.yimei_buwei )
            {
                //[buweiString appendFormat:@"%@X%@%@ ",buwei.name, buwei.count, projectItem.uomName];
                [buweiString appendFormat:@"%@ ",buwei.name];
            }
            
            if ( buweiString.length > 0 )
            {
                [buweiString deleteCharactersInRange:NSMakeRange(buweiString.length - 1, 1)];
                title.text = [NSString stringWithFormat:@"%@(%@)",obj.product_name,buweiString];
            }
            else
            {
                title.text = obj.product_name;
            }
        }
        
        CGSize minSize = [title.text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(2000, 20) lineBreakMode:NSLineBreakByWordWrapping];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0 + totalLength, 0, 24 + minSize.width, 24)];
        v.layer.masksToBounds = YES;
        v.layer.cornerRadius = 3;
        v.backgroundColor = COLOR(242, 242, 242, 1);
        [v addSubview:title];
        title.frame = CGRectMake(12, 0, minSize.width, v.frame.size.height);
        
        if ( ![obj isKindOfClass:[CDCurrentUseItem class]] && obj.product.bornCategory.integerValue != kPadBornCategoryProject )
        {
            
        }
        else
        {
            [self.itemScrollView addSubview:v];
            
            totalLength = totalLength + 8 + 24 + minSize.width;
        }
    }];
    
    self.itemScrollView.contentSize = CGSizeMake(totalLength, self.itemScrollView.contentSize.height);
}

- (void)getString
{
    self.buyString = [[NSMutableAttributedString alloc] init];
    self.useString = [[NSMutableAttributedString alloc] init];
    self.useItems = [[NSMutableArray alloc] init];
    self.buyCount = 0;
    self.useCount = 0;
    [self.posProducts enumerateObjectsUsingBlock:^(CDPosBaseProduct*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;// 字体的行间距
        if ( [obj isKindOfClass:[CDCurrentUseItem class]] )
        {
            NSLog(@"%@",((CDCurrentUseItem*)obj).posOperate);
            NSAttributedString *comma = [[NSAttributedString alloc] initWithString:@", " attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
            if (self.useCount > 0)
            {
                [self.useString appendAttributedString:comma];
            }
            NSAttributedString *useItemName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x%d",((CDCurrentUseItem*)obj).itemName,((CDCurrentUseItem*)obj).useCount.intValue] attributes:@{NSForegroundColorAttributeName:COLOR(89.0, 89.0, 89.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
            [self.useString appendAttributedString:useItemName];
//            if (((CDCurrentUseItem*)obj).posOperate.remark && ![((CDCurrentUseItem*)obj).posOperate.remark isEqualToString:@""])
//            {
//                NSAttributedString *remark = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)",((CDCurrentUseItem*)obj).posOperate.remark] attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
//                [self.useString appendAttributedString:remark];
//            }
            self.useCount++;
        }
        else
        {
            if (obj.product.bornCategory.integerValue == kPadBornCategoryProject)
            {
                NSAttributedString *comma = [[NSAttributedString alloc] initWithString:@", " attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
                if (self.useCount > 0)
                {
                    [self.useString appendAttributedString:comma];
                }
                NSAttributedString *useItemName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x%d",obj.product_name,obj.product_qty.intValue] attributes:@{NSForegroundColorAttributeName:COLOR(89.0, 89.0, 89.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
                [self.useString appendAttributedString:useItemName];
                self.useCount++;
            }
            NSAttributedString *newline = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
            if (self.buyCount > 0)
            {
                [self.buyString appendAttributedString:newline];
            }
            
            NSAttributedString *buyItemName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x%d",obj.product_name,obj.product_qty.intValue] attributes:@{NSForegroundColorAttributeName:COLOR(89.0, 89.0, 89.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
            [self.buyString appendAttributedString:buyItemName];
            if (obj.product.subRelateds.count > 0)
            {
                NSAttributedString *left = [[NSAttributedString alloc] initWithString:@"(" attributes:@{NSForegroundColorAttributeName:COLOR(153.0, 153.0, 153.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
                [self.buyString appendAttributedString:left];
            }
            int subCount = 0;
            for (CDProjectRelated *related in obj.product.subRelateds)
            {
                if (subCount>0)
                {
                    NSAttributedString *comma = [[NSAttributedString alloc] initWithString:@"、 " attributes:@{NSForegroundColorAttributeName:COLOR(153.0, 153.0, 153.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
                    [self.buyString appendAttributedString:comma];
                }
                CDProjectItem *subItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:related.productID forKey:@"itemID"];
                NSAttributedString *buySubItemName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@x%d",subItem.itemName,related.quantity.intValue] attributes:@{NSForegroundColorAttributeName:COLOR(153.0, 153.0, 153.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],                                 NSParagraphStyleAttributeName:paragraphStyle}];
                [self.buyString appendAttributedString:buySubItemName];
                subCount++;
            }
            if (obj.product.subRelateds.count > 0)
            {
                NSAttributedString *right = [[NSAttributedString alloc] initWithString:@")" attributes:@{NSForegroundColorAttributeName:COLOR(153.0, 153.0, 153.0, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle}];
                [self.buyString appendAttributedString:right];
            }
//            for (CDProjectItem *subItem in obj.product.subItems)
//            {
//                NSLog(@"%@",subItem);
//                NSAttributedString *buySubItemName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@x%d)",subItem.itemName,subItem.subItemCount] attributes:@{NSForegroundColorAttributeName:COLOR(136.0, 136.0, 136.0, 1.0)}];
//                [self.buyString appendAttributedString:buySubItemName];
//            }
            self.buyCount++;
        }
    }];
    NSLog(@"%@",self.useString);
//    NSMutableString *returnString = [[NSMutableString alloc] init];
//    if (buyItemArray.count > 0 && useItemArray.count > 0)
//    {
//        returnString = [NSMutableString stringWithFormat:@"购买%@\n使用%@",[buyItemArray componentsJoinedByString:@", "],[useItemArray componentsJoinedByString:@", "]];
//    }
//    else if (buyItemArray.count > 0)
//    {
//        returnString = [NSMutableString stringWithFormat:@"购买%@",[buyItemArray componentsJoinedByString:@", "]];
//    }
//    else
//    {
//        returnString = [NSMutableString stringWithFormat:@"使用%@",[useItemArray componentsJoinedByString:@", "]];
//    }
}

- (NSString*)getItemString
{
    NSMutableArray* buyItemArray = [NSMutableArray array];
    NSMutableArray* useItemArray = [NSMutableArray array];
    [self.posProducts enumerateObjectsUsingBlock:^(CDPosBaseProduct*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [obj isKindOfClass:[CDCurrentUseItem class]] )
        {
            [useItemArray addObject:[NSString stringWithFormat:@"%@ x %d",((CDCurrentUseItem*)obj).itemName, ((CDCurrentUseItem*)obj).useCount.intValue]];
        }
        else
        {
            [buyItemArray addObject:[NSString stringWithFormat:@"%@ x %d", obj.product_name, obj.product_qty.intValue]];
        }
    }];
    NSMutableString *returnString = [[NSMutableString alloc] init];
    if (buyItemArray.count > 0 && useItemArray.count > 0)
    {
        returnString = [NSMutableString stringWithFormat:@"购买%@\n使用%@",[buyItemArray componentsJoinedByString:@", "],[useItemArray componentsJoinedByString:@", "]];
    }
    else if (buyItemArray.count > 0)
    {
        returnString = [NSMutableString stringWithFormat:@"购买%@",[buyItemArray componentsJoinedByString:@", "]];
    }
    else
    {
        returnString = [NSMutableString stringWithFormat:@"使用%@",[useItemArray componentsJoinedByString:@", "]];
    }
    return [NSString stringWithFormat:@"%@",returnString];
}

- (void)setOperate:(CDPosOperate *)operate
{
    _operate = operate;
    //    self.posProducts = [[BSCoreDataManager currentManager] fetchPosProductsWithOperate:operate];
    self.posProducts = [NSMutableArray arrayWithArray:operate.products.array];
    
    if ( operate.useItems.count > 0 )
    {
        [self.posProducts addObjectsFromArray:operate.useItems.array];
    }
    
    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.operate.member.memberID forKey:@"memberID"];
    self.nameLabel.text = operate.member.memberName;
    if ([member.gender isEqualToString:@"Male"])
    {
        self.genderLabel.text = @"性别: 男";
    }
    else
    {
        self.genderLabel.text = @"性别: 女";
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"医生: %@",(operate.doctor_name.length > 0 ? operate.doctor_name : @"")];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.02f",[operate.amount doubleValue]];
    [self getString];
    self.buyTextView.attributedText = self.buyString;
    if (self.buyCount > 2)
    {
        if (self.buyCount > 6)
        {
            self.useTitle.frame = CGRectMake(self.useTitle.frame.origin.x, (self.useTitle.frame.origin.y + 4*18), self.useTitle.frame.size.width, self.useTitle.frame.size.height);
            self.remarkTextView.frame = CGRectMake(self.remarkTextView.frame.origin.x, (self.remarkTextView.frame.origin.y + 4*18), self.remarkTextView.frame.size.width, self.remarkTextView.frame.size.height);
        }
        else
        {
            self.useTitle.frame = CGRectMake(self.useTitle.frame.origin.x, (self.useTitle.frame.origin.y + (self.buyCount-2)*18), self.useTitle.frame.size.width, self.useTitle.frame.size.height);
            self.remarkTextView.frame = CGRectMake(self.remarkTextView.frame.origin.x, (self.remarkTextView.frame.origin.y + (self.buyCount-2)*18), self.remarkTextView.frame.size.width, self.remarkTextView.frame.size.height);
        }
    }
    self.remarkTextView.attributedText = self.useString;
    
    
//    if ( [PersonalProfile currentProfile].is_show_consume_product )
//    {
//        self.remarkTextView.text = [NSString stringWithFormat:@"%@\n%@",[self getItemString],operate.remark.length > 0 ? operate.remark : @""];
//    }
//    else
//    {
//        self.remarkTextView.text = operate.remark;
//    }
    //[self reloadItems];
}

- (void)setProvision:(NSString *)provision
{
    self.contentTextView.text = provision;
    [self.contentWebView loadHTMLString:provision baseURL:nil];
}

@end


