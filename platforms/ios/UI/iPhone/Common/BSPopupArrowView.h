//
//  BSPopupView.h
//  Boss
//
//  Created by lining on 16/10/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum PopupViewStyle
{
    PopupViewStyle_Image, //图片+文字
    PopupViewStyle_Text   //只有文字
}PopupViewStyle;

@class PopupItem;
@class BSPopupArrowView;
@protocol BSPopupArrowViewDelegate <NSObject>
@optional
- (void)didSelectedItem:(BSPopupArrowView *)popupView atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BSPopupArrowView : UIView<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)createView;
+ (instancetype)createViewWithStyle:(PopupViewStyle)style;

@property (weak, nonatomic) id<NSObject>delegate;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *arrowView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<PopupItem *>*items;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;


- (void)showArrowView:(UIView *)view;
@end

@interface PopupItem : NSObject
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *title;
@property(nonatomic) SEL function;
@end
