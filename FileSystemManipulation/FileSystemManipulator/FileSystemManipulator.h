#import <Foundation/Foundation.h>

//! Project version number for FileSystemManipulator.
FOUNDATION_EXPORT double FileSystemManipulatorVersionNumber;

//! Project version string for FileSystemManipulator.
FOUNDATION_EXPORT const unsigned char FileSystemManipulatorVersionString[];

/// The FileSystemManipulator is activated when an environment variable with this key
/// has a path value pointing to a serialized instance of FileSystemManipulatorConfiguration
extern NSString * const kFileSystemManipulatorConfigurationPathEnvironmentKey;

#import <FileSystemManipulator/FileSystemManipulatorConfiguration.h>
