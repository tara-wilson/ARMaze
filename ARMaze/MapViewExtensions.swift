//
//  MapViewExtensions.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import SnapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MazeOverlay {
            return MazeOverlayView(overlay: overlay, overlayImage: UIImage(named: "CGmap.jpg")!)
        }
        
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.pinTintColor = UIColor.ThemeColors.mediumDarkColor
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var radius = UserDefaults.standard.integer(forKey: "radius")
        if radius == 0 {
            radius = 10
        }
        let coordinate = view.annotation!.coordinate
        
        if let userCoordinate = userLocation {
//            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < radius {
                let vc = CameraViewController()
                
                if let mapAnnotation = view.annotation as? MapAnnotation {
                    vc.target = mapAnnotation.item
                    vc.userLocation = mapView.userLocation.location!
                    selectedAnnotation = view.annotation
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
//            }
        }
    }
    
    func setAllTargets(level: Level?) {
        targets.append(ShipObject(item: .entrance))
        targets.append(ShipObject(item: .afterWalk))
        targets.append(ShipObject(item: .shipPiece1))
        targets.append(ShipObject(item: .shipPiece2))
        targets.append(ShipObject(item: .shipPiece3))
        targets.append(ShipObject(item: .shipPiece4))
        targets.append(ShipObject(item: .shipPiece5))
        targets.append(ShipObject(item: .shipPiece6))
        targets.append(ShipObject(item: .shipPiece7))
        targets.append(ShipObject(item: .shipPiece8))
        targets.append(ShipObject(item: .shipPiece9))
        targets.append(ShipObject(item: .shipPiece10))
        
        if level == .hard {
            targets.append(ShipObject(item: .extraPiece1))
            targets.append(ShipObject(item: .extraPiece2))
            targets.append(ShipObject(item: .extraPiece3))
            targets.append(ShipObject(item: .extraPiece4))
            targets.append(ShipObject(item: .extraPiece5))
            targets.append(ShipObject(item: .extraPiece6))
            targets.append(ShipObject(item: .extraPiece7))
            targets.append(ShipObject(item: .extraPiece8))
            targets.append(ShipObject(item: .extraPiece9))
            targets.append(ShipObject(item: .extraPiece10))
        }
        removeInventory()
    }
    
    func removeInventory() {
        let defaults = UserDefaults.standard
        var toRemove = [Int]()
        for (index, item) in targets.enumerated() {
            if defaults.bool(forKey: "\(item.piece.rawValue)_saved") == true {
                toRemove.insert(index, at: 0)
                inventory.append(item)
            }
        }
        for index in toRemove {
            targets.remove(at: index)
        }
        saveScore()
    }
    
    func addToInventory(index: Int) {
        let item = targets[index]
        self.targets.remove(at: index)
        inventory.append(item)
        saveCollected()
        if self.targets.count == 0 {
            alertDone()
        }
    }
    
    func alertDone() {
        
    }
    
    func saveCollected() {
        for item in inventory {
            UserDefaults.standard.set(true, forKey: "\(item.piece.rawValue)_saved")
        }
    }
    
    func saveScore() {
        let numItems = inventory.count
        let score = Score()
        score.points = numItems * 100
        score.time = self.timerInt
            
        NetworkController().sendScore(score: score, completion: {
            score in
        })
    }
}

extension MapViewController: ARControllerDelegate {
    
    func viewController(controller: CameraViewController, tappedTarget: ShipObject) {
        
        let index = self.targets.index(where: {$0.itemName == tappedTarget.itemName})
        
        addToInventory(index: index!)
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MapViewController {
    
    func saveTimer() {
        UserDefaults.standard.set(timerInt, forKey: "timer")
    }
    
    func getSavedTime() {
        let timerval = UserDefaults.standard.integer(forKey: "timer")
        self.timerInt = timerval
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedTime()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func runTimedCode() {
        timerInt = timerInt + 1
        timer.text = "\(timerInt)"
    }
    
    
}
