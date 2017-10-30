//
//  Networking.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import Foundation

class APIService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            let objects = data.flatMap(resource.parse)
            completion(objects)
            }.resume()
    }
    
}

struct Resource<T>{
    
    let url: URL
    let parse: (Data) -> T?
    
}

extension Resource where T: Decodable {
    
    init(url: URL, decoder: JSONDecoder = JSONDecoder()) {
        let parse: (Data) -> T? = { data in
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        self.init(url: url, parse: parse)
    }
    
}

