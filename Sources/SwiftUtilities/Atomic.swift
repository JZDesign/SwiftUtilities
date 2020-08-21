import Foundation

// Credits to Vadim Bulavin https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/

@propertyWrapper
public class Atomic<Value> {
    private let queue = DispatchQueue(label: "com.jzdesign.atomic")
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var projectedValue: Atomic<Value> {
        return self
    }

    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }

    public func mutate(_ mutation: (inout Value) -> Void) {
        return queue.sync {
            mutation(&value)
        }
    }

}
