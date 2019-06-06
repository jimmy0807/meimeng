//
//  PadBookColorView.m
//  Boss
//
//  Created by lining on 15/12/1.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookColorView.h"
#import "UIView+Frame.h"
#import "NSDate+Formatter.h"
#import "UIImage+Resizable.h"
#import "PadBookDefine.h"


#define kMarginSize 6

#define Drag_Point_Size 12

#define GAP 0

#define kMinHeight 40
#define kDragHeight 30

#define Normal_Color COLOR()
#define Selected_Color COLOR()

@interface PadBookColorView ()<UIAlertViewDelegate>
{
    NSInteger year, month, day;
    
    CGPoint start_point;
    CGPoint pre_point;
    
    BOOL overDate;
    CGRect orignRect;
    
    bool tap;
    bool long_pressed;
    
    NSInteger move_count;
    
}

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *phoneLabel;
@property(nonatomic, strong) UILabel *shejishiLabel;

@property(nonatomic, strong) UIImageView *topDragView;
@property(nonatomic, strong) UIImageView *bottomDragView;


@property(nonatomic, strong) UIImageView *bgImgView;
@end

@implementation PadBookColorView

- (instancetype) initWithCDBook:(CDBook *)book columnIdx:(NSInteger)columnIdx
{
    self = [super init];
    if (self) {
        self.book = book;
        self.columnIdx = columnIdx;
        self.orignColumn = self.columnIdx;
        
        
        NSDate *startDate = [NSDate dateFromString:self.book.start_date];
        NSDate *endDate = [NSDate dateFromString:self.book.end_date];
        
        year = startDate.year;
        month = startDate.month;
        day = startDate.day;
        
        NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
        
        self.x = self.columnIdx * VIEW_WIDTH + GAP;
        self.y = TOP_SPACE + ((startDate.hour - START_HOUR) * 60 + startDate.minute + startDate.second / 60.0) * HEIGHT_PER;
        self.width = VIEW_WIDTH - 2*GAP;
        self.height = interval / 60.0 * HEIGHT_PER;
        
        
        
        self.bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImgView.alpha = 0.8;
        [self addSubview:self.bgImgView];
        
        
        NSTimeInterval endSinceNow = [endDate timeIntervalSinceDate:[NSDate date]];
        if (endSinceNow < 0)
        {
            //NSLog(@"已经结束");
        }
        else
        {
            
        }
        
        if ( [book.state isEqualToString:@"draft"] )
        {
            self.bgImgView.image = [[UIImage imageNamed:@"pad_book_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        }
        else if ( [book.state isEqualToString:@"done"] )
        {
            self.bgImgView.image = [[UIImage imageNamed:@"pad_book_draft_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_draft_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        }
        else
        {
            self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            if (![[book.member_type lowercaseString] isEqualToString:@"pt"]) {
                if ([[book.member_type lowercaseString] isEqualToString:@"vip"] || [[book.member_type lowercaseString] isEqualToString:@"wip"] || [[book.member_type lowercaseString] isEqualToString:@"vvip"])
                {
                    self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_vip_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                    self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                }
                else
                {
                    self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_normal_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                    self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                }
            }
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, kMarginSize/2.0, self.width - 2*kMarginSize, 16)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        if ( book.designers_name.length > 0 )
        {
            self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",self.book.booker_name, book.designers_name];
        }
        else
        {
            self.titleLabel.text = self.book.booker_name.length > 0? self.book.booker_name:@"新预约";
        }
        [self addSubview:self.titleLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.x, self.titleLabel.bottom, self.titleLabel.width, self.titleLabel.height)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.textColor = [UIColor blackColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:11];
        if ( self.book.telephone.length > 0 )
        {
            self.phoneLabel.text = [NSString stringWithFormat:@"%@*****%@", [self.book.telephone substringToIndex:3],[self.book.telephone substringFromIndex:8]];
        }
        
        [self addSubview:self.phoneLabel];
#if 0
        self.shejishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.phoneLabel.x, self.phoneLabel.bottom, self.phoneLabel.width, self.phoneLabel.height)];
        self.shejishiLabel.backgroundColor = [UIColor clearColor];
        self.shejishiLabel.textColor = [UIColor blackColor];
        self.shejishiLabel.font = [UIFont systemFontOfSize:11];
        if ( book.designers_name.length > 0 )
        {
            self.shejishiLabel.text = [NSString stringWithFormat:@"设计师:%@",book.designers_name];
        }
        [self addSubview:self.shejishiLabel];
#endif
        UIImage *drag_point = [UIImage imageNamed:@"book_drag_point.png"];
        
        self.topDragView = [[UIImageView alloc] initWithImage:drag_point];
        self.topDragView.center = CGPointMake(self.width - 20, Drag_Point_Size/3.0);
        [self addSubview:self.topDragView];
        
        self.bottomDragView = [[UIImageView alloc] initWithImage:drag_point];
        self.bottomDragView.center = CGPointMake(20, self.height - Drag_Point_Size/3.0);
        [self addSubview:self.bottomDragView];
        
        self.showDragPoint = false;
      
    }
    
    return self;
}

- (void)setColumnIdx:(NSInteger)columnIdx
{
    _columnIdx = columnIdx;
    self.book.columnIdx = [NSNumber numberWithInteger:columnIdx];
}

- (void)setOrignColumn:(NSInteger)orignColumn
{
    _orignColumn = orignColumn;
    self.book.orginColumnIdx = [NSNumber numberWithInteger:orignColumn];
}


- (void)setShowDragPoint:(bool)showDragPoint
{
    _showDragPoint = showDragPoint;
    self.bgImgView.highlighted  = _showDragPoint;
    if (showDragPoint)
    {
        self.topDragView.hidden = false;
        self.bottomDragView.hidden = false;
        
    }
    else
    {
        self.topDragView.hidden = true;
        self.bottomDragView.hidden = true;
    }
}

- (void)reloadViewWithCDBook:(CDBook *)book
{
    NSDate *startDate = [NSDate dateFromString:book.start_date];
    NSDate *endDate = [NSDate dateFromString:book.end_date];
    
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    self.columnIdx = [book.columnIdx integerValue];
    self.orignColumn = [book.orginColumnIdx integerValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.x = self.columnIdx * VIEW_WIDTH + GAP;
        self.y = TOP_SPACE + ((startDate.hour - START_HOUR) * 60 + startDate.minute) * HEIGHT_PER;
        self.height = interval / 60.0 * HEIGHT_PER;
        
        self.bottomDragView.centerY = self.height - Drag_Point_Size/3.0;
        self.bgImgView.frame = self.bounds;
    } completion:nil];
    
    
    if ( book.designers_name.length > 0 )
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",self.book.booker_name, book.designers_name];
    }
    else
    {
        self.titleLabel.text = self.book.booker_name.length > 0? self.book.booker_name:@"新预约";
    }
    
    if ( self.book.telephone.length > 0 )
    {
        self.phoneLabel.text = [NSString stringWithFormat:@"%@*****%@", [self.book.telephone substringToIndex:3],[self.book.telephone substringFromIndex:8]];
    }

    if ( book.designers_name.length > 0 )
    {
        self.shejishiLabel.text = [NSString stringWithFormat:@"设计师:%@",book.designers_name];
    }
    
    if ( [book.state isEqualToString:@"draft"] )
    {
        self.bgImgView.image = [[UIImage imageNamed:@"pad_book_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    else if ( [book.state isEqualToString:@"done"] )
    {
        self.bgImgView.image = [[UIImage imageNamed:@"pad_book_draft_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_draft_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    else
    {
        self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        if (![[book.member_type lowercaseString] isEqualToString:@"pt"]) {
            if ([[book.member_type lowercaseString] isEqualToString:@"vip"] || [[book.member_type lowercaseString] isEqualToString:@"wip"])
            {
                self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_vip_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            }
            else
            {
                self.bgImgView.image = [[UIImage imageNamed:@"pad_book_done_normal_bg_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
                self.bgImgView.highlightedImage = [[UIImage imageNamed:@"pad_book_done_bg_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            }
        }
    }
}

//- (void)rollBack
//{
//    [self reloadViewWithCDBook:self.book];
//}

- (bool)intersectWithColorView:(PadBookColorView *)colorView
{
//    NSLog(@"%f",self.y);
//    NSLog(@"%f",colorView.bottom);
    if ((self.y - colorView.y > 0.001) && (colorView.bottom - self.y > 0.001)) {
        
        if (self.direction == DragDirecitonCenter) {
            return true;
        }
        self.height = self.height - (colorView.bottom - self.y);
        self.y = colorView.bottom;
        self.bottomDragView.centerY = self.height - Drag_Point_Size/3.0;
        self.bgImgView.frame = self.bounds;
        return true; 
    }
    
    if ((colorView.y - self.y > 0.001 ) && (self.bottom - colorView.y > 0.001))
    {
        if (self.direction == DragDirecitonCenter)
        {
            return true;
        }
        self.height = colorView.y - self.y;
        self.bottomDragView.centerY = self.height - Drag_Point_Size/3.0;
        self.bgImgView.frame = self.bounds;
        return true;
    }
    
    return false;
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touch_point = [touch locationInView:self];
    
    self.direction = [self directionWithPoint:touch_point];
    
    if (self.direction == DragDirecitonCenter) {
        orignRect = self.frame;
        self.orignColumn = self.columnIdx;
    }
    
    start_point = [self convertPoint:touch_point toView:self.superview];
    
    [self touchBeganAtPoint:start_point];
    
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s : %@",__FUNCTION__,NSStringFromCGPoint(touch_point));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint move_point = [self convertPoint:touchPoint toView:self.superview];
    
    if (![self touchMoveAtPoint:move_point])
    {
        return;
    }
    NSLog(@"%s : %@",__FUNCTION__,NSStringFromCGPoint(touchPoint));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touch_point = [touch locationInView:self];
    
    CGPoint end_point = [self convertPoint:touch_point toView:self.superview];
    [self touchEndAtPoint:end_point];
    
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s : %@",__FUNCTION__,NSStringFromCGPoint(touch_point));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touch_point = [touch locationInView:self];
    CGPoint end_point = [self convertPoint:touch_point toView:self.superview];
    
    if (![self isSelfMove])
    {
        self.showDragPoint = false;
    }
    [self touchEndAtPoint:end_point];
    
    
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s : %@",__FUNCTION__,NSStringFromCGPoint(touch_point));
}

#pragma mark - drag dirction
- (DragDireciton) directionWithPoint:(CGPoint)point
{
    DragDireciton direction = DragDirecitonNone;
    if (CGRectContainsPoint(self.bounds, point))
    {
        direction = DragDirecitonCenter;
    }
    
    if (self.showDragPoint) {
        CGRect topDragRect = CGRectMake(VIEW_WIDTH/2.0, 0, VIEW_WIDTH/2.0, kDragHeight);
        CGRect bottomDragRect = CGRectMake(0, self.height - kDragHeight, VIEW_WIDTH/2.0, kDragHeight);
        
        if (CGRectContainsPoint(topDragRect, point))
        {
            direction = DragDirecitonTop;
        }
        
        if (CGRectContainsPoint(bottomDragRect, point))
        {
            direction = DragDirecitonBottom;
        }
    }
    return direction;
}



#pragma mark - custome toutch

- (void) touchBeganAtPoint:(CGPoint)point
{
    tap = true;
    start_point = point;
    pre_point = start_point;
    move_count = 0;
}

- (bool) touchMoveAtPoint:(CGPoint)point
{
    tap = false;
    move_count ++;
    if (![self isSelfMove] && !self.dragNew)
    {
        return false;
    }
    
    if (self.direction == DragDirecitonCenter)
    {
        CGFloat x_move = point.x - pre_point.x;
        CGFloat y_move = point.y - pre_point.y;
        self.x += x_move;
        self.y += y_move;
        pre_point = point;
    }
    else
    {
        CGFloat distance = point.y - pre_point.y;
        
        if (self.direction == DragDirecitonTop)
        {
            if ((self.height - distance) > 0)
            {
                self.y += distance;
                self.height -= distance;
            }
            
            if (self.height <= kMinHeight )
            {
//                self.y -= distance;
                self.y = self.bottom - kMinHeight;
                self.height = kMinHeight;
               
            }
        }
        
        if (self.direction == DragDirecitonBottom)
        {
            if ((self.height + distance) > 0)
            {
                self.height += distance;
            }
            
            if (self.height <= kMinHeight )
            {
                self.height = kMinHeight;
            }
           
        }
        
        pre_point = point;
    }
    UIView *superView = self.superview;
    CGSize maxSize;
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        maxSize = ((UIScrollView *)superView).contentSize;
    }
    else
    {
        maxSize = CGSizeMake(superView.width, superView.height);
    }
    if (self.x < GAP)
    {
        self.x = GAP;
    }
    if (self.y < 0) {
        if (self.direction == DragDirecitonTop)
        {
            self.height = self.height + (self.y - 0);
        }
        self.y = 0;
    }
    if (self.right >= maxSize.width - GAP)
    {
        self.right = maxSize.width - GAP;
    }
    if (self.bottom >= maxSize.height)
    {
        if (self.direction == DragDirecitonBottom)
        {
            self.height = self.height - (self.bottom - maxSize.height);
        }
        self.bottom = maxSize.height;
    }
    
//    if (self.bottom - self.y <= kMinHeight) {
//        self.height = kMinHeight;
//    }
    self.bottomDragView.centerY = self.height - Drag_Point_Size/3.0;
    self.bgImgView.frame = self.bounds;
    
    if ([self.delegate respondsToSelector:@selector(onTouchMoved:)]) {
        [self.delegate onTouchMoved:self];
    }
    
    if (self.direction != DragDirecitonCenter) {
        if ([self.delegate respondsToSelector:@selector(intersectedOnBoundChanged:)]) {
            if ([self.delegate intersectedOnBoundChanged:self]) {
                return false;
            }
        }
    }
    return true;
}

- (void) touchEndAtPoint:(CGPoint)point
{
    if (tap) {
        NSLog(@"tapped");
        if ([self.delegate respondsToSelector:@selector(onPressed:)]) {
            self.showDragPoint = !self.showDragPoint;
            [self.delegate onPressed:self];
        }
        tap = false;
        return;
    }
    
    if ( ![PersonalProfile currentProfile].access_write_reservation && [self.book.book_id integerValue] > 0 && self.book.create_uid.integerValue > 0 && ![self.book.create_uid isEqualToNumber:[PersonalProfile currentProfile].userID] )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您无权修改别人创建的预约单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        self.columnIdx = self.orignColumn;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = orignRect;
        } completion:nil];
        return;
    }
    
    if ( [self.book.state isEqualToString:@"billed"] )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已开单的预约,不能更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        self.columnIdx = self.orignColumn;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = orignRect;
        } completion:nil];
        return;
    }
    
    if (self.direction == DragDirecitonCenter) {
        NSInteger idx = round(self.x / VIEW_WIDTH);
        self.columnIdx = idx;
        if ([self.delegate respondsToSelector:@selector(intersectedOnPositionMovedEnd:)]) {
            if ([self.delegate intersectedOnPositionMovedEnd:self]) {
                self.columnIdx = self.orignColumn;
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = orignRect;
                } completion:nil];
                return;
            }
            else
            {
                if (self.columnIdx != self.orignColumn) {
                    if ([self.delegate respondsToSelector:@selector(changeTipsMessage:)]) {
                        NSString *message = [self.delegate changeTipsMessage:self];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        return;
                    }
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.x = idx * VIEW_WIDTH + GAP;
                } completion:nil];
                
            }
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.x = idx * VIEW_WIDTH + GAP;
            } completion:nil];
        }
    }
    
    if (self.dragNew) {
        self.dragNew = false;
    }
    
    if (![self isSelfMove]) {
        NSLog(@"scroll View 滚动");
        return;
    }
    
    
    self.book.start_date = [self dateFromY:self.y];
    self.book.end_date = [self dateFromY:self.bottom];
    if ([self.delegate respondsToSelector:@selector(onDragEnd:)]) {
        [self.delegate onDragEnd:self];
    }
}

- (bool)isSelfMove
{
    if (move_count <= 4) {
        NSLog(@"scrollView 滚动或者滚动次数太少");
        if ([self.delegate respondsToSelector:@selector(onTouchMoved:)]) {
            [self.delegate onTouchMoved:self];
            //            self.showDragPoint = false;
        }
        return false;
    }
    return true;
}


- (NSString *)dateFromY:(CGFloat)y
{
    y = y - TOP_SPACE;
    CGFloat totalMinute = y / HEIGHT_PER;
    NSInteger hour = START_HOUR + floor(totalMinute/60);
    
    NSInteger other_minute = totalMinute - (hour - START_HOUR) * 60;
    NSInteger minute = floor(other_minute);
    NSInteger second = (other_minute - minute) * 60;
    if (hour == START_HOUR - 1) {
        hour = START_HOUR;
        minute = 0;
        second = 0;
    }
    if (hour == END_HOUR) {
        hour = END_HOUR - 1;
        minute = 59;
        second = 59;
    }
    
    NSString *date = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",year,month,day, hour,minute,second];
    NSLog(@"date: %@",date);
    return date;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
        self.columnIdx = self.orignColumn;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = orignRect;
        } completion:nil];
        return;
    }
    if (buttonIndex == 1) {
        NSLog(@"确定");
        [UIView animateWithDuration:0.25 animations:^{
            self.x = self.columnIdx * VIEW_WIDTH + GAP;
        } completion:nil];
        self.book.start_date = [self dateFromY:self.y];
        self.book.end_date = [self dateFromY:self.bottom];
        if ([self.delegate respondsToSelector:@selector(onDragEnd:)]) {
            [self.delegate onDragEnd:self];
        }
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    //    [self removeGestureRecognizer:self.tapGesture];
}

@end
