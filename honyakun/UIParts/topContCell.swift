//
//  File.swift
//  honyakun
//
//  Created by WKC on 2016/09/30.
//  Copyright © 2016年 WKC. All rights reserved.
//

import Foundation


class topContCell:UITableViewCell{
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBOutlet weak var textContentView: UITextView!
    
    
    
    let langList:[String] = ["en","es","fr","zh-CHS","ko","de","ru","it"]
    let langTitle:[String:String] = ["en":"英語","es":"スペイン語","fr":"フランス語","zh-CHS":"中国語","ko":"韓国語","de":"ドイツ語","ru":"ロシア語","it":"イタリア語"]
    let colorList:[String:UInt] = ["en":0xC91380,"es":0xED0E3F,"fr":0xF36C20,"zh-CHS":0xFFCC2F,"ko":0x50AE24,"de":0x1AA2C4,"ru":0x0A5299,"it":0x021479]
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setCell(_ topcard:topCard){
        
         self.contentView.autoresizingMask = autoresizingMask;
        self.backgroundColor = UIColorFromRGB(0xF8F8F8)
        let blueCircle = UILabel(frame:CGRect(x: 8,y: 17.5,width: 10,height: 10))
        blueCircle.layer.cornerRadius = 5.0
        blueCircle.clipsToBounds = true
       // blueCircle.backgroundColor = UIColorFromRGB(0xA8A8A8)
        blueCircle.backgroundColor = UIColorFromRGB(0xFF5BBE)
        self.addSubview(blueCircle)
        self.titleLabel.text = topcard.title
        //self.textContentView.frame = CGRectMake(20,30,self.frame.size.width-40,80)
        self.textContentView.text = topcard.content
        self.textContentView.isUserInteractionEnabled = false
        self.textContentView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        //iphone6 self.textContentView.font = UIFont.systemFontOfSize(CGFloat(14))
        let devName = UIDevice.current.modelName
        print("機種=>\(devName)")
            switch devName{
            case "iPhone6","iPhone6Plus":
                self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(14))
                break
            case "iPhone7,1","iPhone7,2","iPhone8,1","iPhone8,2":
                self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(12))
                break
            case "iPhone9,1","iPhone9,2":
                self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(12))
                break
            default:
                self.textContentView.font = UIFont.systemFont(ofSize: CGFloat(14))
        }

        let langView = UILabel(frame:CGRect(x: self.frame.size.width-120,y: self.titleLabel.frame.origin.y,width: 80,height: 26))
        langView.text = langTitle[topcard.lang]
        langView.textColor = UIColorFromRGB(colorList[topcard.lang]!)
        langView.textAlignment = .center
        self.addSubview(langView)
        
        let allowView = UIButton(frame:CGRect(x: self.frame.size.width-30,y: self.titleLabel.frame.origin.y+5.5,width: 15,height: 15))
        allowView.setImage(UIImage(named:"parrow.png"), for:UIControlState())
        allowView.isUserInteractionEnabled = false
        self.addSubview(allowView)
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
