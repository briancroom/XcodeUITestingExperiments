#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// This class allows setting up a list of commands that the FileSystemManipulator
/// framework will carry out when it is loaded into a process. The idea is to create
/// an instance in the test process, write it to a file and pass that path to the app
/// process as an environment variable under kFileSystemManipulatorConfigurationPathEnvironmentKey 
@interface FileSystemManipulatorConfiguration : NSObject

+ (nullable instancetype)configurationFromURL:(NSURL *)URL;
- (NSDictionary<NSString *, NSString *> *)generateLaunchEnvironment;

- (void)copyFileAtURL:(NSURL *)URL toRelativePath:(NSString *)relativeDestinationPath;

- (void)enumerateManipulationsWithBlock:(void (^)(NSURL *sourceURL, NSString *relativeDestinationPath))block;

@end

NS_ASSUME_NONNULL_END
