//
//  SpecificationAddPropertyBoomView.h
//  Boss
//
//  Created by jiangfei on 16/7/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SpecificationAddPropertyBoomViewDelegate <NSObject>

@optional

-(void)specificationAddPropertyBoomViewCompletionWithText:(NSString*)text;

@end
typedef void(^SpecificationAddPropertyBoomViewBlock)(BOOL isTransform);
@interface SpecificationAddPropertyBoomView : UIView

+(instancetype)specificationBoomView;
/** placeHold*/
@property (nonatomic,strong)NSString *placeHold;
/** block*/
@property (nonatomic,strong)SpecificationAddPropertyBoomViewBlock beginEditBlock;
/** delegate*/
@property (nonatomic,weak)id<SpecificationAddPropertyBoomViewDelegate>delegate;
@end
