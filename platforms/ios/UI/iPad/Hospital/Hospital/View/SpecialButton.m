//
//  SpecialButton.m
//  meim
//
//  Created by 刘伟 on 2017/9/18.
//
//

#import "SpecialButton.h"

@implementation SpecialButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

//负责接收参数
+(instancetype)initWithTitle:(NSString *)title andRect:(CGRect)rect andCanClick:(BOOL)canClick andBlock:(BtnBlock)btnBlock{
    
    SpecialButton *sb = [super buttonWithType:UIButtonTypeCustom];
    
    sb.titleLabel.font = [UIFont systemFontOfSize:16];
    [sb setTitle:title forState:UIControlStateNormal];
    [sb setTitleColor:[UIColor colorWithRed:149/255.0 green:171/255.0 blue:171/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sb setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    sb.frame = rect;
    //[sb setBackgroundImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [sb setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [sb addTarget:sb action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    sb.layer.cornerRadius=sb.frame.size.width/5;
    sb.clipsToBounds=YES;
    if (!canClick) {
        sb.userInteractionEnabled=NO;
    }
    sb.btnBlock = btnBlock;
    return sb;
}

-(void)click:(SpecialButton *)button{
    //NSLog(@"%d",button.isSelected);
    button.selected = !button.isSelected;
    button.btnBlock();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
