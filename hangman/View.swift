//
//  ViewController.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class View: UIViewController {
    
    private let sessionmanager = SessionManager()
        
    private lazy var hangmanStackView: UIStackView = {
        
        let hangmanStackView = UIStackView()
        hangmanStackView.spacing = 5
        
        return hangmanStackView
    }()
    
    private let gameTitleLabel: UILabel = {
        
        let gameTitleLabel = UILabel()
        
        let text = "Hangman game"
        
        let attributes = [AttributedRange(attributes: [.font: App.font as Any,
                                                       .foregroundColor: UIColor.white],
                                          range: text)]
        
        gameTitleLabel.addAttributedText(text: text, attributes)
        
        return gameTitleLabel
    }()
    
    private let chooseALetter: UILabel = {
        
        let chooseALetter = UILabel()
        
        let text = "Choose a letter"
        
        let attributes = [AttributedRange(attributes: [.font: App.font as Any,
                                                       .foregroundColor: UIColor.white],
                                          range: text)]
        
        chooseALetter.addAttributedText(text: text, attributes)
        
        return chooseALetter
    }()
        
    private let hangmanImage: UIImageView = {
        
        let hangman = UIImageView()
        hangman.image = App.Images.game_1
        hangman.contentMode = .scaleAspectFit
        
        return hangman
    }()
    
    private lazy var viewModel: ViewModel = {
        
        let viewModel = ViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()

    override func viewDidLoad() {
        
        view.addSubviews([hangmanImage, hangmanStackView, gameTitleLabel, chooseALetter])
        view.backgroundColor = App.green
        
        sessionmanager.APIFullRequest{response in
            
            self.hangmanStackView.addArrangedSubviews(self.viewModel.createTextFields(response.slip.advice))
            print(self.viewModel.gameWord)
        }
        
        super.viewDidLoad()
        
        gameTitleLabel.constraint(to: hangmanImage, by: [.centerX, .top])
        
        hangmanImage.constraint(to: view.safeAreaLayoutGuide, by: [.top, .leading, .trailing])
        hangmanImage.constraint(to: view.keyboardLayoutGuide, with: [.bottom: .top])
        
        hangmanStackView.constraint(to: hangmanImage, by: [.centerX], view.frame.size.width*0.1)
        hangmanStackView.constraint(to: hangmanImage, by: [.centerY], view.frame.size.height*0.15)
        
        chooseALetter.constraint(to: hangmanImage, by: [.centerX, .bottom])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        .lightContent
    }
    
    @objc func textFieldsTarget(_ sender: UITextField) {
        
        let TargetText = viewModel.gameWord[viewModel.gameWord.index(viewModel.gameWord.startIndex,
                                                                     offsetBy: sender.tag)]
        
        var hitWord = false
        
        for i in 0...viewModel.gameWord.count-1 {

            let TargetText = viewModel.gameWord[viewModel.gameWord.index(viewModel.gameWord.startIndex,
                                                                         offsetBy: i)]
            if sender.text == "\(TargetText)" || sender.text == "\(TargetText.uppercased())" {

                guard let textField = hangmanStackView.arrangedSubviews[i] as? UITextField else {return}
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
            
            viewModel.updateRangmanImage(hangmanImage)
        }
        sender.text = ""
    }
}

extension View: ViewModelDelegate {
    
    func setTxtFieldsTarget(_ textField: UITextField) {
        
        textField.addTarget(self, action: #selector(textFieldsTarget), for: .editingChanged)
    }
}
