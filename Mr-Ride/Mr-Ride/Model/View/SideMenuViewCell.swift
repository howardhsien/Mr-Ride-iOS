//
//  SideMenuViewCell.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/25.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class SideMenuViewCell: UITableViewCell {
    let classDebugInfo = "[SideMenuViewCell]"
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var prefixView: UIView!
    @IBOutlet weak var roundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
    }
    
    func setupCellStyle(){
        pageLabel.textColor = UIColor.mrWhite50Color()
        prefixView.backgroundColor = UIColor.clearColor()
        roundView.layer.cornerRadius = roundView.frame.width/2
        roundView.hidden = true
    }
    
    func setPageLabelText(labelName: String){
        pageLabel.text = labelName
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected{
            pageLabel.textColor = UIColor.whiteColor()
            roundView.hidden = false
        }
        else{
            pageLabel.textColor = UIColor.mrWhite50Color()
            roundView.hidden = true
        }
    }
}
