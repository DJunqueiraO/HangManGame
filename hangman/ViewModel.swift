//
//  ViewModel.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class ViewModel {
    
    var delegate: ViewModelDelegate?
    var gameWord = ""
    
    private func validateName(_ name: String) -> Bool {
        
        let nameRegEx = "^[a-zA-Zá-üÁ-Ü]{2,8}+(([',. -][a-zA-Zá-üÁ-Ü])?[a-zA-Zá-üÁ-Ü]*)*$"

        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        
        if namePred.evaluate(with: name) {
            
            return true
        }
        return false
    }
    
    private func splitWords(_ advice: String) -> [String] {
        
        var words: [String] = []
        
        var word: String = ""
        
        for char in advice {
            
            if char == " " {
                
                if validateName(word) && word != "don\\'t" && word.count > 1 {words.append(word)}
                word = ""
                continue
            }
            word.append(char)
        }
        
        return words
    }
    
    private func memorizeTheWord(_ word: String) {
        
        let words = splitWords(word)
        let randomWordIndex = Int.random(in: 0...words.count-1)
        
        gameWord = words[randomWordIndex]
    }
    
    func verifyTextField(_ sender: UITextField) {
        
        let TargetText = gameWord[gameWord.index(gameWord.startIndex, offsetBy: sender.tag)]
        
        var hitWord = false
        
        for i in 0...gameWord.count-1 {

            let TargetText = gameWord[gameWord.index(gameWord.startIndex, offsetBy: i)]
            if sender.text == "\(TargetText)" || sender.text == "\(TargetText.uppercased())" {
                
                guard let hangmanStackView = sender.superview as? UIStackView,
                      let textField = hangmanStackView.arrangedSubviews[i] as? UITextField else {return}
                
                textField.text = sender.text
                textField.isEnabled = false
                hitWord = true
            }
        }
        
        if sender.text == "\(TargetText)" || sender.text == "\(TargetText.uppercased())" {
            
            sender.isEnabled = false
            hitWord = true
            return
        }
        if !hitWord {
            
            delegate?.setHangmanImage()
        }
        sender.text = ""
    }
    
    func updateRangmanImage(_ imageView: UIImageView) {
        
        switch imageView.image {
            
            case App.Images.game_1:
            
                imageView.image = App.Images.game_2
            
            case App.Images.game_2:
            
                imageView.image = App.Images.game_3
            
            case App.Images.game_3:
            
                imageView.image = App.Images.game_4
            
            case App.Images.game_4:
            
                imageView.image = App.Images.game_5
            
            default:
            
                imageView.image = App.Images.game
                delegate?.freezeStackView()
        }
    }
        
    func createTextFields(_ word: String) -> [UITextField] {
        
        memorizeTheWord(word)
        var textFields = [UITextField]()
        
        for i in 0...gameWord.count-1 {
            
            let textField = UITextField()
            textField.font = App.font
            textField.textColor = .white
            textField.tag = i
            delegate?.setTxtFieldsTarget(textField)
            
            let label = UILabel()
            
            let text = "_"

            let attributes = [AttributedRange(attributes: [.font: textField.font as Any,
                                                           .foregroundColor: textField.textColor as Any],
                                              range: text)]

            label.addAttributedText(text: text, attributes)
            
            textField.addSubview(label)
            
            label.constraint(to: textField, by: [.centerY], 1)
            label.constraint(to: textField, by: [.centerX, .width, .height])
            
            textFields.append(textField)
        }
        
        return textFields
    }
}

protocol ViewModelDelegate {
    
    func setTxtFieldsTarget(_ textField: UITextField)
    
    func setHangmanImage()
    
    func freezeStackView()
}
