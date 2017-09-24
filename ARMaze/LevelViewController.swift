//
//  LevelViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//


import Foundation
import UIKit
import PopupDialog

class LevelViewController: UIViewController {
    
    var questionLabel: UILabel?
    var easy: UIButton?
    var hard: UIButton?
    var level: Level?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        
        let buttonWidth = (view.frame.width - 80)/2
        
        questionLabel = UILabel()
        questionLabel?.textColor = UIColor.ThemeColors.mediumLightColor
        questionLabel?.text = "Select a level:"
        questionLabel?.textAlignment = .center
        questionLabel?.font = UIFont(name: appFont, size: 35)
        questionLabel?.numberOfLines = 0
        view.addSubview(questionLabel!)
        questionLabel?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(50)
            make.height.equalTo(100)
        })
        
        easy = UIButton()
        easy?.setTitle("Easy", for: .normal)
        easy?.tag = 0
        easy?.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        easy?.titleLabel?.font = UIFont(name: appFont, size: 18)
        easy?.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        easy?.addTarget(self, action: #selector(LevelViewController.didSelectButton(button:)), for: .touchUpInside)
        view.addSubview(easy!)
        easy?.snp.makeConstraints({ make in
            make.left.equalTo(view).offset(20)
            make.top.equalTo((questionLabel?.snp.bottom)!).offset(40)
            make.height.width.equalTo(buttonWidth)
        })
        
        hard = UIButton()
        hard?.setTitle("Hard", for: .normal)
        hard?.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        hard?.tag = 1
        hard?.titleLabel?.font = UIFont(name: appFont, size: 18)
        hard?.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        hard?.addTarget(self, action: #selector(LevelViewController.didSelectButton(button:)), for: .touchUpInside)
        view.addSubview(hard!)
        hard?.snp.makeConstraints({ make in
            make.left.equalTo((easy?.snp.right)!).offset(20)
            make.top.equalTo((questionLabel?.snp.bottom)!).offset(40)
            make.height.width.equalTo(buttonWidth)
        })
        
    }
    
    func didSelectButton(button: UIButton) {
        self.level = .easy
        switch button.tag {
        case 1:
            alertNoHard()
        default:
            print("nothing")
        }
        saveLevel(level: self.level!)
        openGame()
    }
    
    func alertNoHard() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        let title = "Oh no!"
        let message = "The hard level isn't ready yet. Come back next week!"
        
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "OK") {
            print("Alright")
        }
        
        buttonOne.buttonColor = UIColor.ThemeColors.mediumLightColor
        buttonOne.titleColor = UIColor.ThemeColors.darkColor
        buttonOne.titleFont = UIFont(name: appFont, size: 18)!
        
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    func saveLevel(level: Level) {
        switch level {
        case .easy:
            UserDefaults.standard.set("easy", forKey: "level")
        case .hard:
            UserDefaults.standard.set("hard", forKey: "level")
        default:
            print("")
        }
        
    }
    
    func openGame() {
        if let level = level {
            let map = MapViewController()
            map.level = level
            navigationController?.pushViewController(map, animated: true)
        }
    }
    
}
