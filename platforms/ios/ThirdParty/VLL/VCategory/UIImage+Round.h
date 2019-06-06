//
//  UIImageEx.h
//  Tinger_iPhone
//
//  Created by Jimmy on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Round)

-(UIImage*) createRoundedRectImage:(CGSize)size ovalSize: (CGSize)ovalSize;
-(UIImage*) createEllipseImage:(CGSize)size;

@end
