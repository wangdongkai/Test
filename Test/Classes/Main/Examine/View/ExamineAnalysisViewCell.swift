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
    
    var correct: String? {
        didSet {
            
            guard let c = correct else {
                
                return
            }
            
            self.correctLabel.text = "\(c), "
        }
    }
    
    var answer: String? {
        didSet {
            
            guard let c = answer else {
                
                return
            }
            
            self.answerLabel.text = c
        }

    }
    
    var analysis: String? {
        
        didSet {
            
            guard let c = analysis else {
                
                return
            }
            
            self.analysisLabel.text = c
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
