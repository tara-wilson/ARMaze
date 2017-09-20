//
//  NameViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

let appFont = "Courier"

class NameViewController: UIViewController, UITextFieldDelegate {
    
    var questionLabel: UILabel?
    var nameTextView: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        
        questionLabel = UILabel()
        questionLabel?.textColor = UIColor.ThemeColors.mediumLightColor
        questionLabel?.text = "Before you go on your adventure, please enter your astronaut name:"
        questionLabel?.textAlignment = .center
        questionLabel?.font = UIFont(name: appFont, size: 30)
        questionLabel?.numberOfLines = 0
        view.addSubview(questionLabel!)
        questionLabel?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(50)
            make.height.equalTo(150)
        })
        
        nameTextView = UITextField()
        nameTextView?.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        nameTextView?.font = UIFont(name: appFont, size: 18)
        nameTextView?.delegate = self
        view.addSubview(nameTextView!)
        nameTextView?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo((questionLabel?.snp.bottom)!).offset(50)
            make.height.equalTo(50)
        })
        //tara need left padding here
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text {
            resignFirstResponder()
            verifyName(name: name.lowercased())
            return true
        }
        return false
    }
    
    func saveName(name: String) {
        UserDefaults.standard.set(name, forKey: "username")
    }
    
    func verifyName(name: String) {
        NetworkController().verifyName(name: name, completion: {
            success in
            if success {
                self.saveName(name: name)
                self.openLevel()
            } else {
                self.nameError()
            }
        })
    }
    
    func nameError() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        nameTextView?.text = ""

        let title = "Oops!"
        let message = "Sorry, that name is already taken by a fellow astronaut!"
        
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
    
    func openLevel() {
        let vc = LevelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
