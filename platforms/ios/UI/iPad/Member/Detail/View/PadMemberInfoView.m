//
//  PadMemberInfoView.m
//  meim
//
//  Created by 刘伟 on 2017/9/26.
//
//

#import "PadMemberInfoView.h"
#import "PadProjectConstant.h"
#import "VCommonDef.h"

#define kPadMemberCellHeight        178.0

///9月份修改会员中心 第一个section移到了self.view顶部
@implementation PadMemberInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame])
    {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0, 54.0, 90.0, 90.0)];
        self.avatarImageView.backgroundColor = [UIColor clearColor];
        self.avatarImageView.image = [UIImage imageNamed:@"pad_member_default"];
        [self addSubview:self.avatarImageView];
    
//        UIImageView *avatarMaskView = [[UIImageView alloc] initWithFrame:self.avatarImageView.bounds];
//        avatarMaskView.backgroundColor = [UIColor clearColor];
//        avatarMaskView.image = [UIImage imageNamed:@"pad_member_upload_avatar"];
//        [self.avatarImageView addSubview:avatarMaskView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + 90.0 + 24.0, 72.0 - 4.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 90.0 - 24.0, 32.0)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont systemFontOfSize:27.0];
        self.nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self addSubview:self.nameLabel];
        
        CGFloat originX = 66.0 + 90.0 + 20.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 12.0, 28.0, 28.0)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"pad_member_phone_number"];
        [self addSubview:imageView];
        originX += 28.0;
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 116.0, 20.0)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.textAlignment = NSTextAlignmentLeft;
        self.phoneLabel.font = [UIFont systemFontOfSize:15.0];
        self.phoneLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self addSubview:self.phoneLabel];
        originX += 116.0;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 10.0, 28.0, 28.0)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"pad_member_birthday"];
        [self addSubview:imageView];
        originX += 28.0 + 2.0;
        
        self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 84.0, 20.0)];
        self.birthdayLabel.backgroundColor = [UIColor clearColor];
        self.birthdayLabel.textAlignment = NSTextAlignmentLeft;
        self.birthdayLabel.font = [UIFont systemFontOfSize:15.0];
        self.birthdayLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self addSubview:self.birthdayLabel];
        originX += 84.0;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 12.0, 28.0, 28.0)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"pad_member_gender"];
        [self addSubview:imageView];
        originX += 28.0 + 3.0;
        
        self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 64.0, 20.0)];
        self.genderLabel.backgroundColor = [UIColor clearColor];
        self.genderLabel.textAlignment = NSTextAlignmentLeft;
        self.genderLabel.font = [UIFont systemFontOfSize:15.0];
        self.genderLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
        [self addSubview:self.genderLabel];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(532, 78, 16, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"pad_member_arrow"];
        [self addSubview:_arrowImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(66.0, kPadMemberCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 1.0)];
        lineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
        [self addSubview:lineView];
        
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0, 54.0, 90.0, 90.0)];
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.image = [UIImage imageNamed:@"pad_member_default"];
    [self addSubview:self.avatarImageView];
//    UIImageView *avatarMaskView = [[UIImageView alloc] initWithFrame:self.avatarImageView.bounds];
//    avatarMaskView.backgroundColor = [UIColor clearColor];
//    avatarMaskView.image = [UIImage imageNamed:@"pad_member_upload_avatar"];
//    [self.avatarImageView addSubview:avatarMaskView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0 + 90.0 + 24.0, 72.0 - 4.0, kPadMemberAndCardInfoWidth - 2 * 66.0 - 90.0 - 24.0, 32.0)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:27.0];
    self.nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    [self addSubview:self.nameLabel];
    
    CGFloat originX = 66.0 + 90.0 + 20.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 12.0, 28.0, 28.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"pad_member_phone_number"];
    [self addSubview:imageView];
    originX += 28.0;
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 116.0, 20.0)];
    self.phoneLabel.backgroundColor = [UIColor clearColor];
    self.phoneLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneLabel.font = [UIFont systemFontOfSize:15.0];
    self.phoneLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    [self addSubview:self.phoneLabel];
    originX += 116.0;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 10.0, 28.0, 28.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"pad_member_birthday"];
    [self addSubview:imageView];
    originX += 28.0 + 2.0;
    
    self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 84.0, 20.0)];
    self.birthdayLabel.backgroundColor = [UIColor clearColor];
    self.birthdayLabel.textAlignment = NSTextAlignmentLeft;
    self.birthdayLabel.font = [UIFont systemFontOfSize:15.0];
    self.birthdayLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    [self addSubview:self.birthdayLabel];
    originX += 84.0;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 12.0, 28.0, 28.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"pad_member_gender"];
    [self addSubview:imageView];
    originX += 28.0 + 3.0;
    
    self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 54.0 + 90.0/2.0 + 16.0, 64.0, 20.0)];
    self.genderLabel.backgroundColor = [UIColor clearColor];
    self.genderLabel.textAlignment = NSTextAlignmentLeft;
    self.genderLabel.font = [UIFont systemFontOfSize:15.0];
    self.genderLabel.textColor = COLOR(136.0, 136.0, 136.0, 1.0);
    [self addSubview:self.genderLabel];
    
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(532, 78, 16, 16)];
    _arrowImageView.image = [UIImage imageNamed:@"pad_member_arrow"];
    [self addSubview:_arrowImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(66.0, kPadMemberCellHeight - 1.0, kPadMemberAndCardInfoWidth - 2 * 66.0, 1.0)];
    lineView.backgroundColor = COLOR(236.0, 236.0, 236.0, 1.0);
    [self addSubview:lineView];
    
}



@end
