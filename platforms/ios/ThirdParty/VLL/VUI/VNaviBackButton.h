//
//  VNaviBackButton.h
//  VLL (VinStudio Link Library)
//
//  Created by vincent on 4/29/11.
//  Copyright 2011 VinStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSoundButton.h"

@interface VNaviBackButton : UIBarButtonItem {
    id<NSObject> _delegate;
    VSoundButton* button;
}

- (id)initWithImage:(UIImage *)image;
@property (nonatomic, assign) id<NSObject> delegate;
@property (nonatomic, retain) VSoundButton* button;

@end
