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
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    class func button()-> UIButton?{
        
        let buttonView = UINib(nibName: "FBShareButton", bundle: nil).instantiateWithOwner(nil, options: nil).first as? FBShareButtonView
        let button = UIButton()
        button.addSubview(buttonView!)
        buttonView?.autoPinEdgesToSuperviewEdges()
        buttonView?.backgroundColor = UIColor.clearColor()
//        buttonView?.backgroundColor = UIColor(red: 109/255, green: 132/255, blue: 180/255, alpha: 1.0)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        if let imageView = buttonView?.fbImageView{
            imageView.image =  imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            imageView.tintColor = UIColor.fbBlueColor()
            imageView.layer.cornerRadius = 6.0
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = UIColor.whiteColor()
            print("test")
        }
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        button.userInteractionEnabled = false
        return button
    }
    

}
