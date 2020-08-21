import Foundation

public enum Environment: String, CaseIterable {
    case prod
    case qa
    case test

    public static let key = Bundle.main.bundleIdentifier ?? "JZDesign_Environment"
    
    private static var defaultEnvironment: Environment {
        #if DEBUG
            return .test
        #endif
        return .prod
    }

    public static func set(_ environment: Environment, userDefaultsKey: String = key) {
        UserDefaults.standard.setValue(environment.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }

    public static func currentEnvironment(userDefaultsKey: String = key) -> Environment {
        guard let savedEnvironment = UserDefaults.standard.value(forKey: userDefaultsKey) as? String else {
            return defaultEnvironment
        }
        return Environment(rawValue: savedEnvironment) ?? defaultEnvironment
    }
}
