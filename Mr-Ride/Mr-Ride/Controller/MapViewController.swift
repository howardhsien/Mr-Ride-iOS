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
    
    func showUserLocation(coordinate: CLLocationCoordinate2D){
        let span = MKCoordinateSpanMake(0.005, 0.005)
        
        let region = MKCoordinateRegion(center: coordinate , span: span)
        
        mapView.setRegion(region, animated: true)
        

    }
    
    //TODO: show map poly line sometimes not correct
    func addMapPolyline(coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int){
        let polyline = MKPolyline(coordinates: coords, count: count)
//        regionBoundingRect = polyline.boundingMapRect
        mapView.addOverlay(polyline)

        
    }
    
    func setMapRect(coordinates coords: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int){
        let polyline = MKPolyline(coordinates: coords, count: count)
        regionBoundingRect = polyline.boundingMapRect
    }

    
    func showMapPolyline() {
        if regionBoundingRect != nil{
            let edgeInset = UIEdgeInsetsMake(150, 150, 150, 150)
            mapView.setVisibleMapRect(regionBoundingRect!,edgePadding: edgeInset ,animated: true)
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
    
    func overlayBoundingMapRect(coords coords: [CLLocationCoordinate2D])-> MKMapRect {
        
        var leftMostLongitude:CLLocationDegrees = 180
        var rightMostLongitude:CLLocationDegrees = -180
        var topMostLatitude:CLLocationDegrees = -90
        var bottomMostLatitude:CLLocationDegrees = 90

        for coord in coords{
            if coord.longitude < leftMostLongitude{ leftMostLongitude = coord.longitude}
            if coord.longitude > rightMostLongitude{ rightMostLongitude = coord.longitude}
            if coord.latitude > topMostLatitude { topMostLatitude = coord.latitude }
            if coord.latitude < bottomMostLatitude { bottomMostLatitude = coord.latitude}
            
        }
        
        let overlayTopLeftCoordinate = CLLocationCoordinate2D(latitude: topMostLatitude, longitude: leftMostLongitude)
        let overlayTopRightCoordinate = CLLocationCoordinate2D(latitude: topMostLatitude, longitude: rightMostLongitude)
        let overlayBottomLeftCoordinate = CLLocationCoordinate2D(latitude: bottomMostLatitude, longitude: leftMostLongitude)

        
        let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate)
        let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate)
        let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate)
        print(classDebugInfo+" topleft:\(topLeft) topRight:\(topRight) bottomLeft:\(bottomLeft)"    )
        return MKMapRectMake(topLeft.x,
                             topLeft.y,
                             fabs(topLeft.x-topRight.x),
                             fabs(topLeft.y - bottomLeft.y))
    }
    
    
}
