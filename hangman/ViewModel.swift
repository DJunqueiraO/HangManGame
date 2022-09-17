//
//  ViewModel.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class ViewModel {
    
    private let sessionmanager = SessionManager()
    
    var delegate: ViewModelDelegate?
    var gameWord = ""
    var advice: String = ""
    
    private func validateName(_ name: String) -> Bool {
        
        let nameRegEx = "^[a-zA-Zá-üÁ-Ü]{2,8}+(([a-zA-Zá-üÁ-Ü])?[a-zA-Zá-üÁ-Ü]*)*$"

        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        
        if namePred.evaluate(with: name) {
            
            return true
        }
        return false
    }
    
    func splitWords(_ advice: String) -> [String] {
        
        var words: [String] = []
        var word: String = ""
        
        for char in advice {
            
            if char == " " {
                
                if validateName(word) && word != "don\\'t" && word.count > 2 {words.append(word)}
                word = ""
                continue
            }
            word.append(char)
        }
        words.append(word)
        
        return words
    }
    
    private func memorizeAdvice(_ words: [String]) {
        
        advice = ""
        
        for word in words {
            
            if word == gameWord {
                
                advice.append("? ")
                
                continue
            }
            advice.append(word + " ")
        }
    }
    
    private func memorizeTheWord(_ words: [String]) {
        
        let randomWordIndex = Int.random(in: 0...words.count-1)
        
        gameWord = words[randomWordIndex]
    }
    
    func playerWin(_ hangmanStackView: UIStackView) {
        
        for arrangedSubview in hangmanStackView.arrangedSubviews {
            
            guard let textField = arrangedSubview as? UITextField else {return}
            if textField.text == "" {return}
        }
        delegate?.displayResult(App.Images.trollFace, "You Win")
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
        
        if sender.text == "\(TargetText.lowercased())" || sender.text == "\(TargetText.uppercased())" {
            
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
                delegate?.displayResult(App.Images.skull, "You Lose")
        }
    }
    
    func initializeGame(_ hangmanStackView: UIStackView) {
        
        sessionmanager.APIFullRequest{response in
            
            hangmanStackView.removeArrangedSubviews()
            hangmanStackView.addArrangedSubviews(self.createTextFields(response.slip.advice))
            self.delegate?.setAdviceLabel(self.advice)
        }
    }
    
    func createLabel(attributedText: NSAttributedString? = nil) -> UILabel {
        
        let label = UILabel()
        if let attributedText = attributedText {label.attributedText = attributedText}
        label.font = App.font
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }
        
    func createTextFields(_ advice: String) -> [UITextField] {
        
        let words = splitWords(advice)
        memorizeTheWord(words)
        memorizeAdvice(words)
        
        var textFields = [UITextField]()
        
        for i in 0...gameWord.count-1 {
            
            let textField = UITextField()
            textField.font = App.font
            textField.textColor = .white
            textField.tag = i
            delegate?.setTxtFieldsTarget(textField)
            
            let attributedText = NSMutableAttributedString(string: "_",
                                                           attributes: [.font: textField.font as Any,
                                                                        .foregroundColor: textField.textColor as Any])
            
            let label = createLabel(attributedText: attributedText)
            
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
    func displayResult(_ image: UIImage?,_ text: String)
    func setAdviceLabel(_ advice: String)
}
