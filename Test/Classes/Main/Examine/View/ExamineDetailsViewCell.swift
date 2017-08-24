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
        
        self.dataTableView.register(UINib.init(nibName: "ExamineOptionViewCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionViewCell")
        self.dataTableView.register(UINib.init(nibName: "ExamineOptionLabelCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionLabelCell")
        
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 44.0
        self.dataTableView.separatorStyle = .none
        self.dataTableView.tableFooterView = UIView()
        
    }
    
   
}

extension ExamineDetailsViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }
        
        return self.model?.options!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
           
            if self.submitModel!.answer != self.model!.ans! {
                
                self.submitModel!.correct = 0
                
            } else {
                
                self.submitModel!.correct = 1
                
            }

        }
 
        
    }
    
    
}

