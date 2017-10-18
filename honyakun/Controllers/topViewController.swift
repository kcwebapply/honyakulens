//
//  topView.swift
//  honyakun
//
//  Created by WKC on 2016/09/03.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit

class topViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var topTableView: UITableView!
    var topViewArray:[topSetClass]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex:0xF8F8F8)
        setTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTableView(){
        topViewArray = []
        let top1 = topSetClass(image:UIImage(named: "camera.png")!,labelText:"文書撮影",explainText:"文書を撮影します。")
        let top2 =  topSetClass(image:UIImage(named: "wordCard.png")!,labelText:"単語辞書",explainText:"チェックした単語一覧です。")
        let top3 =  topSetClass(image:UIImage(named: "notebook.png")!,labelText:"文書履歴",explainText:"文書の履歴一覧です。")
        let top4 =  topSetClass(image:UIImage(named: "search.png")!,labelText:"辞書検索",explainText:"単語を検索します。")
        let top5 =  topSetClass(image:UIImage(named: "config.png")!,labelText:"設定",explainText:"各種機能の設定です。")
        topViewArray.append(top1)
        topViewArray.append(top2)
        topViewArray.append(top3)
        topViewArray.append(top4)
        topViewArray.append(top5)
        let nib = UINib(nibName: "topViewCell", bundle: nil)
        topTableView.register(nib , forCellReuseIdentifier: "topViewCell")
        topTableView.isScrollEnabled = false
        topTableView.rowHeight = topTableView.frame.size.height/5//self.view.frame.size.height/6;//100
    }
    
    
}

extension topViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return topTableView.frame.size.height/5;//self.view.frame.size.height/6;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topViewCell", for: indexPath) as? topViewCell else {
            return UITableViewCell()
        }
        cell.setSelected(true, animated: true)
        cell.setCell(topViewArray[indexPath.row])
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            let controller = instantiate(cameraViewController.self,storyboard:"cameraViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
            let controller = instantiate(searchController.self,storyboard:"searchController")
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 2:
            let controller = instantiate(textListController.self,storyboard:"textListController")
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 3:
            let controller = instantiate(wordListController.self,storyboard:"wordListController")
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 4:
            let controller = instantiate(cameraViewController.self,storyboard:"cameraViewController")
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            let controller = instantiate(cameraViewController.self,storyboard:"cameraViewController")
            //self.presentViewController(controller, animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override var shouldAutorotate : Bool{
        return false
    }


}
