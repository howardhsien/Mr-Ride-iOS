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
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    func showMapAnnotations(){
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    func addMapPolyline(coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int){
        let polyline = MKPolyline(coordinates: coords, count: 2)
        mapView.addOverlay(polyline)
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
