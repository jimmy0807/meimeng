//
//  PadBookSelectScrollView.h
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSScrollView.h"

@protocol PadBookSelectScrollViewDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView PadBookSelectScrollView:(UIView*)PadBookSelectScrollView;
@end

@interface PadBookSelectScrollView : UIView

@property(nonatomic, weak)IBOutlet UIScrollView* scrollView;

- (void)initWithTechnicianArray:(NSArray*)technicianArray day:(NSString *)day;
- (void)initWithTableArray:(NSArray *)tableArray day:(NSString *)day;
- (void)setContentSize:(CGSize)contentSize;

@property(nonatomic, weak)id<PadBookSelectScrollViewDelegate> delegate;

- (void)updateCurrentTime:(BOOL)isToday;
- (void)updateDataWithBookArray:(NSArray*)bookArray;
- (void)updateWithDay:(NSString *)day;

- (void)resetDirection:(int)scrollDirection;
- (void) hidePopoverView:(BOOL)animation;

@property(nonatomic, strong)NSString* bookPhoneNumber;
@property(nonatomic, strong)CDMember* bookMember;

- (BOOL)setInitBook:(CDBook*)book delay:(BOOL)isDelay;

@end
