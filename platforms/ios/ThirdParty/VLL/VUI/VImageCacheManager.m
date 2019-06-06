//
//  VImageCacheManager.m
//  BetSize
//
//  Created by Vincent on 11/13/12.
//
//

#import "VImageCacheManager.h"

//@interface VCacheManagerItem : NSObject
//
//@property(nonatomic, assign) NSInteger count;
//@property(nonatomic, copy) NSString* filePath;
//@property(nonatomic, retain) UIImage* image;
//@end
//
//@implementation VCacheManagerItem
//
//- (id)init
//{
//    self = [super init];
//    if (self)
//    {
//        self.count = 1;
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    self.filePath = nil;
//    self.image = nil;
//    [super dealloc];
//}
//
//@end
#import "VFileImage.h"

static VImageCacheManager* s_sharedImageCacheManager;

@implementation VImageCacheManager
@synthesize imageDictionary;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.imageDictionary = [NSMutableDictionary dictionary];
        _locker = [[NSRecursiveLock alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveMemoryWarning:) name: @"UIApplicationMemoryWarningNotification" object: nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_locker release];
    self.imageDictionary = nil;
    [super dealloc];
}

+ (VImageCacheManager*)sharedManager
{
    @synchronized(s_sharedImageCacheManager)
    {
        if (s_sharedImageCacheManager == nil)
        {
            s_sharedImageCacheManager = [[VImageCacheManager alloc] init];
        }
    }
    return s_sharedImageCacheManager;
}

- (void)addFileImage: (VFileImage*)fileImage
{
    if ([fileImage.filePath length] > 0)
    {
        [_locker lock];
        [self.imageDictionary setObject: fileImage forKey: fileImage.filePath];
        [_locker unlock];
    }
}

- (void)removeFileImage: (VFileImage*)fileImage
{
    if ([fileImage.filePath length] > 0)
    {
        [_locker lock];
        [self.imageDictionary removeObjectForKey: fileImage.filePath];
        [_locker unlock];
    }
}

- (VFileImage*)fileImageWithFilePath: (NSString*)filePath
{
    VFileImage* image = nil;
    if ([filePath length] > 0)
    {
        [_locker lock];
        image = [self.imageDictionary objectForKey: filePath];
        [_locker unlock];
    }
    return image;
}

- (void)didReceiveMemoryWarning: (NSNotification*)notification
{
    [_locker lock];
    [self.imageDictionary removeAllObjects];
    [_locker unlock];
}
@end
