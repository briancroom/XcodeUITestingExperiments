import Foundation

@objc public class FileSystemManipulatorProcessor: NSObject {
    static let ConfigurationPathEnvironmentKey = "FileSystemManipulatorConfigurationPath"

    let configuration: FileSystemManipulatorConfiguration
    let fileManager = NSFileManager()

    init(configuration: FileSystemManipulatorConfiguration) {
        self.configuration = configuration
    }

    @objc public static func processorFromEnvironment() -> FileSystemManipulatorProcessor? {
        guard let configurationPath = NSProcessInfo.processInfo().environment[ConfigurationPathEnvironmentKey],
        configuration = FileSystemManipulatorConfiguration(URL: NSURL(fileURLWithPath: configurationPath)) else {
            return nil
        }

        return FileSystemManipulatorProcessor(configuration: configuration)
    }

    @objc public func performManipulations() {
        let baseURL = NSURL(fileURLWithPath: NSHomeDirectory())
        for (sourceURL, relativeDestinationPath) in configuration.manipulations {
            let destinationURL = NSURL(fileURLWithPath: relativeDestinationPath, relativeToURL: baseURL)
            do {
                try fileManager.removeItemAtURL(destinationURL)
                try fileManager.copyItemAtURL(sourceURL, toURL: destinationURL)
                print("**** Successfully copied \(sourceURL) to \(destinationURL)")
            } catch let error {
                print("**** Failed to copy \(sourceURL) to \(destinationURL) (\(error))")
            }
        }
    }
}
