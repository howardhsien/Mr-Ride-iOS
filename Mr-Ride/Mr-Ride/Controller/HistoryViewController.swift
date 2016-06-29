//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData
import Charts
import Amplitude_iOS


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    class func controller() ->HistoryViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    let histroyCellIdentifier = "HistoryCell"
    
    
    //MARK: DataManager
    var dataManager = DataManager.instance()  //values are from dataManager
    var sortedKeys :[NSDateComponents]{ return dataManager.sortedKeys }           
    var tableDictionary : [NSDateComponents: [RideEntity]] { return dataManager.dateRideDictionary }
    
    //MARK: month chart
    let monthDictionary = [
        1 : "Jan",
        2 : "Feb",
        3 : "Mar",
        4 : "Apr",
        5 : "May",
        6 : "Jun",
        7 : "Jul",
        8 : "Aug",
        9 : "Sep",
        10: "Oct",
        11: "Nov",
        12: "Dec"
    ]
    
 
    
    //MARK: UI Setting
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTableView()
    }
    deinit{
        print(classDebugInfo+"deinit")
    }
    
    
    // change navigation properties between switches
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        Amplitude.instance().logEvent(classDebugInfo+#function)
        dataManager.fetchFromCoreData({
            self.tableView.reloadData()
        })
    }

    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: histroyCellIdentifier)
    }
    
    
    func setupNavigationBar(){
        self.parentViewController?.navigationItem.titleView = nil
        self.parentViewController?.navigationItem.title = "History"
    }
    
    func setupBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrPineGreen50().CGColor]
        gradientLayer.locations = [0.5, 1]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1 )
    }
    
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableDictionary.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entities = tableDictionary[sortedKeys[section]]
        {
            return entities.count
        }
        else{
            print(classDebugInfo+"numberOfRowsInSection return 0")
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(histroyCellIdentifier, forIndexPath: indexPath) as! HistoryViewCell
        
        guard let entities = tableDictionary[sortedKeys[indexPath.section]] else{
            print(classDebugInfo+"cellForRowAtIndexPath has problem about entities")
            return cell
        }
        let entity = entities[indexPath.row]
        let timeDisplayStr =  String(format: "%02d:%02d:%02d", entity.spentTimeHourDisplay, entity.spentTimeMinDisplay, entity.spentTimeSecDisplay)
       //NSDate component
        let calendar = NSCalendar.currentCalendar()
        if let date = entity.date{
            let components = calendar.components([.Day], fromDate: date)
            cell.setDate("\(String(components.day))th")
        }
        //distance
        if let distance_m = entity.distance{
            let distance_km :Double = Double(distance_m)/1000
            cell.setInfo(String(format:"%0.2f km \(timeDisplayStr)", distance_km))
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let entities = tableDictionary[sortedKeys[indexPath.section]] else{
            print(classDebugInfo+"didSelectRowAtIndexPath has problem about entities")
            return
        }
        let entity = entities[indexPath.row]
        let recordPageViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordPageViewController") as! RecordPageViewController
        navigationController?.pushViewController(recordPageViewController, animated: true)
        recordPageViewController.setRecordObjectID(entity.objectID)
        recordPageViewController.setFromHistoryPage()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let historyHeaderView = HistoryHeaderView.loadFromNibNamed("HistoryHeaderView",bundle: nil)
        guard let month = monthDictionary[sortedKeys[section].month] else{ return nil}
        historyHeaderView?.setMonth("\(month), \(sortedKeys[section].year)")
        return historyHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        footerView.frame = CGRectMake(0, 0, view.frame.width, 10)
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // change chart view when scroll to different months
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        setupChartData(section)
    }
    

    //MARK: chartView
    func setupChartData(section: Int) {
        let calendar = NSCalendar.currentCalendar()
        var xArray :[String] = [] // xArray is the date
        var yArray :[Double] = [] // yArray is the distance

        guard let entities = tableDictionary[sortedKeys[section]] else { print(classDebugInfo+"setupchart entities is nil"); return }
        let count = entities.count
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
        let gradientColors = [UIColor.mrBrightSkyBlue().CGColor, UIColor.mrTurquoiseBlue().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.0, 0.3] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        chartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.lineWidth = 0.0
        
    
        chartDataSet.drawCirclesEnabled = false //remove the point circle
        chartDataSet.mode = .CubicBezier  //make the line to be curve
        chartData.setDrawValues(false)        //remove value label on each point

        //make chartview not scalable and remove the interaction line
        lineChartView.setScaleEnabled(false)
        lineChartView.userInteractionEnabled = false
        
        //set display attribute
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.labelTextColor = UIColor.whiteColor()

        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false

        //ony display leftAxis gridline
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.gridColor = UIColor.whiteColor()

        
        lineChartView.legend.enabled = false  // remove legend icon
        lineChartView.descriptionText = ""   // clear description
        
        
        switch dataPoints.count {
        case 0...15:
            lineChartView.xAxis.setLabelsToSkip(0)
        case 16...30:
            lineChartView.xAxis.setLabelsToSkip(1)
        case 31...50:
            lineChartView.xAxis.setLabelsToSkip(2)
        default:
            lineChartView.xAxis.setLabelsToSkip(100)
        }
        
        
    }


}


