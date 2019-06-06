//
//  TextViewCell.m
//  Boss
//
//  Created by lining on 16/5/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "TextViewCell.h"

@interface TextViewCell ()<UITextViewDelegate>

@end

@implementation TextViewCell

+ (instancetype)createCell
{
    TextViewCell *cell = [self loadFromNib];
    cell.textView.delegate = cell;
    return cell;
}

- (void)setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        self.textView.text = text;
        self.textView.textColor = self.textColor == nil ?[UIColor darkTextColor] : self.textColor;;
    }
    else
    {
        self.textView.text = self.placeHolder;
        self.textView.textColor = [UIColor lightGrayColor];

    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    if (_text.length > 0) {
        return;
    }
    if (placeHolder.length > 0) {
        _placeHolder = placeHolder;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = placeHolder;
    }
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    self.textView.text = self.text;
    if ([self.delegate respondsToSelector:@selector(didTextViewBeginEdit:)]) {
        [self.delegate didTextViewBeginEdit:textView];
    }
    return true;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.text = textView.text;
    if ([self.delegate respondsToSelector:@selector(didTextViewEndEdit:)]) {
        [self.delegate didTextViewEndEdit:textView];
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%@ ____ %@",NSStringFromRange(range),text);
    return true;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"%s ---- %@",__FUNCTION__,textView.text);
    if (textView.text.length > 0)
    {
        self.text = textView.text;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
