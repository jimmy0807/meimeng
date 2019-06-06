//
//  VSliderView.h
//  PaintingTycoon
//
//  Created by Vincent on 12/25/12.
//  Copyright (c) 2012 InnovClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSliderView;
@protocol VSliderViewDelegate <NSObject>
- (void)sliderView: (VSliderView*) sliderView didSlide: (NSUInteger)location;
@end

@interface VSliderView : UIView

- (id)initWithFrame:(CGRect)frame;

@property(nonatomic, retain) UIImageView* backgroundImageView;
@property(nonatomic, assign) NSRange range;
@property(nonatomic, assign) CGFloat currentLocation;
@property(nonatomic, assign) id<VSliderViewDelegate> delegate;

- (void)setLeftForgroundImage: (UIImage*)image;
- (void)setRightForgroundImage: (UIImage*)image;
- (void)setSliderButtonImage: (UIImage*)image forState:(UIControlState)state;
@end
