//
//  CustomAnnotationView.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/20.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    var customImageView = UIImageView()
    
    func setCustomImage(image: UIImage){
        customImageView.image = image
    }
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
//        super.init(annotation: MKAnnotation?, reuseIdentifier: String?)
//    }
    
   init(frame: CGRect, annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = frame
        customImageView.frame = CGRectMake(0, 0, frame.width/2, frame.height/2)
        customImageView.center = self.center
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = frame.width/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mrPinkishGreyColor().CGColor
        

        self.layer.shadowPath = UIBezierPath(roundedRect: frame, cornerRadius: frame.width/2).CGPath
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.addSubview(customImageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
