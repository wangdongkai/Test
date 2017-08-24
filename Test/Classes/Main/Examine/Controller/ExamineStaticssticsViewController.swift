//
//  ExamineStaticssticsViewController.swift
//  Test
//
//  Created by 王东开 on 2017/8/10.
//  Copyright © 2017年 wangdongkai. All rights reserved.
//

import UIKit
import FMDB
import SVProgressHUD
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
        button.isUserInteractionEnabled = false
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
        vc.scrollCollection(index: indexPath.row + 1)
        
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
        
        SVProgressHUD.show(withStatus: "正在发送请求请稍等。。。")

        guard let groupId = self.dataArray[0].exerciseGroupId else {
            
            return
        }
        
        let name = UserDefaults.standard.object(forKey: "username") as! String
        
        let path: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
        
        let sqlPath = path.appendingPathComponent("\(name).sqlite")
        
        let queue = FMDatabaseQueue.init(path: sqlPath)
        queue.inDeferredTransaction { (db, rollBack) in
            
            do {
                
                let sql = "SELECT * FROM t_topic"
                
                let res = try db.executeQuery(sql, values: nil)
                
                while res.next() {
                    
                    do {
                        
                        try db.executeUpdate("UPDATE t_topic SET chooseAnswer = ''", values: nil)
                        
                    } catch {
                        
                        print("failed: \(error.localizedDescription)")
                    }
                    
                }
                
            } catch {
                
                print(error)
            }
        }
        
        
        UserDefaults.standard.set(0, forKey: self.dataArray[0].exerciseGroupId!)
        UserDefaults.standard.synchronize()
        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/updateNewExerRecordNew"

        weak var weakSelf = self
        
        NetworkTool.shareInstance.request(method: .GET, url: url, param: ["groupId": groupId]) { (_, success: Any?, error: Error?) in
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            
            if isSuccess == true {
                
                SVProgressHUD.dismiss()
                let vc = self.navigationController?.childViewControllers[1] as! ExamineMainViewController
                
                weakSelf?.navigationController?.popToViewController(vc, animated: true)
                
            }
            
        }

    }
    
    // 提交
    @IBAction func submitClick(_ sender: UIButton) {
        
        self.submitModel.exerciseGroupId = self.dataArray[0].exerciseGroupId
        
        let dict = self.submitModel.mj_keyValues()
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted) else {
            
            return
        }
        
        let encoding = String(data: jsonData, encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = "http://www.qxueyou.com/qxueyou/exercise/Exercise/exerAnswers?answers=\(encoding!)"
        
        NetworkTool.shareInstance.request(method: .POST, url: url, param: nil) { (_, success: Any?, error: Error?) in
            
            guard let data = success as? [String: Any] else {
                
                return
            }
            
            let isSuccess = data["success"] as! Bool
            let msg = data["msg"] as! String
            
            if isSuccess == true {
                
                print("成功, \(msg)")
                
                let vc = ExamineReportViewController.init(nibName: "ExamineReportViewController", bundle: nil)
                vc.submitModel = self.submitModel
                vc.dataArray = self.dataArray
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
        
    }
    

}
