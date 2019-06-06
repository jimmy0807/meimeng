//
//  BNBackButtonItem.h
//  Boss
//
//  Created by XiaXianBing on 15/6/8.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNBackButtonItemDelegate <NSObject>
@optional
- (void)didBackBarButtonItemClick:(id)sender;
@end


@interface BNBackButtonItem : UIBarButtonItem

- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted;

@property (nonatomic, assign) id<NSObject> delegate;

@end
