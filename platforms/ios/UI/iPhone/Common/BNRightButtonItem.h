//
//  BNRightButtonItem.h
//  Boss
//
//  Created by XiaXianBing on 15/6/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNRightButtonItemDelegate <NSObject>
@optional
- (void)didRightBarButtonItemClick:(id)sender;
@end


@interface BNRightButtonItem : UIBarButtonItem

- (id)initWithTitle:(NSString *)title;
- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted;

@property (nonatomic, assign) id<NSObject> delegate;
@property (nonatomic, copy) NSString *btnTitle;

@end
