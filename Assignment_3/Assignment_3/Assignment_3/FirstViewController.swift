//
//  ViewController.swift
//  Assignment_3
//
//  Created by Guest User on 12/07/2019.
//  Copyright © 2019 Guest User. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var rhymingWordTextField: UITextField!
    @IBOutlet weak var showSelectedWordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rhymingWordTextField.delegate = self
    }
    
    // method to do setup operations before transition to the next scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if rhymingWordTextField.text?.isEmpty == true {
            let emptyTextFieldAlert = UIAlertController(title: "Empty Text Field!", message: "Please enter the letter/letters in the text field if you want to search for rhyming words.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            emptyTextFieldAlert.addAction(okAction)
            
            present(emptyTextFieldAlert, animated: true) {() -> Void in }
        } else {
            // get the View Controller object of the destination scene for this segue
            let secondVC = segue.destination as! SecondViewController
            
            // access the property in the View Controller object of the destination
            secondVC.wordSuffix = rhymingWordTextField.text!
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hides the keyboard when the user clicks outside
    // of Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

