//
//  ImageMapViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/18/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit

class ImageMapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeColors.darkColor
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CGmap.jpg")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints({
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view).offset(80)
            make.bottom.equalTo(view).offset(-20)
        })
        
        let backButton = UIButton()
        backButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        backButton.layer.cornerRadius = 5
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        backButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        backButton.addTarget(self, action: #selector(ImageMapViewController.close), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.top.equalTo(view).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
