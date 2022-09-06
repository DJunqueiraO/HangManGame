//
//  UILabelExtension.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

extension UITextField {
    
    func addAttributedText(text: String,
                           _ attributes: [AttributedRange]) {
        
        let attributedText = NSMutableAttributedString(string: text)
        
        for attribute in attributes {
            
            let attributes: [NSAttributedString.Key: Any] = attribute.attributes
            
            attributedText.addAttributes(attributes,
                                         range: (attributedText.string as NSString).range(of: attribute.range))
        }
        
        self.attributedText = attributedText
    }
}
