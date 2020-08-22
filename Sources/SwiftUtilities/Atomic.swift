import Foundation

// Credits to Vadim Bulavin https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/


/// Atomic reads and writes via a property wrapper
///
/// **Note:**
/// When performing simultaneous read/write operations like `+=`
/// you must use the `mutate` function for atomic functionality
///
/// ```swift
///
/// @Atomic public var balance: Decimal
///
/// // Write without read works atomically as expected
/// func resetBalance() { balance = 1000.00 }
///
/// // This does **NOT** guarantee atomic operations
/// func incrementBalane() { balance += 500 }
///
/// // This does guarantee atomic operations
/// func decrement() { $balance.mutate { $0 -= 500 } }
/// ```
///
@propertyWrapper public class Atomic<Value> {
    private let queue = DispatchQueue(label: "com.jzdesign.atomic")
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    /// The value of the atomic wrapped object.
    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }


    /// Atomic mutation
    /// - Parameter mutation: A mutating function used when getting and setting the wrapped value is necessary
    ///
    /// Atomic's `wrappedValue` is capable of atomic gets and sets, however when attempting to do both with operators like `+=` that is a nonatomic operation. It is for this reason that the mutate function exists
    public func mutate(_ mutation: (inout Value) -> Void) {
        queue.sync {
            mutation(&value)
        }
    }

}
