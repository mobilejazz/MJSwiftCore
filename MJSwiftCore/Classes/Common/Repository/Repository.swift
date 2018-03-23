//
// Copyright 2017 Mobile Jazz SL
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

/// Default query interface
public protocol Query { }

/// Blank query
public class BlankQuery : Query {
    public init() {}
}

/// A query by an id
public class QueryById : Query {
    public let id : String
    public init(_ id: String) {
        self.id = id
    }
}

/// All objects query
public class AllObjectsQuery : Query {
    public init() { }
}

/// Key based query
public class KeyQuery : Query {
    public let key : String
    public init(_ key: String) {
        self.key = key
    }
}

///
/// An operation defines an abstraction on how data must be fetched
///
public struct Operation : RawRepresentable, Equatable, Hashable, CustomStringConvertible {
    public typealias RawValue = String
    public var rawValue: String
    public var hashValue: Int { return rawValue.hashValue }
    public static func ==(lhs: Operation, rhs: Operation) -> Bool { return lhs.rawValue == rhs.rawValue }
    public init(rawValue: String) { self.rawValue = rawValue }
    public var description: String { return rawValue }

    /// Blank/Undefined/Default operationx cierto
    public static let blank = Operation(rawValue:"blank")
}


/// Abstract definition of a repository
open class Repository<T> {
    
    /// Get a single method
    ///
    /// - Parameter query: An instance conforming to Query that encapsules the get query information
    /// - Returns: A Future of an optional repository's type
    open func get(_ query: Query, operation: Operation = .blank) -> Future<T?> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method get on \(String(describing: type(of:self)))")
    }
    
    /// Main get method
    ///
    /// - Parameter query: An instance conforming to Query that encapsules the get query information
    /// - Returns: A Future of the repository's type
    open func getAll(_ query: Query, operation: Operation = .blank) -> Future<[T]> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method getAll on \(String(describing: type(of:self)))")
    }
    
    /// Put by query method
    ///
    /// - Parameter query: An instance conforming to Query that encapsules the get query information
    /// - Returns: A future of Boolean type. If the operation succeeds, the future will be resolved as true.
    @discardableResult
    open func put(_ value: T, in query: Query = BlankQuery(), operation: Operation = .blank) -> Future<T> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method put on \(String(describing: type(of:self)))")
    }
    
    /// Put by query method
    ///
    /// - Parameter query: An instance conforming to Query that encapsules the get query information
    /// - Returns: A future of Boolean type. If the operation succeeds, the future will be resolved as true.
    @discardableResult
    open func putAll(_ array: [T], in query: Query = BlankQuery(), operation: Operation = .blank) -> Future<[T]> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method putAll on \(String(describing: type(of:self)))")
    }
    
    /// Delete by query method
    ///
    /// - Parameter query: An instance conforming to Query that encapusles the delete query information
    /// - Returns: A future of Boolean type. If the operation succeeds, the future will be resolved as true.
    @discardableResult
    open func delete(_ value: T? = nil, in query: Query = BlankQuery(), operation: Operation = .blank) -> Future<Bool> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method delete on \(String(describing: type(of:self)))")
    }
    
    /// Delete by query method
    ///
    /// - Parameter query: An instance conforming to Query that encapusles the delete query information
    /// - Returns: A future of Boolean type. If the operation succeeds, the future will be resolved as true.
    @discardableResult
    open func deleteAll(_ array: [T] = [], in query: Query = BlankQuery(), operation: Operation = .blank) -> Future<Bool> {
        fatalError("Undefined query class \(String(describing: type(of:query))) for method deleteAll on \(String(describing: type(of:self)))")
    }
}