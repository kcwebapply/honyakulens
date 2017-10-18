//
//  wordOCR.swift
//  honyakun
//
//  Created by WKC on 2016/10/04.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire

class wordOcrController: UIViewController,UIWebViewDelegate,popViewProt,popWordProt{
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    //画像
    var im:UIImage!
    //テキスト
    var onlyTextContets:String! = ""
    
    //swiftData
//    var _mySwiftData = MySwiftData()

    
    //発音周り
    var sayClass:SayClass!
    var megaButton:UIButton!
    
    //webView
    var ocrView:UIWebView!
    var htmlContents:String!
    
    //touchedWord
    var TouchedWord:String!
    
    //単語カード
    var wordView:popWord!
    
    //db
    var worddb = wordDB()
    var textdb = textDB()
    var imagedb = imageDB()
    var exdb = ExCheckDB()
    var iddb = IDCheckDB()



    
    //言語
    var langButton:UIButton!
    var lang:String = "en"
    var langView:popView!
    var selfLang:String = "en"
    var langShow:Bool = false
    var langList:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]


    
    //撮影周り
    var pictButton:UIButton!
    //net周辺
   // var net = Net(baseUrlString: "http://153.120.62.197/cruster/tesorgNEO.php")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromRGB(0xFFFFF3)
        setCamera()
        setSubView()
        initPopView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



extension wordOcrController{
    
    func setSubView(){
        self.selfLang = "en"
        pictButton = UIButton(frame:CGRect(x: self.view.frame.size.width/2-20,y: self.view.frame.size.height-50,width: 40,height: 40))
        pictButton.setImage(UIImage(named:"camera.png"), for: UIControlState())
        pictButton.addTarget(self, action: #selector(wordOcrController.takePicture), for: .touchUpInside)
        self.view.addSubview(pictButton)
        var navHeight = self.navigationController?.navigationBar.frame.size.height
        langButton = UIButton(frame:CGRect(x: self.view.frame.size.width-100,y: self.view.frame.size.height/2+30,width: 100,height: 40))
        langButton.setTitle("言語選択", for: UIControlState())
        langButton.setTitleColor(UIColorFromRGB(0x69AEFC), for: UIControlState())
        langButton.addTarget(self, action: #selector(wordOcrController.showProt), for: .touchUpInside)
        self.view.addSubview(langButton)
        sayClass = SayClass(lang:"en")
        
        
        //webView
        ocrView = UIWebView(frame:CGRect(x: 5,y: self.view.frame.size.height/2+70,width: self.view.frame.size.width-10,height: self.view.frame.size.height/2-150))
        ocrView.layer.borderColor = UIColorFromRGB(0xDDDDDD).cgColor
        ocrView.layer.borderWidth = 1
        ocrView.delegate=self
        // ocrView.scalesPageToFit = true;
        ocrView.backgroundColor=UIColor.white
        self.view.addSubview(ocrView)
        
        //単語View
        wordView = popWord(frame: CGRect(x: 0,y: self.view.frame.size.height+20,width: self.view.frame.size.width,height: 200),word: "",text: "",lang:selfLang)
        wordView.delegate = self
        self.view.addSubview(wordView)
        
        let titleView = UILabel(frame:CGRect.zero)
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.textColor = UIColorFromRGB(0xFF5BBE)
        titleView.text = "文書解析"
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView

        


    }
    
    
    func setCamera(){
        mySession = AVCaptureSession()
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices!{
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        var videoInput:AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device:myDevice)
            mySession.addInput(videoInput)
            //mySession.addInput(videoInput)
        }catch{
            
        }
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:mySession) as AVCaptureVideoPreviewLayer
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        myVideoLayer.frame = CGRect(x: 10,y: navHeight!,width: self.view.frame.size.width-20, height: self.view.frame.size.height/2-navHeight!+20)
        
        //self.navigationController!.navigationBar.bounds.size.height
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
    }
}



extension wordOcrController{
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

}


extension wordOcrController{
    func takePicture(){
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            self.im=UIImage(data:myImageData)
            self.pictButton.isEnabled = false
            self.ocrText()
        })
        
    }
    

    
    func ocrText(){
         SVProgressHUD.show(withStatus: "解析中")
        let img = self.im//UIImage(named: "image.jpg")!
        let url = URL(string:"http://153.126.180.38/camerakun/api/ocr/parameters?lang=\(self.lang)")//URL(string:"http://153.120.62.197/cruster/tesorgNEO.php/post")
        let headers = HTTPHeaders.init()
        let reqs = try! URLRequest(url: url!, method: .get, headers: headers)
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
                        self.onlyTextContets = org
                        str = self.convertSpecialCharacters(str)
                        self.OcrView(str)
                    }catch{
                        self.OcrView("解析に失敗しました。撮影環境を変えて撮影してみてください。")
                        SVProgressHUD.dismiss()
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                self.pictButton.isEnabled = true
                self.pictButton.alpha = 1.0
                SVProgressHUD.dismiss()

            }
            
        })

        /*net =  Net(baseUrlString: "http://153.126.180.38/camerakun/api/ocr/parameters?lang=\(self.selfLang)")
        
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
                str = self.convertSpecialCharacters(str)
                self.OcrView(str)
                
            }catch{
                self.pictButton.isEnabled = true
                print("だめみたいですね")
                SVProgressHUD.dismiss()
                self.pictButton.alpha = 1.0
                print(error)
            }
            }, failureHandler: { error in
                self.pictButton.isEnabled = true
                print(error)
                self.pictButton.alpha = 1.0
                SVProgressHUD.dismiss()
             
        })*/
        
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
            requestWord(request.url!.path);
        }else if request.url!.host=="requestText"{
            
            SVProgressHUD.show(withStatus: "翻訳中")
            requestText(request.url!.path);
        }
    }
    
    func requestWord(_ url:String){
        //単語のパスを処理する。
        let urls:[String] = url.components(separatedBy: "/")
        let num = (urls.count)-1
        let word = urls[num];
        let encodedString = word.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/WordGet/parameters?word=\(encodedString!)&lang=\(self.selfLang)")!
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        
        
        
        myRequest.httpMethod="GET"

        self.TouchedWord=word//Regword
        NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getWord as! (URLResponse?, Data?, Error?) -> Void)
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
        let myUrl:URL = URL(string:"http://153.126.180.38/camerakun/api/TextTranslate/parameters?text=\(encodedString!)&lang=\(self.selfLang)")!
        print("\(encodedString)=>言語：\(self.selfLang)")
        let myRequest:NSMutableURLRequest  = NSMutableURLRequest(url: myUrl)
        myRequest.httpMethod="GET"
        self.TouchedWord = tmpWord
        NSURLConnection.sendAsynchronousRequest(myRequest as URLRequest, queue: OperationQueue.main, completionHandler: self.getText as! (URLResponse?, Data?, Error?) -> Void)
        
    }
    
    func getText(_ res:URLResponse?,data:Data?,error:NSError?){
        // 帰ってきたデータを文字列に変換.
        if error == nil{
            
            let myData:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let HTMLString:String! = myData as String//myData as String
            self.htmlContents = HTMLString
            print("翻訳結果=>\(self.htmlContents)")
            SVProgressHUD.dismiss()
            self.popWordView(TouchedWord, text:htmlContents)
        }else{
            //self.PopWordError()
            print("エラー")
            SVProgressHUD.dismiss()
        }
        
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
    
    func OcrView(_ text:String){
        //self.webText = text
        self.pictButton.isEnabled = true
        self.ocrView.loadHTMLString(text, baseURL: nil)
    }

    
    func dawnView() {
        wordView.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height+100)
        
    }
    
      
    func disView(){
        self.navigationController?.popViewController(animated: true)
        for subview in (self.navigationController?.navigationBar.subviews)!{
            /*if(subview == "UIButton"){
                subview.removeFromSuperview()
            }*/
                   }
    }
    
    func wordPreserve(_ word:String,text:String) {
       // _mySwiftData.wordAdd(word, str2:text,lang:selfLang)
        worddb.saveWord(wordw: word, mean: text, lang: selfLang)
        SVProgressHUD.showSuccess(withStatus: "追加しました!")
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
