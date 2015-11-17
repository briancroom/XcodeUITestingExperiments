#import "FileSystemManipulator.h"

NSString * const kFileSystemManipulatorConfigurationPathEnvironmentKey = @"FileSystemManipulatorConfigurationPath";

@interface FileSystemManipulatorProcessor : NSObject
@property (nonatomic, strong) FileSystemManipulatorConfiguration *configuration;
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation FileSystemManipulatorProcessor

+ (void)load {
    NSString *configurationPath = [NSProcessInfo processInfo].environment[kFileSystemManipulatorConfigurationPathEnvironmentKey];
    if (configurationPath) {
        NSLog(@"**** Got FileSystemManipulator configuration path %@", configurationPath);
        FileSystemManipulatorConfiguration *configuration = [FileSystemManipulatorConfiguration configurationFromURL:[NSURL fileURLWithPath:configurationPath]];
        if (configuration) {
            [[[self alloc] initWithConfiguration:configuration] performManipulations];
        }
    }
}

- (instancetype)initWithConfiguration:(FileSystemManipulatorConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

- (void)performManipulations {
    NSLog(@"**** Performing file system manipulations");
    NSURL *baseURL = [NSURL fileURLWithPath:NSHomeDirectory()];

    [self.configuration enumerateManipulationsWithBlock:^(NSURL *sourceURL, NSString *relativeDestinationPath) {
        NSURL *destinationURL = [NSURL fileURLWithPath:relativeDestinationPath relativeToURL:baseURL];
        [self.fileManager removeItemAtURL:destinationURL error:NULL];
        BOOL res = [self.fileManager copyItemAtURL:sourceURL toURL:destinationURL error:NULL];
        NSLog(@"**** %@ - copying %@ to %@", res ? @"Success!" : @"Failed!", sourceURL, destinationURL);
    }];
}

@end
