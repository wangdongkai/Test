//
//  ExamineStaticssticsViewController.swift
//  Test
//
//  Created by 王东开 on 2017/8/10.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineStaticssticsViewController: UIViewController {

    var submitModel: ExamineSubmitModel? {
        
        didSet {
            
            guard let m = submitModel else {
                
                return
            }
            
            totalLabel.text = "\(m.doCount)/\(m.allCount)"
            doLabel.text = "已做 \(m.doCount)"
            undoLabel.text = "未做 \(m.allCount - m.doCount)"
            
        }
    }

    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doLabel: UILabel!
    @IBOutlet weak var undoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "答题卡"
        setupCollection()
        
        
        // Do any additional setup after loading the view.
    }

   
    
}

extension ExamineStaticssticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self || type(of: view) == UIImageView.self{
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        button.setImage(UIImage(named: "circle"), for: .normal)

        if indexPath.row == 100 {
            
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            image.center = button.center
            image.image = UIImage(named: "pen")
            cell.contentView.addSubview(image)

        } else {
            
            let label = UILabel(frame: button.bounds)
            label.center = button.center
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textAlignment = .center
            label.text = "\(indexPath.row)"
            cell.contentView.addSubview(label)

        }
        cell.contentView.addSubview(button)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

private extension ExamineStaticssticsViewController {
    
    func setupCollection() {
        
        self.listCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        
        layout.minimumInteritemSpacing = (self.listCollection.frame.width - 40.0 * 5) / 5
        layout.minimumLineSpacing = 10

    }
}
