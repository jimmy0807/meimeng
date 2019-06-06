//
//  LNTextView.m
//  Boss
//
//  Created by lining on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "LNTextView.h"

@implementation LNTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        self.backgroundColor = [UIColor orangeColor];
//        self.editable = false;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint.y -= 10;
    NSLayoutManager *layoutManager = self.layoutManager;
    NSInteger charcterIndex;
    
    charcterIndex = [layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (charcterIndex < self.text.length) {
//        NSRange range;
        NSString *s=[self.text substringWithRange:NSMakeRange(charcterIndex, 1)];
        [[[UIAlertView alloc] initWithTitle:s message:s delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil] show];
    }
    [super touchesBegan:touches withEvent:event];

    
}

@end
