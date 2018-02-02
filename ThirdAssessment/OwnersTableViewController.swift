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
        ownersTableView.delegate = self
        if !UserDefaults.standard.bool(forKey: "alreadyFirstRun") {
            loadOwners()
            fetchOwners()
            UserDefaults.standard.set(true, forKey: "alreadyFirstRun")
        } else {
            fetchOwners()
        }
    }
    
    func loadOwners() {
        let owners = ["You Jing", "Faris Roslan", "Ming Xiang", "Josh Teng", "Jalen Ong", "Shin Yin", "Tommy MiddleFinger", "Yen Ping", "Estelle Chang", "Audrey Ling"]
        for item in owners {
            guard let owner = NSEntityDescription.insertNewObject(forEntityName: "Owner", into: DataController.moc) as? Owner else {return}
            
            owner.name = item
        }
        DataController.saveContext()
        ownersTableView.reloadData()
    }
    
    func fetchOwners() {
        let request = NSFetchRequest<Owner>(entityName: "Owner")
        
        let sortName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortName]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            ownersTableView.reloadData()
        } catch {
            print("Error Fetching Owner Data")
        }
        
    }
    
    
    
}

extension OwnersTableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownersCell", for: indexPath)
        let currentCell = fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = currentCell.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = sb.instantiateViewController(withIdentifier: "PropertiesTableViewController") as? PropertiesTableViewController {
            vc.selectedOwner = fetchResultController.object(at: indexPath)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension OwnersTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ownersTableView.beginUpdates()
        print("WillChange")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("DidChange")
        //        print("old : ", indexPath)
        //        print("new : ", newIndexPath)
        
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
