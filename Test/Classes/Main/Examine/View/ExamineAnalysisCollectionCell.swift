//
//  ExamineAnalysisCollectionCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineAnalysisCollectionCell: UICollectionViewCell {

    @IBOutlet weak var listTableView: UITableView!
    
    var model: ExamineItemModel? {
        
        didSet {
            guard model != nil else {
                
                return
            }
            
            self.listTableView.reloadData()
            
        }
    }

    var answer: ExamineAnswerModel? {
        didSet {
            
            guard let _ = answer else {
                
                return
            }
            
            let a = answer!.answer
            
            if model?.type == 1 { // 单选
                
                for option in (model?.options)! {
                    
                    option.optionState = option.optionAnswer == a ? true : false
                }
            } else if model?.type == 2 { //多选
                
                let answerArray = a?.components(separatedBy: ",")
                
                for option in (model?.options)! {
                    
                    for ans in answerArray! {
                        
                        option.optionState = option.optionAnswer == ans ? true : false
                    }
                }
            } else { // 判断
                
                if a == "False" {
                    
                    model?.options?[1].optionState = true
                } else {
                    model?.options?[0].optionState = true

                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        
        // Initialization code
    }

}

extension ExamineAnalysisCollectionCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return CGFloat.leastNormalMagnitude
        } else if section == 1 {
            
            return CGFloat.leastNormalMagnitude
        } else {
            
            return 30
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            
            return "解析"
        } else if section == 3 {
            
            return "统计"
        } else {
            
            return "评论"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 2 || section == 3 {
            
            return 1
        } else if section == 1 {
            
            return self.model?.options?.count ?? 0
        } else {
            
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionLabelCell", for: indexPath) as! ExamineOptionLabelCell
            cell.model = self.model
            
            return cell

        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionViewCell", for: indexPath) as! ExamineOptionViewCell
            cell.model = self.model?.options?[indexPath.row]
            return cell

        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineAnalysisViewCell", for: indexPath) as! ExamineAnalysisViewCell
            
            
                        
            return cell

        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineStatisticsViewCell", for: indexPath) as! ExamineStatisticsViewCell
            
            if let dict = self.model?.analisisResult {
                cell.person = "个人统计：作答本题\(dict["submitNumber"]!)次，做错\(dict["submitErrorNumber"]!)次，正确率为\(dict["accuracy"]!)%"
                
                cell.all = "全站统计：作答本题\(dict["submitAllNumber"]!)次，正确率为\(dict["allAccuracy"]!)%"

            }
            
            return cell

        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineCommentsViewCell", for: indexPath) as! ExamineCommentsViewCell
            
            return cell

        }

        
    
    }
    
    
}

private extension ExamineAnalysisCollectionCell {
    
    func setup() {
        
        self.listTableView.rowHeight = UITableViewAutomaticDimension
        self.listTableView.estimatedRowHeight = 44.0
        self.listTableView.separatorStyle = .none
        
        self.listTableView.register(UINib.init(nibName: "ExamineOptionLabelCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionLabelCell")
        self.listTableView.register(UINib.init(nibName: "ExamineOptionViewCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineAnalysisViewCell", bundle: nil), forCellReuseIdentifier: "ExamineAnalysisViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineStatisticsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineStatisticsViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineCommentsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineCommentsViewCell")
        
       
    }
}
