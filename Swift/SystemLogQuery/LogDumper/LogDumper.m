#import "LogDumper.h"
#import <LogDumper/LogDumper-Swift.h>

@implementation LogDumper (Loader)

+ (void)load {
    [self registerForDumpNotification];
}

@end
