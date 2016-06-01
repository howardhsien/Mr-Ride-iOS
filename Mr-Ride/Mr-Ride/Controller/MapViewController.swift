//
//  MapViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/31.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let classDebugInfo = "[MapViewController]"
    
    @IBOutlet weak var mapView: MKMapView!
    var regionBoundingRect :MKMapRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewStyle()
        setupMap()
        
    }
    
    func setupMapViewStyle() {
        view.backgroundColor = UIColor.clearColor()
        mapView.layer.cornerRadius = 10
    }
    
    func setupMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func invalidateUserLocation(){
        mapView.showsUserLocation = false
    }
    
    func showMapAnnotations(){
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    func addMapPolyline(coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int){
        let polyline = MKPolyline(coordinates: coords, count: count)
        regionBoundingRect = polyline.boundingMapRect
        mapView.addOverlay(polyline)
    }
    
    func showMapPolyline() {
        print(classDebugInfo+"showMapPolyline start")
        if regionBoundingRect != nil{
            mapView.setVisibleMapRect(regionBoundingRect!, animated: true)
        }
        else{
            print(classDebugInfo+"showMapPolyline failed")
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return polylineRenderer
        
    }
}
