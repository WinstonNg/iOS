//
//  SecondViewController.swift
//  Assignment_3
//
//  Created by Guest User on 12/07/2019.
//  Copyright © 2019 Guest User. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    @IBOutlet weak var rhymingWordsPickerView: UIPickerView!
    @IBOutlet weak var selectedWordLabel: UILabel!
    @IBOutlet weak var wordSuffixLabel: UILabel!
    
    var wordSuffix: String = ""
    var rhymingWords = [String]()
    var filteredRhymingWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rhymingWordsPickerView.dataSource = self
        rhymingWordsPickerView.delegate = self
        
        wordSuffixLabel.text = wordSuffix
        
        if let filePath = Bundle.main.path(forResource: "poemWords", ofType: "plist"){
            
            if let plistData = FileManager.default.contents(atPath: filePath) {
                do {
                    let plistObject = try PropertyListSerialization.propertyList(from: plistData, options: PropertyListSerialization.ReadOptions(), format: nil)
                    
                    let words = plistObject as? [String]
                    
                    if let words = words {
                        for index in 0..<words.count {
                            rhymingWords.append(words[index])
                        }
                    }
                    
                    if (wordSuffix.isEmpty == false) {
                        filteredRhymingWords = rhymingWords.filter {
                            (filteredRhymingWords) -> Bool in
                            filteredRhymingWords.hasSuffix(wordSuffix)
                        }
                    }
                    
                    if filteredRhymingWords.isEmpty == true {
                        let noMatchingWord = UIAlertController(title: "No Matching Suffix!", message: "There are no words matching the letters submitted!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: backToFirst)
                        noMatchingWord.addAction(okAction)
                        
                        DispatchQueue.main.async {
                            self.present(noMatchingWord, animated: true) {() -> Void in }
                        }
                    }
                    
                } catch {
                    print("Error serializing data from property list")
                }
            } else {
                print("Error reading data from property list file")
            }
        } else {
            print("Property list file does not exist")
        }
    }
    
    
    @IBAction func submitWordButtonPressed(_ sender: UIButton) {
        if selectedWordLabel.text?.isEmpty == true {
            let emptyLabelAlert = UIAlertController(title: "Word Not Chosen!", message: "Please choose a word from the list.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            emptyLabelAlert.addAction(okAction)
            
            present(emptyLabelAlert, animated: true) {() -> Void in }
        } else {
            // get the View Controller object of the source scene for the segue
            let firstVC = presentingViewController as! FirstViewController
            
            // set the property in the View Controller object of the source scene
            firstVC.showSelectedWordLabel.text = selectedWordLabel.text
            
            // Clear the text field where the user enters the word suffix
            firstVC.rhymingWordTextField.text = ""
            
            // dismiss the current scene
            dismissSecondVC()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredRhymingWords.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredRhymingWords[row]
    }
    
    // Picker View Delegate method
    // - displays the word selected by the user to the label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if filteredRhymingWords.count != 0 {
            selectedWordLabel.text = filteredRhymingWords[row]
        }
    }
    
    // function to dismiss the Second View Controller
    func dismissSecondVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Alert function that triggers if no words were found matching the suffix submitted
    // Returns the user to the first scene
    func backToFirst(alert: UIAlertAction) {
        dismissSecondVC()
    }
    
}
