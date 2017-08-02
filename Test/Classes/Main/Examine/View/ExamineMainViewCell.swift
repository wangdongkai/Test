//
//  ExamineMainViewCell.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineMainViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    var model: ExamineMainModel? {
        didSet {
            
            guard let m = model else {
                
                return
            }
            
            titleLabel.text = m.name
            progressLabel.text = "完成：\(m.doCount)/\(m.allCount)"
            timeLabel.text = "共\(m.exerciseTime!)分钟，\(m.update!)"
            
            if m.buttonStatus == 0 { //未做未提交
                
                statusButton.layer.borderColor = UIColor.orange.cgColor
                statusButton.setTitleColor(UIColor.orange, for: .normal)
                statusButton.setTitle("未提交", for: .normal)

            } else if m.buttonStatus == 1 { // 已提交
                
                statusButton.layer.borderColor = UIColor.lightGray.cgColor
                statusButton.setTitleColor(UIColor.lightGray, for: .normal)
                statusButton.isEnabled = false
                statusButton.setTitle("已提交", for: .normal)

            } else { // 已做未提交
                
                statusButton.layer.borderColor = UIColor.blue.cgColor
                statusButton.setTitleColor(UIColor.blue, for: .normal)
                statusButton.setTitle("做题中", for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        // Initialization code
    }

    
}

private extension ExamineMainViewCell {
    
    func setupUI() {
        
        statusButton.layer.borderColor = UIColor.orange.cgColor
        statusButton.layer.borderWidth = 1.0
        statusButton.layer.masksToBounds = false
        statusButton.layer.cornerRadius = 3.0

    }
}
