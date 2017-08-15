//
//  ExamineAnaysisController.swift
//  Test
//
//  Created by 王东开 on 2017/8/15.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ExamineAnalysisCollectionCell"

class ExamineAnaysisViewController: UICollectionViewController {

    var model: ExamineMainModel?
    var dataArray: [ExamineItemModel]?

    var index: Int = 0 {
        didSet {
            
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupNetwork()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataArray?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExamineAnalysisCollectionCell
    
        cell.backgroundColor = UIColor.white
        cell.model = self.dataArray?[indexPath.row] ?? nil
        
        return cell
    }

}

private extension ExamineAnaysisViewController {
    
    func setup() {
        
        title = "测试题目"
        self.view.backgroundColor = UIColor.white

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height - 64)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.isPagingEnabled = true

        self.collectionView?.register(UINib.init(nibName: "ExamineAnalysisCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func setupNetwork() {
        
        let param = ["groupId": model?.groupId! ?? "", "exerciseRecordId": model?.exerciseRecordId! ?? "", "getExercise": true, "getAnswer": true] as [String : Any]
        
        weak var weakSelf = self
        
        NetworkTool.shareInstance.get("http://www.qxueyou.com/qxueyou/exercise/Exercise/examExercise", parameters: param, progress: nil, success: { (_, data: Any?) in
            
            guard let dict = data as? [String: Any] else {
                
                return
            }
            
            let detailModel: ExamineDetailModel = ExamineDetailModel.mj_object(withKeyValues: dict)
            
            weakSelf?.dataArray = detailModel.items!
            
            weakSelf?.collectionView?.reloadData()
            
        }) { (_, error: Error) in
            
            print(error)
            
            
        }
    }

}
