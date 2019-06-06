//
//  BSSuccessBtnView.h
//  Boss
//
//  Created by lining on 16/9/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ViewShowStyle
{
    ViewShowStyle_Give,
    ViewShowStyle_Cashier,
    ViewShowStyle_Assign
}ViewShowStyle;

@protocol BSSuccessBtnViewDelegate <NSObject>
@optional
- (void)didCashierBtnPressed;
- (void)didAssignBtnPressed;
- (void)didSendBtnPressed;
- (void)didBackBtnPressed;
@end

@interface BSSuccessBtnView : UIView
+ (instancetype)createViewWithTopTip:(NSString *)topTip contentTitle:(NSString *)title detailTitle:(NSString *)detailTitle;

+ (instancetype)createQRViewWithUrl:(NSString *)url;

//@property (assign, nonatomic) ViewShowStyle showStyle;
@property (weak, nonatomic)id<BSSuccessBtnViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *topTipView;
@property (strong, nonatomic) IBOutlet UILabel *topTipLabel;

@property (strong, nonatomic) IBOutlet UIView *QRCodeView;
@property (strong, nonatomic) IBOutlet UIImageView *QRImgView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentDetailLabel;

@end
