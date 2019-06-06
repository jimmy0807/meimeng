#import "LanControlServerCallback.h"

void LanControlServerCallback::onReceivePadOrder(const char* data)
{
    if ( data && strlen(data) > 0 )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPadMenuOrderBoardcast object:nil userInfo:@{@"orderNumber":[NSString stringWithCString:data+1 encoding:NSUTF8StringEncoding]}];
    }
}