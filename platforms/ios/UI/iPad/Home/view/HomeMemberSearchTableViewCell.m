//
//  HomeMemberSearchTableViewCell.m
//  Boss
//
//  Created by jimmy on 16/3/23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "HomeMemberSearchTableViewCell.h"

@interface HomeMemberSearchTableViewCell ()
@end

@implementation HomeMemberSearchTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [self.delegate willSearchContent:self.searchContentTextFiled.text];
}

- (void)clear
{
    self.searchContentTextFiled.text = @"";
}

@end
