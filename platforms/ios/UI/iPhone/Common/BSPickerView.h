//
//  BSPickerView.h
//  Boss
//
//  Created by lining on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSPickerViewDelegate <NSObject>
@optional
- (void)didSureBtnPressed;
@end

@interface BSPickerView : UIView

+ (instancetype)createViewWithTitle:(NSString *)title;
@property (nonatomic, weak)id<UIPickerViewDataSource>dataSource;
@property (nonatomic, weak)id<UIPickerViewDelegate,BSPickerViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
- (void)show;
- (void)hide;
@end
