//
//  CameraViewController.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import AVFoundation
import CoreLocation

protocol ARControllerDelegate {
    func viewController(controller: CameraViewController, tappedTarget: ShipObject)
}

class CameraViewController: UIViewController {
    
    var delegate: ARControllerDelegate?
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var target: ShipObject!
    var rightIndicator: UILabel!
    var leftIndicator: UILabel!
    var sceneView: SCNView!
    var locationManager = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
        setUpUI()
        self.cameraSession?.startRunning()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingHeading()
        sceneView.scene = scene
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        setupTarget()
    }
    
    func setUpUI() {
        sceneView = SCNView()
        sceneView.backgroundColor = .clear
        view.addSubview(sceneView)
        sceneView.snp.makeConstraints({
            make in
            make.edges.equalTo(view)
        })
        
        leftIndicator = UILabel()
        leftIndicator.backgroundColor = UIColor.gray
        view.addSubview(leftIndicator)
        leftIndicator.snp.makeConstraints({
            make in
            make.left.equalTo(view).offset(10)
            make.centerY.equalTo(view.snp.centerY)
            make.height.width.equalTo(50)
        })
        
        rightIndicator = UILabel()
        rightIndicator.backgroundColor = UIColor.gray
        view.addSubview(rightIndicator)
        rightIndicator.snp.makeConstraints({
            make in
            make.right.equalTo(view).offset(-10)
            make.centerY.equalTo(view.snp.centerY)
            make.height.width.equalTo(50)
        })
    }
    
    func setupTarget() {
        let scene = SCNScene(named: target.piece.getDAE())
        
        let enemy = scene?.rootNode.childNode(withName: target.piece.getDAEName(), recursively: true)
        enemy?.position = SCNVector3(x: 0, y: 0, z: 0)

        let node = SCNNode()
        node.addChildNode(enemy!)
        node.name = "enemy"
        self.target.itemNode = node
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResult = sceneView.hitTest(location, options: nil)
        

        if hitResult.first != nil {
            target.itemNode?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5), SCNAction.removeFromParentNode(), SCNAction.hide()]))
            self.delegate?.viewController(controller: self, tappedTarget: self.target)
        }
    }
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
        var error: NSError?
        var captureSession: AVCaptureSession?
        let backVideoDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        if backVideoDevice != nil {
            var videoInput: AVCaptureDeviceInput!
            do {
                videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
            } catch let error1 as NSError {
                error = error1
                videoInput = nil
            }
            if error == nil {
                captureSession = AVCaptureSession()
                if captureSession!.canAddInput(videoInput) {
                    captureSession!.addInput(videoInput)
                } else {
                    error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
                }
            } else {
                error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
            }
        } else {
            error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
        }
        return (session: captureSession, error: error)
    }
    
    func loadCamera() {
        let captureSessionResult = createCaptureSession()
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
            print("Error creating capture session.")
            return
        }
        
        self.cameraSession = session
        
        if let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession) {
            cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            cameraLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(cameraLayer, at: 0)
            self.cameraLayer = cameraLayer
        }
    }
    
    
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = fmod(newHeading.trueHeading, 360.0)
        repositionTarget()
    }
    
    func repositionTarget() {
        let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: target.location)
        
        let delta = heading - self.heading
        
        if delta < -15.0 {
            leftIndicator.isHidden = false
            rightIndicator.isHidden = true
        } else if delta > 15 {
            leftIndicator.isHidden = true
            rightIndicator.isHidden = false
        } else {
            leftIndicator.isHidden = true
            rightIndicator.isHidden = true
        }
        
        let distance = userLocation.distance(from: target.location)
        if let node = target.itemNode {
            if node.parent == nil {
                node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
                scene.rootNode.addChildNode(node)
            } else {
                //6
                node.removeAllActions()
                node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
            }
        }
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return (radians) * (180.0 / M_PI)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return (degrees) * (M_PI / 180.0)
    }
    
    func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
        let fLat = degreesToRadians(from.coordinate.latitude)
        let fLng = degreesToRadians(from.coordinate.longitude)
        let tLat = degreesToRadians(to.coordinate.latitude)
        let tLng = degreesToRadians(to.coordinate.longitude)
        let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        if degree >= 0 {
            return degree
        } else {
            return degree + 360
        }
    }

}
