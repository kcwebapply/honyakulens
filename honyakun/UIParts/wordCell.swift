//
//  wordCell.swift
//  honyakun
//
//  Created by WKC on 2016/09/20.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation



protocol wordCellProtocol{
    func propertyCheck(word:String!,id:Int!)
    func deleteCheck(word:String!,id:Int!,tag:Int!)
}



class wordCell:UITableViewCell{
    
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var propertyButton: UIButton!
    
    var id:Int!
    let langList:[String] = ["en","es","fr","zh-CHS","ko","de","ru","it"]
    let langTitle:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]
    
    
    var delegate:wordCellProtocol?
   // let colorList:[UInt] = [0xC91380,0xED0E3F,0xF36C20,0xFFCC2F,0x50AE24,0x1AA2C4,0x0A5299,0x021479]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setCell(_ wordcard:wordCard,id:Int!){
        self.wordLabel.text = wordcard.word
        self.id = id
        self.langLabel.textAlignment = .center
        self.langLabel.text = langTitle[wordcard.lang]
        self.langLabel.textColor = UIColorFromRGB(colorList[wordcard.lang]!)
        
        //var propertyCheckButton = UIButton(frame:CGRect(x:0,y:0,))
        
        
        propertyButton.addTarget(self, action: "propertyCheck", for: .touchUpInside)
        propertyButton.layer.cornerRadius = 15.0
        propertyButton.setBackgroundImage(UIImage(named:"note.png"), for: .normal)
        //propertyButton.backgroundColor = UIColorFromRGB(0xFF3399)
    }
    
    func propertyCheck(){
        delegate?.propertyCheck(word: self.wordLabel.text,id:self.id)
    }

 
    func resizeImage(_ image:UIImage,size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size,false,0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
        
    }
    
     func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

}
