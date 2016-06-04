//
//  HistoryViewController.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let classDebugInfo = "[HistoryViewController]"
    
    class func controller() ->HistoryViewController{
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var rideEntities : [RideEntity] = []
    var tableDictionary : [NSDateComponents: [RideEntity]] = [:]
    
    var sortedKeys : [NSDateComponents]{  return Array(tableDictionary.keys).sort{$0.month > $1.month} ?? [] }
    
    @IBOutlet weak var tableView: UITableView!
    let histroyCellIdentifier = "HistoryCell"
    
    
    //MARK: UI Setting
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTableView()
        
        
    }

    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: histroyCellIdentifier)
    }
    
    // change navigation properties between switches
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        fetchFromCoreDate({
            self.tableDictionary = self.categorizeByFunc(self.rideEntities)
            self.tableView.reloadData()})
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
    //MARK: Catergorize by month
    func categorizeByFunc(rideEntities: [RideEntity]) ->[NSDateComponents: [RideEntity]] {
        let calendar = NSCalendar.currentCalendar()
        
        var myDictionary = [NSDateComponents: [RideEntity]]()
        
        for rideEntity in rideEntities{
            if let date = rideEntity.date{
                let components = calendar.components([.Month,.Year], fromDate: date)
                if myDictionary[components] != nil{
                    myDictionary[components]!.append(rideEntity)
                }
                else{
                    myDictionary[components] = [rideEntity]
                }
    
            }
        }
        return myDictionary
        
        
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
        if let distance_m = entity.distance{
            let distance_km :Double = Double(distance_m)/1000
            cell.setInfo(String(format:"%0.2f km \(timeDisplayStr)", distance_km))
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let historyHeaderView = HistoryHeaderView.loadFromNibNamed("HistoryHeaderView",bundle: nil)

        historyHeaderView?.setMonth("\(sortedKeys[section].month),\(sortedKeys[section].year)")
        return historyHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }



}

//MARK: FetchedResultsControllerDelegate
extension HistoryViewController :  NSFetchedResultsControllerDelegate{
    
    
    func fetchFromCoreDate(completion:()->()){
        let fetchRequest = NSFetchRequest(entityName: "RideEntity")
        let sortDesriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDesriptor]
        
        if let managedObjectContext = managedObjectContext{
            let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let rideEntities = fetchResultController.fetchedObjects as? [RideEntity]
                {
                    self.rideEntities = rideEntities
                }
            }
            catch{
                print(error)
            }
            completion()

        }
    }
    
}
