#import "MockWebServer.h"
#import <GCDWebServers/GCDWebServer.h>
#import <GCDWebServers/GCDWebServerDataRequest.h>

static const NSInteger kServerPort = 8080;

@interface MockWebServer ()
@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong, readwrite) NSString *postedString;
@end

@implementation MockWebServer

- (instancetype)init {
    if (self = [super init]) {
        _webServer = [[GCDWebServer alloc] init];
    }
    return self;
}

- (void)start {
    [self setupHandlers];

    [self.webServer startWithOptions:@{ GCDWebServerOption_Port: @(kServerPort),
                                        GCDWebServerOption_AutomaticallySuspendInBackground: @NO }
                               error:NULL];
}

- (void)stop {
    [self.webServer stop];
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%@", @(kServerPort)]];
}

- (void)setupHandlers {
    [self.webServer addGETHandlerForPath:@"/hello"
                              staticData:[@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding]
                             contentType:@"text/plain"
                                cacheAge:0];

    __weak typeof(self) weakSelf = self;
    [self.webServer addHandlerForMethod:@"POST"
                                   path:@"/checkin"
                           requestClass:GCDWebServerDataRequest.class
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               weakSelf.postedString = [[NSString alloc] initWithData:((GCDWebServerDataRequest *)request).data encoding:NSUTF8StringEncoding];
                               return [GCDWebServerResponse responseWithStatusCode:200];
                           }];
}

@end
