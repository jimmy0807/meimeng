//
//  SendStyleRadioCell.m
//  Boss
//
//  Created by lining on 16/9/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SendStyleRadioCell.h"

@interface SendStyleRadioCell ()
@property (strong, nonatomic) IBOutlet UIImageView *directImgView;
@property (strong, nonatomic) IBOutlet UIImageView *qrImgView;
@end

@implementation SendStyleRadioCell


- (void)setIsDirectSend:(BOOL)isDirectSend
{
    _isDirectSend = isDirectSend;
    if (_isDirectSend) {
        self.directImgView.highlighted = true;
        self.qrImgView.highlighted = false;
    }
    else
    {
        self.directImgView.highlighted = false;
        self.qrImgView.highlighted = true;
    }
    
}
- (IBAction)directRadioBtnPressed:(id)sender {
    if (self.isDirectSend) {
        return;
    }
    self.isDirectSend = true;
    if ([self.delegate respondsToSelector:@selector(isDirectedSend:)]) {
        [self.delegate isDirectedSend:self.isDirectSend];
    }
}
- (IBAction)qrRadioBtnPressed:(id)sender {
    if (!self.isDirectSend) {
        return;
    }
    self.isDirectSend = false;
    if ([self.delegate respondsToSelector:@selector(isDirectedSend:)]) {
        [self.delegate isDirectedSend:self.isDirectSend];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
