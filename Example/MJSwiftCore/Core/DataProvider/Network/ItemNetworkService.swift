//
// Created by Jose Luis  Franconetti Olmedo on 17/10/2017.
// Copyright (c) 2017 Defence Innovations PTY LTD. All rights reserved.
//

import Foundation

import Alamofire
import MJSwiftCore

class ItemNetworkService: AlamofireRepository<ItemEntity> {
    
    override func getAll(_ query: Query) -> Future<[ItemEntity]> {
        switch query.self {
        case is QueryById:
            return get((query as! QueryById).id).map { [$0] }
        case is AllItemsQuery:
            return getItems(query as! AllItemsQuery)
        case is SearchItemsQuery:
            return searchItems(query as! SearchItemsQuery)
        default:
            return super.getAll(query)
        }
    }
    
    // MARK: Private Methods
    
    private func get(_ id: String) -> Future<ItemEntity> {
        let url = "/items/\(id)"
        return sessionManager.request(url).toFuture().flatMap { json in
            let future = json.decodeAs(ItemEntity.self) { item in
                item.lastUpdate = Date()
            }
            return future
        }
    }
    
    private func getItems(_ query: AllItemsQuery) -> Future<[ItemEntity]> {
        let url = "/items"
        return sessionManager.request(url).toFuture().flatMap { json in
            guard let results = json["results"] as? [[String: AnyObject]] else {
                return Future([]) // or pass error if desired
            }
            return results.decodeAs(forEach: { item in
                item.lastUpdate = Date()
            })
        }
    }
    
    private func searchItems(_ query: SearchItemsQuery) -> Future<[ItemEntity]> {
        let url = "/items"
        return sessionManager.request(url,
                                      parameters: ["name" : query.text])
            .toFuture().flatMap { json in
                guard let results = json["results"] as? [[String: AnyObject]] else {
                    return Future([]) // or pass error if desired
                }
                return results.decodeAs(forEach: { item in
                    item.lastUpdate = Date()
                })
            }
    }
}
