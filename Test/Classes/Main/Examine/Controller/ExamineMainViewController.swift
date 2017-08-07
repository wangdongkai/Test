//
//  ExamineMainViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

private let identifier = "ExamineMainViewCell"

class ExamineMainViewController: UITableViewController {

    var model: UserModel?
    
    var modelArray: Array<ExamineMainModel>  = [ExamineMainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupHeader()

    }

        // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ExamineMainViewCell
        cell.selectionStyle = .none
        
        cell.model = self.modelArray[indexPath.row]
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //detailVC.model = self.modelArray[indexPath.row]
        detailVC.model = self.modelArray[indexPath.row]
        navigationController!.pushViewController(detailVC, animated: true)
    }
}
private extension ExamineMainViewController {
    
    func setup() {
        
        title = self.model?.courseName ?? "测试"
        
        self.view.backgroundColor = UIColor.white

        self.tableView.rowHeight = 72
        self.tableView.register(UINib.init(nibName: "ExamineMainViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.tableFooterView = UIView()

    }
    
    func setupHeader() {
        
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: "setupNetwork")
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放以更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        header?.beginRefreshing()
        
        
    }
    
   @objc func setupNetwork() {
        
        self.tableView.mj_header.endRefreshing()
        if self.modelArray.count != 0 {
            self.modelArray.removeAll()
   
        }
        weak var weakSelf = self
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "1", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                return
            }
            
            for dict in result {
                
                weakSelf!.modelArray.append(ExamineMainModel(dict: dict))
            }
            
            weakSelf?.tableView.reloadData()
            
        }) { (_, error: Error) in
            
            print(error)

        }
                
    }
    
    
}
