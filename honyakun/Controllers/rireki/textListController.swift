//
//  textList.swift
//  honyakun
//
//  Created by WKC on 2016/09/18.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

import UIKit
import GoogleMobileAds
class textListController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate{
    
    
    //テーブル
    var textTableView:UITableView!
    
    var refreshControl:UIRefreshControl!
    
    //パスetc..
    var imagePath: String {
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return doc
    }

    
    //テキストリスト
    var textList:[Int:textSet] = [:]
    var filePathNameList:[Int:String] = [:]
   // var _mySwiftData = MySwiftData()
    
    
    //数値
    var navHeight:CGFloat!
    var selfWidth:CGFloat!
    var selfHeight:CGFloat!
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var orgdb = orgTextDB()
    var iddb = IDCheckDB()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setSize()
        setnavBar()
        setTexts()
        setTableView()
        adCheck()
    }
    
    func setSize(){
        self.navHeight = self.navigationController!.navigationBar.bounds.size.height+UIApplication.shared.statusBarFrame.size.height
        selfWidth = self.view.frame.size.width
        selfHeight = self.view.frame.size.height
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
            let image = UIImage(contentsOfFile: filepath as String)
            let title = getTitle(path as! String)
            let lang = getLang(path as! String)
            print("info=> paht:\(path),title:\(title),lang:\(lang)")
            //var contText =  _mySwiftData.getOrgText(filepath as String).replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
            var conText = orgdb.getImage(name: path as! String)
            print("text=>\(conText)")
            if title == ""{
                continue
            }
            filePathNameList[i] = path as! String//filepath
            textList[i] = textSet(title: title,image: image!,lang:lang,contentText: conText)
            i += 1

        }
    }
    
    func getLang(_ path:String)->String{
        //let str = _mySwiftData.getLang(path)
        let str = imagedb.getLang(name: path)
        return str
    }
    
    func getTitle(_ path:String)->String{
            //let str = _mySwiftData.getTitle(path)
        let str = imagedb.getTitle(name: path)
            return str
    }
    
    func setTableView(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl.addTarget(self, action: #selector(newTopViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.textTableView = UITableView(frame:CGRect(x: 0,y: navHeight,width: selfWidth,height: selfHeight-navHeight))
        self.textTableView.delegate = self
        self.textTableView.dataSource = self
        self.textTableView.contentInset = UIEdgeInsets(top: -navHeight,left: 0,bottom: 0,right: 0)
        let nib = UINib(nibName: "textCell", bundle: nil)
        self.textTableView.register(nib, forCellReuseIdentifier: "textCell")
        self.textTableView.addSubview(refreshControl)
        self.view.addSubview(textTableView)
        
        self.refresh()
    }
    
    func setnavBar(){
        // タイトルを設定する.
        let titleView = UILabel(frame:CGRect.zero)
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.textColor = UIColorFromRGB(0xFF5BBE)
        titleView.text = "文章一覧"
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.navigationBar.hidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    func adCheck(){
        
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize:kGADAdSizeFullBanner,origin: CGPoint(x: 0,y: self.view.frame.size.height-kGADAdSizeFullBanner.size.height))
        // bannerView.frame = CGRectMake(0,self.view.frame.size.height-bannerView.frame.size.height,self.view.frame.size.width,bannerView.frame.size.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-6722210748079586/9275127954"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        //let adMobTestID = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString.md5()
        //gadRequest.testDevices = ["2896635ab2c5853b412e1fa7c1b95995"]

        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        
        
    }
    
    
    
}



extension textListController{
    
    func refresh(){
        self.setTexts()
        self.textTableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filePath = filePathNameList[indexPath.row]
        let storyboard = UIStoryboard(name: "textViewController", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "textViewController") as! textViewController
        mainViewController.webText = imagedb.getImage(name: filePathNameList[indexPath.row]!)
        //_mySwiftData.getImage(filePathNameList[indexPath.row]!)
        mainViewController.textTitle = textList[indexPath.row]?.titleText
        mainViewController.lang = textList[indexPath.row]?.lang
        mainViewController.im = textList[indexPath.row]?.titleImage
        
      /*  let rightViewController = storyboard.instantiateViewControllerWithIdentifier("ImageGet") as! ImageGet
        rightViewController.checker = 0
        rightViewController.im = textList[indexPath.row]?.titleImage
        
        var textView : back = back(mainViewController:mainViewController, rightMenuViewController:rightViewController)
        textView.navigationItem.title = textList[indexPath.row]?.titleText
        textView.navigationController?.setNavigationBarHidden(false, animated: true)
        / self.navigationController?.pushViewController(textView, animated: true)*/
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    /*
     Cellの総数を返すデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textList.count
    }
    
    /*
     Cellに値を設定するデータソースメソッド.
     (実装必須)
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
        
        // Cellに値を設定する.
        let tmpSet = textList[indexPath.row]//textSet(title: "TOEIC対策",image: UIImage(named:"sampleText.jpg")!,lang:"en")
        cell.setCell(tmpSet!)
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*for (ind,textsetInstance) in textList{
            let cell = self.textTableView.cellForRow(at: IndexPath(row: ind,section: 0)) as! textCell
            cell.textContentView.setContentOffset(CGPoint.zero, animated: false)
        }*/
    }
}
