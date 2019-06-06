//
//  ProductBaseInfoView.h
//  ds
//  基本信息
//  Created by lining on 2016/10/27.
//
//

#import <UIKit/UIKit.h>
#import "ProductTemplateDetailViewController.h"
#import "BSAttributeLine.h"
#import "BSAttributePrice.h"
#import "BSAttributeValue.h"
#import "BSProjectItem.h"

@protocol ProductBaseInfoViewDelegate <NSObject>

@optional
- (void)didItemSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEditTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;
- (void)didCheckBoxSelcted:(bool)selected atIndexPath:(NSIndexPath *)indexPath;
- (void)didScanBtnSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ProductBaseInfoView : UIView

+ (instancetype)createViewWithType:(ProductTmplateType)type bornCategory:(CDBornCategory *)bornCategory;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<ProductBaseInfoViewDelegate>delegate;
@property (weak, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) CDProjectTemplate *projectTemplate;
@property (strong, nonatomic) CDBornCategory *bornCategory;

@property (nonatomic, strong) BSProjectItem *bsItem;

- (NSMutableDictionary *)baseInfoParams;

- (NSArray *)needSendAttributePriceRequestsTemplateID:(NSNumber *)templateID;

@end
