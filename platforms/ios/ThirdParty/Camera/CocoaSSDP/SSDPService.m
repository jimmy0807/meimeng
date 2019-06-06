//
//  SSDPService.m
//  Copyright (c) 2014 Stephane Boisson
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SSDPService.h"


@implementation SSDPService

- (id)initWithHeaders:(NSDictionary *)headers {
    self = [super init];
    if (self) {
        _location = [headers objectForKey:@"location"];
        NSUInteger location = [_location rangeOfString:@"//"].location + 2;
        NSUInteger length = [_location rangeOfString:@":" options:NSBackwardsSearch].location - location;
        
        if ([_location rangeOfString:@"//"].location == NSNotFound) {
            
            _servicePath = _location;
        }
        else {
            
            _servicePath = [_location substringWithRange:NSMakeRange(location, length)];
        }
        
        _serviceType = [headers objectForKey:@"st"];
        _uniqueServiceName = [headers objectForKey:@"usn"];
        _server = [headers objectForKey:@"server"];
        NSArray* ext = [[headers objectForKey:@"ext"] componentsSeparatedByString:@","];
        if (ext.count == 1) {
            
            _servicePath = ext.firstObject;
        }
        else if (ext.count == 2){
            
            _servicePath = ext.lastObject;
        }
        
        _name = [headers objectForKey:@"name"];
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"SSDPService<%@>", self.uniqueServiceName];
}

//@property(strong, nonatomic) NSURL *location;
//@property(copy, nonatomic) NSString *servicePath;
//@property(copy, nonatomic) NSString *serviceType;
//@property(copy, nonatomic) NSString *uniqueServiceName;
//@property(copy, nonatomic) NSString *server;
//@property (copy, nonatomic)     NSString *name;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.servicePath forKey:@"servicePath"];
    [encoder encodeObject:self.serviceType forKey:@"serviceType"];
    [encoder encodeObject:self.uniqueServiceName forKey:@"uniqueServiceName"];
    [encoder encodeObject:self.server forKey:@"server"];
    [encoder encodeObject:self.name forKey:@"name"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]) {
        
        self.location = [decoder decodeObjectForKey:@"lowValue"];
        self.servicePath = [decoder decodeObjectForKey:@"servicePath"];
        self.serviceType = [decoder decodeObjectForKey:@"serviceType"];
        self.uniqueServiceName = [decoder decodeObjectForKey:@"uniqueServiceName"];
        self.server = [decoder decodeObjectForKey:@"server"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return  self;
}

@end
