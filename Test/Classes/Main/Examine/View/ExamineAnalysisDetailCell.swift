//
//  ExamineAnalysisDetailCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineAnalysisDetailCell: UITableViewCell {

    @IBOutlet weak var listTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    
}


extension ExamineAnalysisDetailCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        } else if section == 1 {
            
            return 5
        } else if section == 2 {
            
            return 1
        } else if section == 3 {
            
            return 1
        } else {
            
            return 3
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    
}

private extension ExamineAnalysisDetailCell {
    
    func setup() {
        
        self.listTableView.rowHeight = UITableViewAutomaticDimension
        self.listTableView.estimatedRowHeight = 44.0
        self.listTableView.separatorStyle = .none
        self.listTableView.tableFooterView = UIView()

        self.listTableView.register(UINib.init(nibName: "ExamineOptionLabelCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionLabelCell")
        self.listTableView.register(UINib.init(nibName: "ExamineOptionViewCell", bundle: nil), forCellReuseIdentifier: "ExamineOptionViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineAnalysisViewCell", bundle: nil), forCellReuseIdentifier: "ExamineAnalysisViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineStatisticsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineStatisticsViewCell")
        self.listTableView.register(UINib.init(nibName: "ExamineCommentsViewCell", bundle: nil), forCellReuseIdentifier: "ExamineCommentsViewCell")

    }
}
