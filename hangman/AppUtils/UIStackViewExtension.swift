//
//  UIStackViewExtension.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        
        for view in views {
            
            self.addArrangedSubview(view)
        }
    }
}
