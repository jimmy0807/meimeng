//
//  VTouchScrollView.h
//  mojito
//
//  Created by vincent on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VTouchTableView;
@protocol VTouchTableViewDelegate <UITableViewDelegate>

-(void)tableViewDidTouchUp:(VTouchTableView*)tableView;

@end


@interface VTouchTableView : UITableView {
}

@end
