//
//  ProjectBuweiManager.m
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import "ProjectBuweiManager.h"

static ProjectBuweiManager* s_sharedManager = nil;

@interface ProjectBuweiManager()

@end

@implementation ProjectBuweiManager

+ (ProjectBuweiManager*)sharedManager
{
    @synchronized(s_sharedManager)
    {
        if (s_sharedManager == nil)
        {
            s_sharedManager = [[ProjectBuweiManager alloc] init];
        }
    }
    
    return s_sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"YimeiHead" ofType:@"plist"];
        self.headArray = [NSArray arrayWithContentsOfFile:plistPath];
        plistPath = [[NSBundle mainBundle] pathForResource:@"YimeiBody" ofType:@"plist"];
        self.bodyArray = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    return self;
}

@end
