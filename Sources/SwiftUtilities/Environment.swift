import Foundation

public enum Environment: String, CaseIterable {
    case prod
    case qa
    case test

    public static let key = Bundle.main.bundleIdentifier ?? "com.jzdesign.environment"
    
    private static var defaultEnvironment: Environment {
        #if DEBUG
            return .test
        #endif
        return .prod
    }


    
    /// Stores the slected environment to user defaults
    /// - Parameters:
    ///   - environment: .test, .qa, .prod
    ///   - userDefaultsKey: String - A unique but static string
    public static func set(_ environment: Environment, userDefaultsKey: String = key) {
        UserDefaults.standard.setValue(environment.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }


    
    /// Reads the slected environment from user defaults.
    /// - Parameter userDefaultsKey: String - The key used to store the environment to user defaults
    /// - Returns: The last saved environment
    public static func currentEnvironment(userDefaultsKey: String = key) -> Environment {
        guard let savedEnvironment = UserDefaults.standard.value(forKey: userDefaultsKey) as? String else {
            return defaultEnvironment
        }
        return Environment(rawValue: savedEnvironment) ?? defaultEnvironment
    }
}
