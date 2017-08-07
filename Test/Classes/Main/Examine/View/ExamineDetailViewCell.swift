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
    
    var dataTableView: UITableView?
    fileprivate var data: [ExamineOptionModel] = [ExamineOptionModel]()
    
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
            
            self.dataTableView?.frame = CGRect(x: margin, y: self.contentLabel!.frame.maxY + margin, width: width, height: UIScreen.main.bounds.height - self.contentLabel!.frame.maxY)
            self.dataTableView?.tableFooterView = UIView()
            
            self.data = m.options!
            self.dataTableView?.reloadData()
            
        }
    }
    
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dataTableView = UITableView()
        self.dataTableView?.rowHeight = 40
        self.dataTableView?.register(UINib.init(nibName: "ExamineOptionViewCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionViewCell")
        
        self.dataTableView?.dataSource = self
        self.dataTableView?.delegate = self
        
        self.contentView.addSubview(self.dataTableView!)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExamineDetailViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionViewCell", for: indexPath) as! ExamineOptionViewCell
        cell.answerButton.tag = indexPath.row
        cell.model = self.data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExamineOptionViewCell
        
        if model?.type == 2 {
            
           // cell.answerButton.isSelected = !cell.answerButton.isSelected
            cell.model!.optionState = !cell.model!.optionState
            
        } else {
            
           // cell.answerButton.isSelected = !cell.answerButton.isSelected
            cell.model!.optionState = !cell.model!.optionState
            
        }
        
                tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExamineOptionViewCell

        if model?.type != 2 {
            
           // cell.answerButton.isSelected = !cell.answerButton.isSelected
            cell.model!.optionState = !cell.model!.optionState

        }
        tableView.reloadRows(at: [indexPath], with: .automatic)

        
    }
}

