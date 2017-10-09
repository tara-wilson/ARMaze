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
import PopupDialog

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
            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < Double(radius) {
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
    
        setUpInventory()
    }
    
    func setUpInventory() {
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
        
        var timerval = UserDefaults.standard.integer(forKey: "timer")
        let difference = self.currentBackgroundDate?.timeIntervalSince(Date())
        print("tara here")
        print(difference)
        timerval = timerval + Int((difference ?? 0)/1000)
        self.timerInt = timerval
        if inventory.count > 0 {
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        }
        saveScore()
    }
    
    func addToInventory(index: Int) {
        if gameTimer == nil {
            startApp()
        }
        let item = targets[index]
        self.targets.remove(at: index)
        inventory.append(item)
        saveCollected()
        saveScore()
        if self.targets.count == 0 {
            alertDone()
        }
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
        
        self.myPoints.text = "\(numItems * 100)"
        
        score.time = self.timerInt
            
        NetworkController().sendScore(score: score, completion: {
            score in
        })
        NetworkController().sendTime(time: timerInt)
    }
    
    func alertDone() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        let title = "YES!"
        //tara more here....
        let message = "You did it!"
        
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "OK") {
            print("Alright")
        }
        
        buttonOne.buttonColor = UIColor.ThemeColors.mediumLightColor
        buttonOne.titleColor = UIColor.ThemeColors.darkColor
        buttonOne.titleFont = UIFont(name: appFont, size: 18)!
        
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    func alertFound(item: ShipObject) {
        saveTimer()
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
        dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
        dialogAppearance.messageColor         = UIColor.white
        
        let title = "FOUND"
        let message = item.piece.getFoundString()
        
        let popup = PopupDialog(title: title, message: message)
        
        let buttonOne = CancelButton(title: "OK") {
            print("Alright")
        }
        
        buttonOne.buttonColor = UIColor.ThemeColors.mediumLightColor
        buttonOne.titleColor = UIColor.ThemeColors.darkColor
        buttonOne.titleFont = UIFont(name: appFont, size: 18)!
        
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}

extension MapViewController: ARControllerDelegate {
    
    func viewController(controller: CameraViewController, tappedTarget: ShipObject) {
        
        let index = self.targets.index(where: {$0.itemName == tappedTarget.itemName})
        let item = targets[index!]
        
        addToInventory(index: index!)
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation!)
        }
        self.dismiss(animated: true, completion: {
            self.alertFound(item: item)
        })
    }
    
    
}

extension MapViewController {
    
    func saveTimer() {
        UserDefaults.standard.set(timerInt, forKey: "timer")
        NetworkController().sendTime(time: timerInt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func runTimedCode() {
        timerInt = timerInt + 1
        timer.text = "\(timerInt)"
    }
    
    
}
