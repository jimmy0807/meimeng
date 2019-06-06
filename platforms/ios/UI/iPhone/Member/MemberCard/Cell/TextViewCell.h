//
//  TextViewCell.h
//  Boss
//
//  Created by lining on 16/5/16.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TextViewCellDelegate <NSObject>
@optional
- (void)didTextViewBeginEdit:(UITextView *)textView;
- (void)didTextViewEndEdit:(UITextView *)textView;

@end

@interface TextViewCell : UITableViewCell

+ (instancetype)createCell;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (weak, nonatomic) id<TextViewCellDelegate>delegate;

@end
