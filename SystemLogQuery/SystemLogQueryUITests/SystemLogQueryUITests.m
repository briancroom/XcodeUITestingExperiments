#import <XCTest/XCTest.h>
#import <LogDumper/LogDumper.h>
#import "SystemLogQuery.h"

@interface SystemLogQueryUITests : XCTestCase
@property (nonatomic) XCUIApplication *app;
@property (nonatomic) SystemLogQuery *query;
@end

@implementation SystemLogQueryUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    self.query = [SystemLogQuery queryForFutureMessagesFromTestTargetApplication];

    self.app = [[XCUIApplication alloc] init];
    self.app.launchEnvironment = @{ @"DYLD_INSERT_LIBRARIES": [NSBundle bundleForClass:[LogDumperTool class]].executablePath };
    [self.app launch];
}

- (void)testLog {
    XCTAssert([[self.query messages] containsObject:@"App loaded!"]);
}

- (void)testTappingButtonPersistsToUserDefaults {
    NSString *expectedString = @"UserTappedButton = 1";

    XCTAssertFalse([[self dumpedLog] containsString:expectedString]);

    [self expectationForLogContaining:@"UserTappedButton = 1"];
    [self.app.buttons[@"Tap me!"] tap];

    [LogDumperTool sendLogDumpRequest];
    [self waitForExpectationsWithTimeout:5 handler:NULL];
}

#pragma mark - Helpers

- (NSString *)dumpedLog {
    [LogDumperTool sendLogDumpRequestAndWaitForAcknowledgement];
    return [self.query messages].lastObject;
}

- (XCTestExpectation *)expectationForLogContaining:(NSString *)expectedMessageFragment {
    return [self expectationForPredicate:[NSPredicate predicateWithBlock:^(SystemLogQuery *query, NSDictionary<NSString *,id> *bindings) {
        return [[query messages].lastObject containsString:expectedMessageFragment];
    }]
                     evaluatedWithObject:self.query
                                 handler:NULL];
}

@end
