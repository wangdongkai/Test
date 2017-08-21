//
//  ExamineAnalysisViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB

class ExamineAnalysisViewCell: UITableViewCell {

    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var analysisLabel: UILabel!
    
    var correct: String? {
        didSet {
            
            guard let c = correct else {
                
                return
            }
            
            if c == "True" {
                self.correctLabel.text = "A，"
            } else if c == "False" {
                self.correctLabel.text = "B，"
            } else {
                self.correctLabel.text = "\(c), "

            }
        }
    }
    
    var answer: String? {
        didSet {
            
            guard let c = answer else {
                
                return
            }
            
            let name = UserDefaults.standard.object(forKey: "username") as! String
            
            let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
            
            let sqlPath = path.appendingPathComponent("\(name).sqlite")
            let db = FMDatabase(path: sqlPath)

            if db.open() {
                
                    do {
                        
                        let sql = "SELECT * FROM t_topic where exerciseId = '\(c)'"
                        
                        let res = try db.executeQuery(sql, values: nil)
                        while res.next() {
                            
                            let ans = res.string(forColumn: "chooseAnswer")
                            
                            if let _ = ans {
                                
                                self.answerLabel.text = ans
                            } else {
                                
                                
 
                            }
                        }
                        
                    } catch {
                        
                        print(error)
                    }
                
                db.close()
            }

        }

    }
    
    var analysis: String? {
        
        didSet {
            
            guard let c = analysis else {
                
                return
            }
            
            self.analysisLabel.text = c
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
