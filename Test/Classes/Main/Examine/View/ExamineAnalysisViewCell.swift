//
//  ExamineAnalysisViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB

class ExamineAnalysisViewCell: UITableViewCell {

    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    
    var analisis: [String: Any]? {
        
        didSet {
            
            guard let dict = analisis else {
                
                return
            }
            
            self.analysisLabel.text = dict["analysis"] as? String ?? "解析：无"
        }
    }
    
    var model: ExamineItemModel? {
        
        didSet {
            
            guard let _ = model else {
                
                return
            }
            
            self.correctLabel.text = model?.answerValue
            /*
            if model?.answer == "True" {
                
                self.correctLabel.text = "B"
            } else if model?.answer == "False" {
                
                self.correctLabel.text = "A"
            } else {
                
                self.correctLabel.text = model?.answer
            }
            */
            
        }
    }
    
    var submitModel: ExamineSubmitItemModel? {
        
        didSet {
            
            guard let model = submitModel else {
                
                return
            }
            
            if model.answer == self.model?.answerValue {
                
                self.answerTextLabel.text = "您答对了"
                self.answerLabel.text = ""
                self.answerTextLabel.textColor = UIColor.orange
            } else {
                
                self.answerTextLabel.text = "您的答案："
                self.answerLabel.text = model.answer.characters.count == 0 ? "无" : model.answer
                self.answerTextLabel.textColor = UIColor.black
            }
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
