//
//  ViewController.swift
//  ThirdAssessment
//
//  Created by Terence Chua on 02/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import CoreData

class OwnersTableViewController: UIViewController {

    @IBOutlet weak var ownersTableView: UITableView!
    
    var fetchResultController = NSFetchedResultsController<Owner>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownersTableView.dataSource = self
        fetchResultController.delegate = self

    }



}

extension OwnersTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension OwnersTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ownersTableView.beginUpdates()
        print("WillChange")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("DidChange")
        print("old : ", indexPath)
        print("new : ", newIndexPath)
        
        switch type {
        case .insert:
            print("Insert")
            if let new = newIndexPath {
                ownersTableView.insertRows(at: [new], with: .right)
            }
        case .update:
            print("Update")
            if let old = indexPath {
                ownersTableView.reloadRows(at: [old], with: .middle)
            }
        case .move:
            print("Move")
            if let old = indexPath,
                let new = newIndexPath {
                ownersTableView.performBatchUpdates({
                    ownersTableView.moveRow(at: old, to: new)
                }, completion: { (complete) in
                    self.ownersTableView.reloadRows(at: [new], with: .none)
                })
                
                //Method 2
                //                ownersTableView.endUpdates()
                //                ownersTableView.beginUpdates()
                //                ownersTableView.reloadRows(at: [new], with: .middle)
            }
        case .delete:
            print("Delete")
            if let old = indexPath {
                ownersTableView.deleteRows(at: [old], with: .left)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ownersTableView.endUpdates()
        print("FinishChange")
    }
}
