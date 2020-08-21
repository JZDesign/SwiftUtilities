import Foundation
import Combine


public extension Bundle {
    
    ///
    /// - Parameters:
    ///   - type: Decodable
    ///   - file: File name exlcuding the json file type: If the file is "123.json" pass "123" in.
    /// - Returns: A publisher of the decoded type or a failing publisher
    func decodeJsonFile<T: Decodable>(_ type: T.Type, from file: String) -> AnyPublisher<T, Error> {

        guard let path = self.path(forResource: file, ofType: "json"),
            let data = NSData(contentsOfFile: path) as Data? else {
                return ThrowingPublisher(forType: type.self, throws: BundleLoaderError.invalidFilePath)
        }

        return Just(data)
            .decode(type: type.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

public enum BundleLoaderError: LocalizedError {
    case invalidFilePath
}
