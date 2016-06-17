//
//  JSONParser.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/16.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Alamofire

enum DataType: String {
    case Toilet
    case Youbike
}
struct Toilet {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

class JSONParser {
    var classDebugInfo : String { return "[\(self.dynamicType)]" }
    var toilets :[Toilet] = []
    //TODO: need to make plist do better job (not allow everything)
    static let dataUrl :[DataType : String] = [
        .Toilet : "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2",
        .Youbike : "http://"
    ]
    
    func getDataWithCompletionHandler(dataType: DataType, completion:()->Void) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ){
            guard let url = JSONParser.dataUrl[dataType] else{ return }
            Alamofire.request(
                .GET,
                url
                ).responseJSON{
                    [unowned self] response in
                    guard response.result.isSuccess else{
                        print("\(self.classDebugInfo)result is not success")
                        return
                    }
                    if let data = response.result.value {
                       self.parseToilet(data)   //only parsing json now
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        completion()
                        
                    }
            }
        }
    }
    
    func parseToilet(data: AnyObject){
        guard let result = data["result"] as?[String:AnyObject] else { print(classDebugInfo+#function+":result failed") ; return }
        guard let results = result["results"] as? [[String:AnyObject]] else { print(classDebugInfo+#function+":results failed") ; return }
        for toiletResult in results {
            guard let name = toiletResult["單位名稱"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            guard let address = toiletResult["地址"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            guard let longitude = toiletResult["經度"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            guard let latitude = toiletResult["緯度"]  else{ print(classDebugInfo+#function + ":get toiletResult name failed") ; return }
            toilets.append(Toilet(name: String(name), address: String(address), latitude: Double(String(latitude))!, longitude: Double(String(longitude))!))
            
        }
    }
    
    
    
}