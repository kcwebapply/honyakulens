//
//  wordList.swift
//  honyakun
//
//  Created by WKC on 2016/09/19.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class wordListController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,popWordDeleteProt ,popViewProt, GADBannerViewDelegate,wordCellProtocol{
    
    //サーチバー
     var mySearchBar: UISearchBar!
    var searchBackView:UIView!
    //一時保存単語
    var tmpWord:String!
    var selfLang:String!
    var TouchedWord:String!
    var lang:String!
    var dbID:Int!
    //単語カード
    var wordView:popWordDelete!
    
    var wordTableView:UITableView!
    var navHeight:CGFloat!
    //word保存リスト
    var wordList:[Int:wordCard] = [:]
    //検索時使用用保存リスト
    var tmpWordList:[Int:wordCard] = [:]
    //検索時かどうかチェック
    var tmpSearchFlag:Bool = false
    
    //swiftData
   // var _mySwiftData = MySwiftData()
    
    //htmlcontents
    var htmlContents:String!
    
    //戻るボタン
    var backViewButton:UIButton!
    
    //popView
    var popLangView:popView!
    var langShow:Bool = false
    //選択ボタン
    var select:UIButton!
    //etc...
    var langList:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var orgdb = orgTextDB()
    var iddb = IDCheckDB()



    
    var bannerView: GADBannerView!
    var wCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWordList()
        setTableView()
        setSearchBar()
        setSubView()
        initPopView()
        adCheck()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func initPopView(){
        selfLang = "en"
        popLangView = popView(frame:CGRect(x: self.view.frame.size.width/2-150,y: self.view.frame.size.height/2-1000,width: 300,height: 320))
        popLangView.delegate = self
        self.view.addSubview(popLangView)
        
        // 言語選択ボタン
        //print("位置=>\(self.mySearchBar.barPosition.rawValue)")
        select = UIButton(frame:CGRect(x: self.view.frame.size.width-100,y: self.searchBackView.frame
            .size.height-40,width: 100,height: 40))
        //select.backgroundColor = UIColor.redColor()
        select.setTitle("言語", for: UIControlState())
        select.setTitleColor(UIColor.red, for: UIControlState())
        select.addTarget(self, action: #selector(wordListController.showProt), for: .touchUpInside)
        self.searchBackView.addSubview(select)
        
    }
    
    
    func showProt(){
        if(langShow){
            self.popLangView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: -200)
            langShow = false
        }else{
            self.popLangView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2)
            langShow = true
            
        }
        
    }
    
    

    
    func setTableView(){
        navHeight = self.navigationController?.navigationBar.frame.height
        self.wordTableView = UITableView(frame:CGRect(x: 0,y: 100,width: self.view.frame.size.width,height: self.view.frame.size.height-navHeight-150))
        self.wordTableView.delegate = self
        self.wordTableView.dataSource = self
        let nib = UINib(nibName: "wordCell",bundle: nil)
        self.wordTableView.register(nib, forCellReuseIdentifier: "wordCell")
        self.view.addSubview(wordTableView)
    }
    
    func setWordList(){
        print("ここまでいけるで")
       // var wordsData = _mySwiftData.getAllWords()
        var wordsData = worddb.getAllWord()
        self.wordList = [:]
        self.tmpWordList = [:]
        for i:Int in 0 ..< wordsData.count {
            var tmpdic = wordsData[i]!
            let id = tmpdic["id"]
            let word = tmpdic["word"]
            let lang = tmpdic["lang"]
            self.wordList[i] = wordCard(id:id! as! Int,word:word! as! String,lang:lang! as! String)
            
        }
        print("データ取得あかんな")
    }
    
    func setSubView(){
        //タイトル
        let navLabel:UILabel = UILabel(frame:CGRect(x: self.view.frame.size.width/3,y: 20,width: self.view.frame.size.width/3,height: 45))
        navLabel.text="単語履歴"
        navLabel.textAlignment = NSTextAlignment.center
        navLabel.textColor = UIColorFromRGB(0xFF5BBE)
        navLabel.font=UIFont.boldSystemFont(ofSize: 14.0)
        self.mySearchBar.addSubview(navLabel)
        //単語View
        selfLang = "en"
        wordView = popWordDelete(frame: CGRect(x: 0,y: self.view.frame.size.height+100,width: self.view.frame.size.width,height: 200),word: "",text: "",lang:selfLang)
        wordView.delegate = self
        self.view.addSubview(wordView)
        
        //戻るボタン
        backViewButton = UIButton(frame:CGRect(x: 10,y: 30,width: 30,height: 30))
        backViewButton.setImage(UIImage(named:"back.png"), for: UIControlState())
        backViewButton.addTarget(self, action: #selector(wordListController.disView), for: .touchUpInside)
        self.mySearchBar.addSubview(backViewButton)

    }
    
    func protReturn(_ text: String) {
        self.popLangView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: -200)
         self.select.setTitle(langList[text], for: UIControlState())
        self.select.setTitleColor(UIColorFromRGB(colorList[text]!), for: UIControlState())
        langShow = false
      
        
        self.tmpWordList = [:]
        self.wordView.layer.position=CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height+200)
        self.wordTableView.reloadData()
        selfLang = text
        var counter = 0
        for (ind,card) in self.wordList{
            if(card.lang==selfLang){
                tmpWordList[counter] = card
             counter += 1
            }
        }
        self.tmpSearchFlag = true
        self.wordTableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.navigationController?.navigationBar.hidden = false
    }
    
    func disView(){
        self.navigationController?.popViewController(animated: true)
        for subview in (self.navigationController?.navigationBar.subviews)!{
            /*if(subview == "UIButton"){
                subview.removeFromSuperview()
            }*/
        }
    }
    
    func adCheck(){
        if bannerView == nil{
             bannerView = GADBannerView(adSize:kGADAdSizeFullBanner,origin: CGPoint(x: 0,y: self.view.frame.size.height-kGADAdSizeFullBanner.size.height))
        }
        if(wCount>75){
       
       // bannerView.frame = CGRectMake(0,self.view.frame.size.height-bannerView.frame.size.height,self.view.frame.size.width,bannerView.frame.size.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-6722210748079586/9275127954"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        }else{
          //  bannerView = GADBannerView(adSize:kGADAdSizeFullBanner,origin: CGPointMake(0,self.view.frame.size.height-kGADAdSizeFullBanner.size.height))
            bannerView.removeFromSuperview()
        }
        
    }

    
    
    
}

//サーチバー周り
extension wordListController{
    func setSearchBar(){
        searchBackView = UIView(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 100))
        searchBackView.backgroundColor = UIColorFromRGB(0xFFFFF3)//UIColorFromRGB(0xF8F8F8)
        searchBackView.layer.borderColor =  UIColor.gray.cgColor//UIColor.blueColor().CGColor
        searchBackView.layer.borderWidth = 0.5
        
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.backgroundColor = UIColorFromRGB(0xFFFFF3)
        mySearchBar.barTintColor = UIColorFromRGB(0xFFFFF3)//UIColorFromRGB(0xF8F8F8)
        mySearchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*3/4, height: 100)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width*3/8,y: 50)
    
        // キャンセルボタンを有効にする.
        mySearchBar.showsCancelButton = true
        // ブックマークボタンを無効にする.
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.default
        //mySearchBar.layer.cornerRadius = 10.0
        mySearchBar.prompt = " "
        mySearchBar.placeholder = "単語を入力してください"
        // カーソル、キャンセルボタンの色を設定する.
        mySearchBar.tintColor = UIColor.blue
        // 検索結果表示ボタンは非表示にする.
        mySearchBar.showsSearchResultsButton = false
        //searchBackView.addSubview(mySearchBar)
        self.view.addSubview(searchBackView)
        // 検索バーをViewに追加する.
        self.view.addSubview(mySearchBar)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tmpSearchFlag = true
        self.tmpWordList = [:]
        self.wordView.layer.position=CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height+200)
        var counter = 0
        for (ind,card) in wordList{
            if(card.word.hasPrefix(searchText)||card.word.lowercased().hasPrefix(searchText)){
                self.tmpWordList[counter] = card
                counter += 1
            }
        }
        self.wordTableView.reloadData()
        
    }
    
    /*
     Cancelボタンが押された時に呼ばれる
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mySearchBar.text = ""
        self.tmpSearchFlag = false
        self.tmpWordList = [:]
          self.wordTableView.reloadData()
         self.view.endEditing(true)
    }
    
    /*
     Searchボタンが押された時に呼ばれる
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tmpWord = searchBar.text
        self.view.endEditing(true)
        //self.tmpSearchFlag = false
        //self.tmpWordList = [:]
        self.wordTableView.reloadData()
        
    }
}

//単語カード周り

extension wordListController{
    
    
    
        func popWordView(_ word:String,text:String){
            self.wordView.setProperty(word, text: text)
            self.wordView.sayClass.lang = selfLang
            print("プロパティセット:\(word);\(text)")
            //アニメーション
            UIView.animate(withDuration: 0.5,
                                   
                                   // 遅延時間.
                delay: 0.0,
            
            // バネの弾性力. 小さいほど弾性力は大きくなる.
                usingSpringWithDamping: 0.7,
            
            // 初速度.
                initialSpringVelocity: 0.5,
            
            // 一定の速度.
                options: UIViewAnimationOptions.curveLinear,
            
                animations: { () -> Void in
                    
                    self.wordView.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-100)
                
                // アニメーション完了時の処理
            }) { (Bool) -> Void in
            
            }
        
        }

    func dawnView() {
        wordView.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height+100)
    }
    
    func wordDelete(_ word:String) {
        if(self.tmpSearchFlag==false){
            for (ind,cards) in wordList{
                if(cards.word==word){
                    //_mySwiftData.deleteword(cards.word)
                    //wor
                    worddb.deleteWord(wordw: cards.word)
                }
            }
            self.setWordList()
            self.wordTableView.reloadData()
            SVProgressHUD.showSuccess(withStatus: "削除しました!")
        }else{
            for (ind,cards) in wordList{
                if(cards.word==word){
                    worddb.deleteWord(wordw: cards.word)
                   // _mySwiftData.deleteword(cards.word)
                }
            }
            
            self.setWordList()
            var counter = 0
            for (ind,card) in wordList{
                if(card.word.hasPrefix(self.mySearchBar.text!)||card.word.lowercased().hasPrefix(self.mySearchBar.text!)){
                    self.tmpWordList[counter] = card
                    counter += 1
                }
            }
            self.wordTableView.reloadData()
             SVProgressHUD.showSuccess(withStatus: "削除しました!")
        }
    }

    
   
        
}




extension wordListController{
    func propertyCheck(word:String!,id:Int!){
        print("単語=>\(word):id=>\(id)")
    }
    
    func deleteCheck(word:String!,id:Int!,tag:Int!){
        
    }

}

extension wordListController{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.tmpSearchFlag==true){
            return tmpWordList.count
        }else{
            return wordList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = (self.tmpSearchFlag) ? tmpWordList[indexPath.row]:wordList[indexPath.row]
        self.selfLang = card?.lang
        self.TouchedWord = card?.word
        self.dbID = card?.id
       // let text = _mySwiftData.getWord(card!.id!)
        let text = worddb.getAnsWord(wordw: (card?.word)!)
        self.popWordView(card!.word!, text: text as! String)
        
        //広告処理
        wCount = Int(arc4random_uniform(100))
        print("広告スコア=>\(wCount))")
        self.adCheck()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell") as! wordCell
        if(self.tmpSearchFlag){
            cell.setCell(tmpWordList[indexPath.row]!,id:indexPath.row)
        }else{
            cell.setCell(wordList[indexPath.row]!,id:indexPath.row)
        }
        cell.delegate = self
        
        return cell
    }
}
