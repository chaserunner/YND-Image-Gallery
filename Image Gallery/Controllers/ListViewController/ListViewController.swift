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
        tableView.delegate = self
        update()
    }
    
    func update() {
        datasource.update(tableView){ error in
            guard let error = error else {return}
            let alert = UIAlertController.init(title: "Error", message: "Cannot retreive photos, offline mode not implemented yet.\n(\(error.localizedDescription))", preferredStyle: UIAlertControllerStyle.alert)
            let retry = UIAlertAction.init(title: "Retry", style: .default, handler: { action in
                self.update()
            })
            alert.addAction(retry)
            self.present(alert, animated: true)
        }
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard datasource.getPhotos.count > 0 else {return}
        let vc = GalleryViewController(datasource: self.datasource, index: indexPath.row)
        self.navigationController?.present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
