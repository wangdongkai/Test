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

    fileprivate let button: UIButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupButton()
        
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
        self.collectionView?.backgroundColor = UIColor.clear
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
            
            if (weakSelf?.dataArray?.count)! > 0 {
                
                for item in (weakSelf?.dataArray)! {
                    
                    
                }

            }
            
            weakSelf?.collectionView?.reloadData()
            
        }) { (_, error: Error) in
            
            print(error)
            
            
        }
    }

    func setupButton() {
        
        self.button.frame = CGRect(x: self.view.frame.width - 50 - 15, y: self.view.frame.height - 100, width: 50, height: 50)
        self.button.layer.cornerRadius = 25.0
        self.button.layer.masksToBounds = false
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.backgroundColor = UIColor.colorWithHex(color: "2196F3", alpha: 1.0)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        self.button.setTitle("菜单", for: .normal)
        self.button.addTarget(self, action: #selector(ExamineAnaysisViewController.menuClick), for: .touchUpInside)
        self.view.insertSubview(self.button, aboveSubview: self.collectionView!)
        
    }

    func getChooseAnswer() {
        
        
    }
}

private extension ExamineAnaysisViewController {
    
    @objc func menuClick() {
        
        
    }
}
