//
//  GameplayButton.swift
//  VGFlow
//
//  Created by Federico Guidi on 30/04/22.
//

import UIKit

@IBDesignable class GameRatingButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 5
    
    // Sets the Active/Inactive State
    @IBInspectable var active:Bool = false {
        didSet {
            if active {
                setSelected()
            } else {
                setDeselected()
            }
        }
    }

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        if active {
            setSelected()
        } else {
            setDeselected()
        }
        
        // Respond to touch events by user
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        active.toggle()
        
        if active {
            setSelected()
        } else {
            setDeselected()
        }
    }
    
    // Set the selected properties
    func setSelected() {
        let templateImage = imageView!.image?.withRenderingMode(.alwaysTemplate)
        imageView!.image = templateImage
        imageView!.tintColor = .white
        self.backgroundColor = .systemIndigo
    }
    
    // Set the deselcted properties
    func setDeselected() {
        let templateImage = imageView!.image?.withRenderingMode(.alwaysTemplate)
        imageView!.image = templateImage
        imageView!.tintColor = .label
        self.backgroundColor = .lightGray.withAlphaComponent(0.2)
    }
}
