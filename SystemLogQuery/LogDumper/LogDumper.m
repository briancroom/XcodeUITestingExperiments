#import "LogDumper.h"

NSString * const kLogDumperNotificationKey = @"com.briancroom.LogDumper.LogSomeStuff";
NSString * const kLogDumperNotificationAcknowledgementKey = @"com.briancroom.LogDumper.Acknowledgement";

static BOOL LogDumperDidReceiveAcknowledgement = NO;

static void LogDumperNotificationCallback(CFNotificationCenterRef center,
                                          void * observer,
                                          CFStringRef name,
                                          void const * object,
                                          CFDictionaryRef userInfo) {
    if ([kLogDumperNotificationKey isEqualToString:(__bridge NSString *)name]) {
        NSLog(@"** Dumping NSUserDefaults:\n\n%@\n\n", [NSUserDefaults standardUserDefaults].dictionaryRepresentation);
        CFNotificationCenterPostNotification(center, (__bridge CFStringRef)kLogDumperNotificationAcknowledgementKey, NULL, NULL, YES);
    } else {
        LogDumperDidReceiveAcknowledgement = YES;
    }
}

@implementation LogDumperTool

+ (void)load {
    NSLog(@"** Registering for log dumper notifications");

    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    for (NSString *name in @[kLogDumperNotificationKey, kLogDumperNotificationAcknowledgementKey]) {
        CFNotificationCenterAddObserver(center,
                                        (__bridge const void *)(self),
                                        LogDumperNotificationCallback,
                                        (__bridge CFStringRef)name,
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}

+ (void)sendLogDumpRequest {
    LogDumperDidReceiveAcknowledgement = NO;

    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (__bridge CFStringRef)kLogDumperNotificationKey, NULL, NULL, YES);
}

+ (void)sendLogDumpRequestAndWaitForAcknowledgement {
    [self sendLogDumpRequest];

    while (!LogDumperDidReceiveAcknowledgement) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end
