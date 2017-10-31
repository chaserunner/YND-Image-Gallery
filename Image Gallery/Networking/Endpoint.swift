//
//  Endpoint.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import Foundation

enum Endpoint {
    
    case photos(id: Int?)
    
    private var secretKey : String {
        return "d6911870fe6b2bb833e323ba40b0e76fc671ed8420cf04743520a8ff95ed80e8"
    }
    
    private var baseURL : String {
        return "https://api.unsplash.com/"
    }
    
    private var endpointURL : String {
        switch self {
        case .photos:
            return "photos/"
        }
    }
    
    private var query : [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "client_id", value: secretKey))
        switch self {
        case let .photos(id):
            if let id = id {
                items.append(URLQueryItem(name: "id", value: String(id)))
            }
        }
        return items
    }
    
    public var url : URL? {
        let components = NSURLComponents(string: baseURL + endpointURL)
        components?.queryItems = query
        return components?.url
    }
    
}


