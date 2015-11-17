#import <XCTest/XCTest.h>
#import <FileSystemManipulator/FileSystemManipulator.h>

@interface FileSystemManipulationUITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation FileSystemManipulationUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;

    FileSystemManipulatorConfiguration *configuration = [[FileSystemManipulatorConfiguration alloc] init];

    NSURL *dataURL = [self writeStringToTemporaryFile:@"Injected Data!"];
    [configuration copyFileAtURL:dataURL toRelativePath:@"Documents/data.txt"];

    self.app = [[XCUIApplication alloc] init];
    self.app.launchEnvironment = [configuration generateLaunchEnvironment];
    [self.app launch];
}

- (void)testShowsTextLoadedFromFileInDocumentsDirectory {
    XCTAssert(self.app.staticTexts[@"Injected Data!"].exists);
}

#pragma mark - Helpers

- (NSURL *)writeStringToTemporaryFile:(NSString *)string {
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]]];
    [string writeToURL:fileURL atomically:NO encoding:NSUTF8StringEncoding error:NULL];
    return fileURL;
}

@end
