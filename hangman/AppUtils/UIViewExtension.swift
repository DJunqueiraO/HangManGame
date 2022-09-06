//
//  UIViewExtension.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        
        for view in views {
            
            self.addSubview(view)
        }
    }
    
    func constraint(to toItem: Any?,
                    the item: Any? = nil,
                    by attributes: [NSLayoutConstraint.Attribute]? = nil,
                    with itemAttributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil,
                    relation: NSLayoutConstraint.Relation = .equal,
                    multiplier: CGFloat = 1,
                    _ constant: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let attributes = attributes {
            
            for attribute in attributes {
                
                self.superview?.addConstraint(NSLayoutConstraint(item: item ?? self,
                                                                 attribute: attribute,
                                                                 relatedBy: relation,
                                                                 toItem: toItem,
                                                                 attribute: attribute,
                                                                 multiplier: multiplier,
                                                                 constant: constant))
            }
        }
        guard let attributes = itemAttributes else {return}
        for attribute in attributes {
            
            self.superview?.addConstraint(NSLayoutConstraint(item: item ?? self,
                                                             attribute: attribute.key,
                                                             relatedBy: relation,
                                                             toItem: toItem,
                                                             attribute: attribute.value,
                                                             multiplier: multiplier,
                                                             constant: constant))
        }
    }
}
