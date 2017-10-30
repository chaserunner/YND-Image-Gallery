//
//  ListTableViewDatasource.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

typealias PhotoWithAutorCount = (photo: PhotoModel, count: UInt)

class ListTableViewDatasource: NSObject, UITableViewDataSource {
    
    private var tableView : UITableView?
    private var photos : [PhotoWithAutorCount] = []
    private var service :  APIService!
    
    public var getPhotos : [PhotoWithAutorCount] {
        return photos
    }
    
    func update(_ tv: UITableView, with service: APIService = APIService()){
        tv.dataSource  = self
        self.service = service
        self.tableView = tv
        service.load(resource: PhotoModel.all) { array in
            self.photos = []
            if let array = array, !array.isEmpty {
                var dict = [String: UInt]()
                for photo in array {
                    guard dict[photo.user.id] == nil else {
                        dict[photo.user.id]! += 1
                        let photoWithAutorCount = PhotoWithAutorCount(photo: photo, count: dict[photo.user.id]!)
                        self.photos.append(photoWithAutorCount)
                        continue
                    }
                    dict[photo.user.id] = 1
                    let photoWithAutorCount = PhotoWithAutorCount(photo: photo, count: 1)
                    self.photos.append(photoWithAutorCount)
                }
                //self.photos = array
            }
            self.reload()
        }
    }
    
    private func reload() {
        if let tableView = tableView {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! PhotoCell
        cell.updateWith(photos[indexPath.row], service: service)
        return cell
    }
    
}
