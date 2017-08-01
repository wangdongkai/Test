//
//  ExamineMainViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineMainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        

    }

        // MARK: - Table view data source

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamineMainViewCell", for: indexPath) as! ExamineMainViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    

    
}
private extension ExamineMainViewController {
    
    func setup() {
        
        title = "模拟测试"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWith(image: "back", target: self, action: #selector(backClick))

        self.tableView.rowHeight = 72
        self.tableView.register(UINib.init(nibName: "ExamineMainViewCell", bundle: nil), forCellReuseIdentifier: "ExamineMainViewCell")
        self.tableView.tableFooterView = UIView()

        
    }
}
private extension ExamineMainViewController {
    
    @objc func backClick() {
        
        self.navigationController?.popViewController(animated: true)
        
    }

}
