//
//  UISearchBar+Placeholder.m
//  ds
//
//  Created by lining on 2016/11/21.
//
//

#import "UISearchBar+Placeholder.h"

@implementation UISearchBar (Placeholder)
- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
    
}
@end
