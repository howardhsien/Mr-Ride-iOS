//
//  HistoryViewCell.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/6/2.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDate(date: String){
        dateLabel.text = date
    }
    func setInfo(info: String){
        infoLabel.text = info
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
