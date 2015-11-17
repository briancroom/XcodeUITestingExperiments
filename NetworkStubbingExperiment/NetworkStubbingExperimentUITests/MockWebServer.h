#import <Foundation/Foundation.h>

@interface MockWebServer : NSObject

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) NSString *postedString;

- (void)start;
- (void)stop;

@end
