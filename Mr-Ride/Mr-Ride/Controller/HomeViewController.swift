//
//  HomeViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import Charts
import CoreData

class HomeViewController: UIViewController {
    let classDebugInfo = "[HomeViewController]"
    

    var dataManager = DataManager.instance()
    var sortedKeys :[NSDateComponents]{ return dataManager.sortedKeys }
    var dateRideDictionary : [NSDateComponents: [RideEntity]] { return dataManager.dateRideDictionary }
    var rideEntities :[RideEntity] { return dataManager.rideEntities }

    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    
    class func controller() ->HomeViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
    
    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonStyle()
        
    }
    
    // change navigation properties between switches
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationStyle()
        dataManager.fetchFromCoreData(){
            [unowned self] in
            self.setupChartData()
            self.setupLabel()
        }
    }

    

    
    
    @IBAction func startTrackingPageAction(sender: UIButton) {
        let trackingPageNavController = storyboard?.instantiateViewControllerWithIdentifier("TrackingPageNavigationController")
        self.presentViewController(trackingPageNavController!, animated: true, completion: nil)
    }
    //MARK: setup UI
    func setupButtonStyle(){
        rideButton.layer.cornerRadius = 30
        rideButton.layer.shadowColor = UIColor.blackColor().CGColor
        rideButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        rideButton.layer.shadowOpacity = 0.25
        rideButton.layer.shadowRadius = 2.0
    }
    
    func setupNavigationStyle(){
        let bikeIconImageView = UIImageView(image:UIImage(named: "icon-bike"))
        bikeIconImageView.image = bikeIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bikeIconImageView.tintColor = .whiteColor()
        self.parentViewController?.navigationItem.titleView = bikeIconImageView
    }
    
    func setupLabel(){
        distanceLabel.text = String(format: "%.1f km",dataManager.totalDistance/1000)
        countLabel.text = String(format: "%d times",dataManager.totalCount)
        speedLabel.text = String(format: "%.1f km / h",dataManager.averageSpeed*3.6)
    }
    
    //MARK: chartView
    func setupChartData() {
        let calendar = NSCalendar.currentCalendar()
        var xArray :[String] = [] // xArray is the date
        var yArray :[Double] = [] // yArray is the distance
        var count :Int = 0
        if rideEntities.count < 10{
            count = rideEntities.count
        }
        else{
            count = 10
        }
        let entities = rideEntities
       
        for i in 0...count-1{
            if let date = entities[i].date
            {
                let components = calendar.components([.Month,.Day], fromDate: date)
                xArray.append("\(components.month)/\(components.day)")
            }
            if let distance = entities[i].distance as? Double{
                yArray.append(distance)
            }
            
        }
        xArray = xArray.reverse() //reverse the array to be diplayed on chart
        yArray = yArray.reverse()
        setChart(xArray, values: yArray)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "distance")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        lineChartView.data = chartData
        
        //fill gradient for the curve
        let gradientColors = [ UIColor.mrRobinsEggBlue0Color().CGColor, UIColor.mrWaterBlueColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.0, 0.35] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        chartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.lineWidth = 0.0
        
        
        chartDataSet.drawCirclesEnabled = false //remove the point circle
        chartDataSet.mode = .CubicBezier //make the line to be curve
        chartData.setDrawValues(false)        //remove value label on each point
        
        //make chartview not scalable and remove the interaction line
        lineChartView.setScaleEnabled(false)
        lineChartView.userInteractionEnabled = false
        
        //set display attribute
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        //display no labels
        lineChartView.xAxis.drawLabelsEnabled = false

        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        //display no gridlines
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false

        
        lineChartView.legend.enabled = false  // remove legend icon
        lineChartView.descriptionText = ""   // clear description
        

        
        
    }
    

}



