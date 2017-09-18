//
//  Maze.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/17/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import UIKit
import MapKit

class Maze {
    var name: String?
    
    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude,
                                              overlayTopRightCoordinate.longitude)
        }
    }
    
    var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate)
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate)
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate)
            
            return MKMapRectMake(
                topLeft.x,
                topLeft.y,
                fabs(topLeft.x - topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    init() {
        
        midCoordinate = CLLocationCoordinate2D(latitude: 39.066386, longitude: -76.666001)
        overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: 39.066897, longitude: -76.667487)
        overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: 39.067566, longitude: -76.666666)
        overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: 39.065256, longitude: -76.665203)
    }

}

class MazeOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(maze: Maze) {
        boundingMapRect = maze.overlayBoundingMapRect
        coordinate = maze.midCoordinate
    }
}

class MazeOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    init(overlay:MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else { return }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}
