//
//  MenuViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    var leaderBoard: UIButton!
    var seeMap: UIButton!
    var resetButton: UIButton!
    var seeIntroButton: UIButton!
    var nameLabel: UILabel!
    var levelLabel: UILabel!
    
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
        
        levelLabel = UILabel()
        levelLabel?.textColor = UIColor.ThemeColors.mediumLightColor
        levelLabel?.text = getLevel()
        levelLabel?.textAlignment = .center
        levelLabel?.font = UIFont(name: appFont, size: 18)
        view.addSubview(levelLabel!)
        levelLabel?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(50)
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
        
    }
    
    func reset() {
        
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
