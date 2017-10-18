//
//  searchController.swift
//  honyakun
//
//  Created by WKC on 2016/09/13.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import GoogleMobileAds

class searchController: UIViewController, UISearchBarDelegate,popViewProt, GADBannerViewDelegate {
    
    var mySearchBar: UISearchBar!
    var myWordLabel : UILabel!
    var selfWidth:CGFloat!
    var selfHeight:CGFloat!
    
    //意味、例文
    var senseLabel:UILabel!
    var textLabel:UILabel!
    var senseTextLabel:UILabel!
    var tmpWord:String!
    
    //発音周り
    var sayClass:SayClass!
    var megaButton:UIButton!
    
    //保存
    var preButton:UIButton!
    //var _mySwiftData = MySwiftData()

    
    //ローディングView
    var loadImageView:UIImageView!
    var loadImage:UIImage!
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var orgdb = orgTextDB()
    var iddb = IDCheckDB()

    
    
    
    //言語選択
    var langButton:UIButton!
    var langView:popView!
    var selfLang:String = "en"
    var langShow:Bool = false
    var langList:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]
    
    func setGif(){
        loadImageView = UIImageView(frame:CGRect(x: 100,y: 200,width: 40,height: 40))
        loadImageView.backgroundColor = UIColor.blue
        let path = Bundle.main.path(forResource: "loading", ofType: "gif")
        loadImage = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: path!))
        loadImageView.image = loadImage

        self.view.addSubview(loadImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfWidth = self.view.frame.size.width
        selfHeight = self.view.frame.size.height
        //setGif()
        setSearchBar()
        setUnderDictView()
        initPopView()
        adCheck()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUnderDictView(){
        //閉じるボタン
        var exit:UIButton!
        exit = UIButton(frame:CGRect(x: 20,y: selfHeight-125,width: self.view.frame.size.width/5,height: 40))
        exit.setTitle("閉じる",for:UIControlState())
        exit.addTarget(self, action: #selector(searchController.disView), for: UIControlEvents.touchUpInside)
        exit.setTitleColor(UIColorFromRGB(0xFF0000), for: UIControlState())
        exit.tintColor=UIColorFromRGB(0xFF0000)
        self.view.addSubview(exit)

        //発音
        self.sayClass = SayClass(lang: "en")
        //単語ラベル
        myWordLabel = UILabel(frame: CGRect(x: 20,y: 120,width: self.view.frame.size.width/3,height: 40))
        myWordLabel.text = ""
        myWordLabel.textColor = UIColor.red
        myWordLabel.layer.borderColor = UIColor.gray.cgColor
        myWordLabel.layer.cornerRadius = 10.0
        self.view.addSubview(myWordLabel)
        
        //発音ボタン
        megaButton = UIButton(frame:CGRect(x: self.view.frame.size.width*5/6-20,y: selfHeight-125,width: 40,height: 40))
        megaButton.setImage(UIImage(named:"megaP.png"), for: UIControlState())
        megaButton.addTarget(self, action: #selector(searchController.pronounceWord), for: .touchUpInside)
        self.view.addSubview(megaButton)
        //言語選択ボタン
        langButton = UIButton(frame: CGRect(x: self.view.frame.size.width*4/6-20,y: 120,width: self.view.frame.size.width/3,height: 40))
        langButton.setTitle("言語選択", for: UIControlState())
        langButton.setTitleColor(UIColorFromRGB(0x69AEFC), for: UIControlState())
        langButton.addTarget(self, action: #selector(searchController.showProt), for: .touchUpInside)
        self.view.addSubview(langButton)
        
        //横線
        let line = UILabel(frame:CGRect(x: 0,y: 170,width: selfWidth,height: 1))
        line.backgroundColor = UIColorFromRGB(0x69AEFC)
        self.view.addSubview(line)
        
        //意味ラベル
        let sLabel = UILabel(frame:CGRect(x: 20,y: 180,width: 80,height: 20))
        sLabel.text = "意味"
        sLabel.textColor = UIColorFromRGB(0xEFCE4A)
        self.view.addSubview(sLabel)
        
        //意味文章
        senseLabel = UILabel(frame:CGRect(x: 20,y: 200,width: selfWidth-40,height: 40))
        senseLabel.textColor = UIColor.red
        senseLabel.font = UIFont.systemFont(ofSize: CGFloat(18))
        senseLabel.text = ""
        self.view.addSubview(senseLabel)
        
        //例文ラベル
        let tLabel = UILabel(frame:CGRect(x: 20,y: 240,width: 80,height: 20))
        tLabel.textColor = UIColorFromRGB(0xEFCE4A)
        tLabel.text = "例文"
        self.view.addSubview(tLabel)
        
        //例文文章
        textLabel = UILabel(frame:CGRect(x: 20,y: 260,width: selfWidth-40,height: 80))
        textLabel.textColor = UIColorFromRGB(0x333333)
        textLabel.font = UIFont.systemFont(ofSize: CGFloat(18))
        textLabel.text = ""
        textLabel.numberOfLines = 3
        self.view.addSubview(textLabel)
        
        //例文意味
        senseTextLabel = UILabel(frame:CGRect(x: 20,y: 350,width: selfWidth-40,height: 80))
        senseTextLabel.textColor = UIColorFromRGB(0x8F8E94)
        senseTextLabel.font = UIFont.systemFont(ofSize: CGFloat(18))
        senseTextLabel.text = ""
       // senseTextLabel.
        senseTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        senseTextLabel.numberOfLines = 3
        self.view.addSubview(senseTextLabel)
        //senseTextLabe
        
        
        
        //保存ボタン
        preButton = UIButton(frame:CGRect(x: selfWidth/2-30,y: selfHeight-150,width: 60,height: 60))
        preButton.setImage(UIImage(named: "star.png"), for: UIControlState())
        preButton.addTarget(self, action: #selector(searchController.preserveWord), for: .touchUpInside)
        self.view.addSubview(preButton)
        
        //ラベル
        let wordText = UILabel(frame:CGRect(x: selfWidth/2-70,y: selfHeight-80,width: 140,height: 20))
        wordText.text = "単語カードに追加"
        wordText.textColor = UIColorFromRGB(0x8F8E94)
        self.view.addSubview(wordText)
        
        

    }
    
    func setSearchBar(){
        
        
      /*  mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.barTintColor = UIColorFromRGB(0xF8F8F8)
        mySearchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2,y: 50)
        
        // キャンセルボタンを有効にする.
        mySearchBar.showsCancelButton = true
        // ブックマークボタンを無効にする.
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.Default
        //mySearchBar.layer.cornerRadius = 10.0
        mySearchBar.prompt = ""
        mySearchBar.placeholder = "検索したい単語を入力してください"
        // カーソル、キャンセルボタンの色を設定する.
        mySearchBar.tintColor = UIColor.blueColor()
        // 検索結果表示ボタンは非表示にする.
        mySearchBar.showsSearchResultsButton = false
        // 検索バーをViewに追加する.
        self.view.addSubview(mySearchBar)*/
        
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.barTintColor = UIColorFromRGB(0xFFFFF3)
        mySearchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width*4/8,y: 50)
        
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
        //self.view.addSubview(searchBackView)
        // 検索バーをViewに追加する.
        self.view.addSubview(mySearchBar)
        
        //タイトルバー
        let navLabel:UILabel = UILabel(frame:CGRect(x: self.view.frame.size.width/3,y: 20,width: self.view.frame.size.width/3,height: 45))
        navLabel.text="単語検索"
        navLabel.textAlignment = NSTextAlignment.center
        navLabel.textColor = UIColorFromRGB(0xFF5BBE)
        navLabel.font=UIFont.boldSystemFont(ofSize: 14.0)
        self.mySearchBar.addSubview(navLabel)
        
        let backViewButton = UIButton(frame:CGRect(x: 10,y: 30,width: 30,height: 30))
        backViewButton.setImage(UIImage(named:"back.png"), for: UIControlState())
        backViewButton.addTarget(self, action: #selector(searchController.disView), for: .touchUpInside)
        self.mySearchBar.addSubview(backViewButton)
       /* mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.barTintColor = UIColorFromRGB(0xF8F8F8)
        mySearchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width*4/8,y: 50)
        
        // キャンセルボタンを有効にする.
        mySearchBar.showsCancelButton = true
        // ブックマークボタンを無効にする.
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.Default
        //mySearchBar.layer.cornerRadius = 10.0
        mySearchBar.prompt = " "
        mySearchBar.placeholder = "単語を入力してください"
        // カーソル、キャンセルボタンの色を設定する.
        mySearchBar.tintColor = UIColor.blueColor()
        // 検索結果表示ボタンは非表示にする.
        mySearchBar.showsSearchResultsButton = false
        //searchBackView.addSubview(mySearchBar)
        //self.view.addSubview(searchBackView)
        // 検索バーをViewに追加する.
        self.view.addSubview(mySearchBar)*/

        
        

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
        //gadRequest.testDevices = ["2896635ab2c5853b412e1fa7c1b95995"]
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true,animated:true)

    }

    
}

extension searchController{
    func initPopView(){
        selfLang = "en"
        langView = popView(frame:CGRect(x: self.view.frame.size.width/2-150,y: self.view.frame.size.height/2-1000,width: 300,height: 320))
        langView.delegate = self
        self.view.addSubview(langView)
        
    }
    
    func showProt(){
        if(langShow){
            self.langView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: -200)
            langShow = false
        }else{
            self.langView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2)
            langShow = true
            
        }
        
    }

    func protReturn(_ text: String) {
        self.langView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: -200)
        self.langButton.setTitle(langList[text], for: UIControlState())
        self.langButton.setTitleColor(UIColorFromRGB(colorList[text]!), for: UIControlState())
        langShow = false
        selfLang = text
        self.sayClass.lang = text
    }
    
    func preserveWord(){
      //  _mySwiftData.wordAdd(word, str2:text,lang:lang)
      //  SVProgressHUD.showSuccessWithStatus("追加しました!")
        var contText = senseLabel.text!+"\n\n例文\n\n"+textLabel.text!
        print("myWordLabel=>\(myWordLabel.text!),textLabel=>\(textLabel.text),lang=>\(selfLang)")
       // _mySwiftData.wordAdd(myWordLabel.text!, str2:contText,lang:selfLang)
        worddb.saveWord(wordw: myWordLabel.text!, mean: contText, lang: selfLang)
            SVProgressHUD.showSuccess(withStatus: "追加しました!")

    }
    
    func pronounceWord(){
        self.sayClass.Wsay(self.myWordLabel.text!)
    }
    
    func disView(){
        self.navigationController?.popViewController(animated: true)
    }


}
extension searchController{
    
    func requestWord(){
       // let Regword = RegwordP.replacingOccurrences(of: pattern2, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        // var myUrl:NSURL = NSURL(string:"http://153.120.62.197/cruster/WordGet.php")!
        // let myUrl:URL = URL(string:"http://153.120.62.197/cruster/xmlsimple221.php")!
        let pattern = "\\s";
        let replace=""
        tmpWord = tmpWord.replacingOccurrences(of: pattern, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        print("単語->\(tmpWord)")
        let encodedString = tmpWord.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(encodedString!)&lang=\(selfLang)")!
        // リクエストを生成.
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        if tmpWord != "" {
            NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main) { (response, data, erroe) in
                // 受け取ったデータのnil判定.
                if let _data = data {
                    // 帰ってきたデータを文字列に変換.
                    SVProgressHUD.show(withStatus: "単語検索中")
                    let getData: NSString = NSString(data: _data, encoding: String.Encoding.utf8.rawValue)!
                    self.getWord2(data: data)
                }
            }
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func getWord2(data:Data?){
        // 帰ってきたデータを文字列に変換.
        let json = jsonClass(data: data!)
        self.senseLabel.text = json.mean
        self.textLabel.text = json.exText
        self.senseTextLabel.text = json.transText
         SVProgressHUD.dismiss()
        /*let dataString = json.mean+"\n\n例文\n"+json.exText+"\n"+json.transText+"\n"
        var myData:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        let HTMLString:String! = dataString//myData as String
        self.htmlContents = HTMLString
        
        SVProgressHUD.dismiss()
        self.popWordView(TouchedWord, text:htmlContents)*/
    }


    
   /* func requestWord(){
        // var myUrl:NSURL = NSURL(string:"http://153.120.62.197/cruster/WordGet.php")!
        let pattern = "\\s";
        let replace=""
        tmpWord = tmpWord.replacingOccurrences(of: pattern, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        print(tmpWord)
        
        let encodedString = tmpWord.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("エンコードもじ\(encodedString)")
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(encodedString!)&lang=\(selfLang)")!
        // リクエストを生成.
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getWord as! (URLResponse?, Data?, Error?) -> Void)
         SVProgressHUD.show(withStatus: "情報取得中")
    }
    
    func getWord(_ res:URLResponse?,data:Data?,error:NSError?){
        // 帰ってきたデータを文字列に変換.
        
        if error == nil{
            
             let json = jsonClass(data: data!)
             self.senseLabel.text = json.mean
             self.textLabel.text = json.exText
             self.senseTextLabel.text = json.transText
            SVProgressHUD.dismiss()
        }else{
            print("エラー")
            SVProgressHUD.dismiss()
        }
        
    }*/

}
extension SVProgressHUD {
    
    func visibleKeyboardHeight() -> CGFloat {
        
        return 0.0
    }
}

extension searchController{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myWordLabel.text = searchText
    }
    
    /*
     Cancelボタンが押された時に呼ばれる
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        myWordLabel.text = ""
        mySearchBar.text = ""
         self.view.endEditing(true)
    }
    
    /*
     Searchボタンが押された時に呼ばれる
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.view.endEditing(true)
        searchBar.resignFirstResponder()
        myWordLabel.text = searchBar.text
        self.tmpWord = searchBar.text
        requestWord()
    }
}
