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
            
            self.answerButton.setTitle(m.optionOrder, for: .normal)
            self.answerButton.setTitle(m.optionOrder, for: .selected)
            
            self.answerLabel.text = m.content
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButton()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

private extension ExamineOptionViewCell {
    
    func setupButton() {
        
        self.answerButton.layer.cornerRadius = self.answerButton.frame.width / 2.0
        self.answerButton.layer.borderColor = UIColor.lightGray.cgColor
        self.answerButton.layer.borderWidth = 1.0
        self.answerButton.layer.masksToBounds = false
        
    }
}
