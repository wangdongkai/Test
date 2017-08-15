//
//  ExamineStatisticsViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineStatisticsViewCell: UITableViewCell {

    @IBOutlet weak var personStatisticsLabel: UILabel!
    @IBOutlet weak var allStatisticsLabel: UILabel!
    
    var person: String? {
        didSet {
            
            guard let p = person else {
                
                return
            }
            
            self.personStatisticsLabel.text = p
        }
    }
    
    var all: String? {
        didSet {
            
            guard let p = all else {
                
                return
            }
            
            self.allStatisticsLabel.text = p
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
