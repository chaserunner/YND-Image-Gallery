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
        tableView.delegate = self
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return datasource.getPhotos.count > 0
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GalleryViewController(datasource: self.datasource, index: indexPath.row)
        self.navigationController?.present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
