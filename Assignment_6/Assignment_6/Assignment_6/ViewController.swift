//
//  ViewController.swift
//  Assignment_6
//
//  Created by Guest User on 20/8/2019.
//  Copyright © 2019 UTAR. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var thePicker: UIPickerView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playingMusicLabel: UILabel!
    
    let music = ["piano", "keyboard", "guitar", "bells", "meowing"]
    let defaults = UserDefaults.standard
    
    var selectedMusicString: String? = nil
    var audioPlayer : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.dataSource = self
        thePicker.delegate = self
        
        // retrieve saved playing music if it exists, display it in the label
        if let musicLabel = defaults.string(forKey: "playingMusic") {
            playingMusicLabel.text = musicLabel
        }
        
        // retrieve the saved volume level
        let volumeLevel = defaults.float(forKey: "volumeLevel")
        
        if volumeLevel != 0.0 {
            volumeSlider.value = volumeLevel
        } else {
            volumeSlider.value = 5.0
        }
        
        // Retrive the previously selected row
        // for the picker view
        let row = defaults.integer(forKey: "previousSelection")
        
        // Set the picker view to previously selected row
        thePicker.selectRow(row, inComponent: 0, animated: false)
        
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: selectedMusicString, ofType: "mp3")!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:url)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error\(error.localizedDescription)")
        }
        
        if let player = audioPlayer {
            player.play()
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        if let player = audioPlayer {
            player.stop()
        }
    }
    
    
    @IBAction func adjustVolume(_ sender: UISlider) {
        if audioPlayer != nil {
            audioPlayer!.volume = volumeSlider.value
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return music.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return music[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: "previousSelection")
        playingMusicLabel.text = music[row]
        selectedMusicString = music[row]
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let savePreferences = UIAlertController(title: "Success", message: "Preferrences saved successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: preferencesSaved)
        savePreferences.addAction(okAction)
        
        
        savePreferences.title = NSLocalizedString("save-success", comment: "Success")
        savePreferences.message = NSLocalizedString("save-message", comment: "Preferrences saved successfully")
 
        
        present(savePreferences, animated: true) {() -> Void in }
    }
    
    func preferencesSaved(alert: UIAlertAction!) {
        // get access to user settings using singleton NSUserDefaults
        let defaults = UserDefaults.standard
        
        // save the now playing music
        defaults.setValue(playingMusicLabel.text, forKey: "playingMusic")
        
        // save the preferred volume level
        defaults.set(Int(roundf(volumeSlider.value)), forKey: "volumeLevel")
    }
        
}
    



