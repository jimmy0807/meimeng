//
//  BSPickerView.m
//  Boss
//
//  Created by lining on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSPickerView.h"


#define AnimationDuration 0.35
@interface BSPickerView ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;

@end

@implementation BSPickerView

+ (instancetype)createViewWithTitle:(NSString *)title
{
    BSPickerView *pickerView = [self loadFromNib];
    pickerView.titleLabel.text = title;
    
    pickerView.hidden = true;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    return pickerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.bgBtn.backgroundColor = [UIColor blackColor];
    self.bgBtn.alpha = 0.0;
    [self removeConstraint:self.containerViewBottomConstraint];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
    
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    self.pickerView.dataSource = dataSource;
}

- (void)setDelegate:(id<UIPickerViewDelegate,BSPickerViewDelegate>)delegate
{
    _delegate = delegate;
    self.pickerView.delegate = delegate;
}

#pragma mark - show & hide
- (void)show
{
    self.hidden = false;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
    }];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.6;
        [self layoutIfNeeded];
    }];
}

- (void)hide
{
    self.hidden = false;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
         self.hidden = true;
     }];
}

#pragma mark - button action
- (IBAction)sureBtnPressed:(id)sender {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(didSureBtnPressed)]) {
        [self.delegate didSureBtnPressed];
    }
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self hide];
}

- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

@end
