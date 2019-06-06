//
//  KeyBordAccessoryView.h
//  Boss
//
//  Created by jiangfei on 16/7/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBordAccessoryViewDelegate <NSObject>

@optional

-(void)keyBordAccessoryViewCompleteItemClick;

@end
@interface KeyBordAccessoryView : UIToolbar
/** accessory*/
@property (nonatomic,weak)id <KeyBordAccessoryViewDelegate>accessoryDelegate;

+(instancetype)keyBordAccessoryView;
@end
