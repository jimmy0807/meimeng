//
//  VStatusBarOverlay.m
//  Spark2
//
//  Created by Vincent on 9/19/12.
//
//

#import "VStatusBarOverlay.h"

static VStatusBarOverlay* s_sharedOverlay = nil;

@implementation VStatusBarOverlay
@synthesize texts;
@synthesize delegateStack;

- (id)init
{
    self = [super initWithFrame: CGRectMake(320 - 120, 0, 120, 20)];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor blackColor];

        self.delegateStack = [NSMutableArray array];
        self.texts = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    if (_durationTimer)
    {
        [_durationTimer invalidate];
        SAFE_RELEASE(_durationTimer);
    }
    [_tableView release];
    
    self.texts = nil;
    self.delegateStack = nil;
    [super dealloc];
}

+ (VStatusBarOverlay*)sharedOverlay
{
    @synchronized(s_sharedOverlay)
    {
        if (s_sharedOverlay == nil)
        {
            s_sharedOverlay = [[VStatusBarOverlay alloc] init];
        }
    }
    return s_sharedOverlay;
}

- (void)show
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        [self addSubview: _tableView];;
    }
    toRemove = NO;
    self.hidden = NO;
    [_tableView reloadData];
}

- (void)hideAnimation
{
    toRemove = YES;
    [_tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: self.texts.count + 1 inSection: 0] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
    //[self performSelector: @selector(hide) withObject: nil afterDelay: 0.4];
}

- (void)hide
{
    [self.texts removeAllObjects];
    [_tableView removeFromSuperview];
    SAFE_AUTORELEASE(_tableView);
    self.hidden = YES;
}

- (void)addText: (NSString*)text userInfo: (NSDictionary*)userInfo duration: (NSTimeInterval)duration
{
    BOOL animated = (duration > 0);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          text, @"text",
                          userInfo, @"userInfo"
                          , nil];
    id<VStatusBarOverlayDelegate> delegate = [self.delegateStack lastObject];
    BOOL needShow = YES;
    if ([delegate respondsToSelector: @selector(statusOverlay:needShowMessage:)])
    {
        needShow = [delegate statusOverlay: self needShowMessage: userInfo];
    }
    if (needShow)
    {
        [self.texts addObject: dict];
        _duration = duration;
        [self performSelectorOnMainThread: @selector(showOneMessage:) withObject: [NSNumber numberWithBool: animated] waitUntilDone: NO];
    }
    else
    {
        [self performSelectorOnMainThread: @selector(hideAnimation) withObject: nil waitUntilDone: NO];
    }

}

- (void)showOneMessage: (NSNumber*)animated
{
    [self show];
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: self.texts.count inSection: 0] atScrollPosition:UITableViewScrollPositionBottom animated: [animated boolValue]];
    if (_durationTimer)
    {
        [_durationTimer invalidate];
        SAFE_RELEASE(_durationTimer);
    }
    _durationTimer = [[NSTimer scheduledTimerWithTimeInterval: _duration target: self selector: @selector(durationTimeOut) userInfo: nil repeats: NO] retain];
}

- (void)durationTimeOut
{
    SAFE_AUTORELEASE(_durationTimer) ;
    [self hideAnimation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.texts.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 10];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0 || indexPath.row == self.texts.count + 1)
    {
        cell.textLabel.text = @"";
    }
    else
    {
        NSDictionary* dict = [self.texts objectAtIndex: indexPath.row - 1];
        cell.textLabel.text =  [dict objectForKey: @"text"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [self.texts objectAtIndex: indexPath.row - 1];
    [[NSNotificationCenter defaultCenter] postNotificationName: kVStatusBarOverlayClickedNotification object: self userInfo: [dict objectForKey: @"userInfo"]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (toRemove)
    {
        [self hide];
    }
}

- (void)pushDelegate: (id<VStatusBarOverlayDelegate>) aDelegate
{
    [self.delegateStack addObject: aDelegate];
}

- (void)popDelegate
{
    [self.delegateStack removeLastObject];
}

@end
