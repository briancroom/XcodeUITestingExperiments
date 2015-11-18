#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemLogQuery : NSObject

+ (nullable instancetype)queryForFutureMessagesFromTestTargetApplication;

- (NSArray<NSString *> *)messages;

@end

NS_ASSUME_NONNULL_END
