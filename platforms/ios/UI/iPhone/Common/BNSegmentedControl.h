//
//  BNSegmentedControl.h
//  WeiReport
//
//  Created by XiaXianBing on 14-7-21.
//
//

#import <Foundation/Foundation.h>

@class BNSegmentedControl;
@protocol BNSegmentedControlDelegate <NSObject>
@optional
- (void)segmentedControl:(BNSegmentedControl *)segmentedControl didSelectedAtIndex:(NSInteger)selectedIndex;
@end

@interface BNSegmentedControl : UISegmentedControl
{
	NSMutableArray *_items;
    NSArray *_leftImageItems;
    NSArray *_centerImageItems;
    NSArray *_rightImageItems;
    UIFont  *_textFont;
    UIColor *_normalFontColor;
    UIColor *_selectFontColor;
}

@property (nonatomic, assign) id<BNSegmentedControlDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSArray *leftImageItems;
@property (nonatomic, strong) NSArray *centerImageItems;
@property (nonatomic, strong) NSArray *rightImageItems;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *normalFontColor;
@property (nonatomic, strong) UIColor *selectFontColor;

- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithItems:(NSArray *)items;

- (void)setCurrentIndex:(NSInteger)index;

@end
