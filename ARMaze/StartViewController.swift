//
//  ViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/16/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import UIKit


let welcomeOne = "Welcome! You are an astronaut in the year 3000, sent to explore a foreign planet."
let answerOne = "Okay... why?"

let welcomeTwo = "The human population has grown too large and we need to find a new planet. The planet you have been sent to is promising because it's shown signs of plant growth."
let answerTwo = "Awesome! Is my mission going well?"

let welcomeThree = "No. You crash landed on the planet. Your spaceship is in pieces. The only plant that grows on the planet is corn, and it's been shaped into mysterious patterns..."
let answerThree = "What?! Well what am I supposed to do?"

let welcomeFour = "Search in the corn fields and find all the pieces of your ship so that you can get back to earth!"
let answerFour = "Let's go!"

enum Level {
    case easy, hard
}

class StartViewController: UIViewController {

    var letterIndex = 0
    var stringIndex = 0
    var answerIndex = 0
    let welcomeStrings = [welcomeOne, welcomeTwo, welcomeThree, welcomeFour]
    let answers = [answerOne, answerTwo, answerThree, answerFour]
    var typingBox: UILabel?
    var currentText = ""
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        
        typingBox = UILabel()
        typingBox?.textColor = UIColor.ThemeColors.mediumLightColor
        typingBox?.textAlignment = .center
        typingBox?.font = UIFont(name: appFont, size: 20)
        typingBox?.numberOfLines = 0
        view.addSubview(typingBox!)
        typingBox?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(50)
            make.height.equalTo(200)
        })
        
        button = UIButton()
        button.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        button.layer.cornerRadius = 5
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont(name: appFont, size: 18)
        button.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints({ make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo((typingBox?.snp.bottom)!).offset(40)
            make.height.equalTo(60)
        })
        button.isHidden = true
        
        fireTimer()
    }
    
    var timer:Timer?
    func fireTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: "typeLetter", userInfo: nil, repeats: true)
    }
    
    func typeLetter() {
        let currentString = welcomeStrings[stringIndex]
        if stringIndex < welcomeStrings.count {
            if letterIndex < currentString.characters.count {
                let newind = currentString.index(currentString.startIndex, offsetBy: self.letterIndex)
                let character = currentString[newind]
                self.currentText = self.currentText + "\(character)"
                self.typingBox?.text = self.currentText
                self.letterIndex = self.letterIndex + 1
                let randomInterval = Double((arc4random_uniform(8)+1))/40
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: randomInterval, target: self, selector: "typeLetter", userInfo: nil, repeats: false)
            } else {
                showButton()
                timer?.invalidate()
            }
        }
    }
    
    func pressButton() {
        if self.answers[answerIndex] == answerFour {
            let vc = NameViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            answerIndex = answerIndex + 1
            button.isHidden = true
            letterIndex = 0
            currentText = ""
            self.typingBox?.text = ""
            fireTimer()
        }
    }
    
    func showButton() {
        if answerIndex < answers.count {
            button.setTitle(answers[answerIndex], for: .normal)
            stringIndex = stringIndex + 1
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.button.isHidden = false
            }
        }
    }
    
}


