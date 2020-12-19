//
//  WelcomeBadgeView.swift
//  Enjaz
//
//  Created by mohammed balegh on 15/12/2020.
//

import UIKit

class WelcomeBadgeView: UIView {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupImage()
        setupWelcomeLabel()
        setupMessageLabel()
    }
    
    func setupMessageLabel() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 3),
            messageLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.023),
            messageLabel.trailingAnchor.constraint(equalTo: image.leadingAnchor)
        ])
    }
    
    func setupWelcomeLabel() {
        addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.trailingAnchor.constraint(equalTo: image.leadingAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            welcomeLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.023),
            welcomeLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.35)
        ])
    }
    
    func setupImage() {
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.064),
            image.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.064)
        ])
    }
}