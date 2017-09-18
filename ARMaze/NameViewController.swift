//
//  NameViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit

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
            verifyName(name: name)
            return true
        }
        return false
    }
    
    func saveName(name: String) {
        UserDefaults.standard.set(name, forKey: "username")
    }
    
    func verifyName(name: String) {
        //tara do this
        saveName(name: name)
        openLevel()
    }
    
    func openLevel() {
        let vc = LevelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
