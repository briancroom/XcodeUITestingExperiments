import Foundation
import AppleSystemLog

class SystemLogQuery {
    let targetBundleID: String
    let earliestMessageDate: NSDate

    static func queryForFutureMessagesFromTestTargetApplication() -> SystemLogQuery? {
        guard let testConfigurationPath = NSProcessInfo.processInfo().environment["XCTestConfigurationFilePath"],
            let testConfiguration = NSKeyedUnarchiver.unarchiveObjectWithFile(testConfigurationPath),
            let targetApplicationBundleID = testConfiguration.valueForKey("targetApplicationBundleID") as? String else {
                return nil
        }

        return SystemLogQuery(targetBundleID: targetApplicationBundleID, earliestMessageDate: NSDate())
    }

    private init(targetBundleID: String, earliestMessageDate: NSDate) {
        self.targetBundleID = targetBundleID
        self.earliestMessageDate = earliestMessageDate
    }

    func messages() -> [String] {
        let query = asl_new(UInt32(ASL_TYPE_QUERY))
        asl_set_query(query, ASL_KEY_MSG, nil, UInt32(ASL_QUERY_OP_NOT_EQUAL))
        asl_set_query(query, ASL_KEY_FACILITY, targetBundleID, UInt32(ASL_QUERY_OP_EQUAL))

        let time = String(Int(earliestMessageDate.timeIntervalSince1970))
        asl_set_query(query, ASL_KEY_TIME, time, UInt32(ASL_QUERY_OP_GREATER_EQUAL))

        let response = asl_search(nil, query)

        asl_release(query)

        var output: [String] = []
        for var log = asl_next(response); log != nil; log = asl_next(response) {
            let message = asl_get(log, ASL_KEY_MSG)
            if message != nil, let string = String.fromCString(message) {
                output.append(string)
            }
        }
        asl_release(response)

        return output
    }
}