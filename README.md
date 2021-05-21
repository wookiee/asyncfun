# asyncfun
A toy project I'm using to play with and learn about the new structured concurrency features in Swift, discussed in Swift Evolution proposals:

- [`async/await`](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md) and [Structured Concurrency](https://github.com/apple/swift-evolution/blob/main/proposals/0304-structured-concurrency.md) introduce the syntactical building blocks (including the `Task` type) for writing asynchronous code using Swift-native language features.
- There is a WIP standalone proposal to add [`async let`](https://github.com/DougGregor/swift-evolution/blob/90c418f42a5a4c9b9216154cfd323d4c62fde7da/proposals/mmmm-async-let.md) syntax to greatly reduce a pain point of filling values asynchronously for later use.
- [`actor` types](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md) introduce a new top-level reference type (like `class`) that require and statically  enforce that access to any of their mutable state be done asynchronously (such as by using the async/await syntax), and exist to help model thread-safe mutable data structures. The idea of [global actors](https://github.com/DougGregor/swift-evolution/blob/global-actors/proposals/nnnn-global-actors.md) enables single-declaration actor isolation, such as with `@MainActor`.
- A few other related proposals that fill in additional detail around those big three include the idea of [continuations](https://github.com/apple/swift-evolution/blob/main/proposals/0300-continuation.md), a feature for bridging async/await code with existing completion-handler-based async code, and proposals dealing with the implications of the new [features for closures](https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md) and [Objective-C interoperability](https://github.com/apple/swift-evolution/blob/main/proposals/0297-concurrency-objc.md).

## Swift Development

This project is built against the [Swift.org](https://swift.org) [main branch development snapshot dated 2021-05-18](https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2021-05-18-a/swift-DEVELOPMENT-SNAPSHOT-2021-05-18-a-osx.pkg).

