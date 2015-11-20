import Foundation

/// This class allows setting up a list of commands that the FileSystemManipulator
/// framework will carry out when it is loaded into a process. The idea is to create
/// an instance in the test process, write it to a file and pass that path to the app
/// process as an environment variable under kFileSystemManipulatorConfigurationPathEnvironmentKey
public class FileSystemManipulatorConfiguration {
    public typealias Manipulation = (source: NSURL, relativeDestination: String)

    private var filesToCopy: [String : String] = [:]

    public init() {
    }

    public init?(URL: NSURL) {
        guard let loadedFilesToCopy = NSDictionary(contentsOfURL: URL) as? [String : String] else {
            return nil
        }

        filesToCopy = loadedFilesToCopy
    }

    public func generateLaunchEnvironment() -> [String : String] {
        let configurationURL = writeConfigurationToFile()

        let manipulatorBundle = NSBundle(forClass: self.dynamicType)
        let manipulatorPath = manipulatorBundle.executablePath

        return [
            FileSystemManipulatorProcessor.ConfigurationPathEnvironmentKey: configurationURL?.path ?? "",
            "DYLD_INSERT_LIBRARIES": manipulatorPath ?? ""
        ]
    }

    public func copyFileAtURL(URL: NSURL, toRelativePath relativeDestinationPath: String) {
        filesToCopy[URL.path!] = relativeDestinationPath
    }

    public var manipulations: AnySequence<Manipulation> {
        get {
            return AnySequence(filesToCopy.map({ (NSURL(fileURLWithPath: $0.0), $0.1) }))
        }
    }

    private func writeConfigurationToFile() -> NSURL? {
        let configurationURL = NSURL(fileURLWithPath: NSHomeDirectory()).URLByAppendingPathComponent("config")
        return ((filesToCopy as NSDictionary).writeToURL(configurationURL, atomically: true) == true) ? configurationURL : nil
    }
}
