//
//  ExamineAnalysisViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineAnalysisViewCell: UITableViewCell {

    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
