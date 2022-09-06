//
//  AssetsEnum.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

struct AttributedRange {
    
    let attributes: [NSAttributedString.Key: Any]
    let range: String
}

struct App {
    
    static let green = UIColor(named: "AppThemeGreen")
    static let font = UIFont(name: "Chalkduster", size: 20)
    
    struct Images {
        
        static let game = UIImage(named: "LauncherScreen")
        static let skull = UIImage(named: "caveira")
        static let game_1 = UIImage(named: "hangman game - 0")
        static let game_2 = UIImage(named: "hangman game - 1")
        static let game_3 = UIImage(named: "hangman game - 2")
        static let game_4 = UIImage(named: "hangman game - 3")
        static let game_5 = UIImage(named: "hangman game - 4")
        static let line_1 = UIImage(named: "line - 1")
        static let line_2 = UIImage(named: "line - 2")
        static let line_3 = UIImage(named: "line - 3")
        static let line_4 = UIImage(named: "line - 4")
        static let line_5 = UIImage(named: "line - 5")
        static let line_6 = UIImage(named: "line - 6")
    }
}
