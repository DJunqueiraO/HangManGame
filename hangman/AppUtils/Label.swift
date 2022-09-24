//
//  CustomLabel.swift
//  hangman
//
//  Created by Josicleison on 24/09/22.
//

import UIKit

class Label: UILabel {
    
    init(attributedText: NSAttributedString? = nil) {
        
        super.init(frame: .zero)
        
        if let attributedText = attributedText {self.attributedText = attributedText}
        self.font = App.font
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
