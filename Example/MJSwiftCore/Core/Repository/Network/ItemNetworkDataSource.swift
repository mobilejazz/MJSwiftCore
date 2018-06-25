//
// Created by Jose Luis  Franconetti Olmedo on 17/10/2017.
// Copyright (c) 2017 Defence Innovations PTY LTD. All rights reserved.
//

import Foundation

import Alamofire
import MJSwiftCore
import MJCocoaCore

extension ItemEntity {
    fileprivate static var fromNetworkMap : [String : String] {
        return ["image-url" : "imageURL"]
    }
    
    fileprivate static var toNetworkMap : [String : String] {
        return ["imageURL" : "image-url"]
    }
}

class ItemNetworkDataSource : AlamofireDataSource  {
    
    typealias T = ItemEntity
    
    var sessionManager : SessionManager
    
    required init(_ sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func get(_ query: Query) -> Future<ItemEntity> {
        switch query.self {
        case is IdQuery<String>:
            return getById((query as! IdQuery<String>).id)
        default:
            fatalError("Undefined query class \(String(describing: type(of:query))) for method get on \(String(describing: type(of:self)))")
        }
    }
    
    func getAll(_ query: Query) -> Future<[ItemEntity]> {
        switch query.self {
        case is AllObjectsQuery:
            return getAllItems()
        case is SearchItemsQuery:
            return searchItems((query as! SearchItemsQuery).text)
        default:
            fatalError("Undefined query class \(String(describing: type(of:query))) for method get on \(String(describing: type(of:self)))")
        }
    }
    
    func putAll(_ array: [ItemEntity], in query: Query) -> Future<[ItemEntity]> {
        // Protocol-refactoring: NEEDS-IMPLEMENTATION OR ONLY CONFORMING TO GetDataSource
        fatalError()
    }
    
    func put(_ value: ItemEntity?, in query: Query) -> Future<ItemEntity> {
        // Protocol-refactoring: NEEDS-IMPLEMENTATION OR ONLY CONFORMING TO GetDataSource
        fatalError()
    }
    
    func deleteAll(_ query: Query) -> Future<Void> {
        // Protocol-refactoring: NEEDS-IMPLEMENTATION OR ONLY CONFORMING TO GetDataSource
        fatalError()
    }
    
    func delete(_ query: Query) -> Future<Void> {
        // Protocol-refactoring: NEEDS-IMPLEMENTATION OR ONLY CONFORMING TO GetDataSource
        fatalError()
    }
}

private extension ItemNetworkDataSource {
    private func getById(_ id: String) -> Future<ItemEntity> {
        let url = "/items/\(id)"
        return sessionManager.request(url).toFuture().flatMap { json in
            guard let json = json  else {
                return Future(CoreError.NotFound())
            }
            let future = json.decodeAs(ItemEntity.self, keyDecodingStrategy: .map(ItemEntity.fromNetworkMap)) { item in
                item.lastUpdate = Date()
            }
            return future
        }
    }
    
    private func getAllItems() -> Future<[ItemEntity]> {        
        let url = "/items"
        return sessionManager.request(url).toFuture().flatMap { json in
            if let json = json {
                guard let results = json["results"] as? [[String: AnyObject]] else {
                    return Future([]) // or pass error if desired
                }
                return results.decodeAs(keyDecodingStrategy: .map(ItemEntity.fromNetworkMap), forEach: { item in
                    item.lastUpdate = Date()
                })
            }
            return Future([])
        }
    }
    
    private func searchItems(_ text: String) -> Future<[ItemEntity]> {
        let url = "/items"
        return sessionManager.request(url,
                                      parameters: ["name" : text])
            .toFuture().flatMap { json in
                if let json = json {
                    guard let results = json["results"] as? [[String: AnyObject]] else {
                        return Future([]) // or pass error if desired
                    }
                    return results.decodeAs(keyDecodingStrategy: .map(ItemEntity.fromNetworkMap), forEach: { item in
                        item.lastUpdate = Date()
                    })
                }
                return Future([])
        }
    }
}