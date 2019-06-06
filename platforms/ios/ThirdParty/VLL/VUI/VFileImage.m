//
//  VFileImage.m
//  BetSize
//
//  Created by Vincent on 11/13/12.
//
//

#import "VFileImage.h"
#import "VImageCacheManager.h"

@implementation VFileImage

- (void)dealloc
{
    NSLog(@"VFileImage delloc");
    self.filePath = nil;
    [super dealloc];
}

- (oneway void)release
{
    if ([self.filePath length] == 0 || needDelete)
    {
        [super release];        
    }
    else
    {
        [super release];
        if ([self.filePath length] > 0 && self.retainCount == 1)
        {
            needDelete = YES;
            [[VImageCacheManager sharedManager] removeFileImage: self];
        }
    }
}

- (id)initWithContentsOfFile:(NSString *)path
{
    self = [super initWithContentsOfFile: path];
    if (self)
    {
        self.filePath = path;
    }
    return  self;
}

+ (VFileImage *)imageWithContentsOfFile:(NSString *)path
{
    if ([path length] == 0)
    {
        return nil;
    }
    VFileImage* image = [[VImageCacheManager sharedManager] fileImageWithFilePath: path];
    if (image)
    {
        return image;
    }
    image = [[[VFileImage alloc] initWithContentsOfFile: path] autorelease];
    if (image == nil)
    {
        return nil;
    }
    [[VImageCacheManager sharedManager] addFileImage: image];
    return image;
}

+ (void)removeFileImage:(NSString *)path
{
    VFileImage* image = [[VImageCacheManager sharedManager] fileImageWithFilePath: path];
    [[VImageCacheManager sharedManager] removeFileImage:image];
}

@end
