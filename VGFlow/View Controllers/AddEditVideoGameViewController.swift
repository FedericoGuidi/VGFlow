//
//  AddEditVideoGameViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 01/05/22.
//

import UIKit

class AddEditVideoGameViewController: UIViewController {
    
    var videoGameDetails: VideoGameDetails?
    var videoGame: VideoGame?
    var backlogEntry: BacklogEntry?

    @IBOutlet var notStartedRadioButton: GameStatusRadioButton!
    @IBOutlet var unfinishedRadioButton: GameStatusRadioButton!
    @IBOutlet var finishedRadioButton: GameStatusRadioButton!
    @IBOutlet var completedRadioButton: GameStatusRadioButton!
    @IBOutlet var unlimitedRadioButton: GameStatusRadioButton!
    @IBOutlet var abandonedRadioButton: GameStatusRadioButton!
    
    @IBOutlet var nowPlayingLabel: UILabel!
    @IBOutlet var starredLabel: UILabel!
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var nowPlayingSwitch: UISwitch!
    @IBOutlet var starredSwitch: UISwitch!
    
    @IBOutlet var removeFromBacklogButton: UIButton!
    
    var allButtons: [GameStatusRadioButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        setupView()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        
        removeFromBacklogButton.isHidden = true
        self.isModalInPresentation = true
        self.navigationItem.backBarButtonItem?.title = ""
        nowPlayingLabel.font = FontKit.roundedFont(ofSize: 20, weight: .medium)
        starredLabel.font = FontKit.roundedFont(ofSize: 20, weight: .medium)
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        hoursTextField.inputAccessoryView = keyboardToolbar
        
        if let videoGameDetails = videoGameDetails {
            if let hours = videoGameDetails.hours,
               let status = videoGameDetails.status {
                hoursTextField.text = String(hours)
                allButtons.first { $0.status == status }?.isSelected = true
                removeFromBacklogButton.isHidden = false
            } else {
                notStartedRadioButton.isSelected = true
            }
            nowPlayingSwitch.isOn = videoGameDetails.nowPlaying
            starredSwitch.isOn = videoGameDetails.starred
        }
    }
    
    private func buttonSetup() {
        allButtons = [notStartedRadioButton, unfinishedRadioButton, finishedRadioButton, completedRadioButton, unlimitedRadioButton, abandonedRadioButton]
        
        
        notStartedRadioButton.status = .notStarted
        unfinishedRadioButton.status = .unfinished
        finishedRadioButton.status = .finished
        completedRadioButton.status = .completed
        unlimitedRadioButton.status = .unlimited
        abandonedRadioButton.status = .abandoned
        
        for gameButton in allButtons {
            gameButton.alternateButtons = allButtons.filter { return $0 != gameButton }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "addToBacklog" else { return }
        
        let hours = hoursTextField.text!
        let status = allButtons.filter { $0.isSelected }.first?.status!
        let nowPlaying = nowPlayingSwitch.isOn
        let starred = starredSwitch.isOn
        
        if let _ = self.videoGameDetails?.status,
           let videoGame = videoGame {
            // Salvo in libreria
            backlogEntry = BacklogEntry(user: KeychainItem.currentUserIdentifier, videogameId: videoGame.id, hours: Int(hours) ?? 0, starred: starred, nowPlaying: nowPlaying, status: status!)
        } else {
            // Aggiungo per la prima volta in libreria
            if let videoGame = videoGame {
                backlogEntry = BacklogEntry(user: KeychainItem.currentUserIdentifier, videogameId: videoGame.id, name: videoGame.name, cover: videoGame.cover?.imageURL, genres: videoGame.genres.map { $0.name }, hours: Int(hours) ?? 0, starred: starred, nowPlaying: nowPlaying, status: status!)
            }
        }
    }
    
    @IBAction func removeFromBacklogButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Attenzione!", message: "Vuoi davvero rimuovere \(videoGame!.name) dalla tua libreria?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Conferma", style: .destructive, handler: removeFromBacklogHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeFromBacklogHandler(alert: UIAlertAction) {
        self.performSegue(withIdentifier: "removeFromBacklog", sender: self)
    }
}
