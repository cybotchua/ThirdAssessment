//
//  NewPropertyViewController.swift
//  ThirdAssessment
//
//  Created by Terence Chua on 02/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class NewPropertyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Property"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        guard let vcToPropertiesTableVC = storyboard?.instantiateViewController(withIdentifier: "PropertiesTableViewController") as? PropertiesTableViewController else {return}
        
        navigationController?.popViewController(animated: true)
    }


}
