//
//  InventoryViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit

class InventoryViewController: UIViewController {
    
    var inventory: [ShipObject]?
    var collectionView: UICollectionView!
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        setUpBack()
        setUpTitle()
        setUpCollectionView()
    }
    
    func setUpTitle() {
        
    }
    
    func setUpBack() {
        let backButton = UIButton()
        backButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        backButton.layer.cornerRadius = 5
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        backButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        backButton.addTarget(self, action: #selector(InventoryViewController.close), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.ThemeColors.darkColor
        collectionView.register(InventoryCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ make in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.top.equalTo(view).offset(80)
        })
    }
}

extension InventoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? InventoryCollectionCell {
            cell.piece = inventory?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width/2 - 5
        let height = view.frame.height/3
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventory?.count ?? 0
    }
    
}

class InventoryCollectionCell: UICollectionViewCell {
    
    var cover: UIImageView?
    var title: UILabel?
    var piece: ShipObject? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.ThemeColors.lightColor
        setUpUI()
    }
    
    func setUpUI() {
        cover = UIImageView()
        cover?.translatesAutoresizingMaskIntoConstraints = false
        cover?.contentMode = .scaleAspectFit
        guard let cover = cover else { return }
        contentView.addSubview(cover)
        contentView.addConstraints([
            NSLayoutConstraint(item: cover, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: cover, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -15),
            NSLayoutConstraint(item: cover, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: cover, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -80)
            ])
        
        title = UILabel()
        title?.translatesAutoresizingMaskIntoConstraints = false
        title?.numberOfLines = 2
        guard let title = title else { return }
        contentView.addSubview(title)
        contentView.addConstraints([
            NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -15),
            NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: cover, attribute: .bottom, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -15)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
