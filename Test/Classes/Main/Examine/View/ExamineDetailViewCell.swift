//
//  ExamineDetailViewCell.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineDetailViewCell: UICollectionViewCell {

    var model: ExamineItemModel? {
        didSet{
            
            guard let m = model else {
                
                return
            }
            
            titleLabel.text = "\(m.currentCount + 1)/\(m.totalCount).\(m.title!)"
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
