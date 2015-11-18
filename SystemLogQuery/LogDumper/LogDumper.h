#import <Foundation/Foundation.h>

//! Project version number for LogDumper.
FOUNDATION_EXPORT double LogDumperVersionNumber;

//! Project version string for LogDumper.
FOUNDATION_EXPORT const unsigned char LogDumperVersionString[];

@interface LogDumperTool : NSObject

/// Calling this method posts a system-wide notification which will cause any other
/// process which links with LogDumper to dump a bunch of internal state into the
/// system log
+ (void)sendLogDumpRequest;
+ (void)sendLogDumpRequestAndWaitForAcknowledgement;

@end
