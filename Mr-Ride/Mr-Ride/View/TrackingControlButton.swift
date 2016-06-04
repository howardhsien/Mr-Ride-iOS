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
        
        self.addSubview(middleIcon)
        middleIcon.frame = self.bounds
        makeMiddleIconRound()
    }
    
    func makeMiddleIconSquare(){
        UIView.animateWithDuration(0.6,delay: 0.0,options: .TransitionFlipFromLeft, animations:{
            self.middleIcon.transform = CGAffineTransformMakeScale(0.4, 0.4)
            },completion: { (isFinished)in
                self.addIconCornerRadiusAnimation((self.frame.width)/2, to: 10, duration: 0.3)
        })
    }
    
    func makeMiddleIconRound(){
        UIView.animateWithDuration(0.6){
            self.middleIcon.transform = CGAffineTransformMakeScale(0.75 , 0.75)
            self.middleIcon.layer.cornerRadius = (self.frame.width)/2
        }
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

    func addIconCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.middleIcon.layer.addAnimation(animation, forKey: "cornerRadius")
        self.middleIcon.layer.cornerRadius = to
    }
    
}
