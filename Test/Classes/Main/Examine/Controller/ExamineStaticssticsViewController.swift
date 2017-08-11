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
    var submitDataArray: [ExamineItemModel] = [ExamineItemModel]()
    var groupId: String?
    
    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doLabel: UILabel!
    @IBOutlet weak var undoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "答题卡"
        setupCollection()
        
        totalLabel.text = "\(self.submitModel.currTitleNum)/\(self.submitModel.allCount)"
        doLabel.text = "已做 \(self.submitModel.doCount)"
        undoLabel.text = "未做 \(self.submitModel.allCount - self.submitModel.doCount)"

        // Do any additional setup after loading the view.
    }

   }

extension ExamineStaticssticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Int(self.submitModel.allCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        var itemModel: ExamineSubmitItemModel = ExamineSubmitItemModel()
        
        for view in cell.contentView.subviews {
            
            if type(of: view) == UIButton.self || type(of: view) == UILabel.self || type(of: view) == UIImageView.self{
                
                view.removeFromSuperview()
            }
        }
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.center = cell.contentView.center
        let image = itemModel.ans == nil ? UIImage(named: "circle") : UIImage(named: "circle_selected")
        button.setImage(image, for: .normal)

        if indexPath.row == 100 {
            
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            image.center = button.center
            image.image = itemModel.ans == nil ? UIImage(named: "pen") : UIImage(named: "pen_white")
            cell.contentView.addSubview(image)

        } else {
            
            let label = UILabel(frame: button.bounds)
            label.center = button.center
            label.textColor = itemModel.ans == nil ? UIColor.black : UIColor.white
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textAlignment = .center
            label.text = "\(indexPath.row + 1)"
            cell.contentView.addSubview(label)

        }
        cell.contentView.addSubview(button)
        
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
        
        guard let groupId = self.groupId else {
            
            return
        }
        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/updateNewExerRecordNew"

        NetworkTool.shareInstance.request(method: .GET, url: url, param: ["groupId": groupId]) { (_, success: Any?, error: Error?) in
            
            print(success)
            print(error)
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            let msg = data["msg"] as! String
            
            if isSuccess == true {
                
                print("成功, \(msg)")
            }
            
        }

    }
    
    // 提交
    @IBAction func submitClick(_ sender: UIButton) {
        
       let vc = self.navigationController?.childViewControllers[2]
        
    }
    

}
