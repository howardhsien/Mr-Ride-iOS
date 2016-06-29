//
//  FBShareButton.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/27.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class FBShareButtonView: UIView {

    @IBOutlet weak var fbImageView: UIImageView!

    class func button()-> UIButton?{
        
        let buttonView = UINib(nibName: "FBShareButton", bundle: nil).instantiateWithOwner(nil, options: nil).first as? FBShareButtonView
        let button = UIButton()
        button.addSubview(buttonView!)
        buttonView?.autoPinEdgesToSuperviewEdges()
        buttonView?.backgroundColor = UIColor.clearColor()
        button.layer.borderColor = UIColor.whiteColor().CGColor
        if let imageView = buttonView?.fbImageView{
            imageView.image =  imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            imageView.tintColor = UIColor.fbBlueColor()
            imageView.layer.cornerRadius = 6.0
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = UIColor.whiteColor()
        }
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.userInteractionEnabled = false
        return button
    }
    

}
