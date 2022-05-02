//
//  GameStatusSegmentedControl.swift
//  VGFlow
//
//  Created by Federico Guidi on 01/05/22.
//

import Foundation
import UIKit

class GameStatusRadioButton: UIButton {
    var alternateButtons: [GameStatusRadioButton]?
    var status: VideoGameStatus? {
        didSet {
            updateConfiguration()
        }
    }
    
    func unselectAlternateButtons() {
        if alternateButtons != nil {
            self.isSelected = true
            
            for aButton: GameStatusRadioButton in alternateButtons! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override func updateConfiguration() {
        guard let configuration = configuration,
              let status = status else {
            return
        }
        
        // 1
        var updatedConfiguration = configuration
        
        // 2
        var background = UIButton.Configuration.plain().background
        
        // 3
        background.cornerRadius = 10
        background.strokeWidth = 1
        
        // 4
        let strokeColor: UIColor = status.properties.1
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        let baseColor = updatedConfiguration.baseForegroundColor ?? UIColor.tintColor
        
        // 1
        switch self.state {
        case .normal:
            foregroundColor = status.properties.1
            backgroundColor = .clear
        case .selected, [.highlighted], [.selected, .highlighted]:
            foregroundColor = .white
            backgroundColor = status.properties.1
        case .disabled:
            foregroundColor = baseColor.withAlphaComponent(0.3)
            backgroundColor = .clear
        default:
            foregroundColor = baseColor
            backgroundColor = .clear
        }
        
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        // 2
        self.configuration = updatedConfiguration
    }
}
