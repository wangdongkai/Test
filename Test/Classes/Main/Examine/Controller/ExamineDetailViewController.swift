//
//  ExamineDetailViewController.swift
//  Test
//
//  Created by wangdongkai on 17/8/1.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

private let identifier = "ExamineDetailViewCell"

class ExamineDetailViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ExamineDetailViewCell
        cell.backgroundColor = UIColor.red
        
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    
}

private extension ExamineDetailViewController {
    
    func setup() {
        
        title = "模拟测试"

        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.barButtonItemWith(image: "submit", target: self, action: #selector(ExamineDetailViewController.submitClick)),
            UIBarButtonItem.barButtonItemWith(image: "STAR", target: self, action: #selector(ExamineDetailViewController.collectClick))
        ]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.register(UINib.init(nibName: "ExamineDetailViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
    }
}

private extension ExamineDetailViewController {
    
    @objc func collectClick() {
        
        
    }
    
    @objc func submitClick() {
    
    
    }
}
