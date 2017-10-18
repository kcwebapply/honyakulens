//
//  textViewController.swift
//  honyakun
//
//  Created by WKC on 2016/09/19.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation


import UIKit

class textViewController: UIViewController,UIWebViewDelegate,popWordProt,touchImageViewProtocol {
    
    //画像
    var im:UIImage!
    var crip:Int!
    
    //net周辺
   // var net = Net(baseUrlString: "http://153.120.62.197/cruster/tesorgNEO.php")
    
    //ナビゲーションバー高さ
    var barHeight:CGFloat!
    
    //webView
    var ocrView:UIWebView!
    var webText:String! = ""
    var htmlContents:String!
    
    //言語
    var lang:String!
    
    //単語カード
    var wordView:popWord!
    
    //保存、リクエスト周辺
    var TouchedWord = ""
    
    //swiftData
   // var _mySwiftData = MySwiftData()
    
    //発音クラス
    var sayClass:SayClass!
    
    //タイトル
    var textTitle:String!
    
    //文書画像周り
    var textImageView:touchImageView!
    var textImageButton:UIBarButtonItem!
    var textImageViewFlag:Bool = false
    
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var orgdb = orgTextDB()
    var iddb = IDCheckDB()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFFFF3)
        self.setSubView()
        self.setWebView()
        self.setnavBar()
    }
    
    func setSubView(){        
        //発音クラス初期化
        sayClass = SayClass(lang:lang)
        //webView
        self.barHeight = self.navigationController?.navigationBar.frame.size.height
        ocrView = UIWebView(frame:CGRect(x: 0,y: barHeight,width: self.view.frame.size.width,height: self.view.frame.size.height-barHeight))
        ocrView.delegate=self
        ocrView.backgroundColor=UIColorFromRGB(0xFFFFFF)
        self.view.addSubview(ocrView)
        
        //単語View
        wordView = popWord(frame: CGRect(x: 0,y: self.view.frame.size.height+40,width: self.view.frame.size.width,height: 200),word: "",text: "",lang:lang)
        wordView.delegate = self
        self.view.addSubview(wordView)
        
    }
    
    func setWebView(){
        self.ocrView.loadHTMLString(webText, baseURL: nil)
    }
    
    func setnavBar(){
        let titleView = UILabel(frame:CGRect.zero)
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.textColor = UIColorFromRGB(0xFF5BBE)
        titleView.text = textTitle
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView
        
        //navButton
        let size = CGSize(width: 20, height: 20)
        let tmpImage = UIImage(named: "new-document.png")
        let textImage = UIImage(named: "album.png")
        
        let navDocImage = resizeImage(tmpImage!,size: size)
        let textRImage = resizeImage(textImage!, size: size)
        //文書画像ボタン
        textImageButton = UIBarButtonItem(image:textRImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(textViewController.slideImage))
        self.navigationItem.setRightBarButton(textImageButton, animated:true)
        
        //文書画像View
        textImageView = touchImageView(frame:CGRect(x: self.view.frame.size.width,y: (self.navigationController?.navigationBar.frame.size.height)!,width: self.view.frame.size.width,height: self.view.frame.size.height))
        textImageView.delegates = self
        textImageView.isUserInteractionEnabled = true
        textImageView.image = self.im
        self.view.addSubview(textImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//単語周り
extension textViewController{

    func dawnView() {
        wordView.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height+100)
    }
    
    func wordPreserve(_ word:String,text:String) {
        //_mySwiftData.Cadd(word, str2:text)
         //_mySwiftData.wordAdd(word, str2:text,lang:lang)
        worddb.saveWord(wordw: word, mean: text, lang: lang)
        SVProgressHUD.showSuccess(withStatus: "追加しました!")
    }

        
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            SVProgressHUD.dismiss()
            
            let kScheme = "native://";
            let url = request.url!.absoluteString
            //  println("aiueo")
            if url.hasPrefix(kScheme) {
                dealRequest(request)
                return false  // ページ遷移を行わないようにfalseを返す
        }
            
            
            return true
        }
        
    func dealRequest(_ request:URLRequest){
            if request.url!.host=="requestGo"{
                //self.Target = "word"
                SVProgressHUD.show(withStatus: "単語取得中")
                requestWord(request.url!.path);
            }else if request.url!.host=="requestText"{
                 requestText(request.url!.path);
                SVProgressHUD.show(withStatus: "翻訳中")
            }
    }
        
   /* func requestWord(_ url:String){
            //単語のパスを処理する。
            let urls:[String] = url.components(separatedBy: "/")
            let num = (urls.count)-1
            let word = urls[num];
            let encodedString = word.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(encodedString!)&lang=\(self.lang!)")!
            // var myUrl:NSURL = NSURL(string:"http://153.120.62.197/cruster/WordGet.php")!
            //var myUrl:NSURL = NSURL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(word)&lang=\(self.lang)")!
            // リクエストを生成.
            let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
            
            
            
            myRequest.httpMethod="GET"
            
            //  if Regword != "" {
            //   print("okok")
            self.TouchedWord=word//Regword
            NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getWord as! (URLResponse?, Data?, Error?) -> Void)
            /*  }else{
             SVProgressHUD.dismiss()
             }*/
    }
        
        
        
    func getWord(_ res:URLResponse?,data:Data?,error:NSError?){
            // 帰ってきたデータを文字列に変換.
            if error == nil{
                
                let json = jsonClass(data: data!)
                let dataString = json.mean+"\n\n例文\n"+json.exText+"\n"+json.transText+"\n"
                var myData:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                let HTMLString:String! = dataString//myData as String
                self.htmlContents = HTMLString
                SVProgressHUD.dismiss()
                self.popWordView(TouchedWord, text:htmlContents)
            }else{
                //self.PopWordError()
                print("エラー")
                SVProgressHUD.dismiss()
            }
            
    }
    
    func requestText(_ url:String){
        //単語のパスを処理する。
        let urls:[String] = url.components(separatedBy: "/")
        let num = (urls.count)-1
        let word = urls[num];
        
        let pattern = "\\<\\/br\\>|\\\n|\\<br\\>|br\\>";
        let replace=""
        let tmpWord = word.replacingOccurrences(of: pattern, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        print("文章ね\(tmpWord)")
        let encodedString = tmpWord.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/TextTranslate/parameters?text=\(encodedString!)&lang=\(self.lang!)")!
      //  print("\(encodedString)=>言語：\(self.lang)")
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        self.TouchedWord = tmpWord
        NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getText as! (URLResponse?, Data?, Error?) -> Void)
        
    }*/
    
    func requestText(_ url:String){
        let urls:[String] = url.components(separatedBy: "/")
        let num = (urls.count)-1
        let word = urls[num];
        //正規表現で邪魔な記号をとる
        let pattern = "\\<\\/br\\>|\\\n|\\<br\\>|br\\>";
        let replace=""
        let RegwordP = word.replacingOccurrences(of: pattern, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        //let myUrl:URL = URL(string:"http://153.120.62.197/cruster/TextGet.php")!
        //let encodedString = RegwordP.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let encodeString = RegwordP.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        print("\(encodeString)")
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/TextTranslate/parameters?text=\(encodeString!)&lang=\(self.lang!)")!
        // リクエストを生成.
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        if RegwordP != "" {
            self.TouchedWord=RegwordP
            
            // 送信処理を始める.
            NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main) { (response, data, erroe) in
                
                // 受け取ったデータのnil判定.
                if let _data = data {
                    // 帰ってきたデータを文字列に変換.
                    let getData: NSString = NSString(data: _data, encoding: String.Encoding.utf8.rawValue)!
                    //self.getWord2(data: data)
                    self.getText(data: data!)
                }
            }
            
        }else{
            
            SVProgressHUD.dismiss()
        }
    }
    
    func requestWord(_ url:String){
        let urls:[String] = url.components(separatedBy: "/")
        let num = (urls.count)-1
        let word = urls[num];
        
        //正規表現で邪魔な記号をとる
        let pattern = "\\<\\/br\\>|\\\n|\\<br\\>|br\\>";
        let replace=""
        let RegwordP = word.replacingOccurrences(of: pattern, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        
        let pattern2 = "[^a-zA-Z0-9]+";
        // let replace2=""
        let Regword = RegwordP.replacingOccurrences(of: pattern2, with:replace, options:NSString.CompareOptions.regularExpression, range:nil)
        // var myUrl:NSURL = NSURL(string:"http://153.120.62.197/cruster/WordGet.php")!
        // let myUrl:URL = URL(string:"http://153.120.62.197/cruster/xmlsimple221.php")!
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(Regword)&lang=\(self.lang!)")!
        // リクエストを生成.
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        if Regword != "" {
            self.TouchedWord=Regword
            NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main) { (response, data, erroe) in
                // 受け取ったデータのnil判定.
                if let _data = data {
                    // 帰ってきたデータを文字列に変換.
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
        let dataString = json.mean+"\n\n例文\n"+json.exText+"\n"+json.transText+"\n"
        var myData:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        let HTMLString:String! = dataString//myData as String
        self.htmlContents = HTMLString
        
        SVProgressHUD.dismiss()
        self.popWordView(TouchedWord, text:htmlContents)
    }

    
    func getText(data:Data?){
        // 帰ってきたデータを文字列に変換.
            let myData:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let HTMLString:String! = myData as String//myData as String
            self.htmlContents = HTMLString
            print("翻訳結果=>\(self.htmlContents)")
            SVProgressHUD.dismiss()
            self.popWordView(TouchedWord, text:htmlContents)

        
    }
    

    
    func popWordView(_ word:String,text:String){
        self.wordView.setProperty(word, text: text)
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
    
    func slideImage(){
        popImageView()
    }
    
    
    func popImageView(){
        print("なぜだよ")
        if(self.textImageViewFlag == false){
            //アニメーション
            UIView.animate(withDuration: 0.5,
                                       
                                       // 遅延時間.
                delay: 0.0,
                
                // バネの弾性力. 小さいほど弾性力は大きくなる.
                usingSpringWithDamping: 0.8,
                
                // 初速度.
                initialSpringVelocity: 0.5,
                
                // 一定の速度.
                options: UIViewAnimationOptions.curveLinear,
                
                animations: { () -> Void in
                    
                    self.textImageView.layer.position = CGPoint(x: self.view.frame.size.width/2+80, y: (self.navigationController?.navigationBar.frame.size.height)!+self.view.frame.size.height/2)
                    self.textImageViewFlag = true
                    
                    // アニメーション完了時の処理
            }) { (Bool) -> Void in
                
            }
        }else{
            
            self.textImageView.layer.position = CGPoint(x: self.view.frame.size.width+2000, y: (self.navigationController?.navigationBar.frame.size.height)!+self.view.frame.size.height/2);
            self.textImageViewFlag = false
        }
    }
    
    func textImageTouched() {
        popImageView()
    }
    
    
    func resizeImage(_ image:UIImage,size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size,false,0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
        
    }

}



