#import "SystemLogQuery.h"
#import <asl.h>

@interface SystemLogQuery ()
@property (nonatomic, copy) NSString *targetBundleID;
@property (nonatomic, strong) NSDate *earliestMessageDate;
@end

@implementation SystemLogQuery

+ (instancetype)queryForFutureMessagesFromTestTargetApplication {
    NSString *testConfigurationPath = [NSProcessInfo processInfo].environment[@"XCTestConfigurationFilePath"];
    id testConfiguration = [NSKeyedUnarchiver unarchiveObjectWithFile:testConfigurationPath];
    NSString *targetApplicationBundleID = [testConfiguration valueForKey:@"targetApplicationBundleID"];

    if (targetApplicationBundleID) {
        return [[self alloc] initWithTargetBundleID:targetApplicationBundleID
                                earliestMessageDate:[NSDate date]];
    } else {
        return nil;
    }
}

- (instancetype)initWithTargetBundleID:(NSString *)bundleID earliestMessageDate:(NSDate *)earliestMessageDate; {
    if (self = [super init]) {
        _targetBundleID = [bundleID copy];
    }
    return self;
}

- (NSArray<NSString *> *)messages {
    NSString *testConfigurationPath = [NSProcessInfo processInfo].environment[@"XCTestConfigurationFilePath"];
    id testConfiguration = [NSKeyedUnarchiver unarchiveObjectWithFile:testConfigurationPath];
    NSString *targetApplicationBundleID = [testConfiguration valueForKey:@"targetApplicationBundleID"];
    NSLog(@"Got bundle ID: %@", targetApplicationBundleID);

    aslmsg query, message;

    query = asl_new(ASL_TYPE_QUERY);
    asl_set_query(query, ASL_KEY_MSG, NULL, ASL_QUERY_OP_NOT_EQUAL);
    asl_set_query(query, ASL_KEY_FACILITY, self.targetBundleID.UTF8String, ASL_QUERY_OP_EQUAL);
    asl_set_query(query, ASL_KEY_TIME, @([self.earliestMessageDate timeIntervalSince1970]).stringValue.UTF8String, ASL_QUERY_OP_GREATER_EQUAL);

    aslresponse r = asl_search(NULL, query);

    asl_release(query);

    NSMutableArray *output = [@[] mutableCopy];
    while (NULL != (message = asl_next(r))) {
        const char *msg = asl_get(message, ASL_KEY_MSG);
        if (msg) {
            [output addObject:[NSString stringWithUTF8String:msg]];
        }
    }
    asl_release(r);
    
    return output;
}

@end
