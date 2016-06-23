//
//  JSONParser.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

enum DataType: String {
    case Toilet
    case Youbike
}
//MARK: struct declared
struct Toilet {
    var category: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

struct Youbike {
    var category: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var bikeLeft:Int
}

class JSONParser {
    var classDebugInfo : String { return "[\(self.dynamicType)]" }
    var toilets :[Toilet] = []
    var youbikes :[Youbike] = []
    //TODO: need to make plist do better job (not allow everything)
    
    //MARK: return the dataUrl array
    static let dataUrlDictionary :[DataType : [String]] = [
        .Toilet : ["http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2",
                "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f"],
        .Youbike : ["http://data.taipei/youbike"]
    ]
    
    func getDataWithCompletionHandler(dataType: DataType, completion:()->Void) {
        guard let urlArray = JSONParser.dataUrlDictionary[dataType] else{ return }
        for index in 0 ..< urlArray.count{
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ){
                Alamofire.request(.GET, urlArray[index]).responseJSON{
                    [unowned self] response in
                    guard response.result.isSuccess else{
                        print("\(self.classDebugInfo)result is not success")
                        return
                    }
                    if let data = response.result.value {
                        switch dataType{
                        case .Toilet:
                            self.clearToilets()
                            if index == 0 { self.parseToiletTaipeiCity(data) }   //only parsing json now
                            else if index == 1 { self.parseToiletTaipeiRiverSide(data) }
                        case .Youbike:
                            self.clearYoubikes()
                            self.parseYoubike(data)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        completion()
                    }
                }
            }
        }
    }
    
    //MARK: Parsing Method
    func parseToiletTaipeiCity(data: AnyObject){
        
        guard let result = data["result"] as?[String:AnyObject] else { print(classDebugInfo+#function+":result failed") ; return }
        guard let results = result["results"] as? [[String:AnyObject]] else { print(classDebugInfo+#function+":results failed") ; return }
        for toiletResult in results {
            guard let category = toiletResult["類別"] else{ print(classDebugInfo+#function + ":get toiletResult category failed") ; return }
            guard let name = toiletResult["單位名稱"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            guard let address = toiletResult["地址"]  else{ print(classDebugInfo+#function + ":get toiletResult address failed") ; return }
            guard let longitude_str = toiletResult["經度"]  else{ print(classDebugInfo+#function + ":get toiletResult longitude failed") ; return }
            guard let latitude_str = toiletResult["緯度"]  else{ print(classDebugInfo+#function + ":get toiletResult latitude failed") ; return }
            
            guard let longitude = Double(String(longitude_str)) else { print(classDebugInfo+#function + ":make longitude double failed") ; return  }
            guard let latitude = Double(String(latitude_str)) else { print(classDebugInfo+#function + ":make latitude double failed") ; return  }
            
            toilets.append(Toilet(category:String(category),
                name: String(name),
                address: String(address),
                latitude: latitude,
                longitude:longitude))
            
        }
    }
    
    func parseToiletTaipeiRiverSide(data: AnyObject){
        
        guard let result = data["result"] as?[String:AnyObject] else { print(classDebugInfo+#function+":result failed") ; return }
        guard let results = result["results"] as? [[String:AnyObject]] else { print(classDebugInfo+#function+":results failed") ; return }
        for toiletResult in results {
            guard let category = toiletResult["Type"] else{ print(classDebugInfo+#function + ":get toiletResult category failed") ; return }
            guard let name = toiletResult["Location"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            guard let longitude_str = toiletResult["Longitude"]  else{ print(classDebugInfo+#function + ":get toiletResult longitude failed") ; return }
            guard let latitude_str = toiletResult["Latitude"]  else{ print(classDebugInfo+#function + ":get toiletResult latitude failed") ; return }
            
            guard let longitude = Double(String(longitude_str)) else { print(classDebugInfo+#function + ":make longitude double failed") ; return  }
            guard let latitude = Double(String(latitude_str)) else { print(classDebugInfo+#function + ":make latitude double failed") ; return  }
            
            toilets.append(Toilet(category:String(category),
                name: String(name),
                address: "",
                latitude: latitude,
                longitude:longitude))
            
        }
    }

    
    
    func parseYoubike(data: AnyObject) {
        guard let results = data["retVal"] as?[String:[String:AnyObject]] else { print(classDebugInfo+#function+":retVal failed") ; return }
        for youbikeResult in results {
            guard let category = youbikeResult.1["sarea"] else{ print(classDebugInfo+#function + ":get youbikeResult category failed") ; return }
            guard let name = youbikeResult.1["sna"]  else{ print(classDebugInfo+#function + ":get youbikeResult name failed") ; return }
            guard let address = youbikeResult.1["ar"]  else{ print(classDebugInfo+#function + ":get youbikeResult address failed") ; return }
            guard let longitude_str = youbikeResult.1["lng"]  else{ print(classDebugInfo+#function + ":get youbikeResult longitude failed") ; return }
            guard let latitude_str = youbikeResult.1["lat"]  else{ print(classDebugInfo+#function + ":get youbikeResult latitude failed") ; return }
            guard let bikeLeft_str = youbikeResult.1["sbi"] else{ print(classDebugInfo+#function + ":get youbikeResult bikeLeft failed") ; return }
            
            guard let longitude = Double(String(longitude_str)) else { print(classDebugInfo+#function + ":make longitude double failed") ; return  }
            guard let latitude = Double(String(latitude_str)) else { print(classDebugInfo+#function + ":make latitude double failed") ; return  }
            guard let bikeLeft = Int(String(bikeLeft_str)) else { print(classDebugInfo+#function + ":make bikeLeft Int failed") ; return  }
            
            youbikes.append(Youbike(category:String(category),
                name: String(name),
                address: String(address),
                latitude: latitude,
                longitude:longitude,
                bikeLeft: bikeLeft))
            
        }
    }
    
    //MARK: clear Array
    func clearToilets(){
        toilets.removeAll()
    }
    
    func clearYoubikes(){
        youbikes.removeAll()
    }
    
    //MARK: save in core data
    func saveToilets(){
        
    }
    
    
}