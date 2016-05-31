//
//  TrackingControlButton.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/31.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit
import PureLayout

@IBDesignable
class TrackingControlButton: UIButton {
    var middleIcon = UIView()
    let insetValue:CGFloat = 15.0
    let insetValueRound : CGFloat = 7.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(middleIcon)
        setupMiddleIcon()
        cornerRadius = self.frame.width/2
    }
 
    func setupMiddleIcon() {
        middleIcon.userInteractionEnabled = false
        middleIcon.backgroundColor = UIColor.redColor()
        makeMiddleIconRound()
    }
    
    func makeMiddleIconSquare(){
        middleIcon.removeFromSuperview()
        self.addSubview(middleIcon)
        middleIcon.layer.cornerRadius = 5
        middleIcon.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: insetValue,left: insetValue,bottom: insetValue,right: insetValue))

    }
    
    func makeMiddleIconRound(){
        middleIcon.removeFromSuperview()
        self.addSubview(middleIcon)
        middleIcon.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: insetValueRound,left: insetValueRound,bottom: insetValueRound,right: insetValueRound))
        middleIcon.layer.cornerRadius = (self.frame.width-2*insetValueRound)/2
    }

    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius

        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

}
