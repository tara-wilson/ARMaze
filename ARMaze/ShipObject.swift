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
    
    func getDAE() -> String {
        switch self {
        case .entrance:
            return "cratemodel.dae"
        case .afterWalk:
            return "radiomodel.dae"
        case .shipPiece1:
            return "ComDish.dae"
        case .shipPiece2:
            return "cratemodel.dae"
        case .shipPiece3:
            return "cratemodel.dae"
        case .shipPiece4:
            return "cratemodel.dae"
        case .shipPiece5:
            return "controllermodel.dae"
        case .shipPiece6:
            return "cratemodel.dae"
        case .shipPiece7:
            return "cratemodel.dae"
        case .shipPiece8:
            return "ComDish.dae"
        case .shipPiece9:
            return "cratemodel.dae"
        case .shipPiece10:
            return "fuelmodel.dae"
        }
    }
    
    func getFoundString() -> String {
        switch self {
        case .entrance:
            return "You found a crate full of food supplies! This will help get you through the coming journey."
        case .afterWalk:
            return "AWESOME! You found the radio! We'd never get back without this."
        case .shipPiece1:
            return "You found one of our sattelites.... unfortunately this one is too broken to use. Let's hope you find a working one somewhere."
        case .shipPiece2:
            return "You found more food supplies!"
        case .shipPiece3:
            return "You found some scrap metal and wires! That's great, we'll need that to get the ship up and running again."
        case .shipPiece4:
            return "Unfortunately, there was nothing in that crate. Keep looking!"
        case .shipPiece5:
            return "You found our ship controller! That's amazing! Now all we need is a working sattelite dish and some fuel and we can get off this planet."
        case .shipPiece6:
            return "Darn, another empty crate!"
        case .shipPiece7:
            return "You found more food supplies. Better hold on to those because we'll need them on the journey home if we ever find the rest of the ship pieces."
        case .shipPiece8:
            return "YES! You found the working sattelite dish! We're so close."
        case .shipPiece9:
            return "UGH ANOTHER EMPTY CRATE"
        case .shipPiece10:
            return "THE FUEL!!!!! YES! GREAT JOB!"
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .entrance:
            return UIImage(named: "groceries")!
        case .afterWalk:
            return UIImage(named: "radio-antenna")!
        case .shipPiece1:
            return UIImage(named: "radar")!
        case .shipPiece2:
            return UIImage(named: "groceries")!
        case .shipPiece3:
            return UIImage(named: "plug")!
        case .shipPiece4:
            return UIImage(named: "crate")!
        case .shipPiece5:
            return UIImage(named: "circuit-board")!
        case .shipPiece6:
            return UIImage(named: "crate")!
        case .shipPiece7:
            return UIImage(named: "groceries")!
        case .shipPiece8:
            return UIImage(named: "radar")!
        case .shipPiece9:
            return UIImage(named: "crate")!
        case .shipPiece10:
            return UIImage(named: "gasoline")!
        }
    }
    
    func getDAEName() -> String? {
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
        //tara take this out
        return CLLocation(latitude: 38.915253, longitude: -76.984323)
        
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

