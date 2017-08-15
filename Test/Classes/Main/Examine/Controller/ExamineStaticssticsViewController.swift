//
//  ExamineStaticssticsViewController.swift
//  Test
//
//  Created by 王东开 on 2017/8/10.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit

class ExamineStaticssticsViewController: UIViewController {

    var submitModel: ExamineSubmitModel = ExamineSubmitModel()
    var dataArray: [ExamineItemModel] = [ExamineItemModel]()
    var groupId: String?
    
    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doLabel: UILabel!
    @IBOutlet weak var undoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "答题卡"
        setupCollection()
        
        totalLabel.text = "\(self.submitModel.currTitleNum)/\(self.dataArray.count)"
        doLabel.text = "已做 \(self.submitModel.items.count)"
        undoLabel.text = "未做 \(self.dataArray.count - self.submitModel.items.count)"

        // Do any additional setup after loading the view.
    }

   }

extension ExamineStaticssticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let itemModel = self.dataArray[indexPath.row]
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self || type(of: view) == UIImageView.self{
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        let image = itemModel.chooseAnswer == nil ? UIImage(named: "circle") : UIImage(named: "circle_select")
        button.setImage(image, for: .normal)
        cell.contentView.addSubview(button)
        
        if indexPath.row == self.submitModel.currTitleNum {
            
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            image.center = button.center
            image.image = itemModel.chooseAnswer == nil ? UIImage(named: "pen") : UIImage(named: "pen_white")
            cell.contentView.addSubview(image)

        } else {
            
            let label = UILabel(frame: button.bounds)
            label.center = button.center
            label.textColor = itemModel.chooseAnswer == nil ? UIColor.black : UIColor.white
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textAlignment = .center
            label.text = "\(indexPath.row + 1)"
            cell.contentView.addSubview(label)

        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.navigationController?.childViewControllers[2] as! ExamineDetailViewController
        vc.index = indexPath.row
        
        self.navigationController?.popViewController(animated: true)
        
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

private extension ExamineStaticssticsViewController {
    
    // 重做
    @IBAction func redoClick(_ sender: UIButton) {
        
        guard let groupId = self.dataArray[0].exerciseGroupId else {
            
            return
        }
        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/updateNewExerRecordNew"

        weak var weakSelf = self
        
        NetworkTool.shareInstance.request(method: .GET, url: url, param: ["groupId": groupId]) { (_, success: Any?, error: Error?) in
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            
            if isSuccess == true {
                
                /*
                let alertVC = UIAlertController(title: "提示", message: "\(msg)", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertVC.addAction(action)
                
                self.present(alertVC, animated: true, completion: nil)
                */
                
                let vc = self.navigationController?.childViewControllers[2] as! ExamineDetailViewController
                
                vc.network()
                vc.submitModel = ExamineSubmitModel()

                vc.collectionView?.reloadData()
                
                vc.index = 0
                
                weakSelf?.navigationController?.popViewController(animated: true)
            }
            
        }

    }
    
    // 提交
    @IBAction func submitClick(_ sender: UIButton) {
        
        let vc = self.navigationController?.childViewControllers[2] as! ExamineDetailViewController
        vc.submit()
        
    }
    

}
