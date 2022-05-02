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
    
    var allButtons: [GameStatusRadioButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        setupView()
    }
    
    func setupView() {
        self.isModalInPresentation = true
        self.navigationItem.backBarButtonItem?.title = ""
        nowPlayingLabel.font = FontKit.roundedFont(ofSize: 20, weight: .medium)
        starredLabel.font = FontKit.roundedFont(ofSize: 20, weight: .medium)
        
        if let videoGameDetails = videoGameDetails {
            if let hours = videoGameDetails.hours,
               let status = videoGameDetails.status {
                hoursTextField.text = String(hours)
                allButtons.first { $0.status == status }?.isSelected = true
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
}
