//
//  MapViewController.swift
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

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var level: Level?
    var targets = [ShipObject]()
    var inventory = [ShipObject]()
    var selectedAnnotation: MKAnnotation?
    var maze = Maze()
    var myPoints: UILabel!
    var timer: UILabel!
    var timerInt: Int = 0
    var gameTimer: Timer?
    var currentBackgroundDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        setUpButtons()
        setUpTargets(level: self.level)
        alertStart()
        NotificationCenter.default.addObserver(self, selector: "pauseApp", name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: "startApp", name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func pauseApp() {
        saveTimer()
        if let timer = gameTimer {
            timer.invalidate()
        }
        self.currentBackgroundDate = NSDate()
    }
    
    func startApp() {
        setUpInventory()
    }
    
    func alertStart() {
        if UserDefaults.standard.bool(forKey: "hasSeenInstructions") == false {
            UserDefaults.standard.set(true, forKey: "hasSeenInstructions")
            let dialogAppearance = PopupDialogDefaultView.appearance()
            
            dialogAppearance.backgroundColor      = UIColor.ThemeColors.darkColor
            dialogAppearance.titleFont            = UIFont(name: appFont, size: 25)!
            dialogAppearance.titleColor           = UIColor.white
            dialogAppearance.messageFont          = UIFont(name: appFont, size: 18)!
            dialogAppearance.messageColor         = UIColor.white
            
            let title = "WELCOME"
            let message = "Walk around the maze to collect the ship pieces. When you are close enough to a piece, click on the pin and it will open a viewer. When you see the ship piece in the view, tap on it to save it into your inventory."
            
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
    
    func setUpButtons() {
        myPoints = UILabel()
        myPoints.backgroundColor = UIColor.ThemeColors.mediumLightColor
        myPoints.textColor = UIColor.white
        myPoints.layer.borderWidth = 1
        myPoints.layer.borderColor = UIColor.ThemeColors.mediumDarkColor.cgColor
        myPoints.textAlignment = .center
        myPoints.text = "0"
        mapView.addSubview(myPoints)
        myPoints.snp.makeConstraints({ make in
            make.right.equalTo(view.snp.right).offset(-10)
            make.top.equalTo(view).offset(20)
            make.width.height.equalTo(50)
        })
        
        timer = UILabel()
        timer.backgroundColor = UIColor.ThemeColors.mediumLightColor
        timer.textColor = UIColor.white
        timer.layer.borderWidth = 1
        timer.layer.borderColor = UIColor.ThemeColors.mediumDarkColor.cgColor
        timer.textAlignment = .center
        timer.text = "0"
        mapView.addSubview(timer)
        timer.snp.makeConstraints({ make in
            make.left.equalTo(view).offset(10)
            make.top.equalTo(view).offset(20)
            make.width.height.equalTo(50)
        })
        
        
        let menuButton = UIButton()
        menuButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        menuButton.layer.borderWidth = 1
        menuButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        menuButton.layer.cornerRadius = 5
        menuButton.setTitle("Menu", for: .normal)
        menuButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        menuButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        menuButton.addTarget(self, action: #selector(MapViewController.openMenu), for: .touchUpInside)
        mapView.addSubview(menuButton)
        menuButton.snp.makeConstraints({ make in
            make.right.equalTo(view.snp.right).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
        
        let inventoryButton = UIButton()
        inventoryButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        inventoryButton.backgroundColor = UIColor.ThemeColors.mediumDarkColor
        inventoryButton.layer.borderWidth = 1
        inventoryButton.layer.borderColor = UIColor.ThemeColors.mediumLightColor.cgColor
        inventoryButton.setTitle("Inventory", for: .normal)
        inventoryButton.titleLabel?.font = UIFont(name: appFont, size: 18)
        inventoryButton.setTitleColor(UIColor.ThemeColors.mediumLightColor, for: .normal)
        inventoryButton.addTarget(self, action: #selector(MapViewController.openInventory), for: .touchUpInside)
        mapView.addSubview(inventoryButton)
        inventoryButton.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left).offset(10)
            make.bottom.equalTo(view).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(120)
        })
        
    }
    
    func openMenu() {
        let menu = MenuViewController()
        navigationController?.pushViewController(menu, animated: true)
    }
    
    func openInventory() {
        let vc = InventoryViewController()
        vc.inventory = inventory
        navigationController?.present(vc, animated:true)
    }
    
    func setUpMap() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let latDelta = maze.overlayTopLeftCoordinate.latitude -
            maze.overlayBottomRightCoordinate.latitude + 0.004
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake(maze.midCoordinate, span)
        
        mapView.region = region
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints({ make in
            make.edges.equalTo(view)
        })
        
    }
    
    func setUpTargets(level: Level?) {
        setAllTargets(level: level)
        
        for item in targets {
            if let location = item.location {
                let annotation = MapAnnotation(location: location.coordinate, item: item)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pauseApp()
    }
    
}
