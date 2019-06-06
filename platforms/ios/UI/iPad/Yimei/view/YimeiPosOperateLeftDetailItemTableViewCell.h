//
//  YimeiPosOperateLeftDetailItemTableViewCell.h
//  ds
//
//  Created by jimmy on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@interface YimeiPosOperateLeftDetailItemTableViewCell : UITableViewCell

@property(nonatomic, strong)CDPosProduct* product;
@property(nonatomic)BOOL isLastLine;

//+ (CGSize)buweiHeight:(NSArray*)buweis;
+ (CGSize)buweiHeightString:(NSString*)s;

@end
