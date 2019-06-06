//
//  CBRightButtonItem.h
//  CardBag
//
//  Created by chen yan on 13-10-18.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBRightButtonItem;
@protocol CBRightButtonItemDelegate <NSObject>
@optional
- (void)didRightBarButtonItemPressed:(CBRightButtonItem *)barButtonItem;
@end

@interface CBRightButtonItem : UIBarButtonItem

@property (nonatomic, assign) id<CBRightButtonItemDelegate> delegate;

- (id)initWithTitle:(NSString *)title;
- (id)initWithNormalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted;

@end
