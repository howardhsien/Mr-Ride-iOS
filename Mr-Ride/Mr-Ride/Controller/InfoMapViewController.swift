//
//  InfoMapViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class InfoMapViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    //MARK: outlets
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var pickerView :UIPickerView = UIPickerView()
    var pickerContainerView = UIView()
    var blurLayer = CALayer()
    @IBOutlet weak var selectBtn: UIButton!

    //MARK: properties
    var jsonParser = JSONParser()
    var locationManager = CLLocationManager()
    var pickerArray :[String] {
        var array: [String] = []
        for data in JSONParser.dataUrl{
            array.append(data.0.rawValue)
        }
        return array
    }
    
    class func controller() ->InfoMapViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InfoMapViewController") as! InfoMapViewController
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoundedCorner()
        setupPickerView()
        setupBlurLayer()
        setupMapAndLocationManager()
        jsonParser.getDataWithCompletionHandler(DataType.Toilet, completion: {[unowned self] in self.addAnnotationOnMapview()})
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupMapRegion()
    }
    
    
    // MARK: UISetting
    func setupRoundedCorner(){
        selectionView.layer.cornerRadius = 3
        selectionView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        
    }
    
    func setupNavigationBar(){
        self.parentViewController?.navigationItem.titleView = nil
        self.parentViewController?.navigationItem.title = "Map"
    }
    
    func setupPickerView(){
        pickerContainerView.frame = CGRectMake(0, view.frame.height - 250, view.frame.width, 250)
        pickerContainerView.backgroundColor = .whiteColor()
        pickerContainerView.hidden = true
        view.addSubview(pickerContainerView)
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.frame = CGRectMake(0, 0, view.frame.width, 250)
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerContainerView.addSubview(pickerView)
        
        
        let headerLabel = UILabel()
        headerLabel.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        headerLabel.frame = CGRectMake(0, 0, pickerView.bounds.width, 44)
        headerLabel.textAlignment = .Center
        headerLabel.text = "Look for"
        pickerContainerView.addSubview(headerLabel)
        
        let cancelButton = UIButton()
        let defaultBlueColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        cancelButton.frame = CGRectMake(4, 4, 100, 36)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(defaultBlueColor, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(dismissPickerView), forControlEvents: .TouchUpInside)
        headerLabel.addSubview(cancelButton)
        
        headerLabel.userInteractionEnabled = true
 
    }

    func setupBlurLayer(){
        blurLayer.backgroundColor = UIColor.mrBlack25Color().CGColor
        blurLayer.frame = view.frame
        blurLayer.hidden = true
        view.layer.insertSublayer(blurLayer, below: pickerContainerView.layer)
        
    }
    
    
    //MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return JSONParser.dataUrl.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectBtn.setTitle(pickerArray[row], forState: .Normal)
        selectBtn.setTitle(pickerArray[row], forState: .Selected)
        dismissPickerView()
    }

    func showPickerView() {
        pickerContainerView.hidden = false
        blurLayer.hidden = false
    }
    
    func dismissPickerView() {
        pickerContainerView.hidden = true
        blurLayer.hidden = true
    }
    
    @IBAction func presentPickerViewAction(sender: AnyObject) {
        showPickerView()
    }

}

//MARK: MKMapViewDelegate and CLLocationManagerDelegate
extension InfoMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupMapAndLocationManager(){
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setupMapRegion()
    }
    
    func addAnnotationOnMapview(){
        for toilet in jsonParser.toilets{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: toilet.latitude, longitude: toilet.longitude)
            annotation.coordinate = coordinate
            annotation.title = toilet.name
            annotation.subtitle = toilet.address
            mapView.addAnnotation(annotation)
        }
    }
    
    func setupMapRegion(){
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: (locationManager.location?.coordinate)! , span: span)
        mapView.setRegion(region, animated: true)
        
    }

    
}
