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

                /*

                weak var weakSelf = self
                SDWebImageManager.shared().loadImage(with: URL(string: img), options: SDWebImageOptions.cacheMemoryOnly, progress: nil, completed: { (image: UIImage?, _, error: Error?, _, _, _) in
                    
                    //weakSelf!.clickButton.setImage(image, for: .normal)
                    //weakSelf!.clickButton.setBackgroundImage(image, for: .normal)
                    
                })
                                
                self.contentView.layoutIfNeeded()
                
            } else {
                
                self.buttonHeightConstraint.constant = 1
                self.clickButton.setImage(nil, for: .normal)
                
                self.contentView.layoutIfNeeded()

            }
 
              */
                
            self.clickImage.sd_setImage(with: URL(string: img))
           
            } else {
                
                self.imageHeightCons.constant = 1

            }
                
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    
}
