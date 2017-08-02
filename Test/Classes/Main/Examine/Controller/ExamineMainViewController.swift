//
//  ExamineMainViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import AFNetworking

private let identifier = "ExamineMainViewCell"

class ExamineMainViewController: UITableViewController {

    var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupNetwork()

    }

        // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ExamineMainViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
private extension ExamineMainViewController {
    
    func setup() {
        
        title = "模拟测试"
        self.view.backgroundColor = UIColor.white

        self.tableView.rowHeight = 72
        self.tableView.register(UINib.init(nibName: "ExamineMainViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.tableFooterView = UIView()

    }
    
    func setupNetwork() {
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "1", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            print(data)

        }) { (_, error: Error) in
            
            print(error)

        }
                
    }
}
