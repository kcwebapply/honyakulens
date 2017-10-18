//
//  cameraEdicController.swift
//  honyakun
//
//  Created by WKC on 2016/09/04.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

import UIKit

class cameraEditController: UIViewController,CDLabel,popViewProt {
    //基本UI
    var image:UIImage!
    var backImageView:UIImageView!
    var cropButton:UIButton!
    
    //二値化変数
    var nImage:UIImage!
    var nitiFlag = 1
    
    //一時画像
    var myView:UIView!
    var SeleButton:UIButton!
    var checkIV:UIImageView!
    
    //クロップ
    var cView:UIView!
    var trimImage:UIImage!
    var myLabel: CuLabel!
    var my2Label:CuLabel!
    var myTLabel:CuLabel!
    var myFLabel:CuLabel!
    var view2:UIImageView!
    var vf = 1
    var trFlag=1
    var stHeight:CGFloat = 0
    var navHeight:CGFloat=0
    
    //popView
    var langView:popView!
    var langShow:Bool = false
    var langList:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]
    var selfLang = ""
    
    //選択ボタン
    var select:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        initCu()
        initPopView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initPopView(){
        selfLang = "en"
        langView = popView(frame:CGRect(x: self.view.frame.size.width/2-150,y: self.view.frame.size.height/2-1000,width: 300,height: 320))
        langView.delegate = self
        self.view.addSubview(langView)
        
    }
    
    func protReturn(_ text: String) {
        self.langView.layer.position = CGPoint(x: self.view.frame.size.width/2,y: -200)
        self.select.setTitle(langList[text], for: UIControlState())
        self.select.setTitleColor(UIColorFromRGB(colorList[text]!), for: UIControlState())
        langShow = false
        selfLang = text
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
    
    
    
    
    func setSubViews(){
        
        self.view.backgroundColor = UIColorFromRGB(0xFFFFF3)
        //画像
        self.backImageView = UIImageView(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height-60))
        backImageView.image = image
        self.view.addSubview(backImageView)
        
        //クロッピング
        let bim = UIButton()
        let cropImage = UIImage(named:"cropTool.png")
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        cropImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bim.setImage(resizeImage, for: UIControlState())
        //bim.addTarget(self, action: "cropping", forControlEvents: .TouchUpInside)
        bim.addTarget(self, action: #selector(cameraEditController.cropping), for: .touchUpInside)
        bim.frame=CGRect(x: self.view.frame.size.width-46,y: self.view.frame.size.height-46,width: 32,height: 32)
        self.view.addSubview(bim)
        
        //閉じるボタン
        let size2 = CGSize(width: 32, height: 32)
        var exit:UIButton!
        exit = UIButton(frame:CGRect(x: 10,y: self.view.frame.size.height-50,width: self.view.frame.size.width/6,height: 40))
        exit.addTarget(self, action: #selector(cameraEditController.disView), for: UIControlEvents.touchUpInside)
        let exitImage = UIImage(named:"back.png")
        UIGraphicsBeginImageContextWithOptions(size2,false,0.0)
        exitImage!.draw(in: CGRect(x: 0, y: 0, width: size2.width, height: size2.height))
        let resizeImageV = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        exit.setImage(resizeImageV, for: UIControlState())
        self.view.addSubview(exit)
        
        //二値化ボタン
        let sirokuro = UIButton()
        let siroIm = UIImage(named:"niti.png")
        UIGraphicsBeginImageContextWithOptions(size2,false,0.0)
        siroIm!.draw(in: CGRect(x: 0, y: 0, width: size2.width, height: size2.height))
        let resizeImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        sirokuro.setImage(resizeImage2, for: UIControlState())
        sirokuro.addTarget(self, action: #selector(cameraEditController.nitika), for: .touchUpInside)
        sirokuro.frame=CGRect(x: self.view.frame.size.width-98,y: self.view.frame.size.height-48,width: 36,height: 36)
        self.view.addSubview(sirokuro)
        
        //決定ボタン
        
        let decisionButton = UIButton(frame:CGRect(x: self.view.frame.size.width/6+20,y: self.view.frame.size.height-50,width: self.view.frame.size.width/6,height: 40))
        decisionButton.addTarget(self, action: #selector(cameraEditController.selectImage), for: .touchUpInside)
       // decisionButton.backgroundColor = UIColor.redColor()
        decisionButton.setTitle("決定", for: UIControlState())
        decisionButton.setTitleColor(UIColorFromRGB(0xFF5BBE), for: UIControlState())
        self.view.addSubview(decisionButton)
        
        //言語選択ボタン
        select = UIButton(frame:CGRect(x: self.view.frame.size.width/3+20,y: self.view.frame.size.height-50,width: 100,height: 40))
        //select.backgroundColor = UIColor.redColor()
        select.setTitle("言語", for: UIControlState())
        select.setTitleColor(UIColorFromRGB(0xFF5BBE), for: UIControlState())
        select.addTarget(self, action: #selector(cameraEditController.showProt), for: .touchUpInside)
        self.view.addSubview(select)

        
    }
    
    func selectImage(){
        let storyboard = UIStoryboard(name: "cameraTextController", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "cameraTextController") as! cameraTextController
       // let rightViewController = storyboard.instantiateViewControllerWithIdentifier("ImageGet") as! ImageGet
        
        self.checkIV = UIImageView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height-40))
        checkIV.image = self.image
        mainViewController.lang = selfLang
        
        
        if nitiFlag == 1{
            if(self.trFlag==2){
                self.resizeImage()
                mainViewController.im=self.trimImage
                mainViewController.crip=1
               /* rightViewController.im=self.image
                rightViewController.vw = self.cView
                rightViewController.checker=1*/
            }else{
                mainViewController.im=self.image
                mainViewController.crip=0
               /* rightViewController.im=self.image
                rightViewController.checker=2*/
            }
        }else{
            if(self.trFlag==2){
                //println(self.cView.frame)
                self.resizeImage()
                mainViewController.im=self.trimImage
                mainViewController.crip=1
                /*rightViewController.im=self.nImage
                rightViewController.vw = self.cView
                rightViewController.checker=1*/
            }else{
                mainViewController.im=self.nImage
                mainViewController.crip=0
                /*rightViewController.im=self.nImage
                rightViewController.checker=2*/
            }
        }
        
     /*   var secondView : back = back(mainViewController:mainViewController, rightMenuViewController:rightViewController)
        secondView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical*/
        
        //self.presentViewController(secondView, animated: true, completion: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    func cropping(){
        if(self.trFlag==1){
            self.view.addSubview(cView)
            self.trFlag=2
        }else{
            self.cView.removeFromSuperview()
            self.trFlag=1
        }
    }
    
    func nitika(){
        if nitiFlag == 1{
            self.nImage = TestOpenCV.onAdaptive(self.image)
            self.backImageView.image = self.nImage
            nitiFlag = 2
        }else{
            self.backImageView.image = self.image
            nitiFlag = 1
        }
    }

    
    func disView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func UIColorFromRGBA(_ rgbValue: UInt,alpha:Float) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}





extension cameraEditController{
    
    
    func initCu(){
        cView = UIView(frame:CGRect(x: 0,y: 0+1,width: 200,height: 400))
        cView.layer.borderColor = UIColorFromRGB(0xFF3366).cgColor
        cView.layer.borderWidth=2.0
        cView.backgroundColor=UIColorFromRGBA(0xCCCCCC,alpha:0.3)
        
        myLabel = CuLabel()
        myLabel.frame=CGRect(x: -20, y: -20, width: 40, height: 40)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.backgroundColor = UIColorFromRGB(0x1AFAFF)
        myLabel.layer.masksToBounds = true
        myLabel.tag = 1
        myLabel.layer.cornerRadius = 10.0
        myLabel.delegate = self
        
        my2Label = CuLabel()
        my2Label.frame=CGRect(x: -20, y: 380, width: 40, height: 40)
        my2Label.textAlignment = NSTextAlignment.center
        my2Label.backgroundColor = UIColorFromRGB(0xFF33FF)
        my2Label.layer.masksToBounds = true
        my2Label.tag = 2
        my2Label.layer.cornerRadius = 10.0
        my2Label.delegate = self
        
        myTLabel = CuLabel()
        myTLabel.frame=CGRect(x: 180, y: 380, width: 40, height: 40)
        myTLabel.textAlignment = NSTextAlignment.center
        myTLabel.backgroundColor = UIColorFromRGB(0x1AFAFF)
        myTLabel.layer.masksToBounds = true
        myTLabel.tag = 3
        myTLabel.layer.cornerRadius = 10.0
        myTLabel.delegate = self
        
        myFLabel = CuLabel()
        myFLabel.frame=CGRect(x: 180, y: -20, width: 40, height: 40)
        myFLabel.textAlignment = NSTextAlignment.center
        myFLabel.backgroundColor = UIColorFromRGB(0xFF33FF)
        myFLabel.layer.masksToBounds = true
        myFLabel.tag = 4
        myFLabel.layer.cornerRadius = 10.0
        myFLabel.delegate = self
        
        // Labelをviewに追加.
        self.cView.addSubview(myLabel)
        self.cView.addSubview(my2Label)
        self.cView.addSubview(myTLabel)
        self.cView.addSubview(myFLabel)
        cView.tag=100
        //self.view.addSubview(cView)
        
    }
    
    func getLabel(_ label: CuLabel) {
        if(label.tag==1){
            myLabel.backgroundColor=UIColorFromRGB(0x1AFAFF)
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    //self.myLabel.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    self.myLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    // 縮小用アフィン行列を作成する.
                    self.myLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (Bool) -> Void in
            })
            
        }else if(label.tag==2){
            my2Label.backgroundColor=UIColorFromRGB(0xFF33FF)
            
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    //self.my2Label.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    self.my2Label.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    // 縮小用アフィン行列を作成する.
                    self.my2Label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (Bool) -> Void in
            })
            
            
        }else if(label.tag==3){
            // print("3")
            myTLabel.backgroundColor=UIColorFromRGB(0x1AFAFF)
            
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    //self.myTLabel.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    self.myTLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    // 縮小用アフィン行列を作成する.
                    self.myTLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (Bool) -> Void in
            })
            
        }else if(label.tag==myFLabel.tag){
            
            //print("4")
            myFLabel.backgroundColor=UIColorFromRGB(0xFF33FF)
            
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    //self.myFLabel.transform = CGAffineTransformMakeScale(0.9, 0.9)
                    self.myFLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    // 縮小用アフィン行列を作成する.
                    self.myFLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (Bool) -> Void in
            })
            
            
            
        }
        
    }
    
    func touchTrans(_ label:CuLabel){
        // print("delegateされてるね")
        if(label.tag==1){
            // print("1")
            myLabel.backgroundColor=UIColor.red
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    self.myLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: { (Bool) -> Void in
            })
            
        }else if(label.tag==2){
            // print("2")
            my2Label.backgroundColor=UIColor.red
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    self.my2Label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: { (Bool) -> Void in
            })
            
            
        }else if(label.tag==3){
            //  print("3")
            myTLabel.backgroundColor=UIColor.red
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    self.myTLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: { (Bool) -> Void in
            })
            
        }else if(label.tag==myFLabel.tag){
            //  print("4")
            myFLabel.backgroundColor=UIColor.red
            UIView.animate(withDuration: 0.06,
                                       // アニメーション中の処理.
                animations: { () -> Void in
                    // 縮小用アフィン行列を作成する.
                    self.myFLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: { (Bool) -> Void in
            })
            
            
            
        }
    }
    
    
    func moveTrans(_ label: CuLabel, lpoint: CGPoint, ppoint: CGPoint) {
        //ずれの範囲
        let deltaX = lpoint.x-ppoint.x
        let deltaY = lpoint.y-ppoint.y
        
        var myFrame: CGRect = self.cView.frame
        
        //ずれたあとのオリジン
        
        if(label.tag==1){
            let newOrsX = myFrame.origin.x + deltaX
            let newOrsY = myFrame.origin.y + deltaY
            
            //ずれたあとのフレームサイズ
            let newSX = myFrame.size.width - deltaX
            let newSY = myFrame.size.height - deltaY
            if(newOrsX > -21 && newSX > 30){
                myFrame.origin.x = newOrsX
                myFrame.size.width = newSX
            }
            if(newOrsY > navHeight+stHeight  && newSY > 30){
                myFrame.origin.y = newOrsY
                myFrame.size.height = newSY
            }
            my2Label.frame=CGRect(x: -20,y: myFrame.size.height-20, width: 40, height: 40)
            myTLabel.frame=CGRect(x: myFrame.size.width-20,y: myFrame.size.height-20, width: 40, height: 40)
            myFLabel.frame=CGRect(x: myFrame.size.width-20,y: -20, width: 40, height: 40)
            // println("\(myFrame.origin.x):\(myFrame.origin.y):\(myFrame.size.width):\(myFrame.size.height)")
            
        }else if(label.tag==2){
            let newOrsX = myFrame.origin.x + deltaX
            let newOrsY = myFrame.origin.y + deltaY
            
            //ずれたあとのフレームサイズ
            let newSX = myFrame.size.width - deltaX
            let newSY = myFrame.size.height + deltaY
            if(newOrsX > -21 && newSX > 30){
                myFrame.origin.x = newOrsX
                myFrame.size.width = newSX
            }
            if(newOrsY > navHeight+stHeight  && newSY > 30){
                myFrame.size.height = newSY
            }
            my2Label.frame=CGRect(x: -20,y: myFrame.size.height-20, width: 40, height: 40)
            myTLabel.frame=CGRect(x: myFrame.size.width-20,y: myFrame.size.height-20, width: 40, height: 40)
            myFLabel.frame=CGRect(x: myFrame.size.width-20,y: -20, width: 40, height: 40)
            
        }else if(label.tag==3){
            let newOrsX = myFrame.origin.x + deltaX
            let newOrsY = myFrame.origin.y + deltaY
            
            //ずれたあとのフレームサイズ
            let newSX = myFrame.size.width + deltaX
            let newSY = myFrame.size.height + deltaY
            if(newOrsX > -21 && newSX > 30){
                myFrame.size.width = newSX
            }
            if(newOrsY > navHeight+stHeight && newSY > 60){
                myFrame.size.height = newSY
            }
            my2Label.frame=CGRect(x: -20,y: myFrame.size.height-20, width: 40, height: 40)
            myTLabel.frame=CGRect(x: myFrame.size.width-20,y: myFrame.size.height-20, width: 40, height: 40)
            myFLabel.frame=CGRect(x: myFrame.size.width-20,y: -20, width: 40, height: 40)
            
        }else if(label.tag==4){
            let newOrsX = myFrame.origin.x + deltaX
            let newOrsY = myFrame.origin.y + deltaY
            
            //ずれたあとのフレームサイズ
            let newSX = myFrame.size.width + deltaX
            let newSY = myFrame.size.height - deltaY
            if(newOrsX > -21 && newSX > 0){
                myFrame.size.width = newSX
            }
            if(newOrsY > -21 && newSY > 0){
                myFrame.origin.y = newOrsY
                myFrame.size.height = newSY
            }
            my2Label.frame=CGRect(x: -20,y: myFrame.size.height-20, width: 40, height: 40)
            myTLabel.frame=CGRect(x: myFrame.size.width-20,y: myFrame.size.height-20, width: 40, height: 40)
            myFLabel.frame=CGRect(x: myFrame.size.width-20,y: -20, width: 40, height: 40)
        }
        
        self.cView.frame=myFrame
        
        
    }
    
    
    /*
     タッチを感知した際に呼ばれるメソッド.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Labelアニメーション.
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view!.tag == cView.tag {

            }else if(t.view!.tag==myLabel.tag){
                myLabel.backgroundColor=UIColorFromRGB(0x1A)
                UIView.animate(withDuration: 0.06,
                                           // アニメーション中の処理.
                    animations: { () -> Void in
                        // 縮小用アフィン行列を作成する.
                        self.myLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: { (Bool) -> Void in
                })
                
            }else if(t.view!.tag==my2Label.tag){
                UIView.animate(withDuration: 0.06,
                                           // アニメーション中の処理.
                    animations: { () -> Void in
                        // 縮小用アフィン行列を作成する.
                        self.my2Label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: { (Bool) -> Void in
                })
                
                
            }else if(t.view!.tag==myTLabel.tag){
                UIView.animate(withDuration: 0.06,
                                           // アニメーション中の処理.
                    animations: { () -> Void in
                        // 縮小用アフィン行列を作成する.
                        self.myTLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: { (Bool) -> Void in
                })
                
                
            }else if(t.view!.tag==myFLabel.tag){
                UIView.animate(withDuration: 0.06,
                                           // アニメーション中の処理.
                    animations: { () -> Void in
                        // 縮小用アフィン行列を作成する.
                        self.myFLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: { (Bool) -> Void in
                })
                
                
            }
        }
    }
    
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    //override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        // println("touchesMoved")
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view!.tag == cView.tag {
                let aTouch = touches.first as UITouch!
                // 移動した先の座標を取得.
                let location = aTouch?.location(in: self.view)
                // 移動する前の座標を取得.
                let prevLocation = aTouch?.previousLocation(in: self.view)
                // CGRect生成.
                var myFrame: CGRect = self.cView.frame
                // ドラッグで移動したx, y距離をとる.
                let deltaX: CGFloat = location!.x - prevLocation!.x
                let deltaY: CGFloat = location!.y - prevLocation!.y
                
                
                if((myFrame.origin.x+myFrame.size.width <= self.view.frame.size.width || deltaX < 0) && (myFrame.origin.x+deltaX) >= 0){
                    myFrame.origin.x += deltaX
                }
                if((myFrame.origin.y+myFrame.size.height+navHeight+stHeight <= self.view.frame.size.height || deltaY < 0) && (myFrame.origin.y+deltaY) >= stHeight+navHeight){
                    myFrame.origin.y += deltaY
                    
                }
                self.cView.frame = myFrame
                
            }
        }
    }
    
    /*
     指が離れたことを感知した際に呼ばれるメソッド.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            if t.view!.tag == cView.tag {
                UIView.animate(withDuration: 0.1,
                                           
                                           // アニメーション中の処理.
                    animations: { () -> Void in
                        
                    }, completion: { (Bool) -> Void in
                    
                })
                
                
                
            }
        }
        
        
        
        // Labelアニメーション.
    }
    
    func resizeImage(){
    
        var frame = self.cView.frame
        let orX = cView.frame.origin.x
        let orY = cView.frame.origin.y
        let sX = cView.frame.width
        let sY = cView.frame.height
        print("\(self.checkIV.image!), x:\(orX),y:\(orY),w: \(Int(sX)), h: \(Int(sY))")
        let Cimage = cropThumbnailImage(self.checkIV.image!, x:orX,y:orY,w: Int(sX), h: Int(sY))
        
        self.trimImage = Cimage
        //self.view2 = UIImageView(frame: CGRectMake(0,navHeight+stHeight+10,self.view.frame.size.width-100,self.view.frame.size.height-100))
        self.view2 = UIImageView(frame: CGRect(x: 0,y: 0,width: cView.frame.size.width,height: cView.frame.size.height))
        
        view2.image = Cimage
        vf=2
    }
    
    func cropThumbnailImage(_ timage :UIImage,x:CGFloat,y:CGFloat, w:Int, h:Int) ->UIImage
    {
               // リサイズ処理
        let origRef    = timage.cgImage;
        let origWidth  = Int(origRef!.width)
        var orX:CGFloat=0
        var orY:CGFloat=0
        
        var ivX = self.view.frame.size.width
        var ivY = self.view.frame.size.height-60
        let origHeight = Int(origRef!.height)
        
        
        var scale:CGFloat!
        var orIX:CGFloat!
        var orIY:CGFloat!
        if(w > h){
            scale = timage.size.width/self.view.frame.size.width
            orIX = timage.size.width
            orIY = scale * (self.view.frame.size.height-60)
        }else{
            scale = timage.size.height/(self.view.frame.size.height-60)
            orIX = self.view.frame.size.width*scale
            orIY = timage.size.height
        }
        let resizeSize = CGSize(width: CGFloat(orIX), height: CGFloat(orIY))
        UIGraphicsBeginImageContextWithOptions(resizeSize,false,0.0)
        timage.draw(in: CGRect(x: 0, y: 0, width: orIX, height: orIY))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("リサイズ画像x=>\(0),y=>\(0),w=>\(orIX),h=>\(orIY),scale=>\(scale)")

      /*let cropRect  = CGRectMake(
            (x*2)*scale,
            ((y-(40))*2)*scale,
            (CGFloat(w*2))*scale, (CGFloat(h*2))*scale)*/
        let cropRect  = CGRect(
            x: (x*2)*scale,
            y: ((y*2))*scale,
            width: (CGFloat(w*2))*scale, height: (CGFloat(h*2))*scale)
        let cropRef   = resizeImage!.cgImage!.cropping(to: cropRect)
        let cropImage = UIImage(cgImage: cropRef!)
        return cropImage
        //return resizeImage!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
       
        self.navigationController?.navigationBar.isHidden = true
    }
    

}



