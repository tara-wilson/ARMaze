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
    var scores: [String: Score]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        setUpUI()
        getLeaders()
    }
    
    func getLeaders() {
        NetworkController().getLeaderBoard(completion: {
            leaderdict in
            self.sortLeaderDict(leaderdict: leaderdict)
        })
    }
    
    func sortLeaderDict(leaderdict: [String: Score]?) {
        if let leaderdict = leaderdict {
            self.scores = leaderdict
            self.tableView.reloadData()
        }
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
            make.left.equalTo(view.snp.left).offset(20)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
        
        let refreshButton = UIButton()
        refreshButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        refreshButton.layer.cornerRadius = 5
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        refreshButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        refreshButton.addTarget(self, action: #selector(LeaderBoardViewController.refresh), for: .touchUpInside)
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints({ make in
            make.right.equalTo(view.snp.right).offset(-20)
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
            make.top.equalTo(view).offset(70)
            make.height.equalTo(60)
        })
        
        self.tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.ThemeColors.darkColor
        tableView.register(LeaderBoardCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints({
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view).offset(150)
        })
    }
    
    func refresh() {
        self.getLeaders()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LeaderBoardCell {
            if let scores = self.scores as? NSDictionary {
                if let keys = scores.allKeys as? [String] {
                    let score = scores[keys[indexPath.row]] as! Score
                    cell.addScore(newname: keys[indexPath.row], newscore: score, index: indexPath.row)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
}

class LeaderBoardCell: UITableViewCell {
    
    var name: UILabel?
    var score: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.ThemeColors.darkColor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        name = UILabel()
        name?.textColor = UIColor.ThemeColors.mediumLightColor
        name?.font = UIFont(name: appFont, size: 18)
        contentView.addSubview(name!)
        name?.snp.makeConstraints({make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        })
        
        score = UILabel()
        score?.textColor = UIColor.ThemeColors.mediumLightColor
        score?.font = UIFont(name: appFont, size: 18)
        score?.textAlignment = .right
        contentView.addSubview(score!)
        score?.snp.makeConstraints({make in
            make.right.equalTo(contentView.snp.right).offset(20)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        })

    }
    
    func addScore(newname: String, newscore: Score, index: Int) {
        name?.text = "\(index + 1). \(newname)"
        score?.text = "\(newscore.points!): \(newscore.time ?? 0)"
    }
}
