import Foundation

@objc public class LogDumper: NSObject {
    private static let NotificationKey = "com.briancroom.LogDumper.LogSomeStuff"
    private static let NotificationAcknowledgementKey = "com.briancroom.LogDumper.Acknowledgement"

    private static var didReceiveAcknowledgement = false

    /// Calling this method posts a system-wide notification which will cause any other
    /// process which links with LogDumper to dump a bunch of internal state into the
    /// system log
    public static func sendLogDumpRequest() {
        didReceiveAcknowledgement = false

        let center = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(center, NotificationKey, nil, nil, true)
    }

    public static func sendLogDumpRequestAndWaitForAcknowledgement() {
        sendLogDumpRequest()

        while !didReceiveAcknowledgement {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
        }
    }

    @objc public static func registerForDumpNotification() {
        print("** Registering for log dumper notifications")

        let callBack: CFNotificationCallback = { center, _, name, _, _ in
            if name as String == LogDumper.NotificationKey {
                NSLog("** Dumping NSUserDefaults:\n\n%@\n\n", NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
                CFNotificationCenterPostNotification(center, LogDumper.NotificationAcknowledgementKey, nil, nil, true)
            } else {
                LogDumper.didReceiveAcknowledgement = true
            }
        }

        let center = CFNotificationCenterGetDarwinNotifyCenter()
        for name in [NotificationKey, NotificationAcknowledgementKey] {
            CFNotificationCenterAddObserver(center, nil, callBack, name, nil, .DeliverImmediately)
        }
    }
}
