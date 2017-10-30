//
//  PhotoCell.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 30.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    private var photo: PhotoModel!
    private var service: APIService!
    
    func updateWith(_ photo: PhotoModel){
        thumbnail.backgroundColor = UIColor(photo.color)
        title.text = photo.user.name
    }
    
    func updateWith(_ photoWithAutorCount: PhotoWithAutorCount, service: APIService = APIService()){
        thumbnail.backgroundColor = UIColor(photoWithAutorCount.photo.color)
        title.text = photoWithAutorCount.photo.user.name + " " + String(photoWithAutorCount.count)
        self.service = service
        self.service.load(resource: photoWithAutorCount.photo.thumbnail) { (image) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.thumbnail.image = image
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo = nil
        service = nil
        thumbnail.image = nil
        indicator.startAnimating()
    }
}
