//
//  VTouchScrollView.m
//  mojito
//
//  Created by vincent on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VTouchTableView.h"

@implementation VTouchTableView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SEL selector = @selector(tableViewDidTouchUp:);
    if ([self.delegate respondsToSelector: selector]) 
    {
        [self.delegate performSelector: selector withObject: self];
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
