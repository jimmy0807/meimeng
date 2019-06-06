//
//  ICProgressView.h
//  BetSize
//
//  Created by jimmy on 12-10-27.
//
//

#import <UIKit/UIKit.h>

@interface ICProgressView : UIProgressView
{
	UIColor *_tintColor;
    UIColor *_backgroundColor;
}

- (void) setTintColorWithImage:(UIImage *)aIamge;
- (void) setBackGroundTintColorWithImage:(UIImage *)aIamge;

@end
