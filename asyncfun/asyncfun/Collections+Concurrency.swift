
import Foundation

extension Array {
    
    /// A (probably-badly-named) method to concurrently transform the values in the receiver, and return an array containing the results ordered by their transformation completion time.
    /// Note that the returned array is not itself an asynchronous value; this method awaits all concurrent transformations before returning.
    /// - Parameter transform: A closure that transforms its argument (an element of the receiver) into another value.
    /// - Throws: Only rethrows an error thrown by your `transform` closure
    /// - Returns: An Array of transformed values. These values may be in a different order than their sources in the receiver.
    func concurrentUnorderedMap<T>(_ transform: @escaping (Self.Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: T.self) { taskGroup in
            var results = [T]()
            for value in self {
                taskGroup.spawn {
                    return try await transform(value)
                }
            }
            for try await result in taskGroup {
                results.append(result)
            }
            return results
        }
    }
}

extension Set {
    /// A (probably-badly-named) method to concurrently transform the values in the receiver using a given closure, and return a set containing the results.
    /// Note that the returned Set is not itself an asynchronous value; this method awaits all concurrent transformations before returning.
    /// - Parameter transform: A closure that transforms its argument (an element of the receiver) into another value.
    /// - Throws: Only rethrows an error thrown by your `transform` closure
    /// - Returns: A Set of transformed values.
    func concurrentMap<T:Hashable>(_ transform: @escaping (Self.Element) async throws -> T) async rethrows -> Set<T> {
        try await withThrowingTaskGroup(of: T.self) { taskGroup in
            var results = Set<T>()
            for value in self {
                taskGroup.spawn {
                    return try await transform(value)
                }
            }
            for try await result in taskGroup {
                results.insert(result)
            }
            return results
        }
    }
}
