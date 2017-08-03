//
//  ExamineDetailViewCell.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import SDWebImage
import TYAttributedLabel

class ExamineDetailViewCell: UICollectionViewCell {
    
    let margin: CGFloat = 15.0
    
    var contentLabel: TYAttributedLabel?
    
    var model: ExamineItemModel? {
        didSet{
            
            guard let m = model else {
                
                return
            }
            let text = "\(m.typeString!)\(m.currentCount + 1)/\(m.totalCount).\(m.title!)\n"
            if self.contentLabel != nil {

                self.contentLabel?.removeFromSuperview()
                self.contentLabel = nil
            }
            
            self.contentLabel = TYAttributedLabel()
            self.contentLabel?.textColor = UIColor.darkGray
            
            let textStorage = TYTextStorage()
            textStorage.range = NSMakeRange(0, 4)
            textStorage.textColor = UIColor.lightGray
            self.contentLabel?.addTextStorage(textStorage)
            
            self.contentLabel?.appendText(text)
            
            let width = UIScreen.main.bounds.width - margin * 2

            if let imgs = m.imgs {
                
                let imgViewWidth = width / CGFloat(imgs.count)
                
                for num in 0..<imgs.count {
                    
                    let url = imgs[num].imgURL ?? ""
                    
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgViewWidth, height: 70))
                    imgView.contentMode = .scaleAspectFit
                    imgView.sd_setImage(with: URL(string: url))
                    self.contentLabel?.append(imgView)
                    
                }
            }
            
            self.contentLabel?.setFrameWithOrign(CGPoint(x: margin, y: 10), width: width)
            self.contentView.addSubview(self.contentLabel!)
            
        }
    }
    
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    
}

