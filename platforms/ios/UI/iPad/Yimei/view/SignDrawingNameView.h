//
//  SignDrawingNameView.h
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import <UIKit/UIKit.h>

@interface DrawLine : NSObject
@property (nonatomic, strong) UIColor *m_Color;
@property (nonatomic, strong) NSArray *pointsArray;
@property float lineWidth;
@end

@protocol SignDrawingNameViewDelegate <NSObject>
@optional
- (void)beginToDraw;
- (void)endDraw;
@end
 
@interface SignDrawingNameView : UIView
{
    NSInteger drawedCount;
    CGPoint lastDrawedPoint;
}

@property(nonatomic, weak)id<SignDrawingNameViewDelegate> delegate;

@property(nonatomic) CGFloat size;
@property(nonatomic, strong) UIColor *m_color;
@property(nonatomic, strong) NSMutableArray *nowDrawPointArray;
@property(nonatomic, strong) NSMutableArray *finishlineArray;
@property(nonatomic, strong) UIImage* savedImage;

-(BOOL)clear;

@end
