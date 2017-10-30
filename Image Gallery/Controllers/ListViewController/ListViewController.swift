//
//  ListViewController.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 29.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let datasource = ListTableViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.update(tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indePath = tableView.indexPathForSelectedRow, let destination = segue.destination as? GalleryViewController {
            destination.index = indePath.row
            destination.datasource = datasource
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return datasource.getPhotos.count > 0
    }
    
}
