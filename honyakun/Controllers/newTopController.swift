//
//  newTopController.swift
//  honyakun
//
//  Created by WKC on 2016/09/29.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

import UIKit
import GoogleMobileAds
class newTopViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var underView:UIView!
    var camera:UIButton!
    var wordcamera:UIButton!
    var wordsearch:UIButton!
    var textrireki:UIButton!
    var wordcard:UIButton!
    
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var orgdb = orgTextDB()
    var iddb = IDCheckDB()
    

    
    //テーブル
    var myTableView:UITableView!
    //パスetc..
    var imagePath: String {
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return doc
    }
    
    
    //テキストリスト
    var textList:[Int:textSet] = [:]
    var filePathNameList:[Int:String] = [:]

    //コンテンツ
    var contentArray:[Int:topCard] = [:]
    
    //テーブルビュー
     var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        setnavBar()
        setTexts()
        if(self.contentArray.count>0){
           setTableView()
        }else{
            setDefaultView()
        }
        setView()
        setButtons()
        if(self.contentArray.count>0){
            self.myTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setDefaultView(){
        let defView = UIView(frame:CGRect(x: 0,y: 60,width: self.view.frame.size.width,height: self.view.frame.size.height-120))
        let cameraImage = UIImageView(frame:CGRect(x: self.view.frame.size.width/2-50,y: self.view.frame.size.height/2-80,width: 100,height: 100))
        cameraImage.image = UIImage(named:"red.png")
        defView.addSubview(cameraImage)
        let explainView = UITextView(frame:CGRect(x: self.view.frame.size.width/6,y: self.view.frame.size.height/2+40,width: self.view.frame.size.width*2/3,height: 130))
        explainView.text = "撮影した文章の履歴がここに表示されます。\n早速、下のカメラアイコンから文を撮影してみましょう！"
        explainView.isUserInteractionEnabled = false
        defView.addSubview(explainView)
        self.view.addSubview(defView)
        
    }
    
    func setTableView(){
        //refreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl.addTarget(self, action: #selector(newTopViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.myTableView = UITableView(frame:CGRect(x: 0,y: 60,width: self.view.frame.size.width,height: self.view.frame.size.height-140))
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.separatorColor = UIColor.clear
        let nib = UINib(nibName: "topContCell", bundle: nil)
        self.myTableView.register(nib, forCellReuseIdentifier: "topContCell")
        self.view.addSubview(myTableView)
        self.myTableView.addSubview(refreshControl)
        self.myTableView.setContentOffset(CGPoint.zero, animated: false)
        self.myTableView.contentInset =  UIEdgeInsets(top:-self.navigationController!.navigationBar.frame.size.height-UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    
    func setView(){
        underView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height-60,width: self.view.frame.size.width,height: 60))
        underView.backgroundColor = UIColorFromRGB(0xFFFFF3)//UIColorFromRGB(0xF8F8F8)
        self.view.addSubview(underView)
    }
    
    
    func setnavBar(){
        // タイトルを設定する.
        self.navigationItem.title = "翻訳レンズ"
        let titleView = UILabel(frame:CGRect.zero)
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.textColor = UIColorFromRGB(0xFF5BBE)
        titleView.text = "翻訳レンズ"
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView
    }
    
    func setTexts(){
        
        let manager = FileManager.default
        var imageList:NSArray=[]
        do{
            imageList = try manager.contentsOfDirectory(atPath: imagePath) as NSArray
        }catch{
            print("miss")
        }
        
        var i = 0
        for path in imageList {
            let filepath:String! = URL(fileURLWithPath:imagePath).appendingPathComponent(path as! String).path
            let title = getTitle(filepath as String)
            let lang = getLang(filepath as String)
           // var contText =  _mySwiftData.getOrgText(filepath as String)//_mySwiftData.getImage(filepath as! String)
            var contText = orgdb.getImage(name: filepath as String)
            if title == ""{
                continue
            }
            contText =  contText.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.regularExpression, range: nil)

            contentArray[i] = topCard(title: title,content: contText,lang: lang)
            filePathNameList[i] = filepath
            i += 1
        }
    }


    
    func setButtons(){
        camera = UIButton(frame:CGRect(x: 15,y: 5,width: 30,height: 30))
        camera.setImage(UIImage(named:"camera.png"), for: UIControlState())
        camera.addTarget(self, action: #selector(newTopViewController.showCamera), for: .touchUpInside)
        var midasi = UILabel(frame:CGRect(x: 5,y: 40,width: 50,height: 15))
        midasi.text = "文章撮影"
        midasi.textAlignment = .center
        midasi.textColor = UIColorFromRGB(0x888888)
        midasi.font =  UIFont.systemFont(ofSize: CGFloat(11))
        self.underView.addSubview(midasi)
        
        
        wordcamera = UIButton(frame:CGRect(x: self.view.frame.size.width/4-5,y: 5,width: 30,height: 30))
        wordcamera.setImage(UIImage(named:"research.png"), for: UIControlState())
        wordcamera.addTarget(self, action: #selector(newTopViewController.showWordCamera), for: .touchUpInside)
        var midasi2 = UILabel(frame:CGRect(x: self.view.frame.size.width/4-15,y: 40,width: 50,height: 15))
        midasi2.text = "一文撮影"
        midasi2.textAlignment = .center
        midasi2.font =  UIFont.systemFont(ofSize: CGFloat(11))
        self.underView.addSubview(midasi2)

        
        wordsearch = UIButton(frame:CGRect(x: self.view.frame.size.width/2-15,y: 5,width: 30,height: 30))
        wordsearch.setImage(UIImage(named:"search.png"), for: UIControlState())
        wordsearch.addTarget(self, action: #selector(newTopViewController.showSearch), for: .touchUpInside)
        var midasi3 = UILabel(frame:CGRect(x: self.view.frame.size.width/2-25,y: 40,width: 50,height: 15))
        midasi3.text = "単語検索"
        midasi3.textAlignment = .center
        midasi3.font =  UIFont.systemFont(ofSize: CGFloat(11))
        self.underView.addSubview(midasi3)
        
        
        textrireki = UIButton(frame:CGRect(x: self.view.frame.size.width*3/4-30,y: 5,width: 30,height: 30))
        textrireki.setImage(UIImage(named:"book.png"), for: UIControlState())
        textrireki.addTarget(self, action: #selector(newTopViewController.showText), for: .touchUpInside)
        var midasi4 = UILabel(frame:CGRect(x: self.view.frame.size.width*3/4-35,y: 40,width: 50,height: 15))
        midasi4.text = "保存文章"
        midasi4.textAlignment = .center
        midasi4.font =  UIFont.systemFont(ofSize: CGFloat(11))
        self.underView.addSubview(midasi4)

        
        
        wordcard =   UIButton(frame:CGRect(x: self.view.frame.size.width-52.5,y: 2.5,width: 35,height: 35))
        wordcard.setImage(UIImage(named:"wordCard.png"), for: UIControlState())
        wordcard.addTarget(self, action: #selector(newTopViewController.showWordList), for: .touchUpInside)
        var midasi5 = UILabel(frame:CGRect(x: self.view.frame.size.width-50,y: 40,width: 50,height: 15))
        midasi5.text = "単語履歴"
        midasi5.textAlignment = .center
        midasi5.font =  UIFont.systemFont(ofSize: CGFloat(11))
        self.underView.addSubview(midasi5)

        
        
        self.underView.addSubview(camera)
        self.underView.addSubview(wordcamera)
        self.underView.addSubview(wordsearch)
        self.underView.addSubview(textrireki)
        self.underView.addSubview(wordcard)
          }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension newTopViewController{
    
    func getLang(_ path:String)->String{
       // let str = _mySwiftData.getLang(path)
        let str = imagedb.getLang(name: path)
        return str
    }
    
    func getTitle(_ path:String)->String{
        //let str = _mySwiftData.getTitle(path)
        let str = imagedb.getTitle(name: path)
        return str
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.setNavigationBarHidden(false,animated:true)
        //self.navigationController?.navigationBar.backgroundColor = UIColorFromRGB(0xF8F8F8)
        
        
    }


}


extension newTopViewController{
    
    func refresh(){
        self.setTexts()
        self.myTableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filePath = filePathNameList[indexPath.row]
        let storyboard = UIStoryboard(name: "textViewController", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "textViewController") as! textViewController
        //mainViewController.webText = _mySwiftData.getImage(filePathNameList[indexPath.row]!)
        mainViewController.webText = imagedb.getImage(name: filePathNameList[indexPath.row]!)
        mainViewController.lang = contentArray[indexPath.row]?.lang
        mainViewController.textTitle = contentArray[indexPath.row]?.title
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myTableView.frame.size.height/5;//self.view.frame.size.height/6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topContCell", for: indexPath) as? topContCell else {
            return UITableViewCell()
        }
        for subview in cell.subviews{
            if(subview.className == "UILabel"){
                subview.removeFromSuperview()
            }
        }
        cell.setSelected(true, animated: true)
        
        cell.setCell(contentArray[indexPath.row]!)
        return cell
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // self.textList.forEach(<#T##body: ((Int, textSet)) throws -> Void##((Int, textSet)) throws -> Void#>)
        for (ind,textsetInstance) in contentArray{
            let cell = self.myTableView.cellForRow(at: IndexPath(row: ind,section: 0)) as! topContCell
            cell.textContentView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    
}



extension newTopViewController{
    
    func showCamera(){
        let controller = instantiate(cameraViewController.self,storyboard:"cameraViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showWordCamera(){
        let controller = instantiate(wordOcrController.self,storyboard:"wordOcrController")
        // controller.navigationController?.setNavigationBarHidden(true,animated:true)
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    func showSearch(){
        let controller = instantiate(searchController.self,storyboard:"searchController")
       // controller.navigationController?.setNavigationBarHidden(true,animated:true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showText(){
        let controller = instantiate(textListController.self,storyboard:"textListController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showWordList(){
        let controller = instantiate(wordListController.self,storyboard:"wordListController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}
