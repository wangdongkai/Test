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
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.barButtonItemWith(image: "submit", target: self, action: #selector(ExamineDetailViewController.submitClick)),
            UIBarButtonItem.barButtonItemWith(image: "star", target: self, action: #selector(ExamineDetailViewController.collectClick))
        ]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0

        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height - 64)
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.register(UINib.init(nibName: "ExamineDetailViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        self.collectionView?.isPagingEnabled = true
        
    }
}

private extension ExamineDetailViewController {
    
    @objc func collectClick() {
        
        
    }
    
    @objc func submitClick() {
    
    
    }
}
