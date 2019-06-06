//
//  AttributeSelectedView.h
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import <UIKit/UIKit.h>
#import "BSAttributeLine.h"

typedef enum AttributeStyle
{
    AttributeStyle_attribute,
    AttributeStyle_attributeValue
}AttributeStyle;


@protocol AttributeSelectedViewDelegate <NSObject>
- (void)didSureBtnPressedWithAttributes:(NSArray *)attributes;
- (void)didSureBtnPressedWithAttributeValues:(NSArray *)atttributeValues;
@end

@interface AttributeSelectedView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) id<AttributeSelectedViewDelegate>delegate;
@property (nonatomic, strong) BSAttributeLine *attributeLine;
@property (nonatomic, strong) NSArray *notShowAttributeIDs;

+ (instancetype)createView;

- (void)show;
- (void)hide;

@end
