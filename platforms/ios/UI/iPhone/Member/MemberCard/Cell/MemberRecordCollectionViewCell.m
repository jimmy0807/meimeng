//
//  MemberRecordCollectionViewCell.m
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberRecordCollectionViewCell.h"


@interface MemberRecordCollectionViewCell ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addBtnTopConstraint;

@end

@implementation MemberRecordCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addBtnHidden = true;
}

- (void)setAddBtnHidden:(BOOL)addBtnHidden
{
    if (self.addBtn.hidden != addBtnHidden) {
        _addBtnHidden = addBtnHidden;
         self.addBtn.hidden = addBtnHidden;
        if (addBtnHidden) {
            [self.contentView removeConstraint:self.addBtnTopConstraint];
        }
        else
        {
            [self.contentView addConstraint:self.addBtnTopConstraint];
        }
    }
}

- (IBAction)addBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didAddBtnPressedOfCell:)]) {
        [self.delegate didAddBtnPressedOfCell:self];
    }
}
@end
