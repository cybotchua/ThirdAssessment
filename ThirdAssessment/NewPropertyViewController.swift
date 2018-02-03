//
//  NewPropertyViewController.swift
//  ThirdAssessment
//
//  Created by Terence Chua on 02/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit

class NewPropertyViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var presentedNavigationItem: UINavigationItem!
    
    @IBOutlet weak var presentedNavigationBar: UINavigationBar!
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        print("done Tapped")
        if let name = nameTextField.text,
            let priceText = priceTextField.text,
            let location = locationTextField.text,
            name != "",
            priceText != "",
            location != "",
            let price = Int16(priceText) {
            
            if addMode {
                createProperty(name: name, price: price, location: location)
            } else {
                updateProperty(name: name, price: price, location: location)
            }
            
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    var addMode : Bool = true
    
    var selectedProperty : Property?
    var selectedOwner2 : Owner?
    var chosenColor3 = UIColor.orange
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let property = selectedProperty {
            addMode = false
            nameTextField.text = property.name
            priceTextField.text = String(property.price)
            locationTextField.text = property.location
        }
        
        if addMode {
            presentedNavigationItem.title = "Add Property"
        } else {
            presentedNavigationItem.title = "Edit Property"
        }
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentedNavigationBar.barTintColor = chosenColor3
//        let height: CGFloat = 50 //whatever height you want to add to the existing height
//        let bounds = presentedNavigationBar.bounds
//        presentedNavigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    
    //    @objc func doneButtonPressed() {
    //
    //        if let name = nameTextField.text,
    //            let priceText = priceTextField.text,
    //            let location = locationTextField.text,
    //            name != "",
    //            priceText != "",
    //            location != "",
    //            let price = Int16(priceText) {
    //
    //            if addMode {
    //                createProperty(name: name, price: price, location: location)
    //            } else {
    //                updateProperty(name: name, price: price, location: location)
    //            }
    //
    //        }
    //
    //        navigationController?.popViewController(animated: true)
    //    }
    
    
    func createProperty(name: String, price: Int16, location: String) {
        let newProperty = Property(entity: Property.entity(), insertInto: DataController.moc)
        newProperty.name = name
        newProperty.price = price
        newProperty.location = location
        selectedOwner2?.addToOwnsProperty(newProperty)
        
        DataController.saveContext()
    }
    
    func updateProperty(name: String, price: Int16, location: String) {
        guard let property = selectedProperty else {return}
        property.name = name
        property.price = price
        property.location = location
        
        DataController.saveContext()
    }
    
    
}
