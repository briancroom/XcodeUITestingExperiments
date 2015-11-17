#import <XCTest/XCTest.h>
#import "MockWebServer.h"
#import "EnvironmentKeys.h"

@interface NetworkStubbingExperimentUITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *app;
@property (nonatomic, strong) MockWebServer *webServer;
@end

@implementation NetworkStubbingExperimentUITests

- (void)setUp {
    [super setUp];

    self.continueAfterFailure = NO;

    self.webServer = [[MockWebServer alloc] init];
    [self.webServer start];

    self.app = [[XCUIApplication alloc] init];
    self.app.launchEnvironment = @{ kServerURLEnvironmentKey: self.webServer.baseURL.absoluteString };
    [self.app launch];
}

- (void)tearDown {
    [super tearDown];
    [self.webServer stop];
}

- (void)testLoadsAndDisplaysTextFromServer {
    XCUIElement *loadedText = self.app.staticTexts[@"Hello World!"];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists==YES"] evaluatedWithObject:loadedText handler:NULL];
    [self waitForExpectationsWithTimeout:5 handler:NULL];

    XCTAssert(loadedText.exists);
}

- (void)testTappingButtonSendsCheckinPost {
    NSString *expectedString = @"Checking in";
    [self keyValueObservingExpectationForObject:self.webServer keyPath:@"postedString" expectedValue:expectedString];

    [self.app.buttons[@"Check In"] tap];

    [self waitForExpectationsWithTimeout:5 handler:NULL];
    XCTAssertEqualObjects(self.webServer.postedString, expectedString);
}

@end
