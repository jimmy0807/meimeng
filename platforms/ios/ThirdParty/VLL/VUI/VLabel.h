//
//  VLabel.h
//  Spark
//
//  Created by jimmy on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@class VLabel;
@protocol VLabelDelegate <NSObject>
@required
- (void)vLabel:(VLabel *)vLabel touchesWtihTag:(NSInteger)tag;
@end

@interface VLabel : UILabel
{
    id <VLabelDelegate> delegate;
}

@property (nonatomic, assign) id <VLabelDelegate> delegate;
@property (nonatomic, assign) BOOL showInMiddle;

- (id)initWithFrame:(CGRect)frame;

@end
