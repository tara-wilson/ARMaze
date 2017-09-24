//
//  LeaderBoardViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit

class LeaderBoardViewController: UIViewController {
    
    var titleLabel: UILabel?
    var tableView: UITableView!
    var scores: [String: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        setUpTable()
        getLeaders()
        //tara do refresh
    }
    
    func getLeaders() {
        
    }
    
    func setUpUI() {
        let backButton = UIButton()
        backButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        backButton.layer.cornerRadius = 5
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        backButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        backButton.addTarget(self, action: #selector(LeaderBoardViewController.close), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })

        titleLabel = UILabel()
        titleLabel?.textColor = UIColor.ThemeColors.mediumLightColor
        titleLabel?.text = "LEADERBOARD"
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: appFont, size: 30)
        view.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(50)
            make.height.equalTo(60)
        })
    }
    
    func setUpTable() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.ThemeColors.darkColor
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        view.snp.makeConstraints({ make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view).offset(80)
        })
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LeaderBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
