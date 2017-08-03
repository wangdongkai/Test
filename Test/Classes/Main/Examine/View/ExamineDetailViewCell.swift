//
//  ExamineDetailViewCell.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import YYText
import SDWebImage

class ExamineDetailViewCell: UICollectionViewCell {

    var model: ExamineItemModel? {
        didSet{
            
            guard let m = model else {
                
                return
            }
            let text = "\(m.typeString!) \(m.currentCount + 1)/\(m.totalCount).\(m.title!)"

            let attrTitle = NSMutableAttributedString(string: text)
            attrTitle.yy_setColor(UIColor.purple, range: NSMakeRange(0, 4))
            attrTitle.yy_setColor(UIColor.orange, range: NSMakeRange(5, 6))
            let url = "http://res.iqtogether.com/web/res/upload/img/exercise/297ebe0e5509907a01550af81f115ff9/297ebe0e55c9e6eb0155cede59812104/9321b4a3b18a42a5ae43f4eea05a143d/9321b4a3b18a42a5ae43f4eea05a143d.png"
            let i = UIImage(named: "STAR")
            print(i!.size)
            
            let attach = NSMutableAttributedString.yy_attachmentString(withContent: i!, contentMode: .center, width: i!.size.width, ascent: 10, descent: 10)
            
            attrTitle.append(attach)
            /*
            if let imgs = m.imgs {
             
                for imgModel in imgs {
                    SDWebImageManager.shared().loadImage(with: URL(string: imgModel.imgURL ?? ""), options: [], progress: nil, completed: { (image: UIImage?, _, error: Error?, _, _, _) in
                        
                        if let img = image {
                            attrTitle.append(NSMutableAttributedString.yy_attachmentString(withContent: img, contentMode: .scaleAspectFit, width: img.size.width, ascent: 0, descent: 0))
                            
                        }
                    })
                    
                }

            }
            */
            
            titleLabel.attributedText = attrTitle
        }
    }
    
    @IBOutlet weak var titleLabel: YYLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
