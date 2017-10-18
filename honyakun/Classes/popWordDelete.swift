//
//  popWordDelete.swift
//  honyakun
//
//  Created by WKC on 2016/09/22.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation

import Foundation

protocol popWordDeleteProt{
    func dawnView()
    func wordDelete(_ word:String)
}

class popWordDelete:UIView{
    var word:String!
    var text:String!
    var lang:String!
    
    
    
    var wordLabel:UILabel!
    var textView:UITextView!
    var buttonL:UIButton!
    var pronounceButton:UIButton!
    var sayClass:SayClass!
    
    var delegate:popWordDeleteProt?
    
    init (frame:CGRect,word:String,text:String,lang:String){
        super.init(frame: frame)
        self.backgroundColor = UIColorFromRGB(0x000000)
        self.word = word
        self.text = text
        self.lang = lang
        setView()
    }
    
    /*func setView(){
        //単語ラベル
        wordLabel = UILabel(frame:CGRectMake(10,10,self.frame.size.width/2,40))
        wordLabel.text = text
        wordLabel.textColor = UIColor.whiteColor()
        self.addSubview(wordLabel)
        
        //発音ラベル
        pronounceButton = UIButton(frame:CGRectMake(self.frame.size.width-70,0,30,30))
        pronounceButton.addTarget(self, action: "pronounceWord", forControlEvents: .TouchUpInside)
        pronounceButton.setImage(UIImage(named:"turn-up-volume.png"), forState: .Normal)
        self.addSubview(pronounceButton)
        //発音クラス
        self.sayClass = SayClass(lang: lang)
        textView = UITextView(frame:CGRectMake(10,60,self.frame.size.width-20,100))
        textView.backgroundColor=UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.0);
        textView.textColor = UIColor.whiteColor()
        textView.font =  UIFont.systemFontOfSize(CGFloat(20))//UIFont(name: UIFont., size: 14)
        textView.editable = false;
        textView.scrollEnabled=true
        self.addSubview(textView)
        
        var buttonL = UIButton()
        buttonL.setTitle("Tap Me!", forState: .Normal)
        buttonL.addTarget(self, action: "DawnView", forControlEvents: .TouchUpInside)
        buttonL.frame = CGRectMake(self.frame.size.width-30, 0, 30, 30)
        // buttonL.layer.position = CGPoint(x:screenSize.width-30, y:15)
        let image2 = UIImage(named: "close.png")!
        buttonL.setImage(image2, forState: .Normal)
        self.addSubview(buttonL)
        
        var wordPreButton = UIButton(frame:CGRectMake(30,165,self.frame.size.width-60,30))
        wordPreButton.addTarget(self, action: "wordDelete", forControlEvents:.TouchUpInside)
        wordPreButton.backgroundColor = UIColorFromRGB(0xFF3399)
        wordPreButton.layer.cornerRadius = 10.0
        wordPreButton.setTitle("単語カードから削除", forState: .Normal)
        
        self.addSubview(wordPreButton)
        
    }*/
    
    func setView(){
        //単語ラベル
        wordLabel = UILabel(frame:CGRect(x: 10,y: 10,width: self.frame.size.width/2,height: 40))
        wordLabel.text = text
        wordLabel.textColor = UIColor.white
        self.addSubview(wordLabel)
        
        //発音ラベル
        pronounceButton = UIButton(frame:CGRect(x: self.frame.size.width-70,y: 5,width: 20,height: 20))
        pronounceButton.addTarget(self, action: #selector(popWordDelete.pronounceWord), for: .touchUpInside)
        pronounceButton.setImage(UIImage(named:"megaPh.png"), for: UIControlState())
        self.addSubview(pronounceButton)
        //発音クラス
        self.sayClass = SayClass(lang: lang)
        textView = UITextView(frame:CGRect(x: 10,y: 60,width: self.frame.size.width-20,height: 100))
        textView.backgroundColor=UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.0);
        textView.textColor = UIColor.white
        textView.font =  UIFont.systemFont(ofSize: CGFloat(14))//UIFont(name: UIFont., size: 14)
        textView.isEditable = false;
        textView.isScrollEnabled=true
        self.addSubview(textView)
        
        let buttonL = UIButton()
        buttonL.setTitle("Tap Me!", for: UIControlState())
        buttonL.addTarget(self, action: #selector(popWordDelete.DawnView), for: .touchUpInside)
        buttonL.frame = CGRect(x: self.frame.size.width-30, y: 5, width: 20, height: 20)
        // buttonL.layer.position = CGPoint(x:screenSize.width-30, y:15)
        let image2 = UIImage(named: "Closing.png")!
        buttonL.setImage(image2, for: UIControlState())
        self.addSubview(buttonL)
        
        let wordPreButton = UIButton(frame:CGRect(x: 30,y: 165,width: self.frame.size.width-60,height: 30))
        wordPreButton.addTarget(self, action: #selector(popWordDelete.wordDelete), for:.touchUpInside)
        wordPreButton.backgroundColor = UIColorFromRGB(0xFF3399)
        wordPreButton.layer.cornerRadius = 10.0
        wordPreButton.setTitle("単語カードから削除", for: UIControlState())
        self.addSubview(wordPreButton)
        
    }

    
    func setProperty(_ word:String,text:String){
        self.word = word
        self.text = text
        self.wordLabel.text = word
        self.textView.text = text
    }
    
    func DawnView(){
        delegate?.dawnView()
    }
    
    func pronounceWord(){
        self.sayClass.Wsay(self.word)
        //delegate?.pronounceWord(word)
    }
    
    func wordDelete(){
        delegate?.wordDelete(self.word)
    }
    
    func setPhoneLang(_ text:String){
        self.sayClass.lang=text
    }
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.8)
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
