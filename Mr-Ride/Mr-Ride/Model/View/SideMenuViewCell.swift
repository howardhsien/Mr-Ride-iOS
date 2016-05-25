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
    }
    
    func setPageLabelText(labelName: String){
        pageLabel.text = labelName
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
