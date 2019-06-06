//
//  PadBookTechnicianView.m
//  Boss
//
//  Created by jimmy on 15/11/30.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookTechnicianView.h"
#import "PadBookDefine.h"

#define TechnicianLabelTag 982
#define TechnicianButtonTag 2982

@interface PadBookTechnicianView ()<UITextFieldDelegate, UIActionSheetDelegate>
@property(nonatomic, strong) NSArray* technicianArray;
@property(nonatomic, strong) NSArray* tableArray;
@property(nonatomic, strong) NSString* currentTime;
@end

@implementation PadBookTechnicianView

- (void)initWithTechnicianArray:(NSArray*)technicianArray
{
    self.technicianArray = technicianArray;
//    self.scrollView.bounces = true;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH * self.technicianArray.count, self.scrollView.frame.size.height);
    
    for ( int i = 0; i < self.technicianArray.count; i++ )
    {
        CDStaff *staff = [self.technicianArray objectAtIndex:i];
        UITextField* technicianLabel = [[UITextField alloc] initWithFrame:CGRectMake(VIEW_WIDTH * i, 0 , 128, 72)];
        technicianLabel.font = [UIFont boldSystemFontOfSize:16];
        technicianLabel.adjustsFontSizeToFitWidth = TRUE;
        technicianLabel.textColor = COLOR(156, 170, 170, 1);
        technicianLabel.textAlignment = NSTextAlignmentCenter;
        technicianLabel.text = [NSString stringWithFormat:@"%@",staff.local_nickName.length > 0 ? staff.local_nickName : staff.name];
        technicianLabel.delegate = self;
        technicianLabel.tag = TechnicianLabelTag + i;
        [self.scrollView addSubview:technicianLabel];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = technicianLabel.frame;
        //[button addTarget:self action:@selector(didTechnicanButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = TechnicianButtonTag + i;
        [self.scrollView addSubview:button];
//        UILabel* staffNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH * i, 44 , 128, 18)];
//        staffNoLabel.font = [UIFont systemFontOfSize:13];
//        staffNoLabel.textColor = COLOR(156, 170, 170, 1);
//        staffNoLabel.textAlignment = NSTextAlignmentCenter;
//        staffNoLabel.text = [NSString stringWithFormat:@"%@",staff.staffNo];
//        [self.scrollView addSubview:staffNoLabel];
    }
}

- (void)didTechnicanButtonPressed:(UIButton*)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"无",@"早",@"中",@"晚", @"休", nil];
    actionSheet.tag = sender.tag;
    [actionSheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 5 )
    {
        return;
    }
    
    NSInteger i = actionSheet.tag - TechnicianButtonTag;
    CDStaff *staff = [self.technicianArray objectAtIndex:i];
    CDStaffLocalName* s = [[BSCoreDataManager currentManager] findEntity:@"CDStaffLocalName" withPredicateString:[NSString stringWithFormat:@"staffID = %@ && time = \"%@\"", staff.staffID, self.currentTime]];
    if ( s == nil )
    {
        s = [[BSCoreDataManager currentManager] insertEntity:@"CDStaffLocalName"];
        s.time = self.currentTime;
    }
    
    s.staffID = staff.staffID;
    
    UITextField* technicianLabel = (UITextField*)[self viewWithTag:TechnicianLabelTag + i];
    
    if ( buttonIndex == 0 )
    {
        s.name = staff.name;
    }
    else if ( buttonIndex == 1 )
    {
        s.name = [NSString stringWithFormat:@"%@(%@)",staff.name,@"早"];
    }
    else if ( buttonIndex == 2 )
    {
        s.name = [NSString stringWithFormat:@"%@(%@)",staff.name,@"中"];
    }
    else if ( buttonIndex == 3 )
    {
        s.name = [NSString stringWithFormat:@"%@(%@)",staff.name,@"晚"];
    }
    else if ( buttonIndex == 4 )
    {
        s.name = [NSString stringWithFormat:@"%@(%@)",staff.name,@"休"];
    }
    
    technicianLabel.text = s.name;
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)realoadTechnicianName:(NSString*)time
{
    self.currentTime = time;
    
    for ( int i = 0; i < self.technicianArray.count; i++ )
    {
        CDStaff *staff = [self.technicianArray objectAtIndex:i];
        UITextField* technicianLabel = (UITextField*)[self viewWithTag:TechnicianLabelTag + i];
        CDStaffLocalName* s = [[BSCoreDataManager currentManager] findEntity:@"CDStaffLocalName" withPredicateString:[NSString stringWithFormat:@"staffID = %@ && time = \"%@\"", staff.staffID, time]];
        if ( s )
        {
            technicianLabel.text = s.name;
        }
        else
        {
            technicianLabel.text = staff.name;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger i = textField.tag - TechnicianLabelTag;
    CDStaff *staff = [self.technicianArray objectAtIndex:i];
    CDStaffLocalName* s = [[BSCoreDataManager currentManager] findEntity:@"CDStaffLocalName" withPredicateString:[NSString stringWithFormat:@"staffID = %@ && time = \"%@\"", staff.staffID, self.currentTime]];
    if ( s == nil )
    {
        s = [[BSCoreDataManager currentManager] insertEntity:@"CDStaffLocalName"];
        s.time = self.currentTime;
    }
    
    s.name = textField.text;
    s.staffID = staff.staffID;
    
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)initWithTableArray:(NSArray *)tableArray
{
    [self reloadWithTableArray:tableArray];
}

- (void)reloadWithTableArray:(NSArray *)tableArray
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.tableArray = tableArray;
    //    self.scrollView.bounces = true;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH * self.tableArray.count, self.scrollView.frame.size.height);
    
    for ( int i = 0; i < self.tableArray.count; i++ )
    {
        CDRestaurantTable *table = [self.tableArray objectAtIndex:i];
        UILabel* technicianLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH * i, (self.frame.size.height - 30)/2.0 , 128, 30)];
        technicianLabel.font = [UIFont boldSystemFontOfSize:19];
        technicianLabel.textColor = COLOR(156, 170, 170, 1);
        technicianLabel.textAlignment = NSTextAlignmentCenter;
        technicianLabel.text = [NSString stringWithFormat:@"%@",table.tableName];
        [self.scrollView addSubview:technicianLabel];
        
//        UILabel* staffNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH * i, 44 , 128, 18)];
//        staffNoLabel.font = [UIFont systemFontOfSize:13];
//        staffNoLabel.textColor = COLOR(156, 170, 170, 1);
//        staffNoLabel.textAlignment = NSTextAlignmentCenter;
//        //        staffNoLabel.text = [NSString stringWithFormat:@"%@",staff.staffNo];
//        staffNoLabel.text = @"";
//        [self.scrollView addSubview:staffNoLabel];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.x > 0 && offset.x < scrollView.contentSize.width) {
//        offset.x = round(offset.x /69.0) * 69;
//        [scrollView setContentOffset:offset animated:YES];
//    }
    [self.delegate scrollViewDidScroll:scrollView padBookTechnicianView:self];
}

@end
