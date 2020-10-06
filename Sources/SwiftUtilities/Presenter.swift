import Combine
import Foundation

public class Presenter {
    private let baseView: Presentable
    var tasks: [AnyCancellable] = []
    
    init(view: Presentable) {
        self.baseView = view
    }
    
    @discardableResult
    func perform<T>(background: @escaping () -> T, foreground: @escaping (T) -> Void = { _ in }) -> AnyCancellable {
        return Deferred { Just(background()) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: foreground)
    }
    
    func perform<T>(background: AnyPublisher<T, Error>, foreground: @escaping (T) -> Void = { _ in }) -> AnyCancellable {
        return background
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.baseView.onError(error: error)
                case .finished:
                    break
                }
            }, receiveValue: foreground)
    }
}

public protocol Presentable {
    var screenId: String { get }
    func onError(error: Error)
}

public extension Presentable {
    var screenId: String {
        get {
            String(describing: type(of: self))
                .lowercased()
                .replacingOccurrences(of: "viewcontroller", with: "_screen")
        }
    }
}
