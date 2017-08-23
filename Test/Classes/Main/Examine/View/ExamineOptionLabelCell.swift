//
//  ExamineOptionLabelCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/8.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import YYText
import SDWebImage

class ExamineOptionLabelCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var clickImage: UIImageView!
    
    @IBOutlet weak var imageHeightCons: NSLayoutConstraint!
    
    /*
    var model: ExamineItemModel? {
        didSet {
            
            guard let m = model else {
                
                return
            }
            let text = "\(m.typeString!)\(m.currentCount + 1)/\(m.totalCount).\(m.title!)\n"
            let attrText = NSMutableAttributedString(string: text)
            attrText.yy_setColor(UIColor.lightGray, range: NSRange.init(location: 0, length: 4))
            self.contentLabel.attributedText = attrText
            self.contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 30

            if m.imgs != nil && m.imgs!.count > 0{
                
                guard let img = m.imgs![0].imgURL else {
                    
                    return
                }
                
                self.imageHeightCons.constant = 70

            self.clickImage.sd_setImage(with: URL(string: img))
           
            } else {
                
                self.imageHeightCons.constant = 1

            }
                
        }
    }
    
 */
    
    var topicDetail: TopicDetail? {
        didSet {
            
            guard let model = topicDetail else {
                
                return
            }
            
            let text = "\(model.typeString)\(model.currentCount)/\(model.totalCount).\(model.title!)\n"
            let attrText = NSMutableAttributedString(string: text)
            attrText.yy_setColor(UIColor.lightGray, range: NSRange.init(location: 0, length: 4))
            self.contentLabel.attributedText = attrText
            self.contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 30
            
            if model.imgs.count > 0{
                
                guard let img = model.imgs.first?.imgId else {
                    
                    return
                }
                
                self.imageHeightCons.constant = 70
                
                self.clickImage.sd_setImage(with: URL(string: img))
                
            } else {
                
                self.imageHeightCons.constant = 1
                
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
}
