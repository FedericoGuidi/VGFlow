//
//  EditProfileTableViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 29/05/22.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var bioTextField: UITextView!
    @IBOutlet var nintendoSwitchTextField: UITextField!
    @IBOutlet var xboxTextField: UITextField!
    @IBOutlet var playStationTextField: UITextField!
    @IBOutlet var steamTextField: UITextField!
    
    var user: User
    var socials: [UITextField]!
    
    init?(coder: NSCoder, user: User) {
        self.user = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bioTextField.textContainer.lineFragmentPadding = 0
        bioTextField.textContainerInset = .zero
        
        socials = [nintendoSwitchTextField, xboxTextField, playStationTextField, steamTextField]
        
        update()
    }
    
    func update() {
        nameTextField.text = user.name
        bioTextField.text = user.description
        
        if let socials = user.social {
            for social in socials {
                switch social.type {
                case .nintendoSwitch:
                    nintendoSwitchTextField.text = social.value
                case .xbox:
                    xboxTextField.text = social.value
                case .playstation:
                    playStationTextField.text = social.value
                case .steam:
                    steamTextField.text = social.value
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "updateProfile" else { return }
        
        user.name = nameTextField.text!
        user.description = bioTextField.text!
        user.social = []
        
        for (index, social) in socials.enumerated() {
            if let value = social.text {
                if !value.isEmpty {
                    user.social?.append(Social(type: .allCases[index], value: value))
                }
            }
        }
    }
}
