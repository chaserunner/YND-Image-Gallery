//
//  PhotoModel.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import Foundation
import UIKit

struct PhotoModel: Codable {
    
    let id : String
    let created_at : String
    let updated_at : String
    let width : Int
    let height : Int
    let color : String
    let likes : Int
    let liked_by_user : Int
    let description : String?
    let user : UserModel
    let urls : ImageUrlsModel
    
    var thumbnail: Resource<UIImage> {
        return Resource(url: URL(string: urls.thumb)!, parse: { return UIImage(data: $0) })
    }
    
    var image: Resource<UIImage> {
        return Resource(url: URL(string: urls.regular)!, parse: { return UIImage(data: $0) })
    }
    
}

extension PhotoModel {
    
    static var all: Resource<[PhotoModel]> {
        let endpoint = Endpoint.photos(id: nil)
        return Resource(url: endpoint.url!)
    }
    
}


