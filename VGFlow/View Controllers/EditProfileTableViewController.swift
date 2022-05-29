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
    
    var profile: Profile
    
    init?(coder: NSCoder, profile: Profile) {
        self.profile = profile
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bioTextField.textContainer.lineFragmentPadding = 0
        bioTextField.textContainerInset = .zero
        
        update()
    }
    
    func update() {
        nameTextField.text = profile.name
        bioTextField.text = profile.description
        
        if let socials = profile.social {
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
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
