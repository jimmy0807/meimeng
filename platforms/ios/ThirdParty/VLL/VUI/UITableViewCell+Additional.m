//
//  UITableViewCell+Additional.m
//  Spark
//
//  Created by Vincent on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+Additional.h"

@implementation UITableViewCell (Additional)

+ (UITableViewCell*)tableCellFromSubView: (UIView*)view
{
    UITableViewCell* cell = nil;
    UIView* current = view;
    while (current)
    {
        if ([current isKindOfClass: [UITableViewCell class]]) 
        {
            cell = (UITableViewCell*)current;
            break;
        }
        current = current.superview;
    }
    return cell;
}

@end
