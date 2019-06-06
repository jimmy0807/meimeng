//
//  VScrolledMenu.h
//  VLL (VinStudio Link Library)
//
//  Created by vincent on 5/13/11.
//  Copyright 2011 VinStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VScrolledMenu;

@protocol VScrolledMenuDelegate <NSObject>
@optional
-(void)vScrolledMenu: (VScrolledMenu*) vScrolledMenu didSelectItem: (NSInteger)index;
@end

typedef enum
{
    VScrolledMenuAnimationViewTypeFloating,
    VScrolledMenuAnimationViewTypeMiddle,
}VScrolledMenuAnimationViewType;

@interface VScrolledMenu : UIView {
    NSMutableArray*    itemButtonArray;
    UIImageView* backGroundImageView;
    UIImageView*    selectedImageView;
    id<VScrolledMenuDelegate> delegate;
    UIScrollView*       _scrollView;
    NSInteger       selectedIndex;
    VScrolledMenuAnimationViewType animationViewType;
    NSInteger notSelectedIndex;
}
@property(nonatomic, retain) UIImage* selectedImage;
@property(nonatomic)    NSInteger itemCount;
@property(nonatomic, retain) NSMutableArray*    itemButtonArray;
@property(nonatomic, retain) UIImage* backGroundImage;
@property (nonatomic, assign) id<VScrolledMenuDelegate> delegate;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic)  BOOL animatedSelection;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, assign) VScrolledMenuAnimationViewType animationViewType;
@property (nonatomic) NSInteger notSelectedIndex;

-(void)setItemImage:(UIImage*) image atIndex:(NSInteger)index;
-(void)setItemImageSelected:(UIImage*) image atIndex:(NSInteger)index;
-(void)setItemText:(NSString*)text atIndex:(NSInteger)index;
-(void)setBarHeight:(CGFloat) height;
-(void)setSelectedImage:(UIImage*)image atY: (CGFloat)y;
-(void)adjustAllTabsAccordingToImageSize;
@end
