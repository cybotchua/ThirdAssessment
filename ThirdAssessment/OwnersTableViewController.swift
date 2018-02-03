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
    
    var chosenColor : UIColor = UIColor.orange
    
    @IBOutlet weak var ownersTableView: UITableView!
    
    @IBAction func colorButtonTapped(_ sender: Any) {
        showColor()
    }
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = chosenColor
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
    
    func showColor() {
        let alert = UIAlertController(title: nil, message: "Choose a default color!", preferredStyle: .alert)
        
        let color1 = UIAlertAction(title: "Purple", style: .default) { (action) in
            self.navigationController?.navigationBar.tintColor = UIColor.purple
            self.chosenColor = UIColor.purple
        }
        
        let color2 = UIAlertAction(title: "Blue", style: .default) { (action) in
            self.navigationController?.navigationBar.tintColor = UIColor.blue
            self.chosenColor = UIColor.blue
        }
        
        let color3 = UIAlertAction(title: "Orange", style: .default) { (action) in
            self.navigationController?.navigationBar.tintColor = UIColor.orange
            self.chosenColor = UIColor.orange
        }
        
        let color4 = UIAlertAction(title: "Green", style: .default) { (action) in
            self.navigationController?.navigationBar.tintColor = UIColor.green
            self.chosenColor = UIColor.green
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(color1)
        alert.addAction(color2)
        alert.addAction(color3)
        alert.addAction(color4)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
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
            vc.chosenColor2 = chosenColor
            
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
