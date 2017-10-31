//
//  Networking.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import Foundation
import UIKit

class APIService {
    
    func load<T: UIImage>(resource: Resource<T>, completion: @escaping (T?, Error?) -> Void) {
        if let image = ImageCache.sharedInstance.image(forKey: resource.url.absoluteString){
            completion((image as! T), nil)
            return
        }
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            let objects = data.flatMap(resource.parse)
            if let image = objects {
                ImageCache.sharedInstance.setImage(image, forKey: resource.url.absoluteString)
            }
            completion(objects, error)
            }.resume()
    }
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?, Error?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, error in
            let objects = data.flatMap(resource.parse)
            completion(objects, error)
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

