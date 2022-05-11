//
//  GameplayButton.swift
//  VGFlow
//
//  Created by Federico Guidi on 30/04/22.
//

import UIKit

class GameRatingButton: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleButton()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override func updateConfiguration() {
        guard let configuration = configuration else {
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
        //let strokeColor: UIColor = status.properties.1
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        let baseColor = updatedConfiguration.baseForegroundColor ?? UIColor.tintColor
        
        // 1
        switch self.state {
        case .normal:
            foregroundColor = .label
            backgroundColor = .systemGray.withAlphaComponent(0.2)
        case .selected, [.highlighted], [.selected, .highlighted]:
            foregroundColor = .white
            backgroundColor = .systemIndigo
        case .disabled:
            foregroundColor = baseColor.withAlphaComponent(0.3)
            backgroundColor = .clear
        default:
            foregroundColor = .label
            backgroundColor = baseColor.withAlphaComponent(0.1)
        }
        
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        // 2
        self.configuration = updatedConfiguration
    }
}
