//
//  HistoryHeaderView.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/3.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class HistoryHeaderView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerRadius(3)
        
        print("HistoryHeaderView awake")
    }
    
    
    func setupCornerRadius(radius: CGFloat){
        self.containerView.layer.cornerRadius = radius
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    
    func setMonth(month: String){
        monthLabel.text = month
    }

}

extension HistoryHeaderView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> HistoryHeaderView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? HistoryHeaderView
    }
}
