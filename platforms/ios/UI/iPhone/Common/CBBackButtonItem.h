//
//  CBBackButtonItem.h
//  CardBag
//
//  Created by jimmy on 13-8-6.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBBackButtonItemDelegate <NSObject>
@optional
-(void)didItemBackButtonPressed:(UIButton*)sender;
@end

@interface CBBackButtonItem : UIBarButtonItem

@property(nonatomic, retain) UIButton *btn;
@property(nonatomic, assign)id<NSObject> delegate;

- (id)initWithTitle:(NSString*)title;

@end
