//
//  IconSectionCollectionReusableView.swift
//  VGFlow
//
//  Created by Federico Guidi on 24/04/22.
//

import UIKit

class IconSectionCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "IconSectionView"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontKit.roundedFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.tintColor = .label
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
        
        stackView.addArrangedSubview(iconImage)
        stackView.addArrangedSubview(nameLabel)
        stackView.spacing = 10
    }
    
    func setTitle(_ title: String, with icon: String) {
        nameLabel.text = title
        iconImage.image = UIImage(systemName: icon)
    }
}
