//
//  ImageCache.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 31.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    private let cache: NSCache<NSString,UIImage> = NSCache()
    
    static let sharedInstance = ImageCache()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        let photoSize = UIImagePNGRepresentation(image)?.count
        cache.setObject(image, forKey: key as NSString, cost: photoSize ?? 0)
    }
    
}

