//
//  ProductTemplateDetailViewController.h
//  ds
//
//  Created by lining on 2016/10/27.
//
//

#import "ICCommonViewController.h"

typedef enum ProductTmplateType
{
    ProductTmplateType_Create,
    ProductTmplateType_Edit
}ProductTmplateType;

@interface ProductTemplateDetailViewController : ICCommonViewController

@property (nonatomic, strong) CDBornCategory *bornCategory;
@property (nonatomic, strong) CDProjectTemplate *projectTemplate;

@end
