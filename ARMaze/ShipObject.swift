//
//  ShipObject.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SceneKit

class ShipObject: NSObject {
    
    var itemName: String!
    var location: CLLocation?
    var itemNode: SCNNode?
    var piece: ShipPiece!
    
    init(item: ShipPiece) {
        super.init()
        self.piece = item
        self.itemName = item.rawValue
        self.location = item.getLocation()
    }
    
}

enum ShipPiece: String {
    case entrance = "Entrance"
    case afterWalk = "AfterWalk"
    case shipPiece1 = "ShipPiece1"
    case shipPiece2 = "ShipPiece2"
    case shipPiece3 = "ShipPiece3"
    case shipPiece4 = "ShipPiece4"
    case shipPiece5 = "ShipPiece5"
    case shipPiece6 = "ShipPiece6"
    case shipPiece7 = "ShipPiece7"
    case shipPiece8 = "ShipPiece8"
    case shipPiece9 = "ShipPiece9"
    case shipPiece10 = "ShipPiece10"
    
    case extraPiece1 = "ExtraPiece1"
    case extraPiece2 = "ExtraPiece2"
    case extraPiece3 = "ExtraPiece3"
    case extraPiece4 = "ExtraPiece4"
    case extraPiece5 = "ExtraPiece5"
    case extraPiece6 = "ExtraPiece6"
    case extraPiece7 = "ExtraPiece7"
    case extraPiece8 = "ExtraPiece8"
    case extraPiece9 = "ExtraPiece9"
    case extraPiece10 = "ExtraPiece10"
    
    func getDAE() -> String {
        return "model.dae"
//        return "nissan-front-wheel.dae"
        
        switch self {
        case .entrance:
            return ""
        case .afterWalk:
            return ""
        case .shipPiece1:
            return "ComDish.dae"
        case .shipPiece2:
            return "screw.dae"
        case .shipPiece3:
            return ""
        case .shipPiece4:
            return ""
        case .shipPiece5:
            return ""
        case .shipPiece6:
            return ""
        case .shipPiece7:
            return ""
        case .shipPiece8:
            return "ComDish.dae"
        default:
            return ""
        }
    }
    
    func getFoundString() -> String {
        return ""
    }
    
    func getImage() -> UIImage {
        return UIImage(named: "radar")!
    }
    
    func getDAEName() -> String? {
        return nil
        switch self {
        case .shipPiece1:
            return "DishDEAD"
        case .shipPiece8:
            return "DishBASE"
        default:
            return nil
        }
    }
    
    func getLocation() -> CLLocation? {
        return CLLocation(latitude: 39.003744, longitude: -76.8080199)
        
        let raw = self.rawValue
        let lat = UserDefaults.standard.float(forKey: "\(raw)_lat")
        let long = UserDefaults.standard.float(forKey: "\(raw)_long")
        if lat != 0 && long != 0 {
            return CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        }
        switch self {
        case .entrance:
            return CLLocation(latitude: 39.0672251908, longitude: -76.6670604330)
        case .afterWalk:
            return CLLocation(latitude: 39.0666991, longitude: -76.666252333)
        case .shipPiece1:
            return CLLocation(latitude: 39.066451247, longitude: -76.666230205)
        case .shipPiece2:
            return CLLocation(latitude: 39.06634773, longitude: -76.665851092)
        case .shipPiece3:
            return CLLocation(latitude: 39.06643917, longitude: -76.665740786)
        case .shipPiece4:
            return CLLocation(latitude: 39.06654449, longitude: -76.665859222)
        case .shipPiece5:
            return CLLocation(latitude: 39.066895446, longitude: -76.665850421)
        case .shipPiece6:
            return CLLocation(latitude: 39.0666649312, longitude: -76.6656137)
        case .shipPiece7:
            return CLLocation(latitude: 39.06625649, longitude: -76.66523653)
        case .shipPiece8:
            return CLLocation(latitude: 39.06601304192, longitude: -76.664822716)
        case .shipPiece9:
            return CLLocation(latitude: 39.0656958707, longitude: -76.66492589)
        case .shipPiece10:
            return CLLocation(latitude: 39.06569524, longitude: -76.66556208)
        default:
            return nil
        }
    }
}

class MapAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let item: ShipObject

    init(location: CLLocationCoordinate2D, item: ShipObject) {
        self.coordinate = location
        self.item = item
        self.title = item.itemName
        
        super.init()
    }
}

//    static let post1 = CLLocation(latitude: 39.0037430, longitude: -76.8080190)
//    static let post2 = CLLocation(latitude: 39.003744, longitude: -76.8080199)

