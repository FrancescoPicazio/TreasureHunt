//
//  ViewController.swift
//  Treasure Hunter
//
//  Created by Francesco Picazio on 29/05/18.
//  Copyright © 2018 Francesco Picazio. All rights reserved.
//

import UIKit
import CoreLocation

class NewBeaconController: UIViewController {
    
    //Per l'aggiunta dei beacon
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var UUIDTextfield: UITextField!
    @IBOutlet weak var majorTextfield: UITextField!
    @IBOutlet weak var minorTextfield: UITextField!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let selectedBeacon = BeaconManager.shared.selectedBeacon
        
        identifierTextField.text = selectedBeacon.identifier
        
        UUIDTextfield.text = selectedBeacon.proximityUUID.uuidString
        
        majorTextfield.text = selectedBeacon.major?.stringValue
        
        minorTextfield.text = selectedBeacon.minor?.stringValue
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        let identifier: String = identifierTextField.text ?? "No name"
        
        let UUIDValue: UUID = UUID(uuidString: UUIDTextfield.text!) ?? UUID(uuid: UUID_NULL)
        let minor: CLBeaconMinorValue = CLBeaconMinorValue(minorTextfield.text!) ?? CLBeaconMinorValue(bitPattern: 0)
        let major: CLBeaconMajorValue = CLBeaconMajorValue(majorTextfield.text!) ?? CLBeaconMajorValue(bitPattern: 0)
        
        let newBeacon: CLBeaconRegion = CLBeaconRegion(
            proximityUUID: UUIDValue,
            major: major,
            minor: minor,
            identifier: identifier)
        
        if ((identifierTextField.text?.isEmpty)! && (UUIDTextfield.text?.isEmpty)!) {
      
            let alert = UIAlertController(title: "Error", message: "Choose an identifier and an UUID.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
            
        } else if !BeaconManager.shared.beaconRegions.contains(newBeacon) {
            BeaconManager.shared.beaconRegions.append(newBeacon)
        }
        
        performSegue(withIdentifier: "GoToHunt", sender: nil)
        BeaconManager.shared.saveBeacon()
    }
}
 

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

