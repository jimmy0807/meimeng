//
//  BSPopupView.m
//  Boss
//
//  Created by lining on 16/10/9.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSPopupArrowView.h"
#import "UIImage+Resizable.h"

#define Max_Table_Height  300
#define Row_Height  50

@interface BSPopupArrowView ()
@property (nonatomic, assign) PopupViewStyle style;

@end

@implementation BSPopupArrowView

+ (instancetype)createView
{
    BSPopupArrowView *popView = [self loadFromNib];
    
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    popView.alpha = 0.0;
    return popView;
}

+ (instancetype)createViewWithStyle:(PopupViewStyle)style
{
    BSPopupArrowView *popView = [self loadFromNib];
    popView.style = style;
    
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    popView.alpha = 0.0;
    return popView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.bgBtn.backgroundColor = [UIColor blackColor];
    self.bgBtn.alpha = 0.6;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.masksToBounds = true;
    
    for (NSLayoutConstraint *constraint in self.arrowView.superview.constraints) {
        if (constraint.firstItem == self.arrowView || constraint.secondItem == self.arrowView) {
            [self.arrowView.superview removeConstraint:constraint];
        }
        
    }
    
    UIImage *arrowImg = [UIImage imageNamed:@"sale_back.png"];
    
    self.arrowView.backgroundColor = [UIColor clearColor];
    self.width = arrowImg.size.width;
    
    self.arrowImgView.image = [[UIImage imageNamed:@"sale_back.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(20, 100, 150, 40)];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
}




- (void)setItems:(NSArray<PopupItem *> *)items
{
    _items = items;
    self.height = items.count * Row_Height;
    
    [self.tableView reloadData];
}

- (void)setHeight:(CGFloat)height
{
    if (height > 300) {
        height = 300;
        self.tableView.scrollEnabled = true;
    }
    else
    {
        self.tableView.scrollEnabled = false;
    }
    _height = height;
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}


- (void)setWidth:(CGFloat)width
{
    _width = width;
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}


- (void)showArrowView:(UIView *)view
{
    CGRect frame = [view convertRect:view.bounds toView:nil];
    [self.arrowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(frame.origin.y + frame.size.height + 3);
        CGFloat rightMargin = (IC_SCREEN_WIDTH - (frame.origin.x + frame.size.width/2.0)) - 20;
        make.right.offset(-rightMargin);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
    
}


- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PopupItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.imageName.length > 0) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.imageView.image = [UIImage imageNamed:item.imageName];
    cell.textLabel.text = item.title;
    
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Row_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    PopupItem *item = [self.items objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:item.function]) {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:item.function withObject:nil]);
    }
    else if ([self.delegate respondsToSelector:@selector(didSelectedItem:atIndexPath:)]) {
        
        [(id<BSPopupArrowViewDelegate>)self.delegate didSelectedItem:self atIndexPath:indexPath];
    }
    [self hide];
}
- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

@end


@implementation PopupItem

@end
