//
//  ExamineDetailsViewCell.swift
//  Test
//
//  Created by 王东开 on 2017/8/8.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineDetailsViewCell: UICollectionViewCell {

    @IBOutlet weak var dataTableView: UITableView!
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
        
        return self.model?.options?.count ?? 0
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
            
            
        }
    }
    
    
}
