//
//  InfoMapViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit
import Amplitude_iOS



class InfoMapViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: outlets
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var pickerView :UIPickerView = UIPickerView()
    var pickerContainerView = UIView()
    var blurLayer = CALayer()
    @IBOutlet weak var selectBtn: UIButton!

    //MARKL detail panel
    @IBOutlet weak var detailPanelView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    //MARK: properties
    var jsonParser = JSONParser()
    var dataManager = DataManager.instance()
    var locationManager = CLLocationManager()
    var pickerArray :[DataType] {
        var array: [DataType] = []
        for data in JSONParser.dataUrlDictionary{
            array.append(data.0)
        }
        return array
    }
    var toiletIcon = UIImage(named: "icon-toilet")   //reuse images to save memory
    var youbikeIcon = UIImage(named: "icon-station")

    
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
        showInfoType(dataType: .Toilet)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Amplitude.instance().logEvent(classDebugInfo+#function)
        setupNavigationBar()
        setupMapRegion()
        setupDetailPanel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deSetupNavigationBar()
    }
    
//    override func didReceiveMemoryWarning() {
//        mapView = nil
//    }
//    
    
    // MARK: UISetting
    private func setupRoundedCorner(){
        selectionView.layer.cornerRadius = 3
        selectionView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        detailPanelView.layer.cornerRadius = 5
        
    }
    
    private func setupNavigationBar(){
        self.parentViewController?.navigationItem.titleView = nil
        self.parentViewController?.navigationItem.title = "Map"
        addRightBarButton()
    }
    
    private func addRightBarButton(){
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.image = UIImage(named: "navigationIcon")
        rightBarButtonItem.image =  rightBarButtonItem.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        rightBarButtonItem.tintColor = UIColor.whiteColor()
        rightBarButtonItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5)
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(setupMapRegion)
        self.parentViewController?.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    private func deSetupNavigationBar(){
        self.parentViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    private func setupPickerView(){
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
        cancelButton.frame = CGRectMake(4, 4, 100, 36)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.defaultBlueColor(), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(dismissPickerView), forControlEvents: .TouchUpInside)
        headerLabel.addSubview(cancelButton)
        
        headerLabel.userInteractionEnabled = true
 
    }

    private func setupBlurLayer(){
        blurLayer.backgroundColor = UIColor.mrBlack25Color().CGColor
        blurLayer.frame = view.frame
        blurLayer.hidden = true
        view.layer.insertSublayer(blurLayer, below: pickerContainerView.layer)
    }
    
    private func setupDetailPanel(){
        detailPanelView.hidden = true
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    //MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return JSONParser.dataUrlDictionary.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectBtn.setTitle(pickerArray[row].rawValue, forState: .Normal)
        selectBtn.setTitle(pickerArray[row].rawValue, forState: .Selected)
        showInfoType(dataType: pickerArray[row])
        dismissPickerView()
    }
    
    func showInfoType(dataType type: DataType){
        jsonParser.request?.cancel()
        jsonParser.getDataWithCompletionHandler(type, completion: {[unowned self] in self.addAnnotationOnMapview(dataType: type)})
//      following comments are the version that fetch from coredata
//        dataManager.saveToiletsInfo(toiletsToSave: jsonParser.toilets)
//        dataManager.fetchToiletsFromCoreData({})
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
        locationManager.requestAlwaysAuthorization()
//        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    
    func addAnnotationOnMapview(dataType type: DataType){
        mapView.removeAnnotations(mapView.annotations)
        
        switch type {
        case .Toilet:
            for toilet in jsonParser.toilets{
                let annotation = CustomMKPointAnnotation()
                annotation.type = type
                annotation.toilet = toilet
                annotation.updateInfo()
                mapView.addAnnotation(annotation)
            }
        case .Youbike:
            for youbike in jsonParser.youbikes{
                let annotation = CustomMKPointAnnotation()
                annotation.type = type
                annotation.youbike = youbike
                annotation.updateInfo()
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    func setupMapRegion(){
        let span = MKCoordinateSpanMake(0.006, 0.006)
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate , span: span)
            
            mapView.setRegion(region, animated: true)
        }
        else{
            let location = mapView.userLocation
            let region = MKCoordinateRegion(center: location.coordinate , span: span)
            
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomMKPointAnnotation else { return nil}
        var annotationView: CustomAnnotationView?

        switch annotation.type! {
        case .Toilet:
            let reuseIdentifier = " toiletAnnotationView"  //handle reuse identifier to better manage the memory
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier){ annotationView = view as? CustomAnnotationView }
            else {
                annotationView = CustomAnnotationView(frame:CGRectMake(0, 0, 40, 40),annotation: annotation, reuseIdentifier: reuseIdentifier)
                if let icon = toiletIcon{
                    annotationView?.setCustomImage(icon)
                }
            }
            
        case .Youbike:
            let reuseIdentifier = " youbikeAnnotationView"
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier){ annotationView = view as? CustomAnnotationView }
            else {
                annotationView = CustomAnnotationView(frame:CGRectMake(0, 0, 40, 40),annotation: annotation, reuseIdentifier: reuseIdentifier)
                if let icon = youbikeIcon{
                    annotationView?.setCustomImage(icon)
                }
            }
            
        }
         annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomMKPointAnnotation {
            view.backgroundColor = UIColor.mrLightBlueColor()
            detailPanelView.hidden = false
            let annotationLocation = CLLocation( latitude:annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            if let userLocation = locationManager.location{
                let distance = annotationLocation.distanceFromLocation(userLocation)
                let distanceInTime  = distance / (12 / 3.6 * 60)  //distance in time is not accurate now
                let roundDistanceInTime = ceil(distanceInTime)
                distanceLabel.text = String(format: "%0.0f min", roundDistanceInTime)
            }
            categoryLabel.text = annotation.category
            titleLabel.text = annotation.title
            addressLabel.text = annotation.address
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        detailPanelView.hidden = true
        view.backgroundColor = UIColor.whiteColor()
    }


    
}
