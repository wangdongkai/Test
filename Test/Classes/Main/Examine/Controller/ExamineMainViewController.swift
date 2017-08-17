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
import FMDB

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
        
        let model = self.modelArray[indexPath.row]
        
        if model.buttonStatus == 1 { //已提交
           
            let vc = ExamineAnaysisViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            vc.model = self.modelArray[indexPath.row]

            
            
            navigationController!.pushViewController(vc, animated: true)

            
        } else {
            
            let detailVC = ExamineDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
            
            if self.modelArray.count == 0 {
                return
            }
            
            detailVC.model = self.modelArray[indexPath.row]
            navigationController!.pushViewController(detailVC, animated: true)
        }
        
        
        
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
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ExamineMainViewController.setupNetwork))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放以更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        header?.beginRefreshing()
        
    }
    
    
    func setupDataBase() {
        
        
    }
}

private extension ExamineMainViewController {
    
    @objc func setupNetwork() {
        
        if self.modelArray.count != 0 {
            self.modelArray.removeAll()
            
        }
        weak var weakSelf = self
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "1", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                return
            }
            
            // 插入数据
            let name = UserDefaults.standard.object(forKey: "username") as! String
            
            let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
            
            let sqlPath = path.appendingPathComponent("\(name).sqlite")
            let queue = FMDatabaseQueue.init(path: sqlPath)
            
            
            for dict in result {
                
                weakSelf!.modelArray.append(ExamineMainModel(dict: dict))
                queue.inDatabase({ (db: FMDatabase) in
                    
                   
                    for key in dict.keys {
                        
                        do {
                            let value = dict[key]!
                            print("\(key) = \(value)")
                            try db.executeUpdate("INSERT INTO t_test (\(key)) VALUES(?)", values: [value])
                        } catch {
                            
                            print("failed: \(error.localizedDescription)")
                        }

                    }

                    db.close()
                                        
                })
            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_header.endRefreshing()
            
        }) { (_, error: Error) in
            
            weakSelf?.tableView.mj_header.endRefreshing()
            
            print(error)
            
        }
        
    }

}
