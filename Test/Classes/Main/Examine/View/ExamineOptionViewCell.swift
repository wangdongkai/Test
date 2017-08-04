//
//  ExamineOptionViewCell.swift
//  Test
//
//  Created by wangdongkai on 17/8/4.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineOptionViewCell: UITableViewCell {

    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    
    var model: ExamineOptionModel? {
        
        didSet {
            
            guard let m = model else {
                
                return
            }
            
            self.answerButton.setTitle(m.optionAnswer, for: .normal)
            self.answerButton.setTitle(m.optionAnswer, for: .selected)
            
            self.answerLabel.text = m.optionContent
            
            self.answerButton.isSelected = m.optionState
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButton()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    
}

private extension ExamineOptionViewCell {
    
    func setupButton() {
        
        self.answerButton.setTitleColor(UIColor.white, for: .selected)
        self.answerButton.setTitleColor(UIColor.colorWithHex(color: "bfbfbf", alpha: 1.0), for: .normal)
        
        self.answerButton.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        self.answerButton.setBackgroundImage(UIImage(named: "circle_select"), for: .selected)

        self.model?.optionState = self.answerButton.isSelected
    }
    
    
}
