//
//  KeyBordAccessoryView.m
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "KeyBordAccessoryView.h"

@interface KeyBordAccessoryView ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *compleItem;

@end
@implementation KeyBordAccessoryView
+(instancetype)keyBordAccessoryView
{
    KeyBordAccessoryView *bordView = [[[NSBundle mainBundle]loadNibNamed:@"KeyBordAccessoryView" owner:nil  options:nil]lastObject];
    return bordView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor lightGrayColor];
}
- (IBAction)completeClick:(UIBarButtonItem *)sender {
    if ([_accessoryDelegate respondsToSelector:@selector(keyBordAccessoryViewCompleteItemClick)]) {
        [_accessoryDelegate keyBordAccessoryViewCompleteItemClick];
    }
}

@end
