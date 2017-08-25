//
//  ExamineDetailsViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/8.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB

class ExamineDetailsViewCell: UICollectionViewCell {

    @IBOutlet weak var dataTableView: UITableView!
    var hasSubmit: Bool = false
    
    var submitModel: ExamineSubmitItemModel? {
        didSet {
            
            guard let _ = submitModel else {
                
                return
            }
            
            submitModel!.exerciseId = model!.exerciseId!
            submitModel!.type = model!.type
            
            if model?.type == 1 { // 单选
                
                for option in (model?.options)! {
                    
                    option.optionState = option.optionAnswer == submitModel!.answer ? true : false
                }
            } else if model?.type == 2 { //多选
                
                let answers = submitModel!.answer.components(separatedBy: ",")
                
                for option in (model?.options)! {
                    
                    if answers.contains(option.optionAnswer!) {
                        
                        option.optionState = true
                    }
                }
                
                
            } else { // 判断
                
                if submitModel!.answer == "False" {
                    
                    self.model?.options?[0].optionState = true
                    self.model?.options?[1].optionState = false
                } else if self.submitModel!.answer == "True" {
                    self.model?.options?[1].optionState = true
                    self.model?.options?[0].optionState = false
                }
            }


        }
    }
    
    var model: ExamineItemModel? {
        
        didSet {
            guard model != nil else {
                
                return
            }
           
            self.dataTableView.reloadData()

        }
    }
    
       override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }

}

private extension ExamineDetailsViewCell {
    
    func setupUI() {
        
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 44.0
        self.dataTableView.separatorStyle = .none

        self.dataTableView.register(UINib.init(nibName: "ExamineOptionLabelCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionLabelCell")
        self.dataTableView.register(UINib.init(nibName: "ExamineOptionViewCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionViewCell")
        self.dataTableView.register(UINib.init(nibName: "ExamineAnalysisViewCell", bundle: nil), forCellReuseIdentifier: "ExamineAnalysisViewCell")
        self.dataTableView.register(UINib.init(nibName: "ExamineStatisticsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineStatisticsViewCell")
        self.dataTableView.register(UINib.init(nibName: "ExamineCommentsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineCommentsViewCell")

            
    }
    
   
}

extension ExamineDetailsViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if hasSubmit {
            
            return 4
        } else {
            
            return 2
        }
        
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
        } else if section == 4 {
            
            return "评论"
        } else {
            
            return ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        if hasSubmit {
            
            if section == 0 || section == 2 || section == 3 {
                
                return 1
            } else if section == 1 {
                
                return self.model?.options?.count ?? 0
            } else {
                
                return 10
            }

            
        } else {
            
            if section == 0 {
                
                return 1
            }
            
            return self.model?.options!.count ?? 0

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if hasSubmit {
            
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
                
                cell.analisis = self.model?.analisisResult
                cell.model = self.model
                cell.submitModel = self.submitModel
                
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

        } else {
            
            if indexPath.section == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionViewCell", for: indexPath) as! ExamineOptionViewCell
                
                cell.model = self.model?.options?[indexPath.row]
                return cell

            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionLabelCell", for: indexPath) as! ExamineOptionLabelCell
                
                cell.model = self.model
                
                return cell

            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if hasSubmit {
            
            return
        }
        
        if indexPath.section == 1 {
            
            if self.model!.type == 2 { //多选
                
                let option = self.model!.options?[indexPath.row]
                option?.optionState = !option!.optionState
                tableView.reloadRows(at: [indexPath], with: .none)
                
                self.submitModel?.answer = ""

                for index in 0..<self.model!.options!.count {
                    
                    let option = self.model!.options![index]
                    
                    if option.optionState == true {
                        
                        if self.submitModel!.answer.characters.count > 0 &&  self.submitModel!.answer.characters.count < self.model!.options!.count + 3{
                            
                            self.submitModel!.answer.append(",\(option.optionAnswer!)")
                        } else {
                            
                            self.submitModel!.answer.append(option.optionAnswer!)
                        }
                        
                    }
                }
               
            } else {  //单选
                
               
                for index in 0..<self.model!.options!.count {
                    
                    if index == indexPath.row {
                        
                        self.model!.options![index].optionState = true
                        self.submitModel!.answer = self.model!.options![index].optionAnswer!
                    } else {
                        
                        self.model!.options![index].optionState = false
                    }

                }

                tableView.reloadData()
                               
                if self.next!.next!.next!.isKind(of: ExamineDetailViewController.self) {
                    
                    let vc = self.next?.next?.next as! ExamineDetailViewController
                    vc.scrollCollection(index: (self.model?.currentCount)! + 1)
                }

            }
           
            if self.submitModel!.answer != self.model!.answer! {
                
                self.submitModel!.correct = 0
                
            } else {
                
                self.submitModel!.correct = 1
                
            }

        }
 
        
    }
    
    
}

