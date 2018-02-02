//
//  PropertiesTableViewController.swift
//  ThirdAssessment
//
//  Created by Terence Chua on 02/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import CoreData

class PropertiesTableViewController: UIViewController {
    
    @IBOutlet weak var propertiesTableView: UITableView!
    
    var selectedOwner : Owner?
    
    var propertyName : String = ""
    var propertyPrice : Int16 = 0
    var propertyLocation : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        propertiesTableView.dataSource = self
        propertiesTableView.delegate = self
        
        navigationItem.title = "Properties"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        propertiesTableView.reloadData()
    }
    
    
    @objc func addButtonTapped() {
        guard let vcToNewProperty = storyboard?.instantiateViewController(withIdentifier: "NewPropertyViewController") as? NewPropertyViewController else {return}
        
        vcToNewProperty.selectedOwner2 = selectedOwner
        
        navigationController?.pushViewController(vcToNewProperty, animated: true)
    }
    
    
}

extension PropertiesTableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOwner?.ownsProperty?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = propertiesTableView.dequeueReusableCell(withIdentifier: "propertyCell", for: indexPath)
        
        if let properties = selectedOwner?.ownsProperty?.allObjects as? [Property] {
            let currentProperty = properties[indexPath.row]
            cell.textLabel?.text = currentProperty.name
            cell.detailTextLabel?.text = "\(currentProperty.price), \(currentProperty.location ?? "n/a")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vcToNewProperty = sb.instantiateViewController(withIdentifier: "NewPropertyViewController") as? NewPropertyViewController {
            
            if let properties = selectedOwner?.ownsProperty?.allObjects as? [Property] {
                vcToNewProperty.selectedProperty = properties[indexPath.row]
                navigationController?.pushViewController(vcToNewProperty, animated: true)

            }
        }
    }
}



