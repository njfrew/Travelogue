//
//  SingleTripViewController.swift
//  Travelogue
//
//  Created by Noah Frew on 12/10/20.
//

import UIKit

class SingleTripViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveTrip(_ sender: Any) {
        let trip = Trip(title: titleTextField.text ?? "")
        
        do {
            try trip?.managedObjectContext?.save()
            
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Could not save trip")
        }
    }
    

}


extension SingleTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
