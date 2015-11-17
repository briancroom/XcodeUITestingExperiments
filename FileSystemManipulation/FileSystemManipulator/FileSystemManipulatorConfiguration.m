#import "FileSystemManipulatorConfiguration.h"
#import "FileSystemManipulator.h"

@interface FileSystemManipulatorConfiguration ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *filesToCopy;
@end

@implementation FileSystemManipulatorConfiguration

- (instancetype)init {
    if (self = [super init]) {
        _filesToCopy = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)configurationFromURL:(NSURL *)URL {
    NSMutableDictionary<NSString *, NSString *> *filesToCopy = [NSMutableDictionary dictionaryWithContentsOfURL:URL];

    if (filesToCopy) {
        FileSystemManipulatorConfiguration *configuration = [[FileSystemManipulatorConfiguration alloc] init];
        configuration->_filesToCopy = filesToCopy;
        return configuration;
    } else {
        return nil;
    }
}

- (NSDictionary<NSString *,NSString *> *)generateLaunchEnvironment {
    NSURL *configurationURL = [self writeConfigurationToFile];

    NSBundle *manipulatorBundle = [NSBundle bundleForClass:[FileSystemManipulatorConfiguration class]];
    NSString *manipulatorPath = manipulatorBundle.executablePath;

    return @{
             kFileSystemManipulatorConfigurationPathEnvironmentKey: configurationURL.path ?: @"",
             @"DYLD_INSERT_LIBRARIES": manipulatorPath ?: @""
             };
}

- (void)copyFileAtURL:(NSURL *)URL toRelativePath:(NSString *)relativeDestinationPath {
    self.filesToCopy[URL.path] = relativeDestinationPath;
}

- (void)enumerateManipulationsWithBlock:(void (^)(NSURL *sourceURL, NSString *relativeDestinationPath))block {
    [self.filesToCopy enumerateKeysAndObjectsUsingBlock:^(NSString *sourcePath, NSString *relativeDestinationPath, BOOL *stop) {
        block([NSURL fileURLWithPath:sourcePath], relativeDestinationPath);
    }];
}

#pragma mark - Private

- (NSURL *)writeConfigurationToFile {
    NSURL *configurationURL = [[NSURL fileURLWithPath:NSHomeDirectory()] URLByAppendingPathComponent:@"config"];
    [self.filesToCopy writeToURL:configurationURL atomically:YES];
    return configurationURL;
}

@end
