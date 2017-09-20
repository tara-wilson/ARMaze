//
//  UIColor+Theme.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation

//
//  UIColor+theme.swift
//  BookAppPlatform
//
//  Created by Tara Wilson on 8/28/17.
//  Copyright © 2017 perfpr. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    struct ThemeColors {
        static let darkColor = UIColor(netHex: 0x4D4250)
        static let mediumDarkColor = UIColor(netHex: 0xB66E6F)
        static let mediumLightColor = UIColor(netHex: 0xE6A972)
        static let lightColor = UIColor(netHex: 0xF6D169)
    }
}
