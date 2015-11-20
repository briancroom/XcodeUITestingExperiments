#import "FileSystemManipulator.h"
#import <FileSystemManipulator/FileSystemManipulator-Swift.h>

@implementation FileSystemManipulatorProcessor (Loader)

+ (void)load {
    [[self processorFromEnvironment] performManipulations];
}

@end
