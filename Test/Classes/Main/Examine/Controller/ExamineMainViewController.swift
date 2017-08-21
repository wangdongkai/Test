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
    
    fileprivate var page: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupHeader()

        setupFooter()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.mj_header.beginRefreshing()
        
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
        
    }
    
    
    func setupFooter() {
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ExamineMainViewController.setupMoreData))
        footer?.setTitle("点击加载更多", for: .idle)
        footer?.setTitle("加载更多中...", for: .refreshing)
        footer?.setTitle("无更多数据", for: .noMoreData)
        
        self.tableView.mj_footer = footer
        
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
            
            
            for dict in result {
                
                let item = ExamineMainModel.mj_object(withKeyValues: dict)
                
                weakSelf!.modelArray.append(item!)
                print(dict["groupId"]!)
                /*
                UserDefaults.standard.set(dict["classAccuracy"] as! String, forKey: "\(dict["groupId"]!)classAccuracy")
                UserDefaults.standard.set(dict["classRank"] as! String, forKey: "\(dict["groupId"]!)classRank")

                let time = UserDefaults.standard.integer(forKey: dict["groupId"] as! String)
                if time == 0 {
                    
                    UserDefaults.standard.set(item?.exerciseTimer , forKey: dict["groupId"] as! String)
                    UserDefaults.standard.synchronize()
                    
                }
                */
            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_header.endRefreshing()
            
        }) { (_, error: Error) in
            
            weakSelf?.tableView.mj_header.endRefreshing()
            
            print(error)
            
        }
        
    }

    @objc func setupMoreData() {
        
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examsListNew", parameters: ["page": "\(page)", "limit": "10"], progress: nil, success: { (_, data: Any?) in
            
            guard let result = data as? [Dictionary<String, Any>] else {
                
                weakSelf!.tableView.mj_footer.endRefreshingWithNoMoreData()

                return
            }
            
            if result.count == 0 {// 无更多数据
                
                weakSelf!.tableView.mj_footer.endRefreshingWithNoMoreData()

                return
            }
            
            for dict in result {
                
                let item = ExamineMainModel.mj_object(withKeyValues: dict)
                weakSelf!.modelArray.append(item!)
                
            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_footer.endRefreshing()
            weakSelf?.page += 1
        }) { (_, error: Error) in
            
            weakSelf?.tableView.mj_footer.endRefreshing()
            
            print(error)
            
        }

    }
}
