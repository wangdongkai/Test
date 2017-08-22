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
    var submitModel: ExamineSubmitItemModel = ExamineSubmitItemModel()
    
    var model: ExamineItemModel? {
        
        didSet {
            guard model != nil else {
                
                return
            }
            
            if submitModel != nil {
                
                submitModel = ExamineSubmitItemModel()
            }
            
            submitModel.exerciseId = model!.exerciseId!
            submitModel.type = model!.type
            
            self.dataTableView.reloadData()

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
                
                
            } else { // 判断
                
                
            }
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
        
        return self.model?.options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineOptionViewCell", for: indexPath) as! ExamineOptionViewCell
            /*
            let name = UserDefaults.standard.object(forKey: "username") as! String
            let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
            let sqlPath = path.appendingPathComponent("\(name).sqlite")
            let db = FMDatabase(path: sqlPath)
            
            if db.open() {
                
                do {
                    
                    let sql = "SELECT * FROM t_topic where exerciseId = '\(self.model!.exerciseId!)'"
                    
                    let res = try db.executeQuery(sql, values: nil)
                    
                    while res.next() {
                        
                        let ans = res.string(forColumn: "chooseAnswer")
                        
                        if self.model?.type == 1 {
                            
                            for option in (self.model?.options)! {
                                
                                if option.optionAnswer == ans {
                                    
                                    option.optionState = true
                                }
                            }
                            
                        } else if self.model?.type == 2 {
                            
                            
                        } else {
                            
                            
                        }
                    }
                    
                } catch {
                    
                    print(error)
                }
                
                db.close()

            }
 */
            
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
                
                if option?.optionState == true {
                    
                    if self.submitModel.answer.contains(option!.optionOrder!) == false {
                        
                        self.submitModel.answer.append(option!.optionOrder!)
                        self.model?.chooseAnswer = self.submitModel.answer
                        
                    }
                } else {
                    
                    if self.submitModel.answer.contains(option!.optionOrder!) {
                        
                        self.submitModel.answer = self.submitModel.answer.replacingOccurrences(of: option!.optionOrder!, with: "")
                        self.model?.chooseAnswer = self.submitModel.answer
                        
                    }
                    
                }
                
                tableView.reloadRows(at: [indexPath], with: .none)
           
            } else {  //单选
                
                let cell = tableView.cellForRow(at: indexPath) as! ExamineOptionViewCell
                cell.answerButton.isSelected = true
                let option = self.model!.options?[indexPath.row]
                option?.optionState = true

                self.submitModel.answer = (option?.optionOrder)!
                self.model?.chooseAnswer = (option?.optionOrder)!
                
                if self.next!.next!.next!.isKind(of: ExamineDetailViewController.self) {
                    
                    let vc = self.next?.next?.next as! ExamineDetailViewController
                    vc.index = (self.model?.currentCount)! + 1
                }

            }
           
            if self.submitModel.answer != self.model!.ans! {
                
                self.submitModel.correct = 0
                
            } else {
                
                self.submitModel.correct = 1
                
            }

        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if self.model!.type != 2 {
                
                let cell = tableView.cellForRow(at: indexPath) as! ExamineOptionViewCell
                let option = self.model!.options?[indexPath.row]
                option?.optionState = false
                cell.answerButton.isSelected = false

            }
            
        }
    }
}

