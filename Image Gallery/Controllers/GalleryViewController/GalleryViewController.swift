//
//  GalleryViewController.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var datasource: ListTableViewDatasource!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard datasource != nil && index != nil && index < datasource.getPhotos.count else {
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
}
