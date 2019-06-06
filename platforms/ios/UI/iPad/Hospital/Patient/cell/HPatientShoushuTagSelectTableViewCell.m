//
//  HPatientShoushuTagSelectTableViewCell.m
//  meim
//
//  Created by jimmy on 2017/8/22.
//
//

#import "HPatientShoushuTagSelectTableViewCell.h"

@implementation HPatientShoushuTagSelectTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for ( UIView* subview in self.subviews )
    {
        for ( UIView* subview2 in subview.subviews )
        {
            if ( [subview2.description rangeOfString:@"UITableViewCellActionButton"].location != NSNotFound )
            {
                for (UIView* view in subview2.subviews )
                {
                    if ( [view.description rangeOfString:@"UIButtonLabel"].location != NSNotFound )
                    {
                        if ( [view isKindOfClass:[UILabel class]] )
                        {
                            ((UILabel*)view).font = [UIFont systemFontOfSize:16];
                        }
                    }
                }
            }
        }
    }
}

@end
