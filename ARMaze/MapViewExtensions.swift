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
        let coordinate = view.annotation!.coordinate
        
        if let userCoordinate = userLocation {
            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 25 {
                let vc = CameraViewController()
                
                if let mapAnnotation = view.annotation as? MapAnnotation {
                    vc.target = mapAnnotation.item
                    vc.userLocation = mapView.userLocation.location!
                    selectedAnnotation = view.annotation
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setEasyTargets() {
        targets.append(ShipObject(item: .entrance, location: ShipObject.entranceLocation))
        targets.append(ShipObject(item: .afterWalk, location: ShipObject.afterLongWalk))
        targets.append(ShipObject(item: .shipPiece1, location: ShipObject.post1))
        targets.append(ShipObject(item: .shipPiece2, location: ShipObject.post2))
        targets.append(ShipObject(item: .shipPiece3, location: ShipObject.post3))
        targets.append(ShipObject(item: .shipPiece4, location: ShipObject.post4))
        targets.append(ShipObject(item: .shipPiece5, location: ShipObject.post5))
        targets.append(ShipObject(item: .shipPiece6, location: ShipObject.post6))
        targets.append(ShipObject(item: .shipPiece7, location: ShipObject.post7))
        targets.append(ShipObject(item: .shipPiece8, location: ShipObject.post8))
        targets.append(ShipObject(item: .shipPiece9, location: ShipObject.post9))
        targets.append(ShipObject(item: .shipPiece10, location: ShipObject.post10))
        removeInventory()
    }
    
    func removeInventory() {
        
    }
    
    func addToInventory(index: Int) {
        let item = targets[index]
        self.targets.remove(at: index)
        inventory.append(item)
        saveCollected()
    }
    
    func saveCollected() {
        
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
