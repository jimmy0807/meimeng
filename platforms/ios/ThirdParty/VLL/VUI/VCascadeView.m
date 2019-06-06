//
//  VCascadeView.m
//  Spark2
//
//  Created by Vincent on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VCascadeView.h"

@implementation VCascadeView
@synthesize delegate;
@synthesize tableViews;
@synthesize contentSizeHeight;
@synthesize contentOffset;
@synthesize contentInset;
//@synthesize contentSize;
@synthesize contentSizeOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableViews = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    self.tableViews = nil;
    [super dealloc];
}

- (void)reloadData
{
    CGFloat maxContentHeight = 0.0;
    NSInteger numberOfTableViews = [self.delegate cascadeViewNumberOfColumn: self];
    [self loadTableViews: numberOfTableViews];
    for (UITableView* tableview in self.tableViews) 
    {
        [tableview reloadData];
        CGFloat theContentSize = tableview.contentSize.height;
        if (theContentSize > maxContentHeight) 
        {
            maxContentHeight = theContentSize;
        }
    }
    if (maxContentHeight != contentSizeHeight) 
    {
        contentSizeHeight = maxContentHeight;
        for (UITableView* tableview in self.tableViews) 
        {
            tableview.contentSize = CGSizeMake(tableview.frame.size.width,  maxContentHeight + contentSizeOffset);
        }
        if ([self.delegate respondsToSelector: @selector(cascadeView:didContentSizeChanged:)]) 
        {
            [self.delegate cascadeView: self didContentSizeChanged: contentSizeHeight];
        }
    }
}

- (void)reloadCellAtIndexPath: (NSIndexPath*)indexPath
{
    [self reloadCellAtIndexPath: indexPath animation: UITableViewRowAnimationNone];
}

- (void)reloadCellAtIndexPath: (NSIndexPath*)indexPath animation: (UITableViewRowAnimation)animation
{
    NSInteger col = indexPath.section;
    if (col >= self.tableViews.count) 
    {
        return;
    }
    UITableView* tableView = [self.tableViews objectAtIndex: col];
    NSInteger row = indexPath.row;
    NSIndexPath* idxPath = [NSIndexPath indexPathForRow: row inSection: 0];
    [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: idxPath] withRowAnimation:animation];
    [self checkContentSize];        
}

- (void)loadTableViews: (NSInteger)numberOfTableViews
{
    if (numberOfTableViews == tableViews.count) 
    {
        return;
    }
    if (numberOfTableViews < tableViews.count) 
    {
        NSInteger removeCount = tableViews.count - numberOfTableViews;
        for (NSInteger i = 0; i < removeCount; ++i) 
        {
            UITableView* tableView = [tableViews objectAtIndex: 0];
            [tableView removeFromSuperview];
            [tableViews removeObject: tableView];
        }
    }
    else 
    {
        NSInteger addCount = numberOfTableViews - tableViews.count;
        for (NSInteger i = 0; i < addCount; ++i) 
        {
            UITableView* tableView = [[[UITableView alloc] initWithFrame: CGRectMake(0, 0, 1, 1) style:UITableViewStylePlain] autorelease];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.allowsSelection = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            [self addSubview: tableView];
            [tableViews addObject: tableView];
        }
    }
    CGFloat width = self.frame.size.width / self.tableViews.count;
    for (NSInteger i = 0; i < self.tableViews.count; ++i) 
    {
        UITableView* tableView = [self.tableViews objectAtIndex: i];
        tableView.tag = i;
        tableView.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
    }
}

- (void)insertRowAtIndexPath: (NSIndexPath*)indexPath animated: (BOOL)animated
{
    NSInteger col = indexPath.section;
    if (col >= self.tableViews.count) 
    {
        return;
    }
    UITableView* tableView = [self.tableViews objectAtIndex: col];
    NSIndexPath* idxPath = [NSIndexPath indexPathForRow: indexPath.row inSection: 0];
    [tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: idxPath] withRowAnimation: UITableViewRowAnimationTop];
    [self checkContentSize];
}

- (void)insertNumberOfRowsAtTail: (NSInteger)number animation: (UITableViewRowAnimation)animation
{
    NSInteger tailIndex = 0;
    NSInteger max = 0;
    NSInteger i = 0;
    
    NSMutableArray* indexsArray = [NSMutableArray array];
    for (UITableView* tableView in self.tableViews) 
    {
        if ([tableView numberOfRowsInSection: 0] >= max) 
        {
            max = [tableView numberOfRowsInSection: 0];
            tailIndex = i;
        }
        i++;
        [indexsArray addObject: [NSMutableArray array]];
    }
    
    for (int j = 0; j < number; ++j) 
    {
        NSInteger toInsertTableViewCol;
        if (self.tableViews.count == 0)
        {
            toInsertTableViewCol = 0;
        }
        else
        {
            toInsertTableViewCol = (tailIndex + 1 + j) % self.tableViews.count;
        }
        UITableView* toAddTableView = [self.tableViews objectAtIndex: toInsertTableViewCol];
        NSMutableArray* indexs = [indexsArray objectAtIndex: toInsertTableViewCol];
        NSInteger row = [toAddTableView numberOfRowsInSection: 0];
        NSIndexPath* idxPath = [NSIndexPath indexPathForRow: row + (j / self.tableViews.count) inSection: 0];
        [indexs addObject: idxPath];  
    }
    for (int k = 0; k < self.tableViews.count; ++k) 
    {
        UITableView* toAddTableView = [self.tableViews objectAtIndex: k];
        [toAddTableView insertRowsAtIndexPaths: [indexsArray objectAtIndex: k] withRowAnimation: animation];
    }
    [self checkContentSize];
}

- (void)deleteRowAtTailWithAnimation: (UITableViewRowAnimation)animation
{
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger col = tableView.tag;
    return [self.delegate cascadeView: self numberOfRowInColumn: col];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger col = tableView.tag;
    NSInteger row = indexPath.row;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: row inSection: col];
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        UIView* view = [self.delegate cascadeView: self viewForIndexPath: ipath];
        [cell.contentView addSubview: view];
    }
    
    [self.delegate cascadeView:self viewInCell:[cell.contentView.subviews objectAtIndex:0] viewForIndexPath:ipath];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger col = tableView.tag;
    NSInteger row = indexPath.row;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: row inSection: col];
    return [self.delegate cascadeView: self heightForIndexPath: ipath];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.tag;
    for (int i = 0; i < self.tableViews.count; ++i) 
    {
        if (i != index) 
        {
            UITableView* tablewView = [self.tableViews objectAtIndex: i];
            [tablewView setContentOffset: scrollView.contentOffset];
        }
    }
    contentOffset = scrollView.contentOffset;
    if ([self.delegate respondsToSelector: @selector(cascadeViewDidScroll:)]) 
    {
        [self.delegate cascadeViewDidScroll: self];
    }
    if ( scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height )
    {
        if ( [self.delegate respondsToSelector:@selector(cascadeViewDidScrollToEnd:)] )
        {
            [self.delegate cascadeViewDidScrollToEnd:self];
        }
    }
}

- (void)checkContentSize
{
    CGFloat maxContentHeight = 0.0;
    for (UITableView* tableview in self.tableViews) 
    {
        CGFloat contentSize = tableview.contentSize.height;
        if (contentSize > maxContentHeight) 
        {
            maxContentHeight = contentSize;
        }
    }
    if (maxContentHeight != contentSizeHeight) 
    {
        contentSizeHeight = maxContentHeight;
        for (UITableView* tableview in self.tableViews) 
        {
            tableview.contentSize = CGSizeMake(tableview.frame.size.width,  maxContentHeight + contentSizeOffset);
        }
        if ([self.delegate respondsToSelector: @selector(cascadeView:didContentSizeChanged:)]) 
        {
            [self.delegate cascadeView: self didContentSizeChanged: contentSizeHeight];
        }
    }
}

- (void)setCascadeFrame
{
    CGRect frame = self.frame;
    NSLog(@"setCascadeFrame = %f",frame.size.height);
    for (UITableView* tableview in self.tableViews) 
    {
        CGRect frame0 = tableview.frame;
        frame0.size.height = frame.size.height;
        tableview.frame = frame0;
    }
}

- (void)setContentInset: (UIEdgeInsets)aContentInset
{
    contentInset = aContentInset;
    for (UITableView* tableview in self.tableViews) 
    {
        tableview.contentInset = aContentInset;
    }   
}

- (void)setVCascadeViewSize: (CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    for (UITableView* tableview in self.tableViews) 
    {
        frame = tableview.frame;
        frame.size.height = height;
        tableview.frame = frame;
    }       
}

@end
