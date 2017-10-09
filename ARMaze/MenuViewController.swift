//
//  MenuViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

class MenuViewController: UIViewController {
    
    var leaderBoard: UIButton!
    var seeMap: UIButton!
    var resetButton: UIButton!
    var seeIntroButton: UIButton!
    var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        
        let backButton = UIButton()
        backButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        backButton.layer.cornerRadius = 5
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        backButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        backButton.addTarget(self, action: #selector(MenuViewController.close), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
        
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.ThemeColors.mediumLightColor
        nameLabel?.text = getName()
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: appFont, size: 30)
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(30)
            make.height.equalTo(30)
        })
        
        leaderBoard = UIButton()
        leaderBoard.setTitle("Leaderboard", for: .normal)
        leaderBoard.titleLabel?.font = UIFont(name: appFont, size: 25)
        leaderBoard.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        leaderBoard.addTarget(self, action: #selector(MenuViewController.seeLeaderBoard), for: .touchUpInside)
        view.addSubview(leaderBoard)
        leaderBoard.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(view).offset(view.frame.width/3 + 100)
            make.height.equalTo(50)
        })
        
        seeMap = UIButton()
        seeMap.setTitle("Maze Map", for: .normal)
        seeMap.titleLabel?.font = UIFont(name: appFont, size: 25)
        seeMap.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        seeMap.addTarget(self, action: #selector(MenuViewController.imageMap), for: .touchUpInside)
        view.addSubview(seeMap)
        seeMap.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(leaderBoard.snp.bottom).offset(20)
            make.height.equalTo(50)
        })
        
        resetButton = UIButton()
        resetButton.setTitle("Reset Game", for: .normal)
        resetButton.titleLabel?.font = UIFont(name: appFont, size: 25)
        resetButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        resetButton.addTarget(self, action: #selector(MenuViewController.reset), for: .touchUpInside)
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(seeMap.snp.bottom).offset(20)
            make.height.equalTo(50)
        })
        
        let help = UIButton()
        help.setTitle("Help", for: .normal)
        help.titleLabel?.font = UIFont(name: appFont, size: 25)
        help.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        help.addTarget(self, action: #selector(MenuViewController.help), for: .touchUpInside)
        view.addSubview(help)
        help.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(resetButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        })
        
    }
    
    func getName() -> String {
        return UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    func getLevel() -> String {
        return UserDefaults.standard.string(forKey: "level") ?? "easy"
    }
    
    func seeLeaderBoard() {
        let leader = LeaderBoardViewController()
        present(leader, animated: true, completion: nil)
    }
    
    func imageMap() {
        let map = ImageMapViewController()
        present(map, animated: true, completion: nil)
    }
    
    func help() {
        UserDefaults.standard.set(true, forKey: "hasSeenInstructions")
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        let title = "WELCOME"
        let message = "Walk around the maze to collect the ship pieces. When you are close enough to a piece, click on the pin and it will open a viewer. When you see the ship piece in the view, tap on it to save it into your inventory."
        
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
    
    func areYouSure() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        let title = "Are you sure?"
        let message = "Do you really want to reset your game? All progress will be lost."
        
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "Yes, reset.") {
            self.yesReset()
        }
        let buttonTwo = CancelButton(title: "Never mind, don't reset.", action: {
            
        })
        
        buttonOne.buttonColor = UIColor.ThemeColors.mediumLightColor
        buttonOne.titleColor = UIColor.ThemeColors.darkColor
        buttonOne.titleFont = UIFont(name: appFont, size: 18)!
        
        buttonTwo.buttonColor = UIColor.ThemeColors.mediumLightColor
        buttonTwo.titleColor = UIColor.ThemeColors.darkColor
        buttonTwo.titleFont = UIFont(name: appFont, size: 18)!
        
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    func yesReset() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let nav = UINavigationController(rootViewController: StartViewController())
        nav.isNavigationBarHidden = true
        present(nav, animated: true, completion: nil)
    }
    
    func reset() {
        areYouSure()
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
