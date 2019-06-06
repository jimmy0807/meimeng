//
//  CBIsNoneView.m
//  CardBag
//
//  Created by chen yan on 13-9-17.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "CBIsNoneView.h"

#define kIsNoneViewWidth 200.0

@interface CBIsNoneView ()
{
    UIImageView *imageView;
    UILabel *messageLabel;
    UIButton *reloadButton;
}

@end

@implementation CBIsNoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat locationY = 0.0;
        if (image != NULL)
        {
            imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake((kIsNoneViewWidth - image.size.width)/2.0, locationY, image.size.width, image.size.height);
            imageView.image = image;
            [self addSubview:imageView];
            locationY += image.size.height + 8.0;
        }
        
        if (message.length != 0)
        {
            messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.highlighted = NO;
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont boldSystemFontOfSize:14.0];
            messageLabel.textColor = COLOR(136.0, 138.0, 138.0, 1.0);
            CGSize minSize = CGSizeMake(kIsNoneViewWidth, 240.0);
            CGSize messageSize = [message sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:minSize lineBreakMode:NSLineBreakByCharWrapping];
            messageLabel.frame = CGRectMake(0.0, locationY, minSize.width, messageSize.height);
            messageLabel.text = message;
            [self addSubview:messageLabel];
            locationY += messageSize.height + 12.0;
        }
        
        if (buttonTitle.length != 0)
        {
            reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            reloadButton.frame = CGRectMake((kIsNoneViewWidth - 138.0)/2.0, locationY, 138.0, 37.0);
            [reloadButton setBackgroundImage:[UIImage imageNamed:@"btn_contacts_N"] forState:UIControlStateNormal];
            [reloadButton setBackgroundImage:[UIImage imageNamed:@"btn_contacts_H"] forState:UIControlStateHighlighted];
            [reloadButton setTitle:buttonTitle forState:UIControlStateNormal];
            [reloadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            [reloadButton setTitleColor:COLOR(136.0, 138.0, 138.0, 1.0) forState:UIControlStateNormal];
            [reloadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            locationY += reloadButton.frame.size.height + 24.0;
            [self addSubview:reloadButton];
        }
        
        self.bounds = CGRectMake(0.0, 0.0, kIsNoneViewWidth, locationY);
    }
    
    return self;
}

- (void)dealloc
{
    ;
}

- (void)showNoneViewInView:(UIView *)view
{
    self.frame = CGRectMake((view.frame.size.width - self.frame.size.width)/2.0, 88.0, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
}

- (void)buttonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isNoneViewButtonClick:)])
    {
        [self.delegate isNoneViewButtonClick:self];
    }
}

@end
