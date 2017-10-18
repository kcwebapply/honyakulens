//
//  cameraTextController.swift
//  honyakun
//
//  Created by WKC on 2016/09/07.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
class cameraTextController: UIViewController,UIWebViewDelegate,popWordProt,touchImageViewProtocol,URLSessionTaskDelegate{
    //画像
    var im:UIImage!
    var crip:Int!
    
    
    //ナビゲーションバー高さ
     var barHeight:CGFloat!
    
    //webView
    var ocrView:UIWebView!
    var webText:String! = ""
    var htmlContents:String!
    var onlyTextContents = ""
    
    //言語
    var lang:String!
    
    //単語カード
    var wordView:popWord!
    
    //保存、リクエスト周辺
    var TouchedWord = ""
    
    //swiftData
     //var _mySwiftData = MySwiftData()
    
    //発音クラス
    var sayClass:SayClass!
    
    //保存ボタン
    var preserveButton:UIBarButtonItem!
    
    //本テキスト
    var orgText:String!
    
    //パス
    var imagePath: String {
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return doc
    }

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
        let tmpImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height-60))
        tmpImageView.image = im
       // self.view.addSubview(tmpImageView)
        setSubView()
        setNabVar()
        ocrText()
    }
    
    func setNabVar(){
        // タイトルを設定する.
        self.navigationItem.title = "honyakun"
        let titleView = UILabel(frame:CGRect.zero)
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.textColor = UIColorFromRGB(0xFF5BBE)
        titleView.text = "honyakun"
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView
        
    }
    
    func setSubView(){
        
        
        //発音クラス初期化
        sayClass = SayClass(lang:lang)
        
        //戻るボタン
        var exit:UIButton!
        exit = UIButton(frame:CGRect(x: self.view.frame.size.width/10,y: self.view.frame.size.height-50,width: self.view.frame.size.width/5,height: 40))
        exit.setTitle("戻る",for:UIControlState())
        exit.addTarget(self, action: #selector(cameraTextController.disView), for: UIControlEvents.touchUpInside)
        exit.setTitleColor(UIColorFromRGB(0xFF0000), for: UIControlState())
        exit.tintColor=UIColorFromRGB(0xFF0000)
        self.view.addSubview(exit)
        
        //webView
        self.barHeight = self.navigationController?.navigationBar.frame.size.height
        ocrView = UIWebView(frame:CGRect(x: 0,y: (self.navigationController?.navigationBar.frame.size.height)!+20,width: self.view.frame.size.width,height: self.view.frame.size.height-barHeight))
        ocrView.delegate=self
        // ocrView.scalesPageToFit = true;
        ocrView.backgroundColor=UIColor.white
         SVProgressHUD.show(withStatus: "解析中")
        self.view.addSubview(ocrView)
        
        //単語View
        wordView = popWord(frame: CGRect(x: 0,y: self.view.frame.size.height+30,width: self.view.frame.size.width,height: 200),word: "",text: "",lang:lang)
        wordView.delegate = self
        self.view.addSubview(wordView)
        
        
        //navButton
        let size = CGSize(width: 20, height: 20)
        let tmpImage = UIImage(named: "new-document.png")
        let textImage = UIImage(named: "album.png")
        
        let navDocImage = resizeImage(tmpImage!,size: size)
        let textRImage = resizeImage(textImage!, size: size)
        
        //文書画像ボタン
        textImageButton = UIBarButtonItem(image:textRImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cameraTextController.slideImage))
        
        //保存ボタン
        preserveButton =  UIBarButtonItem(image:navDocImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cameraTextController.saveImage))
        
        self.navigationItem.setRightBarButtonItems([preserveButton,textImageButton], animated:true)
        
        //文書画像View
        textImageView = touchImageView(frame:CGRect(x: self.view.frame.size.width,y: (self.navigationController?.navigationBar.frame.size.height)!,width: self.view.frame.size.width,height: self.view.frame.size.height-(self.navigationController?.navigationBar.frame.size.height)!))
        textImageView.delegates = self
        textImageView.isUserInteractionEnabled = true
        textImageView.image = self.im
        self.view.addSubview(textImageView)


    }
    
    
    func popWordView(_ word:String,text:String){
        self.wordView.setProperty(word, text: text)
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
    
    func disView(){
        self.navigationController?.popViewController(animated: true)
        for subview in (self.navigationController?.navigationBar.subviews)!{
            /*if(subview == "UIButton"){
                subview.removeFromSuperview()
            }*/
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.navigationController?.navigationBar.hidden = false
        //self.navigationController?.navigationBar.backgroundColor = UIColorFromRGB(0xF8F8F8)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension cameraTextController{
    func dawnView() {
        wordView.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height+100)
    }
    
    func wordPreserve(_ word:String,text:String) {
        //_mySwiftData.wordAdd(word, str2:text,lang:lang)
        self.worddb.saveWord(wordw: word,mean: text,lang: lang)
        SVProgressHUD.showSuccess(withStatus: "追加しました!")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        SVProgressHUD.dismiss()
        
        let kScheme = "native://";
        let url = request.url!.absoluteString
        //  println("aiueo")
        if url.hasPrefix(kScheme) {
            // Do something
            // println("翻訳取得開始")
            dealRequest(request)
            return false  // ページ遷移を行わないようにfalseを返す
        }
        
        
        return true
    }
    
    func dealRequest(_ request:URLRequest){
        if request.url!.host=="requestGo"{
            //self.Target = "word"
            SVProgressHUD.show(withStatus: "単語取得中")
            //requestWord(request.url!.path);
            requestGo(request.url!.path)
        }else if request.url!.host=="requestText"{
            requestText(request.url!.path);
            SVProgressHUD.show(withStatus: "翻訳中")
        }
    }
    
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
    
   /* func requestText(_ url:String){
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
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        self.TouchedWord = tmpWord
        NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getText as! (URLResponse?, Data?, Error?) -> Void)
        
    }*/
    



    func requestGo(_ url:String){
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

 
    func requestWord(_ url:String){
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
    
    func getText(data:Data){
        // 帰ってきたデータを文字列に変換.
            let myData:NSString = NSString(data:data, encoding: String.Encoding.utf8.rawValue)!
            let HTMLString:String! = myData as String//myData as String
            self.htmlContents = HTMLString
            SVProgressHUD.dismiss()
            self.popWordView(TouchedWord, text:htmlContents)
        
    }
    

}

extension cameraTextController{

    /*
     通信終了時に呼び出されるデリゲート.
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("didCompleteWithError")
        
        // エラーが有る場合にはエラーのコードを取得.
       // print(error?.code)
    }
    

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        print("didSendBodyData")
        
    }
    
    /*/*
     通信が終了したときに呼び出されるデリゲート.
     */
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        // バックグラウンドだとUIの処理が出来ないので、メインスレッドでUIの処理を行わせる.
        dispatch_async(dispatch_get_main_queue(), {
            print(myData)
        })
        
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession")
        
        // バックグラウンドからフォアグラウンドの復帰時に呼び出されるデリゲート.
    }*/
    
      func ocrText(){
        /* net =  Net(baseUrlString: "http://153.126.180.38/camerakun/api/ocr/parameters?lang=\(self.lang)")

        //送信先のpostを設定する
        let url = "/post"
        
        let params = ["gazo": NetData(jpegImage: self.im!, compressionQuanlity:0.9,filename: "imagev.jpg"),"cripped":1] as [String : Any]
        
        net.POST(url, params: params as NSDictionary?, successHandler: {
            responseData in
            let data = responseData.data
            do{
                 print("始まり")
                let json:NSDictionary = try JSONSerialization.jsonObject(with: data,
                    options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                 print("辞書生成")
                var str = json["content"] as! String
                self.orgText = json["org"] as! String
                print(self.orgText)
                 print("値抽出")
                str = self.convertSpecialCharacters(str)
                 print("文字変換")
                self.OcrView(str)
            }catch{
                SVProgressHUD.dismiss()
                 self.ocrView.loadHTMLString("画像の解析に失敗しました。お手数ですが、再度撮影仕直しいただくようお願いいたします。", baseURL: nil)
                print("だめみたいですね")
                print(error)
            }
            }, failureHandler: { error in
                print(error)
                SVProgressHUD.dismiss()
                self.ocrView.loadHTMLString("ネットが繋がっていません", baseURL: nil)
        })*/
        
        let img = self.im//UIImage(named: "image.jpg")!
        //print("http://153.126.180.38/camerakun/api/ocr/parameters?lang=\(self.lang!)")
        let url  = URL(string:"http://153.126.180.38/camerakun/api/ocr/parameters?lang=\(self.lang!)/post")
        //let url2 = URL(string:"http://153.120.62.197/cruster/tesorgNEO.php/post")
       // print("\(url):\(url2)")
        let headers = HTTPHeaders.init()
        let reqs = try! URLRequest(url: url!, method: .post, headers: headers)
        let parameters = ["text":"I like sushi"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let fileData = UIImageJPEGRepresentation(img!, 1.0)
            multipartFormData.append(fileData!, withName: "gazo", fileName: "imagev.jpg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, with:reqs,encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    var data = response.data
                    do{
                        let json:NSDictionary = try JSONSerialization.jsonObject(with: data!,
                                                                                 options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        var str = json["content"] as! String
                        var org = json["org"] as! String
                        self.onlyTextContents = org
                        str = self.convertSpecialCharacters(str)
                        self.OcrView(str)
                    }catch{
                        self.OcrView("解析に失敗しました。撮影環境を変えて撮影してみてください。")
                        SVProgressHUD.dismiss()
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        })
    }
    
    
    func OcrView(_ text:String){
        self.webText = text
        self.ocrView.loadHTMLString(text, baseURL: nil)
        SVProgressHUD.dismiss()
    }
    
    
    func convertSpecialCharacters(_ string: String) -> String {
        var newString = string
        let char_dictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.regularExpression, range: nil)
        }
        return newString
    }
}


extension cameraTextController{
    func saveImage(){
        
        var titleText=""
        //日付を取得し、ファイル名を獲得
        let image = self.im
        let data = UIImageJPEGRepresentation(image!, 1.0)
        let now = Date() // 現在日時の取
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var comps = (0, 0, 0, 0)
        (calendar as NSCalendar).getEra(&comps.0, year: &comps.1, month: &comps.2, day: &comps.3,from:now)
        var comps2 = (0,0,0,0)
        (calendar as NSCalendar).getHour(&comps2.0, minute: &comps2.1, second: &comps2.2, nanosecond: &comps2.3, from: now)
        let str = "\(comps.0)\(comps.1)\(comps.2)\(comps.3)\(comps2.0)\(comps2.1)\(comps2.2)\(comps2.3).png"
        //
        let filepath:String! = URL(fileURLWithPath:imagePath).appendingPathComponent(str).path
        
        let myAlert: UIAlertController = UIAlertController(title: "保存", message: "解析結果を保存します。", preferredStyle: .alert)
        
        // OKのアクションを作成する.
        //let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in}
        let myOkAction:UIAlertAction = UIAlertAction(title: "OK",
                                                     style: UIAlertActionStyle.default,
                                                     handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        let textFields:Array<UITextField>? =  myAlert.textFields as Array<UITextField>?
                                                        if textFields != nil {
                                                            for textField:UITextField in textFields! {
                                                                //各textにアクセス
                                                                titleText = textField.text!
                                                                try? data!.write(to: URL(fileURLWithPath: filepath), options: [.atomic])
                                                                //self._mySwiftData.addText(str, title:titleText,text: self.webText!,lang:self.lang)
                                                               // imagedb.addText(str,title:titleText,text:self.webText!,lang:self.lang)
                                                                self.imagedb.addImage(name: str, title: titleText, text: self.webText!, lang: self.lang)
                                                            
                                                                self.orgdb.addImage(name: str, title: titleText, text: self.onlyTextContents,lang:self.lang)
                                                                //self._mySwiftData.addOrgText(str,title:titleText,text:self.orgText!,lang: self.lang)
                                                                //self._mySwiftData.
                                                                SVProgressHUD.showSuccess(withStatus: "保存完了!")
                                                                
                                                                
                                                            }
                                                        }
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        //SVProgressHUD.showSuccessWithStatus("保存完!")
                                                        
        })
        
        
        // OKのActionを追加する.
        myAlert.addAction(myOkAction)
        myAlert.addAction(cancelAction)
        myAlert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "first textField"
        })
        
        // UIAlertを発動する.
        present(myAlert, animated: true, completion: nil)

    }
    
    func slideImage(){
        popImageView()
    }
    
    func popImageView(){
        
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
                    print("ああああ")
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

