//
//  ViewController.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class View: UIViewController {
    
    struct ViewElements {
        
        let hangmanStackView: UIStackView,
            gameTitleLabel: UILabel,
            adviceLabel: UILabel,
            chooseALetter: UILabel,
            hangmanImage: UIImageView,
            youLoseLabel: UILabel,
            youLoseImageView: UIImageView,
            playAgainButton: UIButton
    }
        
    private lazy var viewElements: ViewElements = {
        
        let hangmanStackView = UIStackView()
        hangmanStackView.spacing = 5
        
        let gameTitleLabel = Label(attributedText: NSMutableAttributedString(string: "Hangman game", attributes: [.font: App.font as Any, .foregroundColor: UIColor.white]))
        
        let adviceLabel = Label()
        
        let chooseALetter = Label(attributedText: NSMutableAttributedString(string: "Choose a letter", attributes: [.font: App.font as Any, .foregroundColor: UIColor.white]))
        
        let hangmanImage = UIImageView()
        hangmanImage.image = App.Images.game_1
        hangmanImage.contentMode = .scaleAspectFit
        
        let youLoseLabel = Label()
        
        let youLoseImageView = UIImageView()
        youLoseImageView.contentMode = .scaleAspectFit
        youLoseImageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        youLoseImageView.alpha = 0
        
        youLoseImageView.addSubview(youLoseLabel)
        
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerX])
        youLoseLabel.constraint(to: youLoseImageView, by: [.centerY], view.frame.size.height*0.25)
        
        let playAgainButton = UIButton()
        playAgainButton.alpha = 0
        playAgainButton.setImage(App.Images.playAgain, for: .normal)
        playAgainButton.addTarget(self, action: #selector(playAgainTarget),
                                  for: .touchUpInside)
        playAgainButton.imageView?.contentMode = .scaleAspectFit
        
        return ViewElements(hangmanStackView: hangmanStackView,
                            gameTitleLabel: gameTitleLabel,
                            adviceLabel: adviceLabel,
                            chooseALetter: chooseALetter,
                            hangmanImage: hangmanImage,
                            youLoseLabel: youLoseLabel,
                            youLoseImageView: youLoseImageView,
                            playAgainButton: playAgainButton)
    }()
    
    private lazy var viewModel: ViewModel = {
        
        let viewModel = ViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()

    override func viewDidLoad() {
        
        view.addSubviews([viewElements.hangmanImage, viewElements.hangmanStackView, viewElements.adviceLabel, viewElements.gameTitleLabel, viewElements.chooseALetter, viewElements.youLoseImageView, viewElements.playAgainButton])
        view.backgroundColor = App.green
        
        viewModel.initializeGame(viewElements.hangmanStackView)
        
        super.viewDidLoad()
        
        viewElements.gameTitleLabel.constraint(to: viewElements.hangmanImage, by: [.centerX, .top])
        
        viewElements.hangmanImage.constraint(to: view.safeAreaLayoutGuide, by: [.top, .leading, .trailing])
        viewElements.hangmanImage.constraint(to: view.keyboardLayoutGuide, with: [.bottom: .top])
        
        viewElements.hangmanStackView.constraint(to: viewElements.hangmanImage, by: [.centerX], view.frame.size.width*0.1)
        viewElements.hangmanStackView.constraint(to: viewElements.hangmanImage, by: [.centerY], view.frame.size.height*0.15)
        
        viewElements.adviceLabel.constraint(to: viewElements.chooseALetter, with: [.bottom:.top], -view.frame.size.height/20)
        viewElements.adviceLabel.constraint(to: viewElements.hangmanImage, by: [.leading, .trailing])
        
        viewElements.chooseALetter.constraint(to: viewElements.hangmanImage, by: [.leading, .trailing, .bottom])
        
        viewElements.playAgainButton.constraint(to: view.safeAreaLayoutGuide, by: [.leading,.trailing,.bottom])
        viewElements.playAgainButton.constraint(to: viewElements.youLoseImageView, by: [.height], multiplier: 0.1)
        
        viewElements.youLoseImageView.constraint(to: view, by: [.top, .leading, .trailing, .bottom])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent}
    
    @objc private func textFieldsTarget(_ sender: UITextField) {
        
        viewModel.verifyTextField(sender)
        viewModel.playerWin(viewElements.hangmanStackView)
    }
    
    @objc private func playAgainTarget(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1) {
            
            sender.alpha = 0
            self.viewElements.youLoseImageView.alpha = 0
        }
        viewModel.initializeGame(viewElements.hangmanStackView)
        viewElements.hangmanImage.image = App.Images.game_1
    }
}

extension View: ViewModelDelegate {
    
    func setTxtFieldsTarget(_ textField: UITextField) {
        
        textField.addTarget(self, action: #selector(textFieldsTarget), for: .editingChanged)
    }
    
    func setHangmanImage() {
        
        viewModel.updateRangmanImage(viewElements.hangmanImage)
    }
    
    func displayResult(_ image: UIImage?,_ text: String) {
        
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [.font: App.font as Any,
                                                                    .foregroundColor: UIColor.white])
        viewElements.youLoseLabel.attributedText = attributedText
        
        view.endEditing(true)
        
        viewElements.youLoseImageView.image = image
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1) {
            
            self.viewElements.youLoseImageView.alpha = 1
            self.viewElements.playAgainButton.alpha = 1
        }
    }
    
    func setAdviceLabel(_ advice: String) {
        
        viewElements.adviceLabel.text = advice
    }
}
