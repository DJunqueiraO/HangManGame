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
    
    private let adviceLabel: UILabel = {
        
        let adviceLabel = UILabel()
        adviceLabel.font = App.font
        adviceLabel.textColor = .white
        
        return adviceLabel
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
    
    private lazy var youLoseImageView: UIImageView = {
        
        let youLoseImageView = UIImageView()
        youLoseImageView.image = App.Images.skull
        youLoseImageView.contentMode = .scaleAspectFit
        youLoseImageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        youLoseImageView.alpha = 0
        
        let youLoseLabel = UILabel()
        
        let text = "You Lose"
        
        let attributes = [AttributedRange(attributes: [.font: App.font as Any,
                                                       .foregroundColor: UIColor.white],
                                          range: text)]
        
        youLoseLabel.addAttributedText(text: text, attributes)
        
        youLoseImageView.addSubview(youLoseLabel)
        
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerX])
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerY], view.frame.size.height*0.25)
        
        return youLoseImageView
    }()

    override func viewDidLoad() {
        
        view.addSubviews([hangmanImage, hangmanStackView, adviceLabel, gameTitleLabel, chooseALetter, youLoseImageView])
        view.backgroundColor = App.green
        
        sessionmanager.APIFullRequest{response in
            
            self.hangmanStackView.addArrangedSubviews(self.viewModel.createTextFields(response.slip.advice))
            self.adviceLabel.text = self.viewModel.advice
        }
        
        super.viewDidLoad()
        
        gameTitleLabel.constraint(to: hangmanImage, by: [.centerX, .top])
        
        hangmanImage.constraint(to: view.safeAreaLayoutGuide, by: [.top, .leading, .trailing])
        hangmanImage.constraint(to: view.keyboardLayoutGuide, with: [.bottom: .top])
        
        hangmanStackView.constraint(to: hangmanImage, by: [.centerX], view.frame.size.width*0.1)
        hangmanStackView.constraint(to: hangmanImage, by: [.centerY], view.frame.size.height*0.15)
        
        adviceLabel.constraint(to: chooseALetter, with: [.bottom:.top])
        adviceLabel.constraint(to: chooseALetter, by: [.centerX])
        
        chooseALetter.constraint(to: hangmanImage, by: [.centerX, .bottom])
        
        youLoseImageView.constraint(to: view, by: [.top, .leading, .trailing, .bottom])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        .lightContent
    }
    
    @objc func textFieldsTarget(_ sender: UITextField) {
        
        viewModel.verifyTextField(sender)
    }
}

extension View: ViewModelDelegate {
    
    func setTxtFieldsTarget(_ textField: UITextField) {
        
        textField.addTarget(self, action: #selector(textFieldsTarget), for: .editingChanged)
    }
    
    func setHangmanImage() {
        
        viewModel.updateRangmanImage(hangmanImage)
    }
    
    func youLose() {
        
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1) {
            
            self.youLoseImageView.alpha = 1
        }
    }
}
