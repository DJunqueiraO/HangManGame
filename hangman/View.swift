//
//  ViewController.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class View: UIViewController {
    
//    private let sessionmanager = SessionManager()
        
    private lazy var hangmanStackView: UIStackView = {
        
        let hangmanStackView = UIStackView()
        hangmanStackView.spacing = 5
        
        return hangmanStackView
    }()
    
    private lazy var gameTitleLabel: UILabel = {
        
        let attributedText = NSMutableAttributedString(string: "Hangman game",
                                                       attributes: [.font: App.font as Any,
                                                                    .foregroundColor: UIColor.white])
        
        let gameTitleLabel = viewModel.createLabel(attributedText: attributedText)
        
        return gameTitleLabel
    }()
    
    private lazy var adviceLabel: UILabel = {
        
        let adviceLabel = viewModel.createLabel()
        
        return adviceLabel
    }()
    
    private lazy var chooseALetter: UILabel = {
        
        let attributedText = NSMutableAttributedString(string: "Choose a letter",
                                                       attributes: [.font: App.font as Any,
                                                                    .foregroundColor: UIColor.white])
        
        let chooseALetter = viewModel.createLabel(attributedText: attributedText)
        
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
    
    private lazy var youLoseLabel: UILabel = {
        
        let youLoseLabel = viewModel.createLabel()
        
        return youLoseLabel
    }()
    
    private lazy var youLoseImageView: UIImageView = {
        
        let youLoseImageView = UIImageView()
        youLoseImageView.contentMode = .scaleAspectFit
        youLoseImageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        youLoseImageView.alpha = 0
        
        youLoseImageView.addSubview(youLoseLabel)
        
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerX])
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerY], view.frame.size.height*0.25)
        
        return youLoseImageView
    }()
    
    private lazy var playAgainButton: UIButton = {
        
        let playAgainButton = UIButton()
        playAgainButton.alpha = 0
        playAgainButton.setImage(App.Images.playAgain, for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgainTarget),
                                  for: .touchUpInside)
        playAgainButton.imageView?.contentMode = .scaleAspectFit
        
        return playAgainButton
    }()

    override func viewDidLoad() {
        
        view.addSubviews([hangmanImage, hangmanStackView, adviceLabel, gameTitleLabel, chooseALetter, youLoseImageView, playAgainButton])
        view.backgroundColor = App.green
        
        viewModel.initializeGame(hangmanStackView)
        
        super.viewDidLoad()
        
        gameTitleLabel.constraint(to: hangmanImage, by: [.centerX, .top])
        
        hangmanImage.constraint(to: view.safeAreaLayoutGuide, by: [.top, .leading, .trailing])
        hangmanImage.constraint(to: view.keyboardLayoutGuide, with: [.bottom: .top])
        
        hangmanStackView.constraint(to: hangmanImage, by: [.centerX], view.frame.size.width*0.1)
        hangmanStackView.constraint(to: hangmanImage, by: [.centerY], view.frame.size.height*0.15)
        
        adviceLabel.constraint(to: chooseALetter, with: [.bottom:.top], -view.frame.size.height/20)
        adviceLabel.constraint(to: hangmanImage, by: [.leading, .trailing])
        
        chooseALetter.constraint(to: hangmanImage, by: [.leading, .trailing, .bottom])
        
        playAgainButton.constraint(to: view.safeAreaLayoutGuide,
                                   by: [.leading,.trailing,.bottom])
        playAgainButton.constraint(to: youLoseImageView, by: [.height], multiplier: 0.1)
        
        youLoseImageView.constraint(to: view, by: [.top, .leading, .trailing, .bottom])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        .lightContent
    }
    
    @objc func textFieldsTarget(_ sender: UITextField) {
        
        viewModel.verifyTextField(sender)
        viewModel.playerWin(hangmanStackView)
    }
    
    @objc func playAgainTarget(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1) {
            
            sender.alpha = 0
            self.youLoseImageView.alpha = 0
        }
        viewModel.initializeGame(hangmanStackView)
        hangmanImage.image = App.Images.game_1
    }
}

extension View: ViewModelDelegate {
    
    func setTxtFieldsTarget(_ textField: UITextField) {
        
        textField.addTarget(self, action: #selector(textFieldsTarget), for: .editingChanged)
    }
    
    func setHangmanImage() {
        
        viewModel.updateRangmanImage(hangmanImage)
    }
    
    func displayResult(_ image: UIImage?,_ text: String) {
        
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [.font: App.font as Any,
                                                                    .foregroundColor: UIColor.white])
        youLoseLabel.attributedText = attributedText
        
        view.endEditing(true)
        
        youLoseImageView.image = image
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1) {
            
            self.youLoseImageView.alpha = 1
            self.playAgainButton.alpha = 1
        }
    }
    
    func setAdviceLabel(_ advice: String) {
        
        adviceLabel.text = advice
    }
}
