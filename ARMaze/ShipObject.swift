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
    var location: CLLocation!
    var itemNode: SCNNode?
    var piece: ShipPiece!
    
    static let entranceLocation = CLLocation(latitude: 39.0672251908, longitude: -76.6670604330)
    static let afterLongWalk = CLLocation(latitude: 39.0666991, longitude: -76.666252333)
//    static let post1 = CLLocation(latitude: 39.066451247, longitude: -76.666230205)
//    static let post2 = CLLocation(latitude: 39.06634773, longitude: -76.665851092)
    static let post1 = CLLocation(latitude: 39.0037430, longitude: -76.8080190)
    static let post2 = CLLocation(latitude: 39.003744, longitude: -76.8080199)
    
    static let post3 = CLLocation(latitude: 39.06643917, longitude: -76.665740786)
    static let post4 = CLLocation(latitude: 39.06654449, longitude: -76.665859222)
    static let post5 = CLLocation(latitude: 39.066895446, longitude: -76.665850421)
    static let post6 = CLLocation(latitude: 39.0666649312, longitude: -76.6656137)
    static let post7 = CLLocation(latitude: 39.06625649, longitude: -76.66523653)
    static let post8 = CLLocation(latitude: 39.06601304192, longitude: -76.664822716)
    static let post9 = CLLocation(latitude: 39.0656958707, longitude: -76.66492589)
    static let post10 = CLLocation(latitude: 39.06569524, longitude: -76.66556208)
    
    init(item: ShipPiece, location: CLLocation) {
        super.init()
        self.piece = item
        self.itemName = item.rawValue
        self.location = location
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
        return "ComDish.dae"
    }
    
    func getDAEName() -> String {
        return "DishBASE"
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
