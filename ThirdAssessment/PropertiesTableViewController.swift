//
//  PropertiesTableViewController.swift
//  ThirdAssessment
//
//  Created by Terence Chua on 02/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class PropertiesTableViewController: UIViewController {
    
    @IBOutlet weak var propertiesTableView: UITableView!
    

    var selectedOwner : Owner?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        propertiesTableView.dataSource = self
        
        navigationItem.title = "Properties"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonTapped))
    }

    
    @objc func addButtonTapped() {
        
    }


}

extension PropertiesTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
