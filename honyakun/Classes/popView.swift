//
//  popView.swift
//  honyakun
//
//  Created by WKC on 2016/09/10.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation
protocol  popViewProt:class {
    func protReturn(_ text:String)
}

class popView:UIView,LangInfoProt{
    
    var delegate:popViewProt?
    
    var buttons = [UIButton]()
    let langList:[String] = ["en","es","fr","zh-CHS","ko","de","ru","it"]
    let langTitle:[String] = ["英語","スペイン語","フランス語","中国語","韓国語","ドイツ語","ロシア語","イタリア語"]
    let colorList:[UInt] = [0xC91380,0xED0E3F,0xF36C20,0xFFCC2F,0x50AE24,0x1AA2C4,0x0A5299,0x021479]
    let ulist:[UInt] = [0xDDDDDD]
    
    override init(frame:CGRect){
        super.init(frame: frame)
        initButtons()
        self.backgroundColor = UIColorFromRGB(0xFFFFFF)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func LangInfoProt(_ text: String) {
        delegate?.protReturn(text)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.next
        
    }

    
}


extension popView{
    func initButtons(){
        for  i in 0 ... 7{
            let button = LangInfoButton(frame:CGRect(x: 0,y: CGFloat(i)*40,width: 300,height: 40),lang: langList[i],title: langTitle[i],color: colorList[i])
                        self.addSubview(button)
            button.delegate = self
        }
    }
    
    
}

protocol LangInfoProt:class{
    func LangInfoProt(_ text:String)
}

class LangInfoButton:UIButton{
    var lang = ""
    weak var delegate:LangInfoProt?
    init(frame:CGRect,lang:String,title:String,color:UInt){
        super.init(frame: frame)
        self.lang=lang
        self.setTitle(title, for: UIControlState())
        self.tintColor = UIColorFromRGB(color)
        self.setTitleColor(UIColorFromRGB(color), for: UIControlState())
        self.layer.borderWidth = 0.3
        self.layer.borderColor =  UIColorFromRGB(0xCCCCCC).cgColor
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.LangInfoProt(self.lang)
    }
    
    
}

extension popView {
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}

extension LangInfoButton {
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
